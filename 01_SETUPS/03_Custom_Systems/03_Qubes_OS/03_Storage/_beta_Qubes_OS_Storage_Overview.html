<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Qubes OS Storage Overview</title>
<style>
    body {
      font-family: Arial, sans-serif;
      margin: 20px;
      line-height: 1.6;
    }
    h1 {
      color: #333;
    }
    h2 {
      color: #555;
    }
    ul {
      list-style-type: disc;
      margin-left: 20px;
    }
    code {
      background-color: #f4f4f4;
      padding: 2px 4px;
      border-radius: 3px;
    }
    a {
      color: #0066cc;
    }
</style>
</head>
<body>

<h2>Qubes OS Storage Overview (R4.2)</h2>

<p>Qubes OS utilizes a unique storage architecture designed to enhance security and isolation. Here are some essential resources for understanding its storage:</p>

<ul>
  <li><a href="https://www.qubes-os.org/doc/secondary-storage/">Secondary Storage Documentation</a></li>
  <li><a href="https://wiki.archlinux.org/title/LVM">LVM Overview</a></li>
  <li><a href="https://www.qubes-os.org/doc/mount-lvm-image/">Mounting LVM Images</a></li>
  <li><a href="https://www.qubes-os.org/doc/bind-dirs/">Binding Directories</a></li>
  <li><a href="https://www.qubes-os.org/doc/resize-disk-image/">Resizing Disk Images</a></li>
  <li><a href="https://www.qubes-os.org/doc/architecture/">Qubes Architecture</a></li>
  <li><a href="https://www.qubes-os.org/doc/qfilecopy/">QFileCopy Documentation</a></li>
</ul>

<h2>Qubes Storage Pool Types</h2>

<p>Qubes OS utilizes several storage pool types, each with distinct purposes to efficiently manage data:</p>

<ul>
  <li><code>vm-pool</code>: Is a LVM Thin Pool that stores virtual machine (VM) data, providing snapshot and backup capabilities. This pool allows isolated storage for individual VMs, enhancing security and efficiency.</li>
  <li><code>varlibqubes</code>: The primary storage location for system templates and AppVMs, holding core data essential to Qubes OS operation. The storage pool named varlibqubes (and located in /var/lib/qubes) isn't normally used for anything in the default LVM installation layout. But the /var/lib/qubes directory is used for other purposes besides hosting a storage pool. Specifically, installing a template will create some large temporary files there.
</li>
  <li><code>linux-kernel</code>: Dedicated to the Linux kernel and its associated components, it supports system-level functions and secure storage of drivers and essential files.</li>
</ul>

<p>By default, Qubes OS installs with a <code>vm-pool</code> that utilizes Logical Volume Management (LVM). The <code>varlibqubes</code> pool contains both "root" and "private" volumes, though users can configure separate pools if required. Advanced configurations can be managed through command-line tools beyond the Qubes Manager and Desktop Manager interfaces.</p>

<p>Lists all configured storage pools in Qubes OS with: <code>qvm-pool list</code>.</p>

<h2>Types of Storage in Qubes OS</h2>

<ul>
  <li><strong>Qubes System Storage:</strong> This storage contains the system root (<code>/</code>) and is read-write accessible by all domain classes, ensuring reliable system operations.</li>
  <li><strong>Qubes Private Storage:</strong> Stores user data specific to each VM under <code>/home</code>. Each VM’s private storage is isolated, accessible in read-write mode only by the respective VM. For Disposable VMs (DispVMs), this data is discarded at shutdown to maintain system integrity.</li>
</ul>

<h2>Types of Backups in Qubes OS</h2>

<p>Qubes OS provides several backup types to cater to varying needs for data protection and restoration:</p>
<ul>

  <li><strong>Full Backup:</strong> Captures all VM data, configurations, and system state, enabling full VM restoration to the exact backup point.</li>
  <li><strong>Incremental Backup:</strong> Saves only changes made since the last backup, reducing backup time and storage requirements.</li>
  <li><strong>Snapshot Backup:</strong> Creates VM snapshots, useful for restoring to a previous state. Snapshot backups are particularly efficient for temporary changes.</li>
  <li><strong>Template Backup:</strong> Backs up template VMs, preserving configuration and software installations across AppVMs, simplifying recovery or duplication of environments.</li>
</ul>

<h2>AppVM Backup Configuration and Encryption</h2>

<p>Backups in Qubes OS can be securely stored in AppVMs, offering flexibility for both local and remote backup options. Here are some considerations:</p>

