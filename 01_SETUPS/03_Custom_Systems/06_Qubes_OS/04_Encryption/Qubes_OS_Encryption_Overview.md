<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Qubes OS Encryption Overview</title>
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

  <h2>Qubes OS Encryption Overview</h2>

  <table border="1">
  <thead>
    <tr>
      <th>Feature</th>
      <th>dm-crypt</th>
      <th>LUKS</th>
      <th>cryptsetup</th>
      <th>ZuluCrypt</th>
      <th>VeraCrypt</th>
      <th>SiriKali</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Integration with Qubes OS</td>
      <td>Native support; well-integrated for LUKS volumes</td>
      <td>Widely supported and integrated, especially with dm-crypt</td>
      <td>Supports LUKS; used for managing encrypted volumes</td>
      <td>Requires manual configuration; supports VeraCrypt</td>
      <td>Not directly supported; limited usability</td>
      <td>Can be installed in a VM; supports various backends (LUKS, EncFS, CryFS)</td>
    </tr>
    <tr>
      <td>Full-Disk Encryption</td>
      <td>Yes, supports full disk encryption via LUKS</td>
      <td>Primary feature; LUKS is designed for full disk encryption</td>
      <td>Facilitates full disk encryption with LUKS</td>
      <td>No support for full disk encryption on Linux</td>
      <td>No; primarily for directory and container encryption</td>
      <td>No; primarily for directory and container encryption</td>
    </tr>
    <tr>
      <td>Ease of Use in Qubes</td>
      <td>Command-line interface; steeper learning curve</td>
      <td>Generally managed through CLI or GUI front-ends</td>
      <td>Command-line tool; can be complex for new users</td>
      <td>User-friendly GUI for managing encrypted volumes and VeraCrypt containers</td>
      <td>GUI available but not optimized for Qubes</td>
      <td>Accessible GUI; easy management of multiple encryption backends</td>
    </tr>
    <tr>
      <td>Data Volume Management</td>
      <td>Direct management through Qubes' architecture</td>
      <td>Manages encrypted volumes seamlessly with dm-crypt integration</td>
      <td>Used to create and manage LUKS volumes</td>
      <td>Creates and manages encrypted containers, including VeraCrypt vaults</td>
      <td>Requires mounting and manual management</td>
      <td>Supports mounting and unmounting of encrypted directories and containers</td>
    </tr>
    <tr>
      <td>Encryption Algorithms</td>
      <td>Supports AES, Serpent, etc., through LUKS</td>
      <td>Supports various algorithms (AES, Twofish, etc.) depending on setup</td>
      <td>Allows selection of algorithms when setting up LUKS</td>
      <td>Wide range including XTS, but less flexible on Linux</td>
      <td>Varies by backend; supports algorithms through LUKS, EncFS, CryFS, etc.</td>
    </tr>
    <tr>
      <td>Cross-Platform Support</td>
      <td>No</td>
      <td>No; primarily Linux-based</td>
      <td>No</td>
      <td>Yes (Windows, macOS, Linux)</td>
      <td>Limited; cross-platform support varies by backend (EncFS, CryFS)</td>
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

<p>When using encryption in Qubes OS, keep the following in mind:</p>

<ul>
  <li>Qubes OS creates logs for each qube activity, and qube names are recorded in persistent
    logs, even for Disposable VMs. Keep this in mind if total anonymity is a concern.</li>
  <li>Ensure the qubes using VeraCrypt are isolated from the network if handling highly
    sensitive information.</li>
  <li>Disposable VMs are more secure for handling sensitive data as they are wiped after
    every session.</li>
</ul>

<p>Learn more:</p>
<ul>
 <li><a href="https://en.wikipedia.org/wiki/Deniable_encryption">Deniable encryption - Wikipedia</a></li>
 <li><a href="https://en.wikipedia.org/wiki/Key_disclosure_law">Key disclosure law - Wikipedia</a></li>
 <li><a href="https://veracrypt.eu/en/Trim%20Operation.html">Trim Operation - Veracrypt</a></li>
 <li><a href="https://veracrypt.fr/en/Plausible%20Deniability.html">Plausible Deniability - Veracrypt</a>.</li>
</ul>
</body>
</html>