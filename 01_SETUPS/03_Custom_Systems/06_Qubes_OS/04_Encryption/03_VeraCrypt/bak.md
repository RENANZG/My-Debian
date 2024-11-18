<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Basic Encryption in a Qubes OS</title>
<style>
  /* Generic style */
  body {
       font-family: Arial, sans-serif;
       margin: 0;
       padding: 20px;
       line-height: 1.6;
       max-width: 21cm; /* Limit screen maximum width */
       height: 29.7cm;
       margin-left: auto;
       margin-right: auto;
  }
   h1, h2, h3, h4, h5, h6 {
       font-weight: bold;
       margin-bottom: 0.5em;
  }
   h1 {
       font-size: 2.5em;
       line-height: 1.2;
  }
   h2 {
       font-size: 2em;
       line-height: 1.3;
  }
   h3 {
       font-size: 1.8em;
       line-height: 1.4;
  }
   p {
       margin: 1em 0;
       text-align: justify; /* Justify text for better readability */
  }
   a {
       color: #007bff;
       text-decoration: none;
  }
   a:hover {
       text-decoration: underline;
  }
   blockquote {
       margin: 1em 0;
       padding: 0 1em;
       border-left: 3px solid #ccc;
  }
   blockquote cite {
       font-style: italic;
  }
   img {
       max-width: 100%;
       height: auto;
       display: block;
       margin: 1em 0;
  }
   pre {
       background-color: #f4f4f4;
       border: 1px solid #ccc;
       padding: 1em;
       overflow: auto;
       white-space: pre-wrap; /* Wrap long lines in preformatted text */
  }
   code {
       font-family: Consolas, Monaco, 'Andale Mono', monospace;
       font-size: 0.9em;
  }
  /* Tables */
   table {
       width: 100%;
       border-collapse: collapse;
       margin-bottom: 1em;
  }
   th, td {
       border: 1px solid #ccc;
       padding: 0.8em;
  }
   th {
       background-color: #f2f2f2;
  }
  /* Lists */
   ul, ol {
       margin: 1em 0;
       padding-left: 2em;
  }
  /* Miscellaneous */
   sup {
       vertical-align: super;
       font-size: smaller;
  }
   sub {
       vertical-align: sub;
       font-size: smaller;
  }
   @media screen and (max-width: 600px) {
      /* Adjustments for smaller screens */
       body {
           font-size: 16px; /* Font size for better readability */
           line-height: 1.5;
           margin: 0.5em;
      }
       h1 {
           font-size: 2em;
      }
       h2 {
           font-size: 1.8em;
      }
       h3 {
           font-size: 1.6em;
      }
       th, td {
           padding: 0.6em;
      }
       pre {
           padding: 0.5em;
      }
  }
</style>
</head>
<body>

  <h1>Basic Encryption in a Qubes OS</h1>

  <a href="https://veracrypt.eu/en/Downloads.html">Veracrypt Downloads</a>

  <h2>Overview of Encryption Solutions in Qubes OS</h2>

  <table border="1">
    <thead>
      <tr>
        <th>Feature</th>
        <th>dm-crypt</th>
        <th>ZuluCrypt</th>
        <th>VeraCrypt</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>Integration with Qubes OS</td>
        <td>Native support; well-integrated for LUKS volumes</td>
        <td>Requires manual configuration; supports VeraCrypt</td>
        <td>Not directly supported; limited usability</td>
      </tr>
      <tr>
        <td>Full-Disk Encryption</td>
        <td>Yes, supports full disk encryption via LUKS</td>
        <td>No; focused on container-based encryption</td>
        <td>No support for full disk encryption on Linux</td>
      </tr>
      <tr>
        <td>Ease of Use in Qubes</td>
        <td>Command-line interface; steeper learning curve</td>
        <td>User-friendly GUI for managing encrypted volumes and VeraCrypt containers</td>
        <td>GUI available but not optimized for Qubes</td>
      </tr>
      <tr>
        <td>Data Volume Management</td>
        <td>Direct management through Qubes' architecture</td>
        <td>Creates and manages encrypted containers, including VeraCrypt vaults</td>
        <td>Requires mounting and manual management</td>
      </tr>
      <tr>
        <td>Encryption Algorithms</td>
        <td>Supports AES, Serpent, etc., through LUKS</td>
        <td>Supports algorithms available via dm-crypt and VeraCrypt</td>
        <td>Wide range including XTS, but less flexible on Linux</td>
      </tr>
      <tr>
        <td>Cross-Platform Support</td>
        <td>No</td>
        <td>No</td>
        <td>Yes (Windows, macOS, Linux)</td>
      </tr>
    </tbody>
  </table>
  
  <!-- ######################################## -->
  
