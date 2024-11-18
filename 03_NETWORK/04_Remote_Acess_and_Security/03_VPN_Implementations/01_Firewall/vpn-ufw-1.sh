#!/bin/bash

# chmod +x ufw-vpn.sh
# ./ufw-vpn.sh

ufw --force reset
ufw default deny incoming
ufw default deny outgoing
ufw allow in on tun0
ufw allow out on tun0
ufw allow in on wlp6s0 from 192.168.0.0/24
ufw allow out on wlp6s0 to 192.168.0.0/24
ufw allow out on wlp6s0 to 198.51.100.0 port 1194  proto udp
ufw allow in on wlp6s0 from 198.51.100.0 port 1194 proto udp
ufw enable