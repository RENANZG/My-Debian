reference https://github.com/brunowollinger/windows-usb

## Motivation

A modern windows 10 ISO is larger than 4GB, specifically the `install.wim` file which is incompatible with a FAT32 partition. We can use NTFS or exFAT to bypass this limitation. [Rufus](https://rufus.ie/) solves this, but, it's unavailable on Linux. Its creator [pbatard](https://github.com/pbatard) provide the binaries to chain load our Windows partition from a bootable FAT16 one.

## Formating the USB

Identify your USB device using `lsblk` or `fdisk -l`, mine is `/dev/sdb` so I'll be using it as example.

Overwrite the partition table

```bash
parted /dev/sdb mklabel gpt
```

Create FAT16 partition of 1MB, I'm using FAT16 because the required binaries are stored in this format

```bash
parted /dev/sdb mkpart primary fat16 1MiB 2MiB
```

Set the bootable flag

```bash
parted /dev/sdb set 1 boot on
```

Create a NTFS partition with the remaining space of the disk

```bash
parted /dev/sdb mkpart primary ntfs 2MiB 100%
```

Set the flag Microsoft Basic Data to the partition

```bash
parted /dev/sdb set 2 msftdata on
```

Format the ntfs partition

```bash
mkfs.ntfs -f /dev/sdb2
```

## Trasnfering Files

Download the .img that contains the custom binaries to chain load our installation files

```bash
wget 'https://raw.githubusercontent.com/pbatard/rufus/master/res/uefi/uefi-ntfs.img' -O ~/Downloads/uefi-ntfs.img
```

Write the image to the partition

```bash
dd if=~/Downloads/uefi-ntfs.img of=/dev/sdb1 status=progress
```

Download the Windows ISO and mount it

```bash
mkdir /mnt/iso && mount /path/to/iso /mnt/iso
```

Mount the NTFS partition

```bash
mkdir /mnt/ntfs && mount /dev/sdb2 /mnt/ntfs
```

Transfer the ISO contents to the NTFS partition. This process can take some time, after the command finish the device can still be in a locked state.

```bash
rsync -av /mnt/iso/* /mnt/drive
```
