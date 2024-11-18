<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Qubes OS - Additional Losetup Storage</title>
<style>
    body {
      font-family: Arial, sans-serif;
      line-height: 1.6;
    }
    h1, h2 {
      color: #333;
    }
    code {
      background-color: #f4f4f4;
      padding: 0.2em;
    }
</style>
</head>
<body>

  ### ATTACH NOT WORKING ###

  <h2>Qubes OS - Additional Losetup Storage</h2>

  <p>Reference:</p>
  <a href="https://forum.qubes-os.org/t/how-to-create-and-use-additional-volumes-for-vms/23959">
  How to create and use additional volumes for VMs?</a>

  <p>This guide will walk you through creating a loop device to use as a virtual partition
    for encrypted storage in ZuluCrypt or VeraCrypt.</p>

  <p>Loop devices are excellent for users prioritizing flexibility and minimal system
    modifications, but physical partition encryption offers superior performance,
    security, and support for complex storage needs.</p>

  <p>Pros and cons of using loop devices to create encrypted partitions in ZuluCrypt
    or VeraCrypt.</p>

  <table border="1">
  <thead>
    <tr>
      <th>Advantages</th>
      <th>Disadvantages</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><strong>Flexibility and Portability:</strong> Encrypted loop devices are stored
        as files, making them easy to move across systems without modifying physical
        disk partitions.</td>
      <td><strong>Performance Overheads:</strong> Loop device encryption can be slower
        than native partition-based encryption, especially under high I/O operations.</td>
    </tr>
    <tr>
      <td><strong>No Partition Modifications Required:</strong> There’s no need to resize
        or alter physical partitions, reducing the risk to underlying LVM structures.
      </td>
      <td><strong>Fragmentation Issues:</strong> Files in loop devices are subject to
        fragmentation, which can affect performance over time.</td>
    </tr>
    <tr>
      <td><strong>Compatibility with Non-Encrypted Systems:</strong> Loop device files
        can be mounted on various systems, allowing access with VeraCrypt or ZuluCrypt
        installed.
      </td>
      <td><strong>Less Secure Key Management:</strong> Loop devices may lack advanced
        security integrations like TPM, which are available with native encryption
        tools like LUKS.</td>
    </tr>
    <tr>
      <td><strong>Granularity of Encryption:</strong> Allows precise control over the
        encrypted container's size, avoiding unnecessary space use on systems with
        limited disk space.</td>
      <td><strong>Limited Support for Complex Storage Layouts:</strong> For setups like
        RAID, physical partition encryption is often better suited.</td>
    </tr>
    <tr>
      <td></td>
      <td><strong>Reliability on File Systems:</strong> Loop devices rely on both the
        host filesystem and the underlying storage device, making them potentially
        less resilient to corruption.</td>
    </tr>
  </tbody>
  </table>

<h2>Encryption with zuluCrypt Using a Loop Device in Qubes OS</h2>

<h2>Step 1: Create a minimal TemplateVM for zuluCrypt.</h2>

<ul>  
  <li>Start by installing a minimal TemplateVM with the necessary Debian release. For
    example, for Debian 12:</li>
  <pre><code>
[user@dom0 ~]$ sudo qubes-dom0-update qubes-template-debian-12-minimal
  </code></pre>
  
  <li>Customize the Minimal Template for zuluCrypt. First, clone the Minimal Template
   to create an AppVM then delete the unecessary:</li>
  <pre><code>
[user@dom0 ~]$ qvm-clone debian-12-minimal debian-12-encryption
[user@dom0 ~]$ qvm-remove debian-12-minimal
  </code></pre>
  
  <li>Start the TemplateVM to install necessary packages:</li>
  <pre><code>
[user@dom0 ~]$ qvm-run -u root debian-12-encryption xterm
  </code></pre>

  <li>Install Required Packages:</li>
  <ul>
    <li>In the TemplateVM terminal, install the following packages to support zuluCrypt
     and necessary Qubes functionalities:</li>
  <pre><code>
