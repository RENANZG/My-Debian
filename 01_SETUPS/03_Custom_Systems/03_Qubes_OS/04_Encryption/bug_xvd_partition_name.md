### Block devices not detected in Qubes/Xen

https://github.com/mhogomchungu/zuluCrypt/issues/178

ZuluCrypt often only recognizes `sdX` devices, while Qubes uses names like `/dev/xvdb`.

Make sure to run all commands in the appropriate AppVM, not in dom0.

To address this, follow these steps **inside the AppVM** where ZuluCrypt is installed:

1. **Create a Loop Device**:
   ```bash
   sudo losetup /dev/loop0 /dev/xvdb
   ```

2. **Check Disk Recognition**:
   ```bash
   sudo blkid
   ```

3. **Ensure Proper Formatting**: Verify that the disk is formatted with a filesystem.

4. **Mount the Device**: If you can mount it, ZuluCrypt may recognize it better:
   ```bash
   sudo mount /dev/xvdb1 /mnt/mydisk
   ```

5. **Consider Alternatives**: If issues persist, explore other encryption tools compatible with Qubes OS.
