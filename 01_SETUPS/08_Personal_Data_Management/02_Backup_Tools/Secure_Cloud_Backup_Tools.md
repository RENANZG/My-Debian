<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Secure Cloud Backup Tools Comparison</title>
<style>
    table {
      width: 100%;
      border-collapse: collapse;
    }
    th, td {
      border: 1px solid #dddddd;
      text-align: left;
      padding: 8px;
    }
    th {
      background-color: #f2f2f2;
    }
    .bold-yes {
      font-weight: bold;
    }
</style>
</head>
<body>

  <h2>Comparison of Secure Cloud Backup Tools</h2>
  <table>
    <thead>
      <tr>
        <th>Feature</th>
        <th>Cryptomator</th>
        <th>Duplicati</th>
        <th>Restic</th>
        <th>RClone</th>
        <th>VeraCrypt</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>File Content Encryption</td>
        <td class="bold-yes">Yes</td>
        <td class="bold-yes">Yes</td>
        <td class="bold-yes">Yes</td>
        <td class="bold-yes">Yes</td>
        <td class="bold-yes">Yes</td>
      </tr>
      <tr>
        <td>File Name Encryption</td>
        <td class="bold-yes">Yes</td>
        <td class="bold-yes">Yes</td>
        <td>No</td>
        <td>No</td>
        <td>No</td>
      </tr>
      <tr>
        <td>File Attribute Encryption</td>
        <td>No</td>
        <td class="bold-yes">Yes</td>
        <td>No</td>
        <td>No</td>
        <td>No</td>
      </tr>
      <tr>
        <td>Free & Open-Source Software (FOSS)</td>
        <td class="bold-yes">Yes</td>
        <td class="bold-yes">Yes</td>
        <td class="bold-yes">Yes</td>
        <td class="bold-yes">Yes</td>
        <td class="bold-yes">Yes</td>
      </tr>
      <tr>
        <td>Directory Obfuscation</td>
        <td class="bold-yes">Yes</td>
        <td class="bold-yes">Yes</td>
        <td>No</td>
        <td>No</td>
        <td>No</td>
      </tr>
      <tr>
        <td>Integrity Protection</td>
        <td class="bold-yes">Yes</td>
        <td class="bold-yes">Yes</td>
        <td class="bold-yes">Yes</td>
        <td class="bold-yes">Yes</td>
        <td class="bold-yes">Yes</td>
      </tr>
      <tr>
        <td>Quantum-Resistant Cryptography</td>
        <td>No</td>
        <td>No</td>
        <td>No</td>
        <td>No</td>
        <td>No</td>
      </tr>
      <tr>
        <td>Audited Cryptography</td>
        <td class="bold-yes">Yes</td>
        <td>No</td>
        <td>No</td>
        <td>No</td>
        <td>No</td>
      </tr>
      <tr>
        <td>Memory-Hard KDF</td>
        <td class="bold-yes">Yes</td>
        <td class="bold-yes">Yes</td>
        <td class="bold-yes">Yes</td>
        <td>No</td>
        <td class="bold-yes">Yes</td>
      </tr>
      <tr>
        <td>Sharing Without Disclosing Passwords</td>
        <td>No</td>
        <td>No</td>
        <td>No</td>
        <td>No</td>
        <td>No</td>
      </tr>
      <tr>
        <td>Unlimited Number of Devices</td>
        <td class="bold-yes">Yes</td>
        <td class="bold-yes">Yes</td>
        <td class="bold-yes">Yes</td>
        <td class="bold-yes">Yes</td>
        <td class="bold-yes">Yes</td>
      </tr>
      <tr>
        <td>No Account Needed</td>
        <td class="bold-yes">Yes</td>
        <td class="bold-yes">Yes</td>
        <td class="bold-yes">Yes</td>
        <td class="bold-yes">Yes</td>
        <td class="bold-yes">Yes</td>
      </tr>
      <tr>
        <td>Direct File Sharing ("Integrated Sharing")</td>
        <td>No</td>
        <td>No</td>
        <td>No</td>
        <td>No</td>
        <td>No</td>
      </tr>
      <tr>
        <td>Restore Password Without Email Address ("Offline Key Recovery")</td>
        <td>No</td>
        <td>No</td>
        <td>No</td>
        <td>No</td>
        <td>No</td>
      </tr>
      <tr>
        <td>Detection of Sync Conflicts While Editing by Several People</td>
        <td>No</td>
        <td>No</td>
        <td>No</td>
        <td>No</td>
        <td>No</td>
      </tr>
      <tr>
        <td>Support for All Common Operating Systems</td>
        <td class="bold-yes">Yes</td>
        <td class="bold-yes">Yes</td>
        <td class="bold-yes">Yes</td>
        <td class="bold-yes">Yes</td>
        <td class="bold-yes">Yes</td>
      </tr>
      <tr>
        <td>Home Page</td>
        <td><a href="https://cryptomator.org">cryptomator.org</a></td>
        <td><a href="https://www.duplicati.com">duplicati.com</a></td>
        <td><a href="https://restic.net">restic.net</a></td>
        <td><a href="https://rclone.org">rclone.org</a></td>
        <td><a href="https://www.veracrypt.fr">veracrypt.fr</a></td>
      </tr>
      <tr>
        <td>License</td>
        <td>Open Source (GPL)</td>
        <td>Open Source (LGPL)</td>
        <td>Open Source (BSD)</td>
        <td>Open Source (MIT)</td>
        <td>Open Source (Apache 2.0)</td>
      </tr>
    </tbody>
  </table>

<h4>Notes:</h4:
<ul>
<li>VeraCrypt is not designed for file encryption in cloud.</li>
<li><a href="https://mhogomchungu.github.io/sirikali/">SiriKali</a> supports Cryptomator backend on Linux.</li>
<li><a href="https://syncthing.net">Syncthing</a></td> itself does not encrypt files for cloud storage, but it can be part of a workflow where files are encrypted by other tools.</li>
</ul>

</body>

</html>