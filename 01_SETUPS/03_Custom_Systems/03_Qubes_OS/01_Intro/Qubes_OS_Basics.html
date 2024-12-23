<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Qubes OS Basics</title>
<style>
  body {
  font-family: Arial, sans-serif;
  margin: 0;
  padding: 20px;
  line-height: 1.6;
  max-width: 21cm;
  height: 29.7cm;
  background-color: #f9f9f9;
  }
  h1, h2, h3 {
  color: #2c3e50;
  }
  ul, ol {
  margin-left: 20px;
  }
  pre {
  background-color: #f4f4f4;
  padding: 10px;
  border-left: 5px solid #003366;
  overflow-x: auto;
  }
  code {
  background-color: #f4f4f4;
  padding: 2px 5px;
  border-radius: 4px;
  }
  pre code {
  background-color: #f4f4f4;
  padding: 10px;
  border-left: 5px solid #003366;
  overflow-x: auto;
  border-radius: 4px;
  }
</style>
</head>
<body>

  <h1>Qubes OS Basics (R4.2)</h1>

  <p>For more details, visit the <a href="https://www.qubes-os.org/doc/getting-started/">Qubes OS Getting started</a>, <a href="https://qubes-doc-rst.readthedocs.io">Qubes OS Documentation</a>, <a href="https://www.qubes-os.org/doc/glossary/">Qubes OS Glossary</a>, and and <a href="https://dev.qubes-os.org">Qubes OS Developer’s Documentation</a>.</p>

  <h2>Qubes Organization Terminology</h2>

  <ul>
  <li><strong>Core Domains</strong>
    <ul>
    <li><strong>dom0</strong>: The administrative domain with direct hardware access, providing the highest level of trust and control over the system. It manages the overall Qubes OS environment.</li>
    <li><strong>domU</strong>: Unprivileged user domains running isolated applications. All domains except dom0 are considered domUs.</li>
    </ul>
  </li>

  <li><strong>Templates</strong>
    <ul>
    <li><strong>TemplateVM</strong>: A template for creating app qubes; it shares its root filesystem with app qubes and is used for installing and updating software.</li>
    <li><strong>fedora-XX</strong>: A template for creating AppVMs based on the Fedora operating system (XX being the version number).</li>
    <li><strong>debian-XX-xfce</strong>: A template for creating AppVMs based on the Fedora operating system (XX being the version number).</li>
    </ul>
  </li>

  <li><strong>App Qubes (Configured for Security)</strong>
    <ul>
    <li><strong>personal</strong>: For personal activities.</li>
    <li><strong>work</strong>: For work-related tasks.</li>
    <li><strong>untrusted</strong>: For browsing or other potentially risky activities.</li>
    <li><strong>vault</strong>: For securely storing sensitive data.</li>
    <li><strong>anon-whonix</strong>: An AppVM built on Whonix-ws, specifically designed for secure anonymous browsing.</li>
    </ul>
  </li>
  
   <li><strong>Virtual Machines (VMs)</strong>
    <ul>
    <li><strong>StandaloneVM</strong>: An independent full system VM with its own root filesystem, allowing for greater flexibility and isolation.</li>
    <li><strong>Vault VM</strong>: An air-gapped domain for secure storage of sensitive data, providing a high level of trust.</li>
    </ul>
  </li>

  <li><strong>Disposable VMs</strong>
    <ul>
    <li><strong>DisposableVM</strong>: A temporary app qube that self-destructs when its originating window closes, ensuring secure and isolated tasks.</li>
    <li><strong>named disposable</strong>: A type of disposable VM that retains a permanent name and can be restarted, but still has no persistent state.</li>
    <li><strong>whonix-workstation-[xx]-dvm</strong>: A disposable VM based on Whonix designed for temporary, secure anonymous tasks without leaving traces.</li>
    </ul>
  </li>
  
   <li><strong>Networking Services</strong>
    <ul>
    <li><strong>NetVM</strong>: A property of a qube that specifies from which qube it receives network access, playing a crucial role in the networking architecture of Qubes OS.</li>
    </ul>
  </li>
  
  <li><strong>Service Qubes</strong>
    <ul>
    <li><strong>sys-net</strong>: Manages network connections and routes packets from the outside world to the sys-firewall VM.</li>
    <li><strong>sys-firewall</strong>: Routes packets from sys-net to other VMs and manages firewall rules to enhance security.</li>
    <li><strong>sys-usb</strong>: Manages USB devices, allowing controlled access to peripherals within the secure environment.</li>
    <li><strong>sys-whonix</strong>: Provides Tor-based connectivity for anonymous internet access and acts as a ProxyVM utilizing Whonix-gw.</li>
    </ul>
  </li>

  <li><strong>Management Qubes</strong>
    <ul>
    <li><strong>management qube</strong>: A qube used for automated management of a Qubes OS installation via Salt, handling background housekeeping tasks.</li>
    <li><strong>service qube</strong>: Any app qube whose primary purpose is to provide services to other qubes, such as sys-net and sys-firewall.</li>
    </ul>
  </li>
  </ul>

  <h2>Basic Update Commands</h2>

  <p>"When you update using the Qubes Update tool (or its qubesctl command-line equivalents), you are updating via the Salt management stack. Salt allows the Qubes developers to deliver security fixes that cannot be handled by normal package updates."</p>

  <p>For more details, visit the <a href="https://www.qubes-os.org/doc/how-to-update/">Qubes OS DOC - How to Update</a> and <a href="https://www.whonix.org/wiki/Qubes/Update">Qubes OS Wiki - Update</a>.</p>
  
  <ul>
  <li><a href="https://www.qubes-os.org/doc/salt/#updatequbes-dom0">update.qubes-dom0</a></li>
  <li><a href="https://www.qubes-os.org/doc/salt/#updatequbes-dom0">update.qubes-dom0</a></li>
  </ul>

  <h3>Perform Updates Via The Command-line Interface With Salt State</h3>
  
  <h4>update.qubes-dom0:</h4>

  <pre>[user@dom0 ~]$ sudo qubesctl --show-output state.sls update.qubes-dom0</pre>

  <h4>update.qubes-vm for all domUs one by one:</h4>

  <pre>[user@dom0 ~]$ sudo qubesctl --show-output --skip-dom0 --app --templates --max-concurrency=1 state.sls update.qubes-vm</pre>

  <h4>update.qubes-vm for specific domU:</h4>

  <pre>[user@dom0 ~]$ sudo qubesctl --show-output --skip-dom0 --max-concurrency=1 --targets=personal,work,vault,anon-whonix,whonix-workstation-17-dvm state.sls update.qubes-vm</pre>

  <h4>update.qubes-vm for standalones domU:</h4>

  <pre>[user@dom0 ~]$ sudo qubesctl --show-output --skip-dom0 --standalones state.sls --max-concurrency=1 update.qubes-vm</pre>

  <p><strong>Note:</strong> Standalones may need special instructions.</p>

  <h4>Updating with direct commands</h4>

  <p>"Warning: Updating with direct commands such as qubes-dom0-update, dnf update, and apt update is not recommended, since these bypass built-in Qubes OS update security measures. Instead, we strongly recommend using the Qubes Update tool or its command-line equivalents, as described below. (By contrast, installing packages using direct package manager commands is fine.)"</p>

  <p>If you are facing slow updates, direct update commands in tamplate vms may be the solution.</p>
  
  <pre>[user@dom0 ~]$ qubes-dom0-update</pre>
  <pre>[user@debian-12-xfce ~]$ sudo sudo apt update && sudo apt dist-upgrade -y</pre>
  <pre>[user@fedora-40-xfce ~]$ sudo dnf update</pre>
  <pre>[template gatway user ~]% upgrade-nonroot</pre>
  <pre>[template workstation user ~]% upgrade-nonroot</pre>
  <pre>[workstation user ~]% upgrade-nonroot</pre>

  <h2>Installing Packages in domU</h2>

  <p>It's fine to use direct commands for installing new packages.</p>

  <p>To install a package in a Fedora-based domU:</p>

  <pre>[user@fedora-based ~]$ sudo dnf install &lt;package-name&gt;</pre>

  <p>For Debian-based domU:</p>

  <pre>[user@debian-based ~]$ sudo apt install &lt;package-name&gt;</pre>

  <p><strong>Note:</strong> Software in Standalones and dom0 may need special
  instructions. Always check default repositories first.</p>
  
   <h2>Installing Packages in dom0</h2>
  
  <ul>
  <li><a href=https://www.qubes-os.org/doc/how-to-install-software-in-dom0/">How to install software in dom0</a></li>
  </ul>
  
  <p>It's not recommended to install a package in dom0, but if necessary:</p>

  <pre>[user@dom0~]$ sudo qubes-dom0-update &lt;package-name&gt;</pre>

  <h2>Copying Clipboard Text Between Qubes</h2>

  <ol>
  <li>Select text in qube A and copy it (<code>Ctrl+C</code>).</li>
  <li>Press <code>Ctrl+Shift+C</code> to copy to the inter-qube clipboard.</li>
  <li>In qube B, press <code>Ctrl+Shift+V</code> to paste from the inter-qube clipboard.</li>
  <li>Paste normally in qube B (<code>Ctrl+V</code>).</li>
  </ol>

  <h3>From dom0:</h3>

  <ol>
  <li>Copy text in dom0 (<code>Ctrl+C</code>).</li>
  <li>Click the Qubes Clipboard icon.</li>
  <li>Select “Copy dom0 clipboard.”</li>
  <li>In target qube, press <code>Ctrl+Shift+V</code>.</li>
  <li>Paste normally (<code>Ctrl+V</code>).</li>
  </ol>

  <h3>Copying Clipboard Text from dom0</h3>

  <p>This section explains how to copy files and clipboard text between dom0 and domUs.
  Note that the processes differ from those used within qubes.</p>

  <h3>Copying Files from dom0</h3>

  <p>To copy a file from dom0 to a VM, use:</p>

  <pre>qvm-copy-to-vm &lt;target_vm&gt; &lt;file&gt;</pre>

  <p>The file will arrive in the target VM at:</p>

  <pre>/home/user/QubesIncoming/dom0/</pre>

  <h3>Copying Clipboard Text from dom0</h3>

  <p>Using the Qubes Clipboard widget:</p>

  <ol>
  <li>Copy text normally in dom0 (e.g., <code>Ctrl+C</code>).</li>
  <li>Click the Qubes Clipboard icon in the Notification Area.</li>
  <li>Select “Copy dom0 clipboard.”</li>
  <li>In the target qube, press <code>Ctrl+Shift+V</code> to paste.</li>
  <li>Paste normally within that qube (e.g., <code>Ctrl+V</code>).</li>
  </ol>

  <p>Alternatively, you can save text in a file or write it to <code>/var/run/qubes/qubes-clipboard.bin</code>:</p>

  <pre>echo -n dom0 > /var/run/qubes/qubes-clipboard.bin.source</pre>

  <p>Then use <code>Ctrl+Shift+V</code> to paste it in the target qube.</p>

  <h3>Copying Logs from dom0</h3>

  <p>To copy log contents to the inter-VM clipboard:</p>

  <ol>
  <li>Right-click the desired qube in the Qube Manager.</li>
  <li>Click “Logs” and select the desired log.</li>
  <li>Click “Copy to Qubes clipboard.”</li>
  </ol>

  <p>You can now paste the log contents in the target qube as usual (e.g., <code>Ctrl+Shift+V</code>, then <code>Ctrl+V</code>).</p>

  <h2>Transfer Files</h2>

  <h3>Copying files to dom0</h3>

  <p><strong>Warning:</strong> Copying into dom0 is not recommended as it can compromise
  system security. Usually, there's no need to transfer files from domUs to dom0.</p>

  <p>If you still want to copy files, you can use the following command in dom0 (for
  text, first save it to a file):</p>

  <pre>qvm-run --pass-io &lt;src-vm&gt; 'cat /path/to/file_in_src_domain' > /path/to/file_name_in_dom0</pre>

  <p>You can also copy files from dom0 to domUs using:</p>

  <pre>cat /path/to/file_in_dom0 | qvm-run --pass-io &lt;dest-vm&gt; 'cat > /path/to/file_name_in_appvm'</pre>

  <h2>Data Storage and Sharing</h2>

  <p>To copy a file:</p>

  <ol>
  <li>Open the file manager in the source qube.</li>
  <li>Right-click the file and select <strong>Copy to Other AppVM...</strong>.</li>
  <li>Enter the target qube's name.</li>
  <li>The file will be in <code>/home/user/QubesIncoming/&lt;source_qube&gt;/</code>.</li>
  </ol>

  <h2>Attaching Devices in Read-Only Mode</h2>

  <pre>qvm-block a work sys-usb:sda1 -o read-only=true</pre>

  <p>Or use the shortcut:</p>

  <pre>qvm-block a work sys-usb:sda1 --ro</pre>

</body>
</html>