
👷🛠️UNDER CONSTRUCTION🚧🏗<br>

<h4>Enabling a kill switch</h4>

<p>VPN software comes with a killswitch, but it is safer to use iptables which is already integrated into the Linux kernel.</p>

<p>This example assumes that your network interfaces are on eth* and that you want to connect to our Swedish or Dutch servers.</p>

<p>Issue the following in a terminal, replacing the IP ranges or IP addresses with the servers you wish to use. Make sure to check "Use IP addresses" in the advanced settings of the OpenVPN generator. Also note that outgoing ping (ICMP) requests will be blocked outside of the tunnel so you cannot ping the VPN server.</p>

<p>Make sure that your wan interface is eth*, if not you need to replace the script to match your interface name.</p>

<pre>
sudo iptables -P OUTPUT DROP
sudo iptables -A OUTPUT -o tun+ -j ACCEPT
sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A OUTPUT -o lo -j ACCEPT
sudo iptables -A OUTPUT -d 255.255.255.255 -j ACCEPT
sudo iptables -A INPUT -s 255.255.255.255 -j ACCEPT
sudo iptables -A OUTPUT -o eth+ -p udp -m multiport --dports 53,1300:1302,1194:1197 -d
141.98.255.0/24,193.138.218.0/24,45.83.220.0/24,185.213.152.0/24,185.213.154.0/24,185.65.135.0/24,185.65
-j ACCEPT
sudo iptables -A OUTPUT -o eth+ -p tcp -m multiport --dports 53,443 -d
141.98.255.0/24,193.138.218.0/24,45.83.220.0/24,185.213.152.0/24,185.213.154.0/24,185.65.135.0/24,185.65
-j ACCEPT
sudo ip6tables -P OUTPUT DROP
sudo ip6tables -A OUTPUT -o tun+ -j ACCEPT
</pre>