[root@debian-12-encryption ~]# apt update
[root@debian-12-encryption ~]# apt install -y zulucrypt-gui \
gnome-keyring \
vim-tiny \
pciutils \
less \
psmisc \
zenity \
qubes-core-agent \
qubes-core-agent-nautilus \
qubes-core-agent-passwordless-root
  </code></pre>

  <li>Shut down the TemplateVM after installation:</li>
  <pre><code>
[root@debian-12-encryption ~]# shutdown now
  </code></pre>

  <li>Create a New AppVM based on the minimal TemplateVM (e.g., <code>zulucrypt1</code>):</li>
  <pre><code>
[user@dom0 ~]$ qvm-create --class AppVM --property template=debian-12-encryption --label gray zulucrypt1
  </code></pre>

  <li>Enable zuluCrypt shortcut in the App Menu by opening the settings and going to the
   Application tab:</li>
  <pre><code>
[user@dom0 ~]$ qubes-vm-settings zulucrypt1
  </code></pre>
</ul>

<h2>Step 2: Increase Private Storage Size</h2>
  
  <p>Adjust the private storage size in <code>dom0</code> for the created <code>zulucrypt1</code>
   AppVM. Its recommended to add 1 GB to have enough space.</p>

  <pre><code>
[user@dom0 ~]$ qvm-volume resize zulucrypt1:private 1073741824 #For 1 GB
[user@dom0 ~]$ qvm-volume resize zulucrypt1:private 34359738368 #For 32GB
[user@dom0 ~]$ qvm-volume resize zulucrypt1:private 68719476736 #For 64GB
[user@dom0 ~]$ qvm-volume resize zulucrypt1:private 137438953472 #For 128GB
[user@dom0 ~]$ qvm-volume resize zulucrypt1:private 274877906944 #For 256GB
  </code></pre>

<h2>Step 3: Create a File for the Loop Device</h2>

<p>To simulate a partition, start by creating a file to act as your virtual disk. You can
 change the file location and size.</p>

<pre><code>
[user@zulucrypt1 ~]$ dd if=/dev/zero of=/home/user/storage.disk bs=1M count=10240 status=progress
</code></pre>

<p>This command creates a 10GB file named <code>storage.disk</code> in your home directory.</p>
  
<h2>Step 4: Attach the File as a Loop Device</h2>

<p>Next, use <code>losetup</code> to connect this file to a loop device. This creates a block
 device that you can partition and format. There are two possible approachs:</p>

<p>If you want a simpler approach that directly specifies loop11 (or another higher number 1..63),
 you could just check the current loop devices in dom0 with:</p>

<pre><code>
user@dom0 ~]$ sudo losetup -a
</code></pre>

<p>Then make your choice like <code>loop11</code>:</p>

<pre><code>
sudo losetup --show '/dev/loop11' '/home/user/mystorage.disk'
</code></pre>

<p>Another approach, useful for scripts, is use the <code>--find --show</code>
  option that finds the first available loop device (e.g., <code>/dev/loop11</code>)
  and attaches it to <code>storage.disk</code>. Take care, for scripts do not
  use the default loop0.</p>

<pre><code>
for i in {1..63}; do
    if ! losetup /dev/loop$i &>/dev/null; then
        sudo losetup /dev/loop$i /home/user/storage.disk
        break
    fi
done
</code></pre>

<p>Take note the device name output.</p>

<h2>Step 5: Encrypt the Loop Device</h2>

<p>Encrypting with zuluCrypt</p>
<ol>
  <li>
    <strong>Open zuluCrypt</strong>
    <p>Create a new volume. Choose "Encrypted Container In A Hard Drive."</p>
  </li>
  <li>
    <strong>Select the Loop Device</strong>
    <p>Select <code>/dev/loop11</code> as the volume to encrypt and follow the prompts.</p>
  </li>
  <li>
    <strong>Complete the Encryption</strong>
    <p>After encrypting the volume, you can mount it directly for use.</p>
    <p>Se the process result with:</p>
    <pre><code>[user@zulucrypt1 ~]$ ls -lh</code></pre>
    <pre><code>[user@zulucrypt1 ~]$ lsblk</code></pre>
  </li>
</ol>

<h2>Step 6: Attach the Encrypted Volume to Another Qube</h2>

