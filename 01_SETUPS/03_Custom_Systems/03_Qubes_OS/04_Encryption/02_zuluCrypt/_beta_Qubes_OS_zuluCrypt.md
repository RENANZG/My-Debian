<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Qubes OS with zuluCrypt</title>
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

<h1>Qubes OS with zuluCrypt</h1>

<h2>1. zuluCrypt in a Qubes OS Disposable TemplateVM</h2>

<p>This setup is useful for occasional, isolated encryption sessions, like handling sensitive USB drives, as each session will reset upon shutdown.</p>

<p>Create a Qubes Disposable TemplateVM to handle <a href="https://mhogomchungu.github.io/zuluCrypt/">zuluCrypt</a>.</p>

<ol>
  <li>Create a TemplateVM for zuluCrypt (e.g., <code>zulucrypt-temp</code>) and install zuluCrypt in it:</li>
  <pre><code>
[user@dom0 ~]$ qvm-create --class TemplateVM --template debian-12-xfce --property netvm='' --label red zulucrypt-temp
[user@dom0 ~]$ qvm-run zulucrypt-temp xterm
[user@zulucrypt-temp ~]$ sudo apt install zulucrypt-gui
  </code></pre>

  <li>Create a Disposable VM Template based on the TemplateVM, which will launch as disposable instances when needed (e.g., <code>zulucrypt-temp-dvm</code>):</li>
  <pre><code>
[user@dom0 ~]$ qvm-create --class AppVM --template zulucrypt-temp --property template_for_dispvms=true --label red zulucrypt-temp-dvm
[user@dom0 ~]$ qvm-features zulucrypt-temp-dvm template_for_dispvms 1
  </code></pre>

  <li>Connect the USB device containing the encrypted volume to the Disposable VM. Assuming the USB device is handled by <code>sys-usb</code>:</li>
  <pre><code>
[user@dom0 ~]$ qvm-usb ls
[user@dom0 ~]$ qvm-usb attach zulucrypt-temp-dvm sys-usb:[device-name]
  </code></pre>

  <li>In the disposable VM (<code>zulucrypt-temp-dvm</code>), launch zuluCrypt GUI to mount the volume:</li>
  <pre><code>
[user@zulucrypt-temp-dvm ~]$ zuluCrypt-gui
  </code></pre>

  <li>Once the zuluCrypt session is complete, close the Disposable VM. All traces will be removed from the system upon shutdown.</li>
</ol>

<h3>Notes:</h3>
<ul>
  <li>The disposable VM will be wiped clean after every use, enhancing security.</li>
  <li>This method is ideal for sensitive and temporary operations with zuluCrypt.</li>
</ul>

<!-- ######################################## -->

<h2>2. Encryption in a Qubes OS AppVM with zuluCrypt</h2>

<p>This approach allows creating an AppVM to handle zuluCrypt volumes persistently. Below are the steps to set up zuluCrypt in a minimal Debian template.</p>

<p>Create a minimal TemplateVM for zuluCrypt.</p>
<ol>
  <li>Start by installing a minimal TemplateVM with the necessary Debian release. For example, for Debian 12:</li>
  <pre><code>
[user@dom0 ~]$ sudo qubes-dom0-update qubes-template-debian-12-minimal
  </code></pre>
  
  <li>Customize the Minimal Template for zuluCrypt. First, clone the Minimal Template to create an AppVM:</li>
  <pre><code>
[user@dom0 ~]$ qvm-clone debian-12-minimal debian-12-encryption
  </code></pre>
  
  <li>Start the TemplateVM to install necessary packages:</li>
  <pre><code>
[user@dom0 ~]$ qvm-run -u root debian-12-encryption xterm
  </code></pre>

  <li>Install Required Packages:</li>
  <ul>
    <li>In the TemplateVM terminal, install the following packages to support zuluCrypt and necessary Qubes functionalities:</li>
    <pre><code>
[root@debian-12-encryption ~]# apt update
[root@debian-12-encryption ~]# apt install -y zulucrypt-gui gnome-keyring vim-tiny pciutils less psmisc zenity qubes-core-agent qubes-core-agent-nautilus qubes-core-agent-passwordless-root
    </code></pre>
    <li>If you need network access in the final AppVM, install <code>qubes-core-agent-networking</code></li>
  </ul>

  <li>Shut down the TemplateVM after installation:</li>
  <pre><code>
[root@debian-12-encryption ~]# shutdown now
  </code></pre>

  <li>Create a New AppVM based on the minimal TemplateVM (e.g., <code>zulucrypt1</code>):</li>
  <pre><code>
[user@dom0 ~]$ qvm-create --class AppVM --property template=debian-12-encryption --label gray zulucrypt1
  </code></pre>

  <li>Enable zuluCrypt shortcut in the App Menu by opening the settings and going to the Application tab:</li>
  <pre><code>