<ul>
  <li>When storing backups in AppVMs, it’s recommended to use encryption performed in <code>dom0</code> to maintain security boundaries. This ensures that encryption keys remain isolated from AppVMs.</li>
  <li>Qubes OS supports both symmetric encryption (using a single passphrase) and asymmetric encryption for backups. Use <code>qvm-backup</code> to initiate backups, specifying the AppVM and destination directory.</li>
  <li>Compression of backups can be performed in <code>dom0</code> before transfer to reduce file sizes, though this is optional depending on storage limitations.</li>
</ul>

<h2>Configuration Folders</h2>

<p>In an AppVM, most of the filesystem derives from the template, except for <code>/home</code>, <code>/usr/local</code>, and <code>/rw</code>. These directories are persistent across sessions, while changes to other parts of the filesystem are discarded upon shutdown. Binding directories for configuration files are prioritized as follows:</p>

<ul>
  <li><code>/usr/lib/qubes-bind-dirs.d</code>: Lowest priority, used for package configurations and stored on disk, affecting all VMs system-wide.</li>
  <li><code>/etc/qubes-bind-dirs.d</code>: Intermediate priority, applied to all VMs based on a specific template, with changes stored on disk.</li>
  <li><code>/rw/config/qubes-bind-dirs.d</code>: Highest priority, used for per-VM configurations in RAM (<code>tmpfs</code>), and changes persist only for the session duration.</li>
  <li><code>/tmpfs</code>: RAM-based temporary storage, enabling rapid access without persistent storage, suited for fast read/write operations.</li>
</ul>

<h2>Remote and Automated Backup Options</h2>

<p>Qubes OS allows users to send backups to remote locations via AppVMs configured with network access. For instance, users can pipe backups directly to a remote server using SSH or other protocols, offering flexibility for offsite data protection.</p>

<p>For further automation, consider using <code>qubes-rpc</code> services, which allow configuration of AppVMs as secure backup destinations, ensuring backups are stored securely without compromising the security model of Qubes OS.</p>

<p>It is not possible to give the dom0 easy access to an external drive.</p>

<h2>Debugging and Management Commands in dom0 Terminal</h2>

<p>For managing and inspecting storage, VMs, and system configurations, the following commands can be highly useful:</p>

<h3>Storage and Volume Management</h3>

<pre><code>
# A graphical application to manage disks, partitions and LVM2 storages.
sudo blivet-gui

# Displays general system storage usage
qvm-ls --format disk
qvm-ls -d

# Lists all logical volumes
sudo lvs

# Lists block devices
lsblk

# Displays detailed information about volume groups
sudo vgdisplay
sudo vgdisplay -v

# Scans for available physical volumes and partitions
sudo lvmdiskscan

# Lists all configured storage pools in Qubes OS
qvm-pool list

# Provides detailed information about a specific storage pool (e.g., vm-pool)
qvm-pool info vm-pool

# Checks the status of the system’s overall storage preferences
qubes-prefs

# Displays system private storage usage
sudo df -h /rw
</code></pre>

<h3>VM Management</h3>

<pre><code>
# Lists all VMs, their states, and resource allocation
qvm-ls

# Shows a VM's current settings, configurations, and assigned devices
qvm-prefs <vm-name>

# Starts a specified VM
qvm-start <vm-name>

# Shuts down a specified VM
qvm-shutdown <vm-name>

# Forcefully halts a specified VM (useful if a VM is unresponsive)
qvm-kill <vm-name>

# Renames a VM (useful for organizational purposes)
qvm-move-to-vm <old-vm-name> <new-vm-name>
</code></pre>

<h3>Backup and Restore Operations</h3>

<pre><code>
# Creates a backup of specified VMs to a specified location
qvm-backup <destination-path> <vm-names>

# Restores VMs from a backup archive
qvm-backup-restore <backup-file>

# Checks available backup space and lists the most recent backups
ls -lh /var/lib/qubes/backup
</code></pre>

<h3>System and Configuration Information</h3>

<pre><code>
# Displays general system information, including memory and storage usage
xentop
xentop -d 1
qvm-ls --format disk

# Shows current system preferences, such as update and backup preferences
qubes-prefs

# Lists installed kernel versions and allows updating or switching kernels
qubes-dom0-update kernel

# Verifies the system’s Qubes OS version and updates
cat /etc/qubes-release
</code></pre>

</body>
</html>
