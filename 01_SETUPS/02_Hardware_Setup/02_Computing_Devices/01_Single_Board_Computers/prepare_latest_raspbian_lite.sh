#!/usr/bin/env bash
set -euo pipefail

# Set package installer based on flag
USE_APTITUDE_INSTEAD_OF_APTGET=1
PACKAGE_INSTALLER=apt-get

if [ "$USE_APTITUDE_INSTEAD_OF_APTGET" -eq 1 ]; then
  PACKAGE_INSTALLER=aptitude
fi

# Install necessary packages
sudo "$PACKAGE_INSTALLER" install -y qemu qemu-user-static binfmt-support

# Retrieve the QEMU ARM interpreter information
QEMU_ARM_INTERPRETER=$(update-binfmts --display |
  grep -EA 7 "^qemu-arm[ \t]+\([a-zA-Z]+\):" |
  grep interpreter |
  sed 's/^.\+=[ \t]\+//')

# Download the latest Raspbian Lite image
wget --content-disposition -N https://downloads.raspberrypi.org/raspbian_lite_latest

# Clean up old Raspbian images
rm -vf $(ls *-raspbian-*.zip | sort -n | head -n-1)
unzip -vuo -d . *-raspbian-*.zip
rm -vf $(ls *-raspbian-*.img | sort -n | head -n-1)

# Prepare the image
cp -vuf *-raspbian-*.img ./raspbian_lite_latest.img
cp -vf ./raspbian_lite_latest.img ./raspbian_lite_latest.MODIFIED.img
dd if=/dev/zero bs=1M count=1024 >> raspbian_lite_latest.MODIFIED.img

# Extract disk details
DISK_END=$(parted -s raspbian_lite_latest.MODIFIED.img print |
  grep -E "^Disk[ \t]+[^:]+:[ \t][0-9]+MB$" |
  sed 's/^Disk[ \t]\+[^:]\+:[ \t]\([0-9]\+\)MB$/\1/')

PART2_START=$(parted -s raspbian_lite_latest.MODIFIED.img print |
  grep -EA 2 "^Number[ \t]+" |
  tail -n 1 |
  sed 's/^[ \t]\+2//' |
  sed 's/[ \t]\+/ /g' |
  cut -f 2 -d " " |
  sed 's/MB$//')

SECTOR_SIZE=$(parted -s raspbian_lite_latest.MODIFIED.img print |
  grep -E "^Sector[ \t]+size[ \t]+\(logical/physical\):[ \t]+[0-9]+B/[0-9]+B$" |
  sed 's/^Sector[ \t]\+size[ \t]\+(logical\/physical):[ \t]\+[0-9]\+B\/\([0-9]\+\)B$/\1/')

BOOT_START_SECTOR=$(fdisk -lu raspbian_lite_latest.MODIFIED.img |
  tail -n 2 |
  head -n 1 |
  sed 's/[ \t]\+/ /g' |
  cut -f 2 -d " ")

PART2_START_SECTOR=$(fdisk -lu raspbian_lite_latest.MODIFIED.img |
  tail -n 1 |
  sed 's/[ \t]\+/ /g' |
  cut -f 2 -d " ")

echo "PART2_START $PART2_START DISK_END $DISK_END SECTOR_SIZE $SECTOR_SIZE BOOT_START_SECTOR $BOOT_START_SECTOR PART2_START_SECTOR $PART2_START_SECTOR"

# Modify the partition table
parted -s raspbian_lite_latest.MODIFIED.img rm 2
parted -s raspbian_lite_latest.MODIFIED.img mkpart primary "$PART2_START" "$DISK_END"

# Create a loopback device
LOOPBACK_DEVICE=$(sudo losetup -f --show -o $(($PART2_START_SECTOR * $SECTOR_SIZE)) raspbian_lite_latest.MODIFIED.img)
VALID_LOOPBACK_DEVICE=$(echo "$LOOPBACK_DEVICE" | grep -E "^/dev/loop[0-9]+$")

if [ -n "$VALID_LOOPBACK_DEVICE" ]; then
  sudo e2fsck -fp "$LOOPBACK_DEVICE"
  sudo resize2fs "$LOOPBACK_DEVICE"
  sudo losetup -d "$LOOPBACK_DEVICE"
fi

# Create chroot operations script
cat << 'EOF' | sudo tee OPERATIONS_WITHIN_CHROOT.sh > /dev/null
#!/usr/bin/env sh
uname -a
locale-gen
locale -a
apt-get -y install aptitude
aptitude -y update
aptitude -y upgrade
aptitude -y dist-upgrade
aptitude -y install openssh-server openvpn dante-server
sync
sleep 1
sync
exit
EOF

# Set default locale
echo 'LANG="en_US.ISO-8859-15"' | sudo tee default_locale > /dev/null
: > blank_file

# Prepare and mount the image
mkdir -p ./rpi_mnt
sudo mount raspbian_lite_latest.MODIFIED.img -o loop,offset=$(($PART2_START_SECTOR * $SECTOR_SIZE)),rw ./rpi_mnt
sudo mount raspbian_lite_latest.MODIFIED.img -o loop,offset=$(($BOOT_START_SECTOR * $SECTOR_SIZE)),rw ./rpi_mnt/boot

cd ./rpi_mnt

# Bind mount necessary filesystems
for fs in dev sys proc dev/pts; do
  sudo mount --bind "/$fs" "./$fs"
done

# Copy QEMU ARM interpreter
sudo cp -vf "$QEMU_ARM_INTERPRETER" usr/bin/

# Modify ld.so.preload
sudo mv -vf etc/ld.so.preload{,.ORIGINAL}
sudo cp -vf ../blank_file etc/ld.so.preload
sudo cp -vf ../default_locale etc/default/locale

# Configure locales
sudo cp -vf etc/locale.gen ../locale.gen
sudo chmod a+rw ../locale.gen
sed 's/[ \t]*#[ \t]*en_US/en_US/' ../locale.gen | sudo tee etc/locale.gen > /dev/null

# Copy and run chroot script
sudo cp -vf ../OPERATIONS_WITHIN_CHROOT.sh root/
sudo sync && sleep 1 && sudo sync
sudo chroot . /bin/sh /root/OPERATIONS_WITHIN_CHROOT.sh

# Cleanup
sudo sync && sleep 1 && sudo sync
sudo mv -vf etc/ld.so.preload{.ORIGINAL,}
sudo sync && sleep 10
cd ..
for fs in dev/pts proc sys dev; do
  sudo umount -f "./rpi_mnt/$fs"
done
sudo umount -f ./rpi_mnt/boot
sudo umount -f ./rpi_mnt

# Change file permissions
sudo chmod a+rw ./*
