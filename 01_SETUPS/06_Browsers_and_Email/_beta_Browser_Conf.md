<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Firefox Advanced Configuration</title>
</head>
<body>
  
  <h2>Firefox Advanced Configuration</h2>
  
  <h4>Acess Configuration (<code>about:config</code>)</h4>
  
  <p>To access advanced configuration settings, go to (CTRL + L):</p>
  <pre><code>about:config</code></pre>

  <h5>Basic Configuration</h5>

  <p>Adjust the following basic settings:</p>
  <ul>
    <li><code>javascript.enabled</code> - <b>false</b> - Disables JavaScript to mitigate potential security risks associated with executing scripts on web pages.</li>
  </ul>

  <h5>Advanced Configuration (Enhanced Privacy Settings)</h5>

  <p>Configure these settings carefully to enhance your privacy and security (*take care with fingerprinting):</p>
  <ul>
    <li><code>webgl.disabled</code> - <b>true</b> - Disables WebGL to prevent device fingerprinting and potential security vulnerabilities associated with WebGL. Some advanced graphics and interactive web applications that rely on WebGL may not function properly.</li>
    <li><code>media.peerconnection.enabled</code> - <b>false</b> - Disables WebRTC to prevent websites from revealing your real IP address through peer-to-peer connections. Web applications and services that rely on real-time communication features such as video conferencing, voice calls, and file sharing may not work properly.</li>
    <li><code>privacy.resistFingerprinting</code> - <b>true</b> - Makes Tor Browser more resistant to fingerprinting techniques by standardizing browser behaviors.</li>
    <li><code>geo.enabled</code> - <b>false</b> - Disables geolocation tracking to prevent websites from accessing your physical location.</li>
    <li><code>dom.battery.enabled</code> - <b>false</b> - Prevents websites from detecting your device's battery status, enhancing privacy.</li>
    <li><code>dom.event.clipboardevents.enabled</code> - <b>false</b> - Disables clipboard events detection to prevent websites from knowing when you copy/paste content.</li>
    <li><code>network.trr.mode</code> - <b>2</b> - Enables DNS-over-HTTPS (DoH) to encrypt DNS queries, protecting against DNS manipulation and surveillance.</li>
    <li><code>browser.cache.offline.enable</code> - <b>false</b> - Disables offline cache to prevent websites from storing data on your computer for offline use.</li>
  </ul>

  <h5>Other Configuration Adjustments</h5>

  <p>Configure these settings for additional privacy and performance adjustments:</p>
  <ul>
    <li><code>browser.cache.disk.enable</code> - <b>false</b> - Disables disk cache to prevent storing web resources on your hard drive.</li>
    <li><code>browser.cache.memory.enable</code> - <b>false</b> - Disables memory cache to avoid storing web resources in your RAM.</li>
    <li><code>network.prefetch-next</code> - <b>false</b> - Disables prefetching of resources before they are needed.</li>
    <li><code>browser.sessionstore.interval</code> - <b>1500000</b> - Sets the session storage interval to 25 minutes, reducing the frequency of session data saves.</li>
    <li><code>geo.enabled</code> - <b>false</b> - Disables geolocation to stop websites from tracking your physical location.</li>
  </ul>

</body>
</html>
