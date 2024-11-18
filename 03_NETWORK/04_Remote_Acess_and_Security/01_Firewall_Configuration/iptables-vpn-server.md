# Execute these commands together otherwise you will be locked out of your server before you can finish

# If you are using a different configuration than the recommended TCP one, make sure to change these commands accordingly

# Allow loopback device (internal communication)
sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A OUTPUT -o lo -j ACCEPT

#Allow all local traffic.
sudo iptables -A INPUT -s 192.168.0.0/24 -j ACCEPT
sudo iptables -A OUTPUT -d 192.168.0.0/24 -j ACCEPT

# Allow VPN establishment
# Only 2 ports open, 1 for DNS and 1 for VPN
# If establishing thru an IP and not a name, the ones with port 53 can be removed
# Port 1198 may be different depending on the VPN
sudo iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
sudo iptables -A INPUT -p udp --sport 53 -j ACCEPT
sudo iptables -A OUTPUT -p tcp --dport 502 -j ACCEPT
sudo iptables -A INPUT -p tcp --sport 502 -j ACCEPT

#Accept all TUN connections (tun = VPN tunnel)
sudo iptables -A OUTPUT -o tun+ -j ACCEPT
sudo iptables -A INPUT -i tun+ -j ACCEPT

#Set default policies to drop all communication unless specifically allowed
sudo iptables -P INPUT DROP
sudo iptables -P OUTPUT DROP
sudo iptables -P FORWARD DROP