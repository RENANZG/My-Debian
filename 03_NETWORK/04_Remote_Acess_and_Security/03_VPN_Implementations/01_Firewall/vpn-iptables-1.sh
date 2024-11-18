#!/bin/bash

# chmod +x iptables-vpn.sh
# ./iptables-vpn.sh

iptables --flush
iptables --delete-chain
iptables -t nat --flush
iptables -t nat --delete-chain
iptables -P OUTPUT DROP
iptables -A INPUT -j ACCEPT -i lo
iptables -A OUTPUT -j ACCEPT -o lo
iptables -A INPUT --src 192.168.0.0/24 -j ACCEPT -i wlp6s0
iptables -A OUTPUT -d 192.168.0.0/24 -j ACCEPT -o wlp6s0
iptables -A OUTPUT -j ACCEPT -d 198.51.100.0 -o wlp6s0 -p udp -m udp --dport 1194
iptables -A INPUT -j ACCEPT -s 198.51.100.0 -i wlp6s0 -p udp -m udp --sport 1194
iptables -A INPUT -j ACCEPT -i tun0
iptables -A OUTPUT -j ACCEPT -o tun0