[user@dom0 ~]$ qubes-vm-settings zulucrypt1
  </code></pre>

  <li>Storage Management:</li>
  <ul>
    <li><strong>Option 1</strong>: Create an isolated and dedicated Qubes vault for encrypted volumes:</li>
    <pre><code>
[user@dom0 ~]$ qvm-create --class AppVM --property template=debian-12-encryption --label gray zulucrypt-vault
    </code></pre>
    <li><strong>Option 2</strong>: Adjust storage size in <code>dom0</code>:</li>
    <pre><code>
[user@dom0 ~]$ qvm-volume resize veracrypt1:private 1073741824 #For 1 GB
[user@dom0 ~]$ qvm-volume resize veracrypt1:private 34359738368 #For 32GB
[user@dom0 ~]$ qvm-volume resize veracrypt1:private 68719476736 #For 64GB
[user@dom0 ~]$ qvm-volume resize veracrypt1:private 137438953472 #For 128GB
[user@dom0 ~]$ qvm-volume resize veracrypt1:private 274877906944 #For 256GB
    </code></pre>
  </ul>


<h3>Options: Encrypted Partition or Encrypted File Vault</h3>

<ul>
  <li>Encrypted Partition:</li>
  <ul>
    <li>Open zuluCrypt, create a new volume, and follow setup prompts to format the volume (use EXT4 for reliability).</li>
    <pre><code>
[user@dom0 ~]$ qvm-run -u root zulucrypt1 xterm
[root@zulucrypt1 ~]$ zuluCrypt-gui
    </code></pre>
    <li>Set a strong password for the volume.</li>
    <li>Mounting and Using the Encrypted Volume:</li>
    <p>Mount the volume in zuluCrypt, which will appear under <code>/mnt/volume</code> or a similar directory.</p>
    <li><strong>Important</strong>: Unmount the volume after each use to prevent data corruption on VM shutdown.</li>
  </ul>

  <li>Encrypted File Vault:</li>
  <ul>
    <li>Creating an Encrypted File Vault:</li>
    <ul>
      <li>In dom0, create an empty file to serve as the encrypted vault. For 128 GB:</li>
      <pre><code>
[user@dom0 ~]$ dd if=/dev/zero of=/path/to/vault.img bs=1M count=1024 #For 1,1 GB
[user@dom0 ~]$ dd if=/dev/zero of=/home/user/vault.img bs=1 count=1000000000 #For 1,0 GB
[user@dom0 ~]$ dd if=/dev/zero of=/path/to/vault.img bs=1M count=16000000000 status=progess #For 16 GB
[user@dom0 ~]$ dd if=/dev/zero of=/path/to/vault.img bs=1M count=32000000000 status=progess #For 32 GB
[user@dom0 ~]$ dd if=/dev/zero of=/path/to/vault.img bs=1M count=64000000000 status=progess #For 64 GB
[user@dom0 ~]$ dd if=/dev/zero of=/path/to/vault.img bs=1M count=128000000000 status=progess #For 128 GB
      </code></pre>
      <li>Initialize LUKS encryption on the file:</li>
      <pre><code>
[user@dom0 ~]$ sudo cryptsetup luksFormat /path/to/vault.img
      </code></pre>
      <li>Open the LUKS-encrypted file and assign it a mapped device name (e.g., <code>vault_device</code>):</li>
      <pre><code>
[user@dom0 ~]$ sudo cryptsetup luksOpen /path/to/vault.img vault_device
      </code></pre>
      <li>Format the mapped device with a filesystem, such as ext4:</li>
      <pre><code>
[user@dom0 ~]$ sudo mkfs.ext4 /dev/mapper/vault_device
      </code></pre>
      <li>Once formatted, you can close the LUKS device:</li>
      <pre><code>
[user@dom0 ~]$ sudo cryptsetup luksClose vault_device
      </code></pre>
    </ul>
    <li>Using the File Vault:</li>
    <ul>
      <li>Open the LUKS-encrypted file vault:</li>
      <pre><code>
[user@dom0 ~]$ sudo cryptsetup luksOpen /path/to/vault.img vault_device
      </code></pre>
      <li>Mount the device to a designated mount point (e.g., <code>/mnt/vault</code>):</li>
      <pre><code>
[user@dom0 ~]$ sudo mount /dev/mapper/vault_device /mnt/vault
      </code></pre>
      <li>After mounting, access and manage your files within <code>/mnt/vault</code>.</li>
      <li><strong>Important</strong>: When finished, unmount and close the file vault to secure your data:</li>
      <pre><code>
[user@dom0 ~]$ sudo umount /mnt/vault
[user@dom0 ~]$ sudo cryptsetup luksClose vault_device
      </code></pre>
    </ul>
  </ul>
</ul>



<h4>USB Storage Use:</h4>

<p>To use zuluCrypt with USB devices, connect the device from <code>sys-usb</code> to the AppVM:</p>
<pre><code>
[user@dom0 ~]$ qvm-usb attach zulucrypt1 sys-usb:[device-name]
</code></pre>

<!-- ######################################## -->

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