<h3>Understanding VMs and Qubes Storage</h3>

<ul>
  <li><strong>AppVM (Application Virtual Machine):</strong> An AppVM is a type of virtual
  machine in Qubes OS created from a TemplateVM. Each AppVM retains its state and
  configuration, making it ideal for regular use and allowing users to install software
  or save files that persist across sessions.</li>
  <li><strong>DispVM (Disposable Virtual Machine):</strong> A DispVM is a type of virtual
  machine in Qubes OS created from a disposable TemplateVM. A DispVM does not retain
  its state and configuration, making it ideal for sensitive and temporary operations.</li>
  <li><strong>Qubes System Storage:</strong> This is where the system root (/) is
  stored, and where the operating system is installed. This volume is available in
  read-write mode to all domain classes.</li>
  <li><strong>Qubes Private Storage:</strong> This is where a domain’s data or user home (/home)
  is stored. It is isolated from other VMs in a private storage pool. This volume is available
  in read-write mode only to the specific VM that owns it. For DispVMs, data written to this
  storage is discarded upon shutdown.</li>
</ul>

<!-- ######################################## -->

<h3>Security Considerations</h3>

<p>When using VeraCrypt in Qubes OS, keep the following in mind:</p>

<ul>
  <li>Qubes OS creates logs for each qube activity, and qube names are recorded in persistent
    logs, even for Disposable VMs. Keep this in mind if total anonymity is a concern.</li>
  <li>Ensure the qubes using VeraCrypt are isolated from the network if handling highly
    sensitive information.</li>
  <li>Disposable VMs are more secure for handling sensitive data as they are wiped after
    every session.</li>
</ul>

 <p>Learn more: <a href="https://en.wikipedia.org/wiki/Deniable_encryption">Deniable encryption - Wikipedia</a> and
<a href="https://en.wikipedia.org/wiki/Key_disclosure_law">Key disclosure law - Wikipedia</a>.</p>

<!-- ######################################## -->

<h2>1. Encryption in a Qubes OS Disposable TemplateVM</h2>

<p>Create a Qubes Disposable TemplateVM to deal with VeraCrypt or zuluCrypt.</p>

<p>This method is useful if you only need to use VeraCrypt occasionally or want to
  ensure that the session is entirely isolated after every use (e.g., handling
  sensitive USB drives).</p>

<ol>
  <li>Create a TemplateVM for VeraCrypt (e.g., <code>veracrypt-temp</code>) and install
    VeraCrypt in it:</li>
  <pre><code>
[user@dom0 ~]$ qvm-create --class TemplateVM --template debian-12-xfce  --property netvm='' --label red veracrypt-temp
[user@dom0 ~]$ qvm-run veracrypt-temp xterm
[user@veracrypt-temp ~]$ sudo apt install ./veracrypt.deb
  </code></pre>
  <p> Note, you can presw Ctrl-Right mouse click for temporary change of font size

  <li>Create a Disposable VM Template based on the TemplateVM, which will launch as
    disposable instances when needed (e.g., <code>veracrypt-temp-dvm</code>):</li>
  <pre><code>
