<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Qubes OS - Additional Logical Volume</title>
<style>
    body {
      font-family: Arial, sans-serif;
      line-height: 1.6;
    }
    h1 {
      color: #245CB9;
    }
    h2 {
      color: #245CB9;
    }
    pre {
      display: block;
      white-space: pre-wrap;
      word-wrap: break-word;
    }
    code {
      background-color: #f4f4f4;
      padding: 2px 5px;
      border-radius: 3px;
    }
    p {
      margin-bottom: 20px;
    }
</style>
</head>
<body>
  
  <h2>Qubes OS - Additional Logical Volume</h2>

  <p>Follow these steps to create and manage an additional LVM volume in Qubes OS.</p>

  <p>Be cautious when managing volumes, as incorrect commands can affect data integrity.</p>

  <h2>Step 1: Create a Logical Volume</h2>
  <p>Run the following command in dom0 to create a new logical volume named <code>storage</code> with a size of 20 GB in the <code>qubes_dom0</code> volume group:</p>
  <pre><code>sudo lvcreate -n storage -V 20G --thinpool vm-pool qubes_dom0</code></pre>

  <h2>Step 2: Locate the Device ID</h2>
  <p>Run <code>qvm-block</code> in dom0 to get the DEVICE_ID. It should look like <code>dom0:dm-59</code>.</p>
  <pre><code>qvm-block</code></pre>
  
  <h2>Step 3: Attach the Device to a Qube</h2>
  <p>Use <code>qvm-block attach</code> to attach the device to a target Qube (replace <code>QUBE</code> with your actual Qube name):</p>
  <pre><code>qvm-block attach QUBE dom0:dm-59</code></pre>
  
  <p>Alternatively:</p>
  
  <pre><code>qvm-block attach QUBE $(sudo blkid -o value -s UUID | grep your-uuid | awk -F':' '{print "dom0:" $(sudo lvs --noheadings -o lv_path | grep "lvm" | awk '{print $1}')}')
  </code></pre>

  <h2>Step 4: Format the Volume in the Qube</h2>
  <p>Open a terminal in the Qube as root and format the device using the <code>mkfs</code> command:</p>
  
  <pre><code>mkfs /dev/xvdi</code></pre>
  
  <p>Note: The device name may vary, depending on your setup. Replace <code>/dev/xvdi</code> with the correct name if needed, check with <code>lsblk</code> before and after mount and in dom0 with <code>sudo lvs | grep storage</code>.</p>

  <h2>Step 5: Mount the Volume</h2>
  <p>Mount the device to a directory, such as <code>/mnt</code>, to start using it:</p>
  <pre><code>mount /dev/xvdi /mnt</code></pre>
  
  <p>Perform any necessary actions on the mounted volume. Example Steps to Mount a Logical Volume:</p>

  <ul>
  <li>Create a Mount Point:</li>
  <pre><code>sudo mkdir -p /mnt/my_volume</code></pre>

  <li>Adjust Permissions (if needed):</li>
  <pre><code>sudo chmod 755 /mnt/my_volume</code></pre>

  <li>Change Ownership:</li>
  <pre><code>sudo chown user:user /mnt/my_volume</code></pre>

  <li>Mount the Logical Volume:</li>
  <pre><code>sudo mount /dev/xvdi /mnt/my_volume</code></pre>

  <li>Access the Mounted Volume:</li>
  <p>You can now access the contents of the logical volume at <code>/mnt/my_volume</code>.</p>

  <li>Unmount When Done:</li>
  <pre><code>sudo umount /mnt/my_volume</code></pre>
  </ul>

  <h2>Step 6: Unmount the Volume</h2>
  <p>Once done, unmount the volume:</p>
  <pre><code>umount /mnt</code></pre>

  <h2>Step 7: Detach the Volume from the Qube</h2>
  <p>Detach the volume from the Qube using <code>qvm-block detach</code>:</p>
  <pre><code>qvm-block detach QUBE dom0:dm-59</code></pre>

  <h2>Step 8-10: Attach the Volume as Read-Only to Other Qubes</h2>
  <p>To attach the volume in read-only mode to other Qubes, use the following command:</p>
  <pre><code>qvm-block attach --ro qube1 dom0:dm-59</code></pre>
  <p>Repeat this for <code>qube2</code>... as needed.</p>
  
  
  <h3>Alternative Step 5: Mount the Volume</h3>
  <p>1. Use <code>/etc/fstab</code> with <code>user</code> Option</p>

<p>You can edit the <code>/etc/fstab</code> file to allow regular users to mount a specific device without needing <code>sudo</code>. Here’s how:</p>

<ul>
  <li>Open <code>/etc/fstab</code> as root:</li>
  <pre><code>sudo nano /etc/fstab</code></pre>

  <li>Add a line for the device, specifying the <code>user</code> option:</li>
  <pre><code>/dev/xvdi  /mnt/my_volume  ext4  user,noauto  0  0</code></pre>
  <ul>
    <li><code>user</code> allows any user to mount and unmount the filesystem.</li>
    <li><code>noauto</code> prevents the device from mounting automatically at boot, but users can manually mount it when needed.</li>
  </ul>

  <li>Save and exit the editor.</li>

  <li>With this setup, you can mount the volume without <code>sudo</code> by running:</li>
  <pre><code>mount /mnt/my_volume</code></pre>

  <li>And to unmount:</li>
  <pre><code>umount /mnt/my_volume</code></pre>
</ul>

  <h3>Removing the Volume and Thin Pool</h3>

  <p>Make sure you don’t have any VMs using this volume before you delete it:</p>

  <pre><code>
  qvm-block
  sudo lvs | grep my_volume
  </code></pre>

  <p>Remove the thin volume from the pool:</p>

  <pre><code>
  sudo lvremove vm-pool/my_volume
  </code></pre>

  <p>Remove the logical volume you created:</p>
  <pre><code>sudo lvremove qubes_dom0/my_volume</code></pre>

</body>
</html>
