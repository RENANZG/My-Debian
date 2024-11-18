#!/bin/bash

###########################################
#          Created by Thomas Butz         #
#   E-Mail: btom1990(at)googlemail.com    #
#  Feel free to copy & share this script  #
###########################################

# Adapt this value to your config!
VPN_DST_PORT=3478

# Don't change anything beyond this point
###########################################

# Check for root priviliges
if [[ $EUID -ne 0 ]]; then
   printf "Please run as root:\nsudo %s\n" "${0}" 
   exit 1
fi


# Reset the ufw config
ufw --force reset
         
# let all incoming traffic pass
ufw default allow incoming
# and block outgoing by default
ufw default deny outgoing

# Every communiction via VPN is considered to be safe
ufw allow out on tun0

# Don't block the creation of the VPN tunnel
ufw allow out $VPN_DST_PORT
# Don't block DNS queries
ufw allow out 53

# Allow local IPv4 connections 
ufw allow out to 10.0.0.0/8
ufw allow out to 172.16.0.0/12
ufw allow out to 192.168.0.0/16
# Allow IPv4 local multicasts
ufw allow out to 224.0.0.0/24
ufw allow out to 239.0.0.0/8

# Allow local IPv6 connections
ufw allow out to fe80::/64
# Allow IPv6 link-local multicasts
ufw allow out to ff01::/16
# Allow IPv6 site-local multicasts
ufw allow out to ff02::/16
ufw allow out to ff05::/16

# Enable the firewall
ufw enable