[user@dom0 ~]$ qvm-create --class AppVM --template veracrypt-temp --property template_for_dispvms=true --label red veracrypt-temp-dvm
[user@dom0 ~]$ qvm-features veracrypt-temp-dvm template_for_dispvms 1
  </code></pre>

  <li>Connect the USB device containing the VeraCrypt volume to the Disposable VM.
    Assuming the USB device is handled by <code>sys-usb</code>:</li>
  <pre><code>
[user@dom0 ~]$ qvm-usb ls
[user@dom0 ~]$ qvm-usb attach veracrypt-temp-dvm sys-usb:[device-name]
  </code></pre>

  <li>In the disposable VM (veracrypt-temp-dvm), launch VeraCrypt in read-only mode to mount the volume:</li>
  <pre><code>
[user@veracrypt-temp-dvm ~]$ veracrypt --mount-options=ro /dev/qubes_dom0/vm-veracrypt-temp-dvm
  </code></pre>

  <li>Once the VeraCrypt session is complete, simply close the Disposable VM. All traces
    will be removed from the system upon shutdown.</li>
</ol>

<h3>Notes:</h3>
<ul>
  <li>The disposable VM will be wiped clean after every use, enhancing security.</li>
  <li>This method is ideal for sensitive and temporary operations with VeraCrypt.</li>
  <li>Using <code>--mount-options=ro</code> ensures the volume is mounted in read-only
    mode.</li>
</ul>

<!-- ######################################## -->

<h2>2. Encryption in a Qubes OS AppVM</h2>

<p>Create a minimal templatevm for VeraCrypt or zuluCrypt.</p>
<ol>
  <li>Start by installing a minimal TemplateVM with the necessary Debian release. For
    example, for Debian 12:</li>
  <pre><code>
[user@dom0 ~]$ sudo qubes-dom0-update qubes-template-debian-12-minimal
</code></pre>
  <li>Customize the Minimal Template for VeraCrypt or ZuluCrypt, first clone the Minimal Template to create an AppVM:</li>
  <pre><code>
[user@dom0 ~]$ qvm-clone debian-12-minimal debian-12-encryption
  </code></pre>
  </li>
  <li>
    <p>Start the TemplateVM to install necessary packages:</p>
    <pre><code>
[user@dom0 ~]$ qvm-run -u root debian-12-encryption xterm
    </code></pre>
  </li>
  <li>
    <p>Install Required Packages:</p>
    <ul>
      <li>In the TemplateVM terminal, install the following packages to support VeraCrypt,
        ZuluCrypt, and necessary GUI and Qubes functionalities:</li>
      <pre><code>
[root@debian-12-encryption ~]# apt update
[root@debian-12-encryption ~]# apt install -y veracrypt zulucrypt-gui gnome-keyring vim-tiny pciutils less psmisc zenity qubes-core-agent qubes-core-agent-nautilus qubes-core-agent-passwordless-root
      </code></pre>
      <li>If you need network in the final AppVM:<code>qubes-core-agent-networking</code></li>
    </ul>
  </li>
  <li>
    <p>Shut Down the TemplateVM after installation:</p>
    <pre><code>
[root@debian-12-encryption ~]# shutdown now
    </code></pre>
  </li>
  <li>
    <p>Create a New AppVM based on the minimal TemplateVM (e.g. <code>veracrypt1</code>):</p>
    <pre><code>
[user@dom0 ~]$ qvm-create --class AppVM --property template=debian-12-encryption --label gray veracrypt1
    </code></pre>
  </li>
  <li>Enable VeraCrypt or zuluCrypt shortcut in the App Menu, open the settings and go to Application tab:</li>
    <pre><code>
[user@dom0 ~]$ qubes-vm-settings veracrypt1
    </code></pre>
  </li>
  <li>
    <p>Storage Management:</p>
    <ul>
      <li><strong>Option 1</strong>: Create a isolated and dedicated Qubes vault for encrypted volumes:</li>
      <pre><code>
