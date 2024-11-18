<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Restore Accidentally Deleted Files</title>
<style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f9f9f9;
      margin: 0;
      padding: 20px;
    }
    h1, h2, h4, h5, h6 {
      color: #333;
    }
    p {
      line-height: 1.6;
    }
    ul, ol {
      padding-left: 20px;
    }
    pre {
      background-color: #eee;
      padding: 10px;
      border-radius: 5px;
      overflow-x: auto;
    }
    code {
      font-family: monospace;
      background-color: #f2f2f2;
      padding: 2px 4px;
      border-radius: 4px;
    }
    a {
      color: #007bff;
      text-decoration: none;
    }
    a:hover {
      text-decoration: underline;
    }
</style>
</head>
<body>

  <h1>Restore Accidentally Deleted Files with Clonezilla</h1>

  <h4>Introduction to Clonezilla</h4>

  <p>Clonezilla is a powerful, free, and open-source software designed for disk imaging and cloning. It supports a wide range of file systems and offers features like selective partition cloning, disk resizing, and encryption. Clonezilla is suitable for users seeking flexibility and simplicity in disk management.</p>

  <p>Unlike basic tools like <code>dd</code>, <a href="https://clonezilla.org" target="_blank">Clonezilla</a> provides a user-friendly interface with additional features for disk and partition management. However, it operates offline, meaning you cannot clone disks directly over the internet, but you can use network-based filesystems like NFS or Samba for remote operations.</p>

  <h5>Clonezilla Limitations:</h5>
  <ul>
    <li>The destination partition must be equal to or larger than the source one.</li>
    <li>Differential/incremental backups are not yet supported.</li>
    <li>Online imaging/cloning is not available; the partition must be unmounted.</li>
    <li>Images cannot be directly mounted or explored; single-file recovery is not possible without workarounds (<a href="http://drbl.org/faq/fine-print.php?path=./2_System/43_read_ntfsimg_content.faq#43_read_ntfsimg_content.faq" target="_blank">details here</a>).</li>
    <li>Recovery Clonezilla Live using multiple CDs/DVDs is not yet supported (files must be on a single disk).</li>
  </ul>

  <p>For more details, refer to the <a href="https://clonezilla.org/clonezilla-live-doc.php" target="_blank">official Clonezilla documentation</a>.</p>

  <h4>Disk Cloning and Imaging with Clonezilla</h4>

  <p>Clonezilla supports various methods for disk imaging and cloning:</p>

  <ul>
    <li><strong>Disk Image:</strong>
      <ul>
        <li><strong>Full Disk:</strong> Creates an exact copy of the entire disk, including all partitions.</li>
        <li><strong>Selective:</strong> Allows cloning of specific partitions.</li>
      </ul>
    </li>
    <li><strong>Disk-to-Disk:</strong> Directly clones one disk to another, preserving partitions and data.</li>
    <li><strong>Partition-to-Partition:</strong> Clones selected partitions from one disk to another.</li>
    <li><strong>Partition-to-Image:</strong> Saves selected partitions as image files for future restoration.</li>
    <li><strong>Image-to-Partition:</strong> Restores a partition from an image file to a disk.</li>
    <li><strong>Image-to-Disk:</strong> Restores an entire disk from a saved image.</li>
  </ul>

  <h4>Command-line Usage Examples</h4>

  <p>Clonezilla's command-line interface provides advanced options for saving and restoring disk images. Below is a sample command for saving multiple partitions to an image:</p>

  <pre><code>/usr/sbin/ocs-sr -luks no -q2 -c -j2 -z9p -i 4096 -sfsck -scs -senc -p poweroff saveparts my_backup sda1 sda2 sdb1 sdb2</code></pre>

  <p>Explanation of the flags used:</p>
  <ul>
  <li><strong>-luks no:</strong> Disables encryption.</li>
  <li><strong>-q2:</strong> Runs in quiet mode (fewer prompts).</li>
  <li><strong>-c:</strong> Runs a checksum after cloning to ensure data integrity.</li>
  <li><strong>-j2:</strong> Uses parallel gzip compression to speed up the process.</li>
  <li><strong>-z9p:</strong> Enables maximum compression level for image size reduction.</li>
  <li><strong>-i 4096:</strong> Sets the block size to 4096 bytes for efficient data transfer.</li>
  <li><strong>-sfsck:</strong> Performs a filesystem check before cloning to catch potential issues.</li>
  <li><strong>-p poweroff:</strong> Powers off the machine automatically after cloning is complete.</li>
  </ul>

  <p>When using Clonezilla's command-line interface, you typically do not need to activate storage devices manually, as Clonezilla automatically detects devices during startup. However, if the target storage devices (e.g., external USB drives) are not detected, you may need to mount them first.</p>

  <h5>Mounting Storage Devices</h5>
  <p>If you need to access Clonezilla images stored on external drives, ensure they are mounted to an appropriate directory:</p>
  <pre><code>sudo mount /dev/sdb1 /home/partimag</code></pre>

  <p>To verify that your devices are properly mounted, use the following command:</p>
  <pre><code>lsblk</code></pre>

  <p>Once your storage devices are mounted and accessible, you can proceed to use Clonezilla commands to save or restore images as needed.</p>

  <h4>Changing Disk Names in Clonezilla Images</h4>

  <h5>Using <code>cnvt-ocs-dev</code> for Device Name Conversion</h5>

  <p>If you're deploying a Clonezilla image to a system with different device names (e.g., moving from <code>sda2</code> to <code>sdb1</code>), you can use the <code>cnvt-ocs-dev</code> command to update the device names inside the image.</p>

  <h6>Basic Syntax</h6>
  <pre><code>$ cnvt-ocs-dev -d /path/to/image_directory 'image_name' 'old_device' 'new_device'</code></pre>

  <ul>
    <li><strong><code>/path/to/image_directory</code></strong>: Directory where your Clonezilla images are stored (commonly <code>/home/partimag</code>).</li>
    <li><strong><code>image_name</code></strong>: Name of the Clonezilla image.</li>
    <li><strong><code>old_device</code></strong>: Current device name in the image (e.g., <code>sda3</code>).</li>
    <li><strong><code>new_device</code></strong>: New device name (e.g., <code>sdb1</code>).</li>
  </ul>

  <h6>Example Commands</h6>

  <p>1. Convert device name <code>sda3</code> to <code>sda2</code> in the image <code>my_backup</code>:</p>
  <pre><code>$ cnvt-ocs-dev -d /home/partimag 'my_backup' 'sda3' 'sda2'</code></pre>

  <p>2. Change partition name from <code>sda1</code> to <code>sdb1</code>:</p>
  <pre><code>$ cnvt-ocs-dev -d /home/partimag 'my_image' 'sda1' 'sdb1'</code></pre>

  <p>3. Convert multiple devices at once:</p>
  <pre><code>
  $ cnvt-ocs-dev -d /home/partimag 'my_image' 'sda1' 'sdb1'
  $ cnvt-ocs-dev -d /home/partimag 'my_image' 'sda2' 'sdb2'
  $ cnvt-ocs-dev -d /home/partimag 'my_image' 'sda3' 'sdb3'
  </code></pre>

  <p>4. Verify the image and partition names before conversion:</p>
  <pre><code>$ ls /home/partimag/my_backup</code></pre>
  <pre><code>$ cat /home/partimag/my_backup/blkdev.list</code></pre>

  <h4>Troubleshooting and Manual Recovery</h4>

  <p>If you're working with Clonezilla backups and need to restore a partition from a Clonezilla image, keep in mind that Clonezilla doesn't support restoring images to different device names across multiple disks. However, you can convert device names within the Clonezilla image using the <code>cnvt-ocs-dev</code> command.</p>

  <h5>Decompressing and Combining Clonezilla Images</h5>

  <p>When Clonezilla creates an image, it may split the image into multiple parts. To restore these parts, they must be combined:</p>

  <h6>Combining Image Parts</h6>

  <p>If your Clonezilla image is split into multiple parts (e.g., <code>part1</code>, <code>part2</code>, etc.), you can combine them using the <code>cat</code> command:</p>

  <pre><code>cat part1 part2 part3 > combined_image.img</code></pre>
  <pre><code>cat sda2.dd-ptc1-img.zst.* > sda2.dd-ptc1-img.zst</code></pre>

  <h6>Decompressing the Image</h6>

  <p>If the image parts are compressed (e.g., using <code>zstd</code>), decompress them after combining:</p>

  <pre><code>zstd -d combined_image.img.zst -o combined_image.img</code></pre>

  <h6>Using the <code>dd</code> Command to Restore the Image</h6>

  <p>After combining and decompressing the image, you can restore it to a disk using the <code>dd</code> command.</p>

  <p>Restoring Smaller Partitions or Files</p>
  <pre><code>sudo dd if=combined_image.img of=/dev/sda bs=64K status=progress</code></pre>

  <p>Whole Disk Copies:</p>
  <pre><code>sudo dd if=combined_image.img of=/dev/sda bs=4M status=progress</code></pre>

  <p><strong>Note:</strong> Ensure that <code>/dev/sda</code> is the correct target disk, as this command will overwrite the existing data on that disk.</p>

  <h6>Syncing and Verifying Data</h6>

  <p>Once <code>dd</code> completes, run the following command to ensure all data is written:</p>

  <pre><code>sync</code></pre>
  <pre><code>sudo dd if=combined_image.img of=/dev/sda bs=64K status=progress conv=sync</code></pre>

  <p>Optionally, you can verify the data integrity using checksums:</p>

  <pre><code>sha256sum combined_image.img</code></pre>
  <pre><code>sha256sum /dev/sda</code></pre>

</body>
</html>
