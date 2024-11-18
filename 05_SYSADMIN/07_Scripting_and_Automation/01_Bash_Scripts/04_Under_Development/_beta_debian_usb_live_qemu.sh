#!/usr/bin/env bash

########################################################################
# File Name    : debian_live_modify.sh
# Description  : Script to download, verify, modify Debian Live XFCE ISO,
#                and write it to a USB stick
# Dependencies : curl gpg unsquashfs mksquashfs xorriso dosfstools qemu-utils
# Usage        : • Make the script executable with 
#                sudo chmod +x debian_live_modify.sh
#                • Run the script with no arguments:   
#                sudo bash debian_live_modify.sh
# Author       : Me and the bois
# License      : Free of charge, no warranty
# Last edited  : 2024-06-23
########################################################################

# Function to clean up the debian_data directory
if [ "$1" == "clean" ]; then
  find debian_data -not -path debian_data -delete 
  echo "Cleaned up the debian_data/ directory!"
  echo "You can now re-run the script with:"
  echo "$0"
  exit 0
fi

# Function to download the latest Debian Bookworm Live XFCE ISO
download_latest_debian_iso() {
  echo "[+] Downloading the latest Debian Bookworm Live XFCE ISO..."

  # Define base URL and regex pattern to match the ISO file
  BASE_URL="https://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/"
  PATTERN="debian-live-[0-9]+\.[0-9]+\.[0-9]+-amd64-xfce\.iso"

  # Fetch the HTML content from the base URL
  HTML_CONTENT=$(curl -s "$BASE_URL")

  # Extract the ISO file name using regex
  if [[ $HTML_CONTENT =~ ($PATTERN) ]]; then
    ISO_FILE="${BASH_REMATCH[1]}"
    DEBIAN_ISO_URL="${BASE_URL}${ISO_FILE}"
    echo "[+] Found latest ISO file: $ISO_FILE"
  else
    echo "ERROR: Could not find the latest ISO file."
    exit 1
  fi

  # Download the ISO file
  curl -Lo debian_data/"$ISO_FILE" "$DEBIAN_ISO_URL"
}

# Function to verify ISO integrity
verify_iso() {
  echo "[+] Verifying ISO integrity..."
  sha256sum -c <<<"$(curl -s https://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/SHA256SUMS $ISO_FILE)"
}

# Function to modify ISO (embed QEMU)
modify_iso() {
  echo "[+] Modifying ISO to include QEMU..."

  # Mount ISO to a temporary directory
  MOUNT_DIR=$(mktemp -d)
  sudo mount -o loop debian_data/"$ISO_FILE" "$MOUNT_DIR"

  # Copy ISO contents to working directory
  WORK_DIR=$(mktemp -d)
  cp -a "$MOUNT_DIR/"* "$WORK_DIR/"

  # Extract the SquashFS filesystem
  EDIT_DIR=$(mktemp -d)
  sudo unsquashfs -d "$EDIT_DIR" "$WORK_DIR/live/filesystem.squashfs"

  # Mount necessary filesystems for chroot
  sudo mount --bind /dev "$EDIT_DIR/dev"
  sudo mount --bind /sys "$EDIT_DIR/sys"
  sudo mount --bind /proc "$EDIT_DIR/proc"
  sudo mount --bind /dev/pts "$EDIT_DIR/dev/pts"

  # Prepare and execute chroot operations to install QEMU
  sudo cp /etc/resolv.conf "$EDIT_DIR/etc/"
  sudo cp "$QEMU_BIN" "$EDIT_DIR/usr/bin/qemu-x86_64-static"
  sudo chmod +x "$EDIT_DIR/usr/bin/qemu-x86_64-static"
  
  sudo chroot "$EDIT_DIR" /bin/bash <<EOF
apt-get update
apt-get install -y qemu-kvm qemu-system-x86 libvirt-daemon-system libvirt-clients virt-manager gir1.2-spiceclientgtk-3.0 dnsmasq qemu-utils iptables
usermod -aG libvirt "\$(whoami)"
usermod -aG kvm "\$(whoami)"
EOF

  # Cleanup chroot environment
  sudo umount "$EDIT_DIR/dev/pts"
  sudo umount "$EDIT_DIR/proc"
  sudo umount "$EDIT_DIR/sys"
  sudo umount "$EDIT_DIR/dev"

  # Repack the SquashFS filesystem
  sudo mksquashfs "$EDIT_DIR" "$WORK_DIR/live/filesystem.squashfs.new" -comp xz
  sudo mv "$WORK_DIR/live/filesystem.squashfs.new" "$WORK_DIR/live/filesystem.squashfs"

  # Create new ISO image
  sudo xorriso -as mkisofs \
    -o debian_data/modified-"$ISO_FILE" \
    -isohybrid-mbr "$WORK_DIR/isolinux/isohdpfx.bin" \
    -c isolinux/boot.cat \
    -b isolinux/isolinux.bin \
    -no-emul-boot -boot-load-size 4 -boot-info-table \
    -J -r -V "DEBIAN_LIVE" \
    -cache-inodes \
    -isohybrid-gpt-basdat \
    "$WORK_DIR"

  # Cleanup temporary directories
  sudo umount "$MOUNT_DIR"
  rm -rf "$MOUNT_DIR" "$WORK_DIR" "$EDIT_DIR"
}

# Function to write modified ISO to USB stick
write_to_usb() {
  echo "[+] Writing modified ISO to USB stick $USB_DEVICE..."

  # Unmount USB drive if already mounted
  sudo umount "$USB_DEVICE"* 2>/dev/null || true

  # Write ISO to USB
  sudo dd bs=4M if=debian_data/modified-"$ISO_FILE" of="$USB_DEVICE" conv=fsync status=progress
}

# Check dependencies
dependencies="curl gpg unsquashfs mksquashfs xorriso qemu-img qemu-io qemu-nbd"
for dep in $dependencies; do
  if ! command -v "$dep" &> /dev/null; then
    echo "Error: $dep is not installed. Please install $dep."
    exit 1
  fi
done

# Main script execution
if [ ! -d "debian_data" ]; then
  echo "[+] Creating debian_data/ directory..."
  mkdir debian_data/
fi

download_latest_debian_iso
verify_iso
modify_iso
write_to_usb

echo "[+] Process complete. The modified Debian Live XFCE ISO has been written to $USB_DEVICE."
