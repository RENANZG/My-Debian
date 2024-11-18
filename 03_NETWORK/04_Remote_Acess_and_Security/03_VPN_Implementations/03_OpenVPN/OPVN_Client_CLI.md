<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Configure OpenVPN (CLI) for VPN in Debian</title>
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
  
  <h2>Configure OpenVPN (CLI) for VPN in Debian</h2>

  <h4>1. Download an OpenVPN configuration file for Linux</h4>

  <h4>2. Find your OpenVPN username and password</h4>

  <h4>3. Manually configure OpenVPN (CLI)</h4>

  <code>$ sudo apt install openvpn</code>
  <br>
  <code>$ sudo apt install openresolv</code>

  <h5>DNS Update Script</h5>
  <pre>/etc/openvpn/update-resolv-conf</pre>

  <h4>4. Connect to a VPN server using OpenVPN</h4>
  <code>$ sudo openvpn ~/Downloads/config.ovpn</code>
  <p>Enter your OpenVPN username and password when prompted. Check for DNS
    leaks.</p>

  <h4>5. Set Up a Kill Switch</h4>
  <p>A kill switch helps prevent your traffic from leaking if the VPN connection
    drops. To set up a basic kill switch, you can block all traffic unless
    it's routed through the VPN. Here's a simple example:</p>

  <h5>Using iptables</h5>

<pre>
# Flush existing rules
sudo iptables -F
sudo iptables -t nat -F
sudo iptables -t mangle -F

# Set default policies to drop all traffic
sudo iptables -P INPUT DROP
sudo iptables -P FORWARD DROP
sudo iptables -P OUTPUT DROP

# Allow loopback traffic
sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A OUTPUT -o lo -j ACCEPT

# Allow traffic from and to the VPN interface
sudo iptables -A INPUT -i tun0 -j ACCEPT
sudo iptables -A OUTPUT -o tun0 -j ACCEPT

# Allow established and related connections
sudo iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
sudo iptables -A OUTPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# Allow DNS queries (if not using a local DNS server)
sudo iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
sudo iptables -A INPUT -p udp --sport 53 -j ACCEPT
</pre>

  <h5>Using `ufw`</h5>

<pre>
# Reset `ufw` to default settings
sudo ufw reset

# Set default policies to deny all incoming and outgoing traffic
sudo ufw default deny incoming
sudo ufw default deny outgoing

# Allow loopback traffic
sudo ufw allow in on lo
sudo ufw allow out on lo

# Allow traffic from and to the VPN interface (replace 'tun0' with your VPN interface)
sudo ufw allow in on tun0
sudo ufw allow out on tun0

# Allow DNS queries (if not using a local DNS server)
sudo ufw allow out 53/udp
sudo ufw allow in 53/udp

# Enable `ufw` and check status
sudo ufw enable
sudo ufw status
</pre>

  <p>Note: Replace <code>tun0</code> with your actual VPN interface name if
    it's different. Adjust rules based on your specific needs and security
    requirements.</p>

</body>
</html>