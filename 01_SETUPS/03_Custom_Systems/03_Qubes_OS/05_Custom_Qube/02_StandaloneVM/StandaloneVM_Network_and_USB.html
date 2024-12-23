<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Qubes OS Network Configuration Tutorial</title>
<style>
      body {
        font-family: Arial, sans-serif;
        margin: 20px;
        line-height: 1.6;
      }
      h1, h2 {
        color: #333;
      }
      pre {
        background-color: #f4f4f4;
        color: #393318;
        font-family: monospace;
        padding: 5px 10px;
        border-radius: 3px;
        overflow: auto;
      }
      code {
        color: inherit;
        font-family: inherit;
      }
</style>
</head>
<body>
  
  <h1>HVMs in Qubes OS</h1>
  
  <h2>Creating a StandaloneVM</h2>
  
  <p>Select the OVA, RAW, or ISO image of the installation media
   located in <strong>dom0</strong> or in a <strong>sys-usb</strong>
   service. To do this:</p>
  
  <ol>
      <li>Open the Qube Manager.</li>
      <li>Select “Create Qube” and choose “Standalone VM” from the
       options.</li>
      <li>Choose the template none and the storage location size.</li>
  </ol>
  
  <h2>Internet in HVMs</h2>
  
  <p>Generic HVMs (Hardware-assisted Virtual Machine), also known as a
   “Fully-Virtualized Virtual Machine,” like standard Ubuntu or Windows
   do not come with Qubes agent scripts, requiring manual network
   configuration to align with Qubes OS settings.</p>
  
  <p>While a DHCP server in the untrusted stub domain simplifies
   networking for some qubes, modern Linux distributions often use Xen
   PV (Paravirtualization) drivers, allowing direct connections to the
   net backend in the net qube and bypassing the stub domain. As a
   result, the DHCP server may be ineffective for these environments.</p>
  
  <p>For network connectivity, <strong>sys-net</strong> is exposed to
   the real-world network and manages physical interfaces like Ethernet
   and WiFi. <strong>sys-firewall</strong> applies firewall rules and
   is placed just behind <strong>sys-net</strong> to enhance security,
   as <strong>sys-net</strong> itself cannot be fully trusted.</p>
  
  <p><strong>sys-net</strong> operates in HVM mode to facilitate direct
   access to PCI devices, while <strong>sys-firewall</strong> runs in
   PVH mode, which has implications for memory usage and performance.
   Additionally, <strong>sys-net</strong> is an AppVM, allowing it to
   store WiFi credentials and static IP settings, whereas
   <strong>sys-firewall</strong> is a DispVM (disposable VM) that
   resets after shutdown, ensuring a clean state for security.</p>
  
  <h2>Configuring HVMs Network in Qubes OS</h2>
  
  <h3>Check the IP and Gateway</h3>
  
  <p>In the terminal of <strong>dom0</strong>, use the following
   command to find the IP, netmask, and gateway of your StandaloneVM:</p>
  
  <pre><code>qvm-ls -n</code></pre>
  
  <p>Note down the IP address (e.g., <code>10.137.0.12</code>), netmask (e.g.,
   <code>255.255.255.255</code>), and the gateway (e.g., <code>10.137.0.6</code>).</p>
  
  <p>For IPv6 configuration, visit: <a href="https://www.qubes-os.org/doc/networking/#ipv6">IPv6 Documentation</a>.</p>
  
  <h2>Configure Network in the StandaloneVM</h2>
  
  <p>1. Open the Terminal in your StandaloneVM (the Linux ISO you created).</p>
  
  <p>2. Switch to the root user:</p>
  
  <pre><code>su -</code></pre>
  <pre><code>sudo su -</code></pre>
  
  <p>3. Edit the <code>/etc/network/interfaces</code> file to set up your
   network interface:</p>
  
  <pre><code>nano /etc/network/interfaces</code></pre>
  <pre><code>vi /etc/network/interfaces</code></pre>
  
  <p>Add the following configuration, replacing <code>{DEVICE}</code> with your
   actual device name (e.g., <code>enX0</code>):</p>
  
  <pre><code>
  auto {DEVICE}
  iface {DEVICE} inet static
      address 10.137.0.12
      netmask 255.255.255.255
      gateway 10.137.0.6
      dns-nameservers 10.139.1.1 10.139.1.2
  </code></pre>
  
  <p>4. Save and exit the editor (in <code>nano</code>, press <code>CTRL + X</code>,
   then <code>Y</code>, and hit <code>Enter</code>).</p>

  <h2>Restart the Network Service</h2>
  
  <p>To apply the changes, restart the network service using one of the following
   commands based on your system:</p>
  
  <p>For <strong>Debian and Ubuntu</strong>:</p>
  
  <pre><code>systemctl restart networking</code></pre>
  
  <p>For <strong>Alpine Linux</strong>:</p>
  
  <pre><code>/etc/init.d/networking restart</code></pre>
  
  <p>If using <strong>NetworkManager</strong>:</p>
  
  <pre><code>systemctl restart NetworkManager</code></pre>
  
  <p>Take care that NetworkManager or ConnMan could cause troubles.</p>
  
  <h2>Verify Configuration</h2>
  
  <p>After restarting, verify your configuration with the following commands:</p>
  
  <p>To check the IP address:</p>
  
  <pre><code>ip a</code></pre>
  
  <p>To check the default gateway:</p>
  
  <pre><code>ip r</code></pre>
  
  <p>To test DNS resolution:</p>
  
  <pre><code>ping 10.139.1.1</code></pre>
  <pre><code>ping google.com</code></pre>

  <h2>Other Configurations in Qubes OS</h2>
  
  <h3>USB Storage Device</h3>

  <p>Enable USB feature in Windows StandaloneVM (HVM):</p>
  
  <p>You don’t need to install any agents in VM to be able to use USB
   by qrexec and install appropriate drivers for emulated USB hub. You
   just need to:</p>

  <p>Command in dom0:</p>

  <pre><code>[user@dom0 ~]$ sudo qvm-features [StandaloneVM_Name] stubdom-qrexec 1</code></pre>

  <h3>Audio Drive</h3>

  <p>Enable audio feature in Windows StandaloneVM (HVM).</p>

  <p>Command in dom0:</p>

  <pre><code>[user@dom0 ~]$ sudo qvm-features [StandaloneVM_Name] audio-model ich6</code></pre>

</body>
</html>
