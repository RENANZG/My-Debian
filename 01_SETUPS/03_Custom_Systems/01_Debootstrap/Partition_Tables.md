<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>GUID Partition Table (GPT) Partition Types</title>
</head>
<body>

  <h4>GUID Partition Table (GPT) is a partitioning scheme that is part of the Unified Extensible Firmware Interface (UEFI) specification</h4>

  <table border="1" cellpadding="5" cellspacing="0">
    <thead>
      <tr>
        <th>Partition Type</th>
        <th>FDISK Type Code</th>
        <th>GDISK Type Hex Code</th>
        <th>Partition Type GUIDs</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>EFI System Partition (ESP) (for UEFI)¹</td>
        <td>1</td>
        <td>ef00</td>
        <td>C12A7328-F81F-11D2-BA4B-00A0C93EC93B</td>
      </tr>
      <tr>
        <td>BIOS Boot Partition (for GRUB)</td>
        <td>-</td>
        <td>ef02</td>
        <td>21686148-6449-6E6F-744E-656564454649</td>
      </tr>
      <tr>
        <td>Linux Root</td>
        <td>83</td>
        <td>8304</td>
        <td>4F68BCE3-E8CD-4DB1-96E7-FBCAF984B709</td>
      </tr>
      <tr>
        <td>Linux Home</td>
        <td>83</td>
        <td>8302</td>
        <td>933AC7E1-2EB4-4F13-B844-0E14E2AEF915</td>
      </tr>
      <tr>
        <td>Linux Swap</td>
        <td>82</td>
        <td>8200</td>
        <td>0657FD6D-A4AB-43C4-84E5-0933C84B4F4F</td>
      </tr>
      <tr>
        <td>Linux Filesystem</td>
        <td>83</td>
        <td>8300</td>
        <td>0FC63DAF-8483-4772-8E79-3D69D8477DE4</td>
      </tr>
      <tr>
        <td>Linux LUKS</td>
        <td>-</td>
        <td>8309</td>
        <td>CA7D7CCB-63ED-4C53-861C-1742536059CC</td>
      </tr>
      <tr>
        <td>Linux LVM</td>
        <td>8e</td>
        <td>8e00</td>
        <td>E6D6D379-F507-44C2-A23C-238F2A3DF928</td>
      </tr>
      <tr>
        <td>Linux RAID</td>
        <td>fd</td>
        <td>fd00</td>
        <td>A19D880F-05FC-4D3B-A006-743F0F84911E</td>
      </tr>
      <tr>
        <td>Windows basic data</td>
        <td>7</td>
        <td>0700</td>
        <td>EBD0A0A2-B9E5-4433-87C0-68B6B72699C7</td>
      </tr>
      <tr>
        <td>Windows recovery environment</td>
        <td>-</td>
        <td>-</td>
        <td>DE94BBA4-06D1-4D40-A16A-BFD50179D6AC</td>
      </tr>
    </tbody>
  </table>

  <h4>Notes:</h4>

  <a href="https://uapi-group.org/specifications/">UAPI Group Specifications</a>
  <br>

  <p>The EFI System Partition (ESP) uses a FAT-based filesystem, and while
    the UEFI specification defines its use, the differences from the traditional
    FAT specification are minor. For example, Apple maintains its own FAT
    tool (newfs_msdos), but most other systems use standard FAT utilities
    to manage the ESP without any issues.
    Ref: <a href="https://en.wikipedia.org/wiki/EFI_system_partition#Overview">
    https://en.wikipedia.org/wiki/EFI_system_partition#Overview</a></p>

  <p>Partition Type and Purpose: The type of a partition primarily serves
    as metadata to describe its intended purpose. This metadata allows
    systems and tools to know the partition's intended use without inspecting
    its data.</p>

  <p>Filesystem Flexibility: You are not obliged to create a filesystem that
    matches the partition type. For instance, a partition type for "Linux
    filesystems" (type 0x83) can be formatted with FAT32 or NTFS, although
    the partition type serves more as a suggestion rather than a strict
    requirement.</p>

  <p>Tool Expectations: Many tools and operating systems expect specific filesystems
    inside certain partition types. For example, a swap partition (type
    0x82) should contain swap space, and using a filesystem like ext4 could
    cause issues. Similarly, Windows expects NTFS or FAT32 in certain partitions,
    and mismatched filesystems can lead to incompatibility.</p>

  <p>Potential Issues: Using an arbitrary filesystem or data inside a partition
    of a different type can cause problems such as boot issues, tool incompatibility,
    and cross-OS recognition problems.</p>

  <p>cryptsetup: A utility used to set up disk encryption based on the dm-crypt
    kernel module.</p>

  <p>dm-crypt: A disk encryption subsystem in Linux kernel versions 2.6 and
    later, providing transparent encryption of block devices via a device-mapper
    target.</p>

</body>
</html>