[user@dom0 ~]$ qvm-create --class AppVM --property template=debian-12-encryption --label gray veracrypt-vault
</code></pre>
      <li><strong>Option 2</strong>: Adjust storage size directly in the created <code>veracrypt1</code> AppVM:</li>
    <pre><code>
[user@dom0 ~]$ qvm-volume resize veracrypt1:private 1073741824 #For 1 GB
[user@dom0 ~]$ qvm-volume resize veracrypt1:private 34359738368 #For 32GB
[user@dom0 ~]$ qvm-volume resize veracrypt1:private 68719476736 #For 64GB
[user@dom0 ~]$ qvm-volume resize veracrypt1:private 137438953472 #For 128GB
[user@dom0 ~]$ qvm-volume resize veracrypt1:private 274877906944 #For 256GB
    </code></pre>
    </ul>
  </li>
  <li>
    <p>Format the Volume:</p>
    <ul>
      <li>Open VeraCrypt or zuluCrypt, create a new volume, and follow setup prompts to format the
        volume (use EXT4 for reliability).</li>
        [user@dom0 ~]$ qvm-run -u root veracrypt1 xterm
        [user@dom0 ~]$ lsblk | grep veracrypt1
        [root@veracrypt1 ~]$ veracrypt
        To avoid polkit error edit: [root@veracrypt1 ~]$  nano /usr/share/polkit-1/actions/org.zulucrypt.zulupolkit.policy
                Change: &lt;allow_active&gt;auth_admin&lt;/allow_active&gt; to &lt;allow_active&gt;yes&lt;/allow_active&gt;
        [root@veracrypt1 ~]$ zuluCrypt-gui
        Block devices in Qubes have the /dev/xvd prefix, zuluCrypt does not detect them.
      <li>Set a strong password for the volume.</li>
    </ul>
  </li>
  <li>
    <p>Mount and Use the Encrypted Volume:</p>
    <ul>
      <li>Mount the volume in the VeraCrypt GUI, which will appear under <code>/mnt/veracrypt1</code>.</li>
      <li><strong>Important</strong>: Unmount the volume after each use to prevent data
        corruption on VM shutdown.</li>
    </ul>
  </li>
</ol>

<ul>
  <li>To mount from Veracrypt CLI, ensure the path to your private storage is correct.
    Create and mount the VeraCrypt folder. The mounted partition will typically be
    located at <code>/mnt/veracrypt1</code>.</li>
  <pre><code>
[user@veracrypt1 ~]$ sudo mkdir /mnt/veracrypt1
[user@dom0 ~]$ sudo lvdisplay | grep veracrypt1-private
[user@veracrypt1 ~]$ sudo mount /dev/qubes_dom0/vm-veracrypt1-private /mnt/veracrypt1 -o rw,user
[user@veracrypt1 ~]$ veracrypt /mnt/veracrypt1
</code></pre>
  <li>To unmount the VeraCrypt partition use:</li>
  <pre><code>
[user@veracrypt1 ~]$ veracrypt -d /mnt/veracrypt1
</code></pre>
</ul>

<ul>
  <li>To use veracrypt with USB devices, connect the device from <code>sys-usb</code> to the AppVM:</li>
  <pre><code>
[user@dom0 ~]$ qvm-usb attach veracrypt1 sys-usb:&lt;device-name&gt;
</code></pre>
</ul>

<h3>Notes:</h3>
<ul>
  <li>AppVMs retain the configuration between sessions, making this option ideal for
    <li>Using Qubes Private Storage does not necessarily provide additional security,
      but VM isolation for sensitive data does.</li>
    <li>The VeraCrypt partition can be mounted and accessed multiple times without needing
      to recreate or reinstall the environment.</li>
    <li>Consider using <code>--mount-options=ro</code> if you want to mount it in read-only
      mode to prevent accidental modification.</li>
</ul>

</body>
</html>