<p>Now you can attach the encrypted loop device to any qube you like,
  just unmount, detach and attach again. You can do this
  using GUI tools or the terminal in <code>dom0</code>:</p>

<pre><code>
[user@dom0 ~]$ qvm-block attach 'personal' 'zulucrypt1:loop11'
</code></pre>

<h2>Step 7: Mount the Encrypted Partition</h2>

<p>After attaching the loop device to your desired qube, you can mount it as you would
  with any real storage device.</p>

<h2>Step 8: Detach the Loop Device</h2>

<p>When you're finished using the loop device, unmount it in the attached qube. Then,
  detach the loop device from your storage qube:</p>
<pre><code>
[user@zulucrypt1 ~]$ sudo losetup -d /dev/loop11
</code></pre>

<p>You can now remount and use the encrypted file-backed partition
  as needed. This method is also compatible with Windows; you can format the disk to
  NTFS for seamless usage.</p>


  <h1>Resizing and Deleting Partitions on Loop Devices</h1>

  <h2>Note:</h2>
  
  <ul>
    <li><strong>Backup:</strong> Always ensure that you have backups of important data before modifying partitions or filesystems.</li>
    <li><strong>Unmount:</strong> Make sure the partitions are unmounted before performing these operations.</li>
    <li><strong>Filesystem Checks:</strong> Consider running filesystem checks (e.g., <code>fsck</code>) if you encounter any issues after resizing or deleting partitions.</li>
  </ul>
  
  <h2>Resizing a Partition</h2>

  <ol>
    <li>
      <strong>Detach the Loop Device:</strong>
      <pre>[user@dom0 ~]$ sudo losetup -d /dev/loop11</pre>
    </li>
    <li>
      <strong>Resize the Virtual Disk File:</strong>
      <p>To increase the size (e.g., to 2GB):</p>
      <pre>[user@dom0 ~]$ dd if=/dev/zero bs=1M count=1024 >> ~/storage.disk</pre>
      <p>To decrease the size:</p>
      <pre>[user@dom0 ~]$ truncate -s 1G ~/storage.disk</pre>
    </li>
    <li>
      <strong>Reattach the Loop Device:</strong>
      <pre>[user@dom0 ~]$ sudo losetup --find --show ~/storage.disk</pre>
    </li>
    <li>
      <strong>Use fdisk to Resize the Partition:</strong>
      <pre>[user@dom0 ~]$ sudo fdisk /dev/loop11</pre>
      <p>Follow these steps in fdisk:</p>
      <ul>
        <li>Delete the existing partition using the <code>d</code> command.</li>
        <li>Recreate it using the <code>n</code> command, specifying the new size.</li>
        <li>Write the changes with the <code>w</code> command.</li>
      </ul>
    </li>
    <li>
      <strong>Resize the Filesystem:</strong>
      <pre>[user@dom0 ~]$ sudo resize2fs /dev/loop11p1</pre>
    </li>
  </ol>

  <h2>Deleting a Partition</h2>

  <ol>
    <li>
      <strong>Detach the Loop Device:</strong>
      <pre>[user@dom0 ~]$ sudo losetup -d /dev/loop11</pre>
    </li>
    <li>
      <strong>Reattach the Loop Device:</strong>
      <pre>[user@dom0 ~]$ sudo losetup --find --show ~/storage.disk</pre>
    </li>
    <li>
      <strong>Use fdisk to Delete the Partition:</strong>
      <pre>[user@dom0 ~]$ sudo fdisk /dev/loop11</pre>
      <p>Follow these steps in fdisk:</p>
      <ul>
        <li>Use the <code>d</code> command to delete the partition.</li>
        <li>Continue using the <code>d</code> command until all desired partitions are deleted.</li>
        <li>Write the changes with the <code>w</code> command.</li>
      </ul>
    </li>
    <li>
      <strong>Detach the Loop Device Again:</strong>
      <pre>[user@dom0 ~]$ sudo losetup -d /dev/loop11</pre>
    </li>
    <li>
      <strong>Optionally, Reduce the Size of the Image File:</strong>
      <pre>[user@dom0 ~]$ truncate -s 1G ~/storage.disk</pre>
    </li>
  </ol>

</body>
</html>