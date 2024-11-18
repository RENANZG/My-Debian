<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Configure OpenVPN for VPN in Debian with NetworkManager (GUI)</title>
<style>
    body {
      font-family: Arial, sans-serif;
      line-height: 1.6;
      margin: 20px;
    }
    h3, h4 {
      color: #333;
    }
    code {
      background: #f4f4f4;
      padding: 5px;
      border-radius: 4px;
      font-size: 1.1em;
    }
    ul {
      margin: 10px 0;
    }
    li {
      margin: 5px 0;
    }
</style>
</head>
<body>

  <h2>Configure OpenVPN for VPN in Debian with NetworkManager (GUI)</h2>

  <h4>1. Download an OpenVPN Configuration File</h4>
  <p>Obtain the OpenVPN configuration file (usually with a .ovpn extension)
    from your VPN provider. Ensure that it is compatible with Linux.</p>

  <h4>2. Get Your OpenVPN Username and Password</h4>
  <p>Retrieve your OpenVPN username and password from your VPN provider. These
    credentials are required for authentication during the setup process.</p>

  <h4>3. Install NetworkManager OpenVPN Plugin</h4>
  <p>To manage OpenVPN connections through the NetworkManager GUI, install
    the necessary plugin:</p>
  <code>$ sudo apt-get install network-manager-openvpn-gnome</code>

  <h4>4. Configure OpenVPN Using NetworkManager GUI</h4>
  <p>Follow these steps to configure your VPN connection:</p>
  <ul>
    <li>Open the NetworkManager settings from your system menu or by searching
      for "Network" in the application menu.</li>
    <li>Navigate to <strong>Settings → Network → VPN → + (Add)</strong>.</li>
    <li>Select <strong>Import from file</strong>.</li>
    <li>Browse and select the OpenVPN configuration file you downloaded earlier.</li>
    <li>Enter your OpenVPN username and password in the respective fields for
      authentication.</li>
    <li>Save the configuration.</li>
  </ul>

  <h4>5. Connect to Your VPN</h4>
  <p>Activate your VPN connection by:</p>
  <ul>
    <li>Going to <strong>Settings → Network → VPN</strong>.</li>
    <li>Selecting your VPN connection and toggling it to "on".</li>
    <li>Clicking <strong>Connect</strong>.</li>
  </ul>

  <h4>6. Check for DNS Leaks</h4>
  <p>After connecting to the VPN, it’s important to check for DNS leaks to
    ensure that your DNS queries are being routed through the VPN. You
    can use online tools such as <a href="https://www.dnsleaktest.com/"
    target="_blank">DNSLeakTest.com</a> to verify that your DNS queries
    are protected.</p>

</body>
</html>