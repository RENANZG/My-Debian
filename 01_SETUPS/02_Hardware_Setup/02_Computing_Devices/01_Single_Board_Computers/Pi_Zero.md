<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Raspberry Pi - Zero W</title>
</head>
<body>

<h1>Raspberry Pi - Zero W</h1>

<img src="https://media.wired.co.uk/photos/606da1cc5b10d6006e4b211d/master/w_1600%2Cc_limit/rasp2_1.jpg" alt="Raspberry Pi Zero W" width="400" height="300"/>

<h1>Imaging</h1>
<ul>
  <li>Start the imaging tool (Raspberry Pi Imager)</li>
  <li>Plug in micro SD card (USB or SD Adapter)</li>
  <li>Choose OS (Raspian OS lite command line only)</li>
  <li>Click Write (Wait for writing and verification to complete)</li>
  <li>Insert micro SD into Raspberry Pi Zero W and plugin power to boot</li>
</ul>

<h2>Setting up keyboard</h2>
<pre><code>raspi-config
</code></pre>
<p>Run raspi-config then choose <strong>Localisation Options</strong> &gt; <strong>Change Locale</strong> (en_US.UTF-8) (Optional)</p>
<p>Run raspi-config then choose <strong>Localisation Options</strong> &gt; <strong>Change Keyboard Layout</strong></p>
<ul>
  <li>Choose Generic 101-key PC &gt; English (US)</li>
  <li>Choose The default for the keyboard layout</li>
  <li>No compose key</li>
</ul>

<h2>Setting up wifi</h2>
<pre><code>wpa_passphrase &lt;SSID&gt; &gt;&gt; /etc/wpa_supplicant/wpa_supplicant.conf
</code></pre>
<p>Type the password into the blank prompt. Open the wpa_supplicant.conf and delete the plaintext password</p>
<pre><code>wpa_cli -i wlan0 reconfigure
</code></pre>
<p>Connects to the network specified in wpa_supplicant.conf if configured correctly</p>

<h2>Setting up SSH</h2>
<pre><code>sudo systemctl enable ssh
sudo systemctl start ssh
</code></pre>

<h2>Updating</h2>
<pre><code>sudo apt update &amp;&amp; apt full-upgrade -y
</code></pre>

<h2>References</h2>
<ul>
  <li><a href="https://www.raspberrypi.org/documentation/installation/installing-images/">Raspberry Pi Imaging Guide</a></li>
  <li><a href="https://www.raspberrypi.org/documentation/configuration/raspi-config.md">raspi-config Documentation</a></li>
  <li><a href="https://www.raspberrypi.org/documentation/configuration/wireless/wireless-cli.md">WiFi Configuration</a></li>
  <li><a href="https://www.raspberrypi.org/documentation/remote-access/ssh/README.md">SSH Setup Guide</a></li>
  <li><a href="https://www.raspberrypi.com/documentation/computers/os.html#using-apt">APT Package Management</a></li>
</ul>

</body>
</html>
