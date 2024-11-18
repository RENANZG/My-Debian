<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Configure Wi-Fi and Ethernet on Debian CLI</title>
    <style>
      body {
        font-family: Arial, sans-serif;
        line-height: 1.6;
        max-width: 800px;
        margin: auto;
        padding: 20px;
      }
      code {
        background-color: #f0f0f0;
        padding: 2px 5px;
        border-radius: 3px;
      }
      pre {
        background-color: #f7f7f7;
        padding: 10px;
        border-radius: 5px;
        overflow-x: auto;
      }
    </style>
  </head>

  <body>
    
  <h1>Configure Wi-Fi and Ethernet on Debian CLI Without NetworkManager</h1>
   
    <h2>1. Configure Wi-Fi (/etc/network/interfaces)</h2>
   
    <ol>
      <li>Open the file with your preferred text editor:</li>
      <pre><code>sudo nano /etc/network/interfaces</code></pre>
      <li>
        Add the following configuration for Wi-Fi, replacing
        <code>wlan0</code> with your Wi-Fi interface name and
        <code>your-ssid</code> with your Wi-Fi network's SSID:
      </li>
      <pre><code>
      auto lo
      iface lo inet loopback
      auto wlan0
      iface wlan0 inet dhcp
      wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf
      </code></pre>
    </ol>
   
    <h2>2. Configure Wi-Fi Password with wpa_passphrase</h2>
   
    <ol>
      <li>
        Generate a secure passphrase entry using <code>wpa_passphrase</code>:
      </li>
      <pre><code>
      sudo wpa_passphrase your-ssid your-password &gt; /etc/wpa_supplicant/
      wpa_supplicant.conf
      </code></pre>
      <li>
        Replace <code>your-ssid</code> with your Wi-Fi network's SSID and
        <code>your-password</code> with your Wi-Fi network's password. This
        command securely encrypts your password in the
        <code>wpa_supplicant.conf</code> file.
      </li>
    </ol>
    
    <h2>3. Configure Ethernet (/etc/network/interfaces)</h2>
    
    <ol>
      <li>
        If you are using an RJ45-USB adapter for Ethernet, ensure it is
        connected.
      </li>
      <li>
        Add the following configuration for Ethernet to
        <code>/etc/network/interfaces</code>, replacing <code>eth0</code> with
        your Ethernet interface name:
      </li>
      <pre><code>
      auto eth0
      iface eth0 inet dhcp</code></pre>
    </ol>
    
    <h2>4. Create a Drop-in File in /etc/network/interfaces.d/ (Optional)</h2>
    
    <ol>
      <li>
        If you prefer to use a drop-in file, create a file for Wi-Fi in the
        <code>/etc/network/interfaces.d/</code> directory:
      </li>
      <pre><code>
      sudo nano /etc/network/interfaces.d/wifi</code></pre>
      <li>Add the Wi-Fi configuration as shown in step 1:</li>
      <pre><code>
      auto wlan0
      iface wlan0 inet dhcp
      wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf</code></pre>
      <li>Create a file for Ethernet if desired:</li>
      <pre><code>
      sudo nano /etc/network/interfaces.d/ethernet</code></pre>
      <li>Add the Ethernet configuration as shown in step 3:</li>
      <pre><code>
      auto eth0 
      iface eth0 inet dhcp</code></pre>
    </ol>
    
    <h2>5. Configure DNS in /etc/resolv.conf</h2>
    
    <ol>
      <li>Open the file with your preferred text editor:</li>
      <pre><code>sudo nano /etc/resolv.conf</code></pre>
      <li>Add your DNS server addresses. Here's a simple example:</li>
      <pre><code>
      nameserver 1.1.1.1
      nameserver 1.0.0.1
      </code></pre>
    </ol>
    
    <p>Issues</p>
    
    <ul>
    <li>Install resolvconf
    <pre><code>
    sudo apt-get install -y resolvconf
    </code></pre>
    </li>
    
    <li>Add your nameserver into /etc/resolvconf/resolv.conf.d/tail 
    <pre><code>
    nameserver 1.1.1.1
    nameserver 1.0.0.1
    </code></pre>
    </li> 
    </ul>
        
    <h2>6. Bring Up the Interfaces</h2>
    
    <ol>
      <li>Restart the networking service to apply changes:</li>
      <pre><code>sudo systemctl restart networking</code></pre>
      <li>Or manually bring up the interfaces:</li>
      <pre><code>sudo ifdown wlan0 && sudo ifup wlan0<br>sudo ifdown eth0 && sudo ifup eth0</code></pre>
    </ol>
    
    <p>To find your Wi-Fi interface name, you can use the following command:</p>
    
    <pre><code>ip link show</code></pre>

    <p>If necessary, reboot your machine:</p>
    
    <pre><code>
    reboot
    </code></pre>
    
  </body>
</html>
