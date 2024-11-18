<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Qubes OS Disk Trimming</title>
<style>
  /* Generic style */
  body {
       font-family: Arial, sans-serif;
       margin: 0;
       padding: 20px;
       line-height: 1.6;
       max-width: 21cm; /* Limit screen maximum width */
       height: 29.7cm;
       background-color: #f9f9f9;
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
  
  <h1>Qubes OS Disk Trimming</h1>
  
  <h2>What is Disk Trimming?</h2>
  
  <p>Disk trimming is a process that allows the operating system to inform the storage device about unused blocks, enabling the device to reclaim space. This is particularly beneficial for SSDs but has no effect on HDDs.</p>
  
  <h2>Complexity in Qubes OS</h2>
  
  <p>In Qubes OS, the process of issuing TRIM commands is more complex due to virtualization layers, LUKS encryption, and LVM configurations. Discard commands must successfully traverse several layers, including:</p>
  <ul>
    <li>OS</li>
    <li>File-system Driver</li>
    <li>Virtual Storage Driver</li>
    <li>Backend Storage Driver</li>
    <li>LVM Storage Driver</li>
    <li>LUKS Driver</li>
    <li>Physical Storage Driver</li>
    <li>Physical Storage Device</li>
  </ul>
  
  <p>If any layer does not support TRIM, the command will not reach the physical device.</p>
  
  <h2>Security Implications</h2>
  
  <p>While enabling TRIM has potential security concerns, it can enhance security against local forensics by ensuring deleted data is erased promptly. However, data deletion is not guaranteed.</p>
  
  <h2>Configuration Steps</h2>
  
  <h3>1. Setting Up Periodic TRIM Jobs:</h3>
  
  <h4>Systemd:</h4>
  
  <pre><code>systemctl enable fstrim.timer
systemctl start fstrim.timer</code></pre>
  
  <h4>Cron:</h4>
  
  <p>Create a script in <code>/etc/cron.daily/trim</code>:</p>
  
  <pre><code>#!/bin/bash
/sbin/fstrim --all</code></pre>
  <p>Make it executable:</p>
  <pre><code>chmod 755 /etc/cron.daily/trim</code></pre>
  
  <h3>2. LVM Configuration:</h3>
  
  <p>For LVM users, enable TRIM by adding <code>issue_discards = 1</code> in <code>/etc/lvm/lvm.conf</code>.</p>
  
  <h3>3. LUKS Configuration (R4.0):</h3>
  
  <p>To enable TRIM in dom0 with LUKS, update <code>/etc/crypttab</code>:</p>
  
  <pre><code>luks-<UUID> UUID=<UUID> none discard</code></pre>
  
  <p>Modify the kernel command line (GRUB2 or EFI) to include <code>rd.luks.options=discard</code>, then rebuild the grub config and initrd.</p>
  
  <h3>4. Swap Space Configuration:</h3>
  
  <p>To enable TRIM for swap, add the <code>discard</code> option in <code>/etc/fstab</code>. For a one-time trim at boot, use <code>discard=once</code>.</p>
  
  <h2>Future Considerations</h2>
  
  <p>As of R4.1, TRIM is enabled by default. For R4.2, users reported needing to enable the same settings as in R4.0, suggesting ongoing complexity in achieving TRIM functionality in dom0.</p>
  
</body>
</html>