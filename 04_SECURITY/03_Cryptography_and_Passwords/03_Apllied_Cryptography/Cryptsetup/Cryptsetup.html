<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>File Systems and Encrypted Flash Drive Setup</title>
    <style>
        body {
        font-family: Arial, sans-serif;
        line-height: 1.6;
        margin: 20px;
        }
        table {
        width: 100%;
        border-collapse: collapse;
        }
        th, td {
        border: 1px solid #000;
        padding: 8px;
        text-align: left;
        }
        th {
        background-color: #f2f2f2;
        }
        pre, code {
        background-color: #f4f4f4;
        padding: 10px;
        border-radius: 5px;
        display: block;
        margin: 2px 0;
        overflow-x: auto;
        }
        pre < code {
        background-color: #f4f4f4;
        padding: 10px;
        border-radius: 5px;
        display: block;
        margin: 2px 0;
        overflow-x: auto;
        }        
        button {
        margin-top: 5px;
        padding: 5px 5px;
        font-size: 1em;
        cursor: pointer;
        }
    </style>
</head>
<body>

<h2>Create an Encrypted Flash Drive</h2>

<pre>
$ sudo fdisk /dev/sdb
</pre>

<pre>
Command (m for help): n
Partition type
   p   primary (0 primary, 0 extended, 4 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (1-4, default 1): 1
First sector (2048-60555263, default 2048): 
Last sector, +sectors or +size{K,M,G,T,P} (2048-60555263, default 60555263): 
</pre>

<h3>Created a new partition 1 of type 'Linux' and of size 29 GiB.</h3>

<pre>
Command (m for help): p
Disk /dev/sdb: 29 GiB, 31004000000 bytes, 60550000 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x12345678

Device     Boot Start      End  Sectors  Size Id Type
/dev/sdb1        2048  60550000  60548000  29G  83 Linux

Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
</pre>

<h3>Set the Label Once the LUKS Container is Opened</h3>

<pre>
$ sudo cryptsetup luksFormat /dev/sdb1
$ sudo cryptsetup luksOpen /dev/sdb1 LUKS0001
$ sudo mkfs.ext4 /dev/mapper/LUKS0001 -L <label>
$ sudo cryptsetup luksClose LUKS0001
</pre>

<p>To set the label so it appears when the flash drive is inserted, use the following command:</p>

<pre>
$ sudo cryptsetup config /dev/sdb1 --label <label>
</pre>

<p>Finally, you may want to change the ownership of the filesystem. When the drive is mounted, do:</p>

<pre>
$ sudo chown <user>:<user> -R /path/to/mounted/volume
</pre>

<hr>

<h2>Manually Mount Encrypted LVM Logical Volume</h2>

<h3>Identify the Encrypted Device</h3>

<pre>
$ sudo lsblk -f /dev/sdb
NAME   FSTYPE      LABEL UUID                                 MOUNTPOINT
sdb                                                           
├─sdb1 ext2              12345678-9abc-def0-1234-56789abcdef0 
├─sdb2                                                        
└─sdb5 crypto_LUKS       abcdef12-3456-789a-bcde-f0123456789a 
$ sudo file -s /dev/sdb5
/dev/sdb5: LUKS encrypted file, ver 1 [aes, xts-plain64, sha1] UUID: abcdef12-3456-789a-bcde-f0123456789a
</pre>

<h3>Open LUKS Device</h3>

<pre>
$ sudo cryptsetup luksOpen /dev/sdb5 encrypted_device
Enter passphrase for /dev/sdb5: ****************
</pre>

<h3>Identify Volume Group</h3>

<pre>
$ sudo vgdisplay --short
  "alice-vg" <466 GiB [<466 GiB used / 0 free]
  "bob-vg" <1.82 TiB [<1.82 TiB used / 0 free]
</pre>

<h3>List Logical Volumes</h3>

<pre>
$ sudo lvs -o lv_name,lv_size -S vg_name=bob-vg
  LV      LSize  
  root    1.8T
  swap_1  16G
</pre>

<h3>Activate Logical Volumes</h3>

<pre>
$ sudo lvchange -ay bob-vg/root
</pre>

<h3>Mount the Filesystem</h3>

<pre>
$ sudo mount /dev/bob-vg/root /mnt
</pre>

<h3>Unmount and Deactivate</h3>

<pre>
$ sudo umount /mnt
$ sudo lvchange -an bob-vg/root
$ sudo cryptsetup luksClose encrypted_device
</pre>

<hr>

<h2>Change the Encryption Passphrase</h2>

<p>There are actually 8 passphrase slots with LUKS encryption. To check which slots are being used:</p>

<pre>
$ sudo cryptsetup luksDump /dev/<encrypted_device>
</pre>

<p><strong>Note:</strong> In a typical FDE setup (LVM+LUKS), the encrypted device will be the physical partition. Typically /dev/sda1 is boot, /dev/sda2 is a primary partition containing secondary partition /dev/sda5, and /dev/sda5 is the actual encrypted device.</p>

<p>Add a new passphrase:</p>

<pre>
$ sudo cryptsetup luksAddKey /dev/<encrypted_device>
</pre>

<p>Remove a passphrase:</p>

<pre>
$ sudo cryptsetup luksRemoveKey /dev/<encrypted_device>
</pre>

<hr>

<h2>Create an Encrypted Partition with a Key File</h2>

<p>In addition to a passphrase, you can use a key file to open an encrypted container. This is convenient for additional encrypted containers, avoiding the need to enter multiple passphrases at boot.</p>

<p><strong>Important:</strong> To avoid losing access if the key file is damaged or lost, always use a passphrase for the first LUKS key slot.</p>

<hr>

<h3>Create the Key File</h3>

<pre>
$ sudo mkdir /etc/luks-keys/
$ sudo dd if=/dev/urandom of=/etc/luks-keys/mykey bs=512 count=8
$ sudo chmod 0600 /etc/luks-keys/mykey
</pre>

<hr>

<h3>Create the Encrypted Container</h3>

<h4>Format the device. You will have to enter a passphrase:</h4>

<pre>
$ sudo cryptsetup -y -v luksFormat --type luks /dev/sdb1
</pre>

<h4>Check the container can be opened with the passphrase:</h4>

<pre>
$ sudo cryptsetup open /dev/sdb1 mycrypt
$ sudo cryptsetup close mycrypt
</pre>

<h4>Add the key file in the second key slot:</h4>

<pre>
$ sudo cryptsetup -v luksAddKey /dev/sdb1 /etc/luks-keys/mykey
</pre>

<h4>Check the container can be opened with the key file:</h4>

<pre>
$ sudo cryptsetup open /dev/sdb1 mycrypt --key-file=/etc/luks-keys/mykey
</pre>

<h4>Format it and mount it:</h4>

<pre>
$ sudo mkfs.ext4 /dev/mapper/mycrypt
$ sudo mount /dev/mapper/mycrypt /mnt
</pre>

<h4>Get the container UUID and add it to /etc/crypttab to have it opened at boot:</h4>

<pre>
$ sudo cryptsetup luksDump /dev/sdb1 | grep "UUID"
echo 'mycrypt    UUID=abcdef12-3456-789a-bcde-f0123456789a /etc/luks-keys/mykey luks' | sudo tee -a /etc/crypttab
</pre>

<h4>Update /etc/fstab:</h4>

<pre>
/dev/mapper/mycrypt /mnt ext4 defaults 0 2
</pre>

</body>
</html>
