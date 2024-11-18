<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Tutorial: Using USB Flash Drive for Boot and Keyfile in Linux with LVM</title>
<style>
  body {
    font-family: Arial, sans-serif;
    line-height: 1.6;
    max-width: 800px;
    margin: 0 auto;
    padding: 20px;
  }
  h1, h2, h3, h4, h5, h6 {
    margin-top: 20px;
  }
  pre {
    background-color: #f0f0f0;
    padding: 1px;
    overflow-x: auto;
  }
  code {
    font-family: Consolas, monospace;
    font-size: 0.9em;
  }
</style>
</head>
<body>
  <h1>Tutorial: Using USB Flash Drive for Boot and Keyfile in Linux with LVM</h1>

  <h2>Prerequisites</h2>
  <ul>
    <li><strong>Linux Distribution:</strong> Use a Linux distribution that supports <code>cryptsetup</code> for disk encryption and <code>LVM</code> (Logical Volume Manager) (e.g., Ubuntu, Debian, Fedora).</li>
    <li><strong>USB Flash Drive:</strong> Prepare a USB flash drive with sufficient capacity to hold the boot partition and the keyfile.</li>
  </ul>

  <h2>Steps</h2>
  
  <p>Partitioning layout LVM on LUKS ("Full-disk encryption") with swap and home for a minimal 32 GB (29.80232 GiB) of space with separated boot with keyfile</p>

  <pre><code>
  +------------+------------++-----------------------------------------------------------+
  |     ESP    |    Boot    ||                LUKS2 Encryption  /dev/sdb                 |
  +------------+------------++-----------------------------------------------------------+
  | EFI System |            ||                 LVM2 Group  /dev/host-vg                  |
  | Partition  |            |+-------------------+-------------------+-------------------+
  |            |            || Logical volume 1  | Logical volume 2  | Logical volume 3  |
  | /dev/sda1  | /dev/sda2  ||                   |                   |                   |
  |            |            || /dev/host-vg/swap | /dev/host-vg/root | /dev/host-vg/home |
  |            |            ||                   |                   |                   |
  | 100MiB     | 400MiB     || 4GiB              | 12GiB             | 13.7GiB           |
  |            |            ||                   |                   |                   |
  | fat32      | ext2       || swap              | ext4              | ext4              |
  | /boot/efi  | /boot      || [SWAP]            | /                 | /home             |
  +------------+------------++-------------------+-------------------+-------------------+
  </code></pre>

  <h3>1. Prepare the USB Flash Drive</h3>
  <ul>
    <li><strong>Partition USB Drive:</strong> Partition the USB flash drive to create separate partitions for <code>/boot</code>, the keyfile, and potentially LVM physical volumes. You can use tools like <code>fdisk</code>, <code>parted</code>, or a graphical partition manager like <code>gparted</code>.</li>
    <li><strong>Format Partitions:</strong> Format the partitions accordingly:
      <ul>
        <li>Format <code>/boot</code> partition with a filesystem supported by your Linux distribution (e.g., <code>ext4</code>).</li>
        <li>Store the keyfile on another partition, formatted with a filesystem that supports file storage (e.g., <code>ext4</code>).</li>
        <li>If using LVM, prepare LVM physical volumes on suitable partitions.</li>
      </ul>
    </li>
  </ul>

  <h3>2. Install Linux with Encrypted Root and LVM</h3>
  <ul>
    <li>During installation, configure your Linux distribution to use the USB flash drive:
      <ul>
        <li>Set up disk encryption (e.g., LUKS) on the system's main drive (<code>/dev/sda</code>).</li>
        <li>Create LVM logical volumes for <code>/</code>, <code>/home</code>, etc., using the LVM physical volumes on the USB flash drive.</li>
        <li>Configure <code>/boot</code> to be located on the <code>/boot</code> partition of the USB flash drive (<code>/dev/sdb1</code>).</li>
        <li>Install Linux normally, selecting options that reflect the changes you made.</li>
      </ul>
    </li>
  </ul>

  <h3>3. Configure <code>cryptsetup</code> to Use Keyfile</h3>
  <ul>
    <li>After installation, mount the USB flash drive and create a keyfile for encryption:
      <ul>
        <li>Use <code>dd</code> to create a keyfile on the USB flash drive, for example:
          <pre><code>sudo dd if=/dev/urandom of=/media/usb/keyfile bs=512 count=4</code></pre>
        </li>
        <li>Add the keyfile to the LUKS encryption key slots using <code>cryptsetup</code>:
          <pre><code>sudo cryptsetup luksAddKey /dev/sda1 /media/usb/keyfile</code></pre>
        </li>
      </ul>
    </li>
  </ul>

  <h3>4. Update <code>/etc/fstab</code> and <code>/etc/crypttab</code></h3>
  
  <ul>
    <li>Update <code>/etc/fstab</code> to include the USB flash drive's partitions, including <code>/boot</code> and the keyfile:
      <h5>Example - /etc/fstab Configuration</h5>
        <pre><code>
          # /boot partition
          UUID=your-boot-UUID /boot ext4 defaults 0 2
          # Partition with the keyfile
          UUID=your-keyfile-partition-UUID /media/usb ext4 defaults 0 2
        </code></pre>
    </li>
  </ul>

</body>
</html>
