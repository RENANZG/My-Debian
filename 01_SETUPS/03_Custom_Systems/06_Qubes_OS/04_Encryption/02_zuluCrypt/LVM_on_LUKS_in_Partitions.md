<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Encrypted LVM on LUKS</title>
</head>
<body>
  <h1>Encrypted Partition Using LVM on LUKS</h1>

  <h2>Steps to Create an Encrypted LVM on LUKS</h2>
  <ol>
    <li><strong>Install Required Tools:</strong> Make sure <code>lvm2</code> and <code>cryptsetup</code> are installed.</li>
    <li><strong>Create a Partition:</strong> Use a tool like <code>fdisk</code> to create a partition for encryption (e.g., <code>/dev/sdb1</code>). To create a 128 GB partition, follow these steps:
      <pre><code>
sudo fdisk /dev/sdb
n  # Create a new partition
p  # Primary partition
1  # Partition number
[Press Enter]  # Accept default first sector
+128G  # Specify size,e. g., 128 GB
w  # Write changes
      </code></pre>
    </li>
    <li><strong>Format with LUKS:</strong> Initialize LUKS with AES-256 encryption:
      <pre><code>cryptsetup luksFormat --cipher aes-xts-plain64 --key-size 256 /dev/sdb1</code></pre>
      <ul>
        <li><code>--cipher</code>: Specifies the cipher to use, <code>aes-xts-plain64</code> is a commonly used mode.</li>
        <li><code>--key-size</code>: Sets the key size to 256 bits.</li>
      </ul>
    </li>
    <li><strong>Open the LUKS Partition:</strong>
      <pre><code>cryptsetup luksOpen /dev/sdb1 my_encrypted_volume</code></pre>
    </li>
    <li><strong>Create a Physical Volume:</strong>
      <pre><code>pvcreate /dev/mapper/my_encrypted_volume</code></pre>
    </li>
    <li><strong>Create a Volume Group:</strong>
      <pre><code>vgcreate my_volume_group /dev/mapper/my_encrypted_volume</code></pre>
    </li>
    <li><strong>Create Logical Volumes:</strong> Create logical volumes as needed. For example, to create a 10GB logical volume:
      <pre><code>lvcreate -L 10G -n my_logical_volume my_volume_group</code></pre>
    </li>
    <li><strong>Create a Filesystem:</strong> Format the logical volume with a filesystem, such as ext4:
      <pre><code>mkfs.ext4 /dev/my_volume_group/my_logical_volume</code></pre>
    </li>
    <li><strong>Mount the Logical Volume:</strong> Create a mount point and mount it:
      <pre><code>mkdir /mnt/my_encrypted_data
mount /dev/my_volume_group/my_logical_volume /mnt/my_encrypted_data</code></pre>
    </li>
    <li><strong>Unmount and Close:</strong> When finished, unmount and close the LUKS volume:
      <pre><code>umount /mnt/my_encrypted_data
cryptsetup luksClose my_encrypted_volume</code></pre>
    </li>
  </ol>

  <p>To verify the encryption settings after setting up LUKS, you can run:</p>
  <pre><code>cryptsetup luksDump /dev/sdb1</code></pre>

</body>
</html>
