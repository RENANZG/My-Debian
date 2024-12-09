### exFAT Format from Terminal

1. **Make sure you can install `exfatprogs` beforehand:**

   ```bash
   $ sudo apt install exfatprogs # Debian/Ubuntu
   $ sudo dnf install exfatprogs # Red Hat/Fedora/CentOS
   $ sudo pacman -S exfatprogs # Arch Linux/Manjaro
   ```

2. **Identify the flash drive**:

   ```bash
   lsblk
   ```

3. **Unmount the flash drive** (if it is mounted):

   ```bash
   sudo umount /dev/sdX1
   ```

4. **Use `fdisk` to partition**:

   - Start `fdisk` for the correct device (replace `sdX` with the actual drive identifier):

   ```bash
   sudo fdisk /dev/sdX
   ```

   - Create a new partition table: press `o` (for DOS).
   - Create a new partition: press `n`, then enter (accept default options).
   - Write changes: press `w`.

5. **Format the partition** (after creating the partition):

   ```bash
   sudo mkfs.exfat -n "Label" /dev/sdX1
   ```
  
   Tip: if you install `dosfstools`, you can use FAT32:
  
   ```bash
   sudo mkfs.vfat -F 32 -n "Label" /dev/sdX1
   ```
  
   GPT Table:
   - Create a new partition table: press `g` (for GPT).
   - Create a new partition: press `n`, then enter (accept default options).
   - Change the partition type to FAT (press `t`, then `11`).