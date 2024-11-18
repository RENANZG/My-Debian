<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>A Simple Guide for Manually Setting Up a Debian Server</title>
</head>
<body>

<h1>A Simple Guide for Manually Setting Up a Debian Server</h1>

<h3>Perform system updates and cleanup</h3>
<pre>
sudo apt-get update &amp;&amp; sudo apt-get upgrade -y &amp;&amp; sudo apt-get autoremove -y &amp;&amp; sudo apt-get autoclean &amp;&amp; sudo apt-get clean
</pre>

<h3>Install essential packages</h3>
<pre>
sudo apt-get install -y curl nano certbot cron ufw htop dialog
</pre>

<h3>Install Speedtest CLI</h3>
<pre>
curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | sudo bash
sudo apt-get install speedtest
</pre>

<h3>Create a SWAP file</h3>
<pre>
sudo fallocate -l 1G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo cp /etc/fstab /etc/fstab.bak
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
sudo sysctl vm.swappiness=10
sudo sysctl vm.vfs_cache_pressure=50
sudo nano /etc/sysctl.conf
# Add the following lines:
# vm.swappiness=10
# vm.vfs_cache_pressure=50
</pre>

<h3>Change SSH Port</h3>
<pre>
sudo nano /etc/ssh/sshd_config
# Change Port 22 to your desired port number
sudo systemctl reload sshd
</pre>

<h3>Setting Up Cron</h3>
<pre>
sudo systemctl enable cron
crontab -e
# Add scheduled tasks as needed
</pre>

<h3>Obtain SSL Certificate with Certbot</h3>
<pre>
sudo certbot certonly --standalone --preferred-challenges http --agree-tos --email your_email@example.com -d sub.domain.com
</pre>

<h3>Installing X-UI</h3>
<pre>
bash <(curl -Ls https://raw.githubusercontent.com/alireza0/x-ui/master/install.sh)
</pre>

<h3>Installing Pi-hole</h3>
<pre>
curl -sSL https://install.pi-hole.net | bash
pihole -a -p
sudo nano /etc/lighttpd/lighttpd.conf
sudo service lighttpd restart
</pre>

<h3>Erlang MTProto proxy</h3>
<pre>
curl -L -o mtp_install.sh https://git.io/fj5ru &amp;&amp; bash mtp_install.sh
</pre>

<h3>WARP Proxy</h3>
<pre>
bash <(curl -fsSL git.io/warp.sh) proxy
# WARP XrayConfig example:
# {
#   "protocol": "socks",
#   "settings": {
#     "servers": [
#       {
#         "address": "127.0.0.1",
#         "port":40000
#       }
#     ]
#   },
#   "tag":"warp"
# },
</pre>

<h3>Hysteria II</h3>
<pre>
bash <(curl -fsSL https://raw.githubusercontent.com/deathline94/Hysteria-Installer/main/hysteria.sh)
</pre>

<h3>TUIC v5</h3>
<pre>
bash <(curl -fsSL https://raw.githubusercontent.com/deathline94/tuic-v5-installer/main/tuic-installer.sh)
</pre>

<h3>Change Local DNS to Pi-hole</h3>
<pre>
sudo nano /etc/resolv.conf
# Replace nameserver with "127.0.0.1"
sudo systemctl daemon-reload
</pre>

<h3>Install qbittorrent-nox</h3>
<pre>
sudo add-apt-repository ppa:qbittorrent-team/qbittorrent-stable
sudo apt update
sudo apt install qbittorrent-nox
sudo nano /etc/systemd/system/qbittorrent-nox.service
# Example systemd unit for qbittorrent-nox:
# [Unit]
# Description=qBittorrent-nox
# After=network.target
# 
# [Service]
# Type=forking
# ExecStart=/usr/bin/qbittorrent-nox -d --webui-port=8000
# Restart=on-failure
# 
# [Install]
# WantedBy=multi-user.target
# 
# Start and enable the service:
# sudo systemctl daemon-reload
# sudo systemctl enable qbittorrent-nox
# sudo systemctl start qbittorrent-nox
# sudo systemctl status qbittorrent-nox
</pre>

<h3>Enable UFW</h3>
<pre>
sudo nano /etc/default/ufw
# Ensure UFW is set to:
# DEFAULT_FORWARD_POLICY="ACCEPT"
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow SSHPORT/tcp
sudo ufw limit SSHPORT/tcp
sudo ufw allow 443
sudo ufw enable
sudo ufw status verbose
sudo systemctl enable ufw
</pre>

<h3>Useful Commands</h3>
<pre>
netstat -tulnp
sudo shutdown -r now
cat /proc/cpuinfo
wget https://releases.ubuntu.com/22.04.3/ubuntu-22.04.3-live-server-amd64.iso
curl -sL network-speed.xyz | bash
</pre>

</body>
</html>
