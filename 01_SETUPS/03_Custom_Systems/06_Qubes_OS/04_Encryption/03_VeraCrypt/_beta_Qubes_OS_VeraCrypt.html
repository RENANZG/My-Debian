<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Qubes OS with Veracrypt</title>
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

  <h1>Qubes OS with Veracrypt</h1>

  <h2>1. VeraCrypt in a Qubes OS Disposable TemplateVM</h2>

<p>This setup is useful for occasional, isolated encryption sessions, like handling sensitive USB drives, as each session will reset upon shutdown.</p>

<p>Create a Qubes Disposable TemplateVM to handle <a href="https://veracrypt.fr/en/Home.html">Veracrypt</a>.Consider check the hash of the file.</p>

<ol>
  <li>Create a TemplateVM dedicated to VeraCrypt (e.g., <code>veracrypt-temp</code>):</li>
  <pre><code>
[user@dom0 ~]$ qvm-create --class TemplateVM --template debian-12-xfce --property netvm='' --label red veracrypt-temp
[user@dom0 ~]$ qvm-run veracrypt-temp xterm
  </code></pre>

  <li>In the TemplateVM terminal, download and install VeraCrypt:</li>
  <pre><code>
[user@veracrypt-temp ~]$ sudo apt update
[user@veracrypt-temp ~]$ sudo apt install -y curl
[user@veracrypt-temp ~]$ sudo export https_proxy=127.0.0.1:8082
[user@veracrypt-temp ~]$ curl -LO https://launchpad.net/veracrypt/trunk/1.25.9/+download/veracrypt-1.25.9-setup-gui-x64
[user@veracrypt-temp ~]$ sudo dpkg -i veracrypt-1.25.9-setup-gui-x64.deb
or
[user@veracrypt-temp ~]$ curl -s https://launchpad.net/veracrypt/trunk | grep -Eo 'https://launchpad.net/veracrypt/trunk/[0-9]+\.[0-9]+\.[0-9]+/[^"]+\.deb' | head -n 1 | xargs -n 1 curl -LO && sudo dpkg -i *.deb
  </code></pre>

  <li>Create a Disposable VM Template from this TemplateVM (e.g., <code>veracrypt-temp-dvm</code>):</li>
  <pre><code>
[user@dom0 ~]$ qvm-create --class AppVM --template veracrypt-temp --property template_for_dispvms=true --label red veracrypt-temp-dvm
[user@dom0 ~]$ qvm-features veracrypt-temp-dvm template_for_dispvms 1
  </code></pre>

  <li>Attach a USB device containing the VeraCrypt volume to the Disposable VM. Assuming the USB device is managed by <code>sys-usb</code>:</li>
  <pre><code>
[user@dom0 ~]$ qvm-usb ls
[user@dom0 ~]$ qvm-usb attach veracrypt-temp-dvm sys-usb:[device-name]
  </code></pre>

  <li>In the Disposable VM (<code>veracrypt-temp-dvm</code>), mount the VeraCrypt volume:</li>
  <pre><code>
[user@veracrypt-temp-dvm ~]$ veracrypt --mount-options=ro /dev/qubes_dom0/vm-veracrypt-temp-dvm
  </code></pre>

  <li>Close the Disposable VM when finished to remove all session data from the system.</li>
</ol>

<h3>Notes:</h3>
<ul>
  <li>The Disposable VM is reset after every use, enhancing security for temporary operations.</li>
  <li>The <code>--mount-options=ro</code> flag ensures the volume is mounted in read-only mode.</li>
</ul>

<!-- ######################################## -->

<h2>2. Encryption in a Qubes OS AppVM with VeraCrypt</h2>

<p>This approach allows creating an AppVM to handle VeraCrypt volumes persistently. Below are the steps to set up VeraCrypt in a minimal Debian template.</p>

<ol>
  <li>Install a minimal TemplateVM for Debian 12:</li>
  <pre><code>
[user@dom0 ~]$ sudo qubes-dom0-update qubes-template-debian-12-minimal
  </code></pre>

  <li>Clone the minimal TemplateVM to create an AppVM for VeraCrypt:</li>
  <pre><code>
[user@dom0 ~]$ qvm-clone debian-12-minimal debian-12-veracrypt
  </code></pre>

  <li>Start the TemplateVM and install VeraCrypt dependencies:</li>
  <pre><code>
[user@dom0 ~]$ qvm-run -u root debian-12-veracrypt xterm
  </code></pre>

  <li>In the TemplateVM terminal, update and install necessary packages for VeraCrypt:</li>
  
  <pre><code>
[root@debian-12-veracrypt ~]# apt update
[root@debian-12-veracrypt ~]# apt install -y qubes-core-agent-networking \
 curl \
 export https_proxy=127.0.0.1:8082
[root@debian-12-veracrypt ~]# apt install -y gnome-keyring \
 vim-tiny \
 pciutils \
 less \
 psmisc \
 zenity \
 qubes-core-agent \
 qubes-core-agent-nautilus \
 qubes-core-agent-passwordless-root
[root@debian-12-veracrypt ~]# curl -LO https://launchpad.net/veracrypt/trunk/1.25.9/+download/veracrypt-1.25.9-setup-gui-x64
[root@debian-12-veracrypt ~]# dpkg -i veracrypt-1.25.9-setup-gui-x64.deb
  </code></pre>

  <li>Shut down the TemplateVM after installation:</li>
  <pre><code>
[root@debian-12-veracrypt ~]# shutdown now
  </code></pre>

  <li>Create a new AppVM from the TemplateVM (e.g., <code>veracrypt-app</code>):</li>
  <pre><code>
[user@dom0 ~]$ qvm-create --class AppVM --template debian-12-veracrypt --label gray veracrypt-app
  </code></pre>

  <li>Enable the VeraCrypt shortcut in the AppVM’s Application menu:</li>
  <pre><code>
  [user@dom0 ~]$ qubes-vm-settings veracrypt-app
  </code></pre>

  <li>Adjust storage if needed:</li>
  
  <ul>
    <li>Resize the private storage volume of the AppVM as required:</li>
    <pre><code>
[user@dom0 ~]$ qvm-volume resize veracrypt1:private 1073741824 #For 1 GB
[user@dom0 ~]$ qvm-volume resize veracrypt1:private 34359738368 #For 32GB
[user@dom0 ~]$ qvm-volume resize veracrypt1:private 68719476736 #For 64GB
[user@dom0 ~]$ qvm-volume resize veracrypt1:private 137438953472 #For 128GB
[user@dom0 ~]$ qvm-volume resize veracrypt1:private 274877906944 #For 256GB
    </code></pre>
  </ul>

  <li>To mount a VeraCrypt volume, open the AppVM and launch VeraCrypt:</li>
  <pre><code>[user@veracrypt-app ~]$ veracrypt</code></pre>

  <li>When finished, unmount the VeraCrypt volume:</li>
  <pre><code>[user@veracrypt-app ~]$ veracrypt -d</code></pre>
</ol>

<h4>Additional Tips:</h4>

<ul>
  <li>For USB usage, connect the device from <code>sys-usb</code> to the AppVM:</li>
  <pre><code>[user@dom0 ~]$ qvm-usb attach veracrypt-app sys-usb:&lt;device-name&gt;</code></pre>
</ul>

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