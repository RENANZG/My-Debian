<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Advanced Data Transfer Methods Comparison</title>
  <style>
    body {
      margin: 0;
      padding: 0;
      font-family: Arial, sans-serif;
      font-size: 14px;
    }
    table {
      width: calc(100% - 1mm);
      margin: 0.5mm;
      border-collapse: collapse;
      font-size: 14px;
    }
    th, td {
      border: 1px solid #ddd;
      padding: 6px;
    }
    th {
      background-color: #f2f2f2;
    }
    code {
      background-color: #f8f8f8;
      padding: 3px;
      border: 1px solid #ddd;
      font-size: 13px;
      margin: 0;
      display: inline-block;
    }
    ul {
      margin: 0;
      padding-left: 20px;
    }
  </style>
</head>

<body>

  <h2>Advanced Data Transfer Methods Comparison</h2>

  <table>
    <thead>
      <tr>
        <th>Method</th>
        <th>Description</th>
        <th>Cheat Sheet</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td><a href="https://curl.se">curl (Client URL)</a></td>
        <td>
          <ul>
            <li>Usage: Transfer data over various protocols, supporting both uploading and downloading.</li>
            <li>Features: Versatile; supports HTTP, FTP, SCP, etc.; can resume downloads; command-line tool.</li>
            <li>Security: Supports HTTPS for encrypted connections; see
              <a href="https://www.cvedetails.com/vulnerability-list/vendor_id-2852/Curl.html">CVEs</a> for details.</li>
          </ul>
        </td>
        <td>
          <ul>
            <li><code>curl -O http://example.com/file</code> - Download file</li>
            <li><code>curl -u user:pass ftp://example.com/</code> - FTP with user authentication</li>
            <li><code>curl -I http://example.com</code> - Fetch headers</li>
            <li><code>curl -X POST -d "param1=value1" http://example.com</code> - POST data</li>
            <li><code>curl -H "Authorization: Bearer token" http://example.com</code> - Auth header</li>
          </ul>
        </td>
      </tr>
      <tr>
        <td><a href="https://www.gnu.org/software/wget/">wget (World Wide Web get)</a></td>
        <td>
          <ul>
            <li>Usage: Non-interactive network downloader, primarily for downloading files.
            </li>
            <li>Features: Robust for scripts; supports recursive downloads, bandwidth control; can download in the background.</li>
            <li>Security: Basic security; consider using with HTTPS for encryption; see <a href="https://www.cvedetails.com/vulnerability-list/vendor_id-72/product_id-332/GNU-Wget.html">CVEs</a> for details.</li>
          </ul>
        </td>
        <td>
          <ul>
            <li><code>wget -r http://example.com/dir</code> - Recursive download</li>
            <li><code>wget -c http://example.com/file</code> - Continue download</li>
            <li><code>wget --limit-rate=200k http://example.com</code> - Limit rate
            </li>
            <li><code>wget --mirror -p --convert-links -P ./local-dir http://example.com</code> - Mirror site</li>
            <li><code>wget -b http://example.com/file</code> - Download in background
            </li>
          </ul>
        </td>
      </tr>
      <tr>
        <td><a href="https://rsync.samba.org">rsync (Remote Sync)</a></td>
        <td>
          <ul>
            <li>Usage: Synchronize files and directories locally or remotely.</li>
            <li>Features: Efficient; supports delta-transfer algorithm, bidirectional synchronization; can handle large data sets.</li>
            <li>Security: Can use SSH for secure transfers; see <a href="https://www.cvedetails.com/vulnerability-list/vendor_id-7059/Rsync.html">CVEs</a> for details.</li>
          </ul>
        </td>
        <td>
          <ul>
            <li><code>rsync -avz /source/dir user@remote:/destination/dir</code> - Sync directory</li>
            <li><code>rsync -avz --delete /source/dir /dest/dir</code> - Sync with delete</li>
            <li><code>rsync -n -avz /source/dir /dest/dir</code> - Dry run</li>
            <li><code>rsync -avz -e ssh /source/dir user@remote:/destination/dir</code> - Use SSH</li>
            <li><code>rsync --progress /source/file /dest/file</code> - Show progress
            </li>
          </ul>
        </td>
      </tr>
      <tr>
        <td><a href="https://rclone.org">rclone (Rsync for cloud storage)</a></td>
        <td>
          <ul>
            <li>Usage: Sync files and directories to and from cloud storage.</li>
            <li>Features: Versatile; supports many cloud providers, encryption, versatile configuration; can mount cloud storage.</li>
            <li>Security: Supports encryption and secure connections; see
              <a href="https://www.cvedetails.com/vulnerability-list/vendor_id-18942/Rclone.html">CVEs</a> for details.</li>
          </ul>
        </td>
        <td>
          <ul>
            <li><code>rclone copy /source/dir remote:destination/dir</code> - Copy to cloud</li>
            <li><code>rclone sync /source/dir remote:destination/dir</code> - Sync to cloud</li>
            <li><code>rclone config</code> - Configure rclone</li>
            <li><code>rclone ls remote:destination/dir</code> - List files</li>
            <li><code>rclone mount remote:destination/dir /local/mount</code> - Mount remote storage</li>
          </ul>
        </td>
      </tr>
      <tr>
        <td><a href="https://www.openssh.com">ssh (Secure Shell)</a></td>
        <td>
          <ul>
            <li>Usage: Secure Shell, used for remote command execution and file transfer over SSH.</li>
            <li>Features: Secure; encrypts data, supports tunneling, remote access, and commands.</li>
            <li>Security: Highly secure with encryption; see <a href="https://www.cvedetails.com/vulnerability-list/vendor_id-97/product_id-585/OpenBSD-OpenSSH.html">CVEs</a> for details.</li>
          </ul>
        </td>
        <td>
          <ul>
            <li><code>ssh user@remote 'command'</code> - Execute command remotely</li>
            <li><code>ssh -L 8080:localhost:80 user@remote</code> - Port forwarding</li>
            <li><code>ssh -i /path/key user@remote</code> - Login with key</li>
            <li><code>ssh -N -D 8080 user@remote</code> - Dynamic port forwarding</li>
            <li><code>ssh-copy-id user@remote</code> - Copy SSH key</li>
          </ul>
        </td>
      </tr>
      <tr>
        <td><a href="https://www.openssh.com">scp (Secure Copy)</a></td>
        <td>
          <ul>
            <li>Usage: Securely copy files between hosts over SSH.</li>
            <li>Features: Secure; encrypted, preserves file permissions, leverages SSH protocol.</li>
            <li>Security: Uses SSH for encrypted transfer; see <a href="https://www.cvedetails.com/vulnerability-list/vendor_id-97/product_id-585/Openbsd-Openssh.html">CVEs</a> for details.</li>
          </ul>
        </td>
        <td>
          <ul>
            <li><code>scp /source/file user@remote:/destination/file</code> - Copy file</li>
            <li><code>scp -r /source/dir user@remote:/destination/dir</code> - Copy directory</li>
            <li><code>scp -i /path/key /file user@remote:/destination/file</code> - Copy with key</li>
            <li><code>scp -P 2222 /source/file user@remote:/destination/file</code> - Specify port</li>
            <li><code>scp user@remote:/source/file /local/destination</code> - Copy from remote</li>
          </ul>
        </td>
      </tr>
      <tr>
        <td><a href="https://www.slac.stanford.edu/~abh/bbcp">bbcp (Bulk Data Transfer)</a></td>
        <td>
          <ul>
            <li>Usage: High-speed data transfer tool over SSH, suitable for large data sets.</li>
            <li>Features: High performance; parallel transfers, efficient for large data sets.</li>
            <li>Security: Uses SSH; see <a href="https://www.cvedetails.com/vulnerability-list/vendor_id-10734/Bbcp.html">CVEs</a> for details.</li>
          </ul>
        </td>
        <td>
          <ul>
            <li><code>bbcp -P 4 /source/file user@remote:/destination/file</code> - Parallel transfer</li>
            <li><code>bbcp -s 16 /source/dir user@remote:/destination/dir</code> - Transfer directory</li>
            <li><code>bbcp -w /source/file user@remote:/destination/file</code> - Windowed mode</li>
            <li><code>bbcp -z /source/file user@remote:/destination/file</code> - Compressed transfer</li>
            <li><code>bbcp -f /source/file user@remote:/destination/file</code> - Force transfer</li>
          </ul>
        </td>
      </tr>
    </tbody>
  </table>

</body>

</html>