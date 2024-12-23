<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Encrypted LVM on LUKS with a File</title>
</head>
<body>
  <h1>Encrypted LVM on LUKS with a File</h1>

  <h2>Steps to Create an Encrypted LVM on LUKS with a File</h2>
  <ol>
  <li><strong>Install Required Tools:</strong> Make sure <code>lvm2</code> and <code>cryptsetup</code> are installed.</li>

  <li><strong>Create a File to Serve as the Vault:</strong> Use <code>dd</code> to create a file with the desired size. For a 128GB file:
    <pre><code>sudo dd if=/dev/zero of=/path/to/vault.img bs=1M count=131072</code></pre>
    <ul>
    <li><code>of</code>: Output file path (e.g., <code>/path/to/vault.img</code>).</li>
    <li><code>bs=1M</code>: Block size of 1 MB.</li>
    <li><code>count=131072</code>: Number of 1 MB blocks (128 GB in total).</li>
    </ul>
  </li>

  <li><strong>Format with LUKS:</strong> Initialize LUKS encryption on the file:
    <pre><code>sudo cryptsetup luksFormat --cipher aes-xts-plain64 --key-size 256 /path/to/vault.img</code></pre>
  </li>

  <li><strong>Open the LUKS-Encrypted File:</strong> Unlock the encrypted file and map it to a device (e.g., <code>vault_device</code>):
    <pre><code>sudo cryptsetup luksOpen /path/to/vault.img vault_device</code></pre>
  </li>

  <li><strong>Create a Physical Volume:</strong>
    <pre><code>sudo pvcreate /dev/mapper/vault_device</code></pre>
  </li>

  <li><strong>Create a Volume Group:</strong> Set up a volume group (e.g., <code>vault_vg</code>):
    <pre><code>sudo vgcreate vault_vg /dev/mapper/vault_device</code></pre>
  </li>

  <li><strong>Create Logical Volumes:</strong> Create logical volumes as needed. For example, to create a 10GB logical volume:
    <pre><code>sudo lvcreate -L 10G -n vault_lv vault_vg</code></pre>
  </li>

  <li><strong>Create a Filesystem:</strong> Format the logical volume with a filesystem, such as ext4:
    <pre><code>sudo mkfs.ext4 /dev/vault_vg/vault_lv</code></pre>
  </li>

  <li><strong>Mount the Logical Volume:</strong> Create a mount point and mount it:
    <pre><code>sudo mkdir /mnt/vault_data
sudo mount /dev/vault_vg/vault_lv /mnt/vault_data</code></pre>
  </li>

  <li><strong>Unmount and Close:</strong> When finished, unmount and close the encrypted file and volume:
    <pre><code>sudo umount /mnt/vault_data
sudo cryptsetup luksClose vault_device</code></pre>
  </li>
  </ol>

  <p>To verify the encryption settings for the file, you can run:</p>
  <pre><code>sudo cryptsetup luksDump /path/to/vault.img</code></pre>

</body>
</html>
