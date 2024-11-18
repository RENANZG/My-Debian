 #!/bin/bash

set -e

VERSION="0.01"

## NOTE
## below is setup with the following
## eth0 = LAN
## eth1 = WAN

# todo, detect lan, detect interface names.
LAN_RANGE="192.168.0.0/24"
SSH_LAN_ONLY="yes"

# the can be any location, (/root/bin)
YOUR_UFW_SCRIPT_LOCATION="/root/bin"

RUNDATE="$(date +%Y%m%d_%H%M%S)"
CUR_PATH="$(pwd)"
DNS_MANUAL="no"

# check for root or sudo.
if [[ $UID -ne 0 ]]; then
    echo "exiting now, your not a root user or using sudo"
    exit 1
fi

if [ ! -d "${YOUR_UFW_SCRIPT_LOCATION}" ]; then 
    echo "Error, missing : YOUR_UFW_SCRIPT_LOCATION, or unable to detect the folder."
    exit 1
fi

## Menu/Help Begin
if [ -z "$1" ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "This script setup your server firewall settings."
    echo  "usage:"
    echo  " '$0 -h or --help' will print this message."
    echo  " '$0 new' create a basic ufw setup script for you."
    echo  " '$0 reset' reset, back to this scripts defaults."
    echo  " '$0 reload/restart' reload or restart ufw firewall."
    echo  " '$0 show' will show the rules as they are processed."
    echo  " '$0 ipv6' troggle ipv6 on/off, a reload is automaticly done and ipv6 rules are disabled/enabled."
    echo  " '$0 icmpout' enables icmp (ping ipv4 ) in/out. see also: /etc/ufw/before.rules "
    echo  " '$0 nosyslog' sets rsysvol file, /etc/rsyslog.d/20-ufw.conf, to ufw only logging to /var/log/ufw.log"
    echo  " '$0 test' is used to test new functions added in the script."
    exit 0
fi
# if you exstent the list of options add the option here also.
ArrayOfOptions=("new" "reset" "reload" "restart" "show" "ipv6" "icmpout" "nosyslog" "test" )
in_array() {
    local haystack=${1}[@]
    local needle=${2}
    for i in ${!haystack}; do
        if [[ ${i} == ${needle} ]]; then
            return 0
        fi
    done
    return 1
}
in_array ArrayOfOptions $1 || bash $(basename $0) -h
## Menu/Help END

Check_Package_Installed(){
if [ "$(dpkg-query -l "${1}" | grep -c '^.i')" -eq 1 ]; then
    echo "Package : ${1} was already installed."
else
    apt-get -y install "${1}"
fi
}

Get_NetworkInterfaceInfo(){
# This might need some extra work.
IFS=$'\n'
SERVER_IFACE_NAMES=("$(ip -o link show | awk '{print $2,$9}' | grep -v lo| cut -d':' -f1)")
echo "SERVER_IFACE_NAMES are : $SERVER_IFACE_NAMES"
unset IFS
# Get Gateway ip adress.
SERVER_DEF_GW_IP="$(ip route | grep default | awk '{ print $3 }')"
echo "SERVER_DEF_GW_IP is $SERVER_DEF_GW_IP"
# Get ip adres base on gateway.
SERVER_DEF_IF_IP="$(ip route get ${SERVER_DEF_GW_IP} | awk 'NR==1 {print $NF}')"
echo "SERVER_DEF_IF_IP is $SERVER_DEF_IF_IP"
}

# Restrict ufw logging to only /var/log/ufw.log
NoSysLog(){
    sed -i "s/#\& stop/\& stop/g" /etc/rsyslog.d/20-ufw.conf
    systemctl restart rsyslog
    systemctl status rsyslog
}

EnablePingOutIPv4(){
    sed -i "/# don't delete the 'COMMIT' line or these rules won't be processed/i # Allow icmp code for OUTPUT (ipv4)"  /etc/ufw/before.rules
    # Option 1, allow selected ICMP types.
    sed -i "/# don't delete the 'COMMIT' line or these rules won't be processed/i -A ufw-before-output -p icmp --icmp-type destination-unreachable -j ACCEPT" /etc/ufw/before.rules
    sed -i "/# don't delete the 'COMMIT' line or these rules won't be processed/i -A ufw-before-output -p icmp --icmp-type source-quench -j ACCEPT" /etc/ufw/before.rules
    sed -i "/# don't delete the 'COMMIT' line or these rules won't be processed/i -A ufw-before-output -p icmp --icmp-type time-exceeded -j ACCEPT" /etc/ufw/before.rules
    sed -i "/# don't delete the 'COMMIT' line or these rules won't be processed/i -A ufw-before-output -p icmp --icmp-type parameter-problem -j ACCEPT" /etc/ufw/before.rules
    sed -i "/# don't delete the 'COMMIT' line or these rules won't be processed/i -A ufw-before-output -p icmp --icmp-type echo-reply -j ACCEPT" /etc/ufw/before.rules
    sed -i "/# don't delete the 'COMMIT' line or these rules won't be processed/i -A ufw-before-output -p icmp --icmp-type echo-request -j ACCEPT" /etc/ufw/before.rules
    # Option 2, allow all ICMP types.
    sed -i "/# don't delete the 'COMMIT' line or these rules won't be processed/i # Optional, allow all icmp types for OUTPUT (ipv4)" /etc/ufw/before.rules
    sed -i "/# don't delete the 'COMMIT' line or these rules won't be processed/i #-A ufw-before-output -p icmp -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT" /etc/ufw/before.rules
    sed -i "/# don't delete the 'COMMIT' line or these rules won't be processed/i #-A ufw-before-output -p icmp -m state --state ESTABLISHED,RELATED -j ACCEPT"  /etc/ufw/before.rules
    echo "Ping out is enabled, please review /etc/ufw/before.rules, it starts at # Allow icmp code for OUTPUT (ipv4)"
}

EnableDisableIPv6(){
# set ipv6 on/off
if [ -e /etc/default/ufw ]; then 
    # use (import) the setting from /etc/default/ufw
    . /etc/default/ufw
    if [ "$IPV6" = "yes" ]; then
        sed -i 's/IPV6=yes/IPV6=no/g'  /etc/default/ufw
    else
        sed -i 's/IPV6=no/IPV6=yes/g'  /etc/default/ufw
    fi
else
    echo "Warning: function EnableDisableIPv6, missing /etc/default/ufw"
fi
}

## Menu/Help END
Get_nameserver_ips(){
if [ $(grep -n "nameserver" /etc/resolv.conf | grep "127.0." |wc -l ) -ge 1 ]; then
    DNS_MANUAL="yes"
    echo "Warning: possible caching/forwarind nameserver detected."
    echo "Warning: you might need to set the nameservers manualy please review /etc/ufw/personal-script"
    echo "DNS is set to allow out to any port 53."
else
    DNS_MANUAL="no"
    # Try to Detect your nameservers.
    IFS=$'\n'
    NAMESERVERARRAY="$(grep -n "nameserver" /etc/resolv.conf | awk '{ print $NF }')"
    unset IFS
fi
}

Get_DomainControlerNames(){
# check for the needed packages before running commands.
Check_Package_Installed dnsutils
sleep 0.1
IFS=$'\n'
DCS_ARRAY_NAMES=("$(host -t SRV _kerberos._udp.$(hostname -d)| awk '{ print $NF }')")
unset IFS
echo "Your DC names are : ${DCS_ARRAY_NAMES}"
}

Get_DomainMXserver(){
# check for the needed packages before running commands.
Check_Package_Installed dnsutils
sleep 0.1
IFS=$'\n'
MX_ARRAY_NAMES=("$(host -t MX $(hostname -d)| awk '{ print $NF }')")
unset IFS
echo "Your MX names are : ${MX_ARRAY_NAMES}"
}


Ufw_create_personalscript(){
local COUNTER=0
if [ ! -e /etc/ufw/personal-script ]; then 
    echo "Error, the personal script file was not create yet."
    echo "Please edit /etc/ufw/personal-script and add your commands."
    echo "Some basics are already added for you then re-run this script again."
    echo " "
    # Create basic script
    echo "#!/bin/bin/bash -e" > /etc/ufw/personal-script
    echo " " >> /etc/ufw/personal-script
    echo "# The ssh rule is ALWAYS the first rull, this may prevent a lockout when you enable ufw." >> /etc/ufw/personal-script
    echo "# Protect ssh from bruteforce attacks by using the limiting traffic. " >> /etc/ufw/personal-script
    if [ "${SSH_LAN_ONLY}" = "no" ]
    then
	echo "# The line below allows ssh from anywhere." >> /etc/ufw/personal-script
        echo "ufw limit SSH comment 'Limit SSH (22/tcp)'" >> /etc/ufw/personal-script
    else
	echo "# The line below allows ssh only from primary lan." >> /etc/ufw/personal-script
        echo "ufw limit in on eth0 from ${LAN_RANGE} to any proto tcp port 22 comment 'Limit SSH from RTD lan (22/tcp)'" >> /etc/ufw/personal-script
    fi
    echo " " >> /etc/ufw/personal-script
    # DEFAULTS.
    echo "# Restrict the firewall and deny in/out/forward by default." >> /etc/ufw/personal-script
    echo "# Options are : default allow|deny|reject incoming|outgoing|routed" >> /etc/ufw/personal-script
    echo "ufw default deny incoming" >> /etc/ufw/personal-script
    echo "ufw default deny outgoing" >> /etc/ufw/personal-script
    echo "ufw default deny routed" >> /etc/ufw/personal-script
    echo " " >> /etc/ufw/personal-script
    echo "# Reduce ufw logging. (options on/off, low medium high" >> /etc/ufw/personal-script
    echo "# Testing new rules, set it to high and tail -f /var/log/ufw.log and/or /var/log/syslog." >> /etc/ufw/personal-script
    echo "ufw logging low" >> /etc/ufw/personal-script
    echo " " >> /etc/ufw/personal-script
    # DNS: Get the nameserver ips, and use them in the firewall"
    Get_nameserver_ips
    COUNTER=0
    echo "# DNS is not restricted to udp, if the udp package is to big it will retry on tcp." >> /etc/ufw/personal-script
    if [ "${DNS_MANUAL}" = "yes" ]
    then 
	echo "ufw allow out to any port 53 comment 'Allow out to (manual) DNS (port 53)'" >> /etc/ufw/personal-script
    else
	for setdns in $NAMESERVERARRAY; do 
	    COUNTER=$((COUNTER +1))
	    echo "ufw allow out to ${setdns} port 53 comment 'Allow out to (detected from resolv.conf) DNS-${COUNTER} (port 53)'" >> /etc/ufw/personal-script
	done
    fi
    # 
    # NTP: Get the DC hostnames, get the ip numbers and use ip in the firewall rules.
    Get_DomainControlerNames
    for setntp in $DCS_ARRAY_NAMES; do 
        # The assigned ports list includes 123/tcp as NTP as well as 123/udp but the tcp port is not used by ntpd)
        HOSTIP=$(host $setntp | awk '{ print $NF }')
	echo "ufw allow out to ${HOSTIP} port 123 comment 'Allow out to (detected from script, AD-DC) NTP (port 123)'" >> /etc/ufw/personal-script
    done
    for setdcs in $DCS_ARRAY_NAMES; do
        # The assigned ports needed to query the DC, kerberos ldap ldaps GlobalCatalog ports.
        HOSTIP=$(host $setdcs | awk '{ print $NF }')
        # AD DC DNS.
        echo "ufw allow out to ${HOSTIP} port 53 comment 'Allow out to ADDC-DNS-${COUNTER} (port 53)'" >> /etc/ufw/personal-script
        # Kerberos
        echo "ufw allow out to ${HOSTIP} port 88 comment 'Allow out to (detected from script, AD-DC) Kerberos (port 88)'" >> /etc/ufw/personal-script
        echo "ufw allow out to ${HOSTIP} port 464 comment 'Allow out to (detected from script, AD-DC) Kerberos kpasswd (port 464)'" >> /etc/ufw/personal-script
        # Ldap(s)
        echo "ufw allow out to ${HOSTIP} port 389 comment 'Allow out to (detected from script, AD-DC) LDAP (port 389)'" >> /etc/ufw/personal-script
        echo "ufw allow out to ${HOSTIP} port 636 comment 'Allow out to (detected from script, AD-DC) LDAPS (port 636)'" >> /etc/ufw/personal-script
        # Global Catalog
        echo "ufw allow out to ${HOSTIP} port 3268 comment 'Allow out to (detected from script, AD-DC) GC (non-ssl) (port 3268)'" >> /etc/ufw/personal-script
        echo "ufw allow out to ${HOSTIP} port 3269 comment 'Allow out to (detected from script, AD-DC) GC (ssl) (port 3269)'" >> /etc/ufw/personal-script
        # Samba/SMB/CIFS... etc.
        echo "ufw allow out to ${HOSTIP} proto tcp port 135 comment 'Allow out to (detected from script, AD-DC) DCE/RPC Locator Service (port 135/tcp)'" >> /etc/ufw/personal-script
        echo "ufw allow out to ${HOSTIP} proto udp port 137 comment 'Allow out to (detected from script, AD-DC) NetBIOS Name Service (port 137/udp)'" >> /etc/ufw/personal-script
        echo "ufw allow out to ${HOSTIP} proto udp port 138 comment 'Allow out to (detected from script, AD-DC) NetBIOS Datagram (port 138/udp)'" >> /etc/ufw/personal-script
        echo "ufw allow out to ${HOSTIP} proto tcp port 139 comment 'Allow out to (detected from script, AD-DC) NetBIOS Session (port 139/tcp)'" >> /etc/ufw/personal-script
        echo "ufw allow out to ${HOSTIP} proto tcp port 445 comment 'Allow out to (detected from script, AD-DC) SMB over TCP (port 445/tcp)'" >> /etc/ufw/personal-script
        echo "ufw allow out to ${HOSTIP} proto tcp port 49152:65535 comment 'Allow out to (detected from script, AD-DC) Dynamic RPC Ports (port 49152:65535/tcp)'" >> /etc/ufw/personal-script
	echo "ufw allow in on eth0 proto tcp from ${HOSTIP} port 445 to ${THIS_SERVER_IP} port 49152:65535 comment 'Allow in to (detected from script, AD-DC) Dynamic RPC Ports (port 49152:65535/tcp)'" >> /etc/ufw/personal-script
    done
    # MX: Get the MX names within you LAN and allow OUT to these ipnumbers.
    # Asumption: this is a "mail relay" host.  (Internet < port 25 >  This_Host <port 25> Internal mail server.)
    Get_DomainMXserver
    for setMX in $MX_ARRAY_NAMES; do
        MXIP=$(host $setMX | awk '{ print $NF }')
	echo "ufw allow out on eth0 to ${MXIP} proto tcp port 25 comment 'Allow out to (detected from script, MAIL) LAN MX (port 25/tcp)'" >> /etc/ufw/personal-script
    done
    echo "## ALLOW-OUT: Some needed rules to make apt-get update work for example." >> /etc/ufw/personal-script
    echo "# Ftp/http/https" >> /etc/ufw/personal-script
    echo "ufw allow out 21,80,443/tcp comment 'Allow out ftp/http/https (21,80,443/tcp)'" >> /etc/ufw/personal-script
    echo "# Allow whois" >> /etc/ufw/personal-script
    echo "ufw allow out 43/tcp comment 'Allow out whois to any (43/tcp)'" >> /etc/ufw/personal-script
    echo "# Allow Spammassin Razor/Pyzor/DCC." >> /etc/ufw/personal-script
    echo "ufw allow out from any to any proto tcp port 2703 comment 'Allow out Spammassassin/Razor (dport 2703/tcp)'"  >> /etc/ufw/personal-script
    echo "ufw allow out from any proto tcp port 7 to any comment 'Allow out Spammassassin/Razor (sport 7/tcp)'"  >> /etc/ufw/personal-script
    echo "ufw allow out from any to any proto any port 24441 comment 'Allow out Spammassassin/Pyzor (dport 24441)'"  >> /etc/ufw/personal-script
    echo "ufw allow out from any proto udp port 6277 to any comment 'Allow out Spammassassin/DCC (sport 6277/udp)'"  >> /etc/ufw/personal-script
    echo "# Allow Clamav-unofficial Sigs (rsync (873/tcp)/curl443/tcp)" >> /etc/ufw/personal-script
    echo "ufw allow out from any to any proto tcp port 873 comment 'Allow out Rsync-Clamav-unofficial-sigs (dport 873/tcp)'"  >> /etc/ufw/personal-script
    echo " " >> /etc/ufw/personal-script
    echo "# Allow Out, restriced/lan only."  >> /etc/ufw/personal-script
    echo "# Ssh"  >> /etc/ufw/personal-script
    echo "ufw allow out on eth0 from any to ${LAN_RANGE} proto tcp port 22 comment 'Limit SSH To RTD lan (22/tcp)'" >> /etc/ufw/personal-script
    echo "# NFS"  >> /etc/ufw/personal-script
    echo "ufw allow out from any to ${LAN_RANGE} port 111 comment 'Allow out NFS to RTD lan (111)'"  >> /etc/ufw/personal-script
    echo "ufw allow out from any to ${LAN_RANGE} port 2049 comment 'Allow out NFS to RTD lan (2049)'"  >> /etc/ufw/personal-script
    echo "# MYSQL/MariaDB" >> /etc/ufw/personal-script
    echo "# Allow MySQL/MariaDB to mail server, for shared spamassassin/bayes database, hosted on mail server." >> /etc/ufw/personal-script
    echo "#ufw allow out on eth0 from any to Add_Your_SQL_IP_Here proto tcp port 3306 comment 'Allow out MySql/MariaDB (port 3306/tcp)'"  >> /etc/ufw/personal-script
    echo "# Samba"  >> /etc/ufw/personal-script
    echo "ufw allow out on eth0 from any to ${LAN_RANGE} proto tcp port 135 comment 'Allow out to (detected from script, AD-DC) DCE/RPC Locator Service (port 135/tcp)'" >> /etc/ufw/personal-script
    echo "ufw allow out on eth0 from any to ${LAN_RANGE} proto udp port 137 comment 'Allow out to (detected from script, AD-DC) NetBIOS Name Service (port 137/udp)'" >> /etc/ufw/personal-script
    echo "ufw allow out on eth0 from any to ${LAN_RANGE} proto udp port 138 comment 'Allow out to (detected from script, AD-DC) NetBIOS Datagram (port 138/udp)'" >> /etc/ufw/personal-script
    echo "ufw allow out on eth0 from any to ${LAN_RANGE} proto tcp port 139 comment 'Allow out to (detected from script, AD-DC) NetBIOS Session (port 139/tcp)'" >> /etc/ufw/personal-script
    echo "ufw allow out on eth0 from any to ${LAN_RANGE} proto tcp port 445 comment 'Allow out to (detected from script, AD-DC) SMB over TCP (port 445/tcp)'" >> /etc/ufw/personal-script
    echo " " >> /etc/ufw/personal-script
    echo "## ALLOW IN"  >> /etc/ufw/personal-script
    echo "# Web server settings"  >> /etc/ufw/personal-script
    echo "ufw allow in on eth0 from any to any port 80 comment 'Allow in on eth0 to Web ports ( 80/tcp)'" >> /etc/ufw/personal-script
    echo "ufw allow in on eth0 from any to any port 443 comment 'Allow in on eth0 to Web ports ( 443/tcp)'" >> /etc/ufw/personal-script
    echo "# Proxy (squid)" >> /etc/ufw/personal-script
    echo "#ufw allow in on eth0 from any to any port 3128 comment 'Allow in on eth0 to Squid (port 3128/tcp)'" >> /etc/ufw/personal-script
    echo "#or use : ufw allow in on eth0 from any to any app Squid" >> /etc/ufw/personal-script
    echo "#ufw allow in on eth0 proto tcp from any to any port 80,443 comment 'Allow in webtraffic (port 80,443/tcp)'"  >> /etc/ufw/personal-script
    echo "#ufw allow in on eth0 proto tcp from any to any port 3128,8080 comment 'Allow in webtraffic Proxy (port 3128,8080/tcp)'"  >> /etc/ufw/personal-script
    echo "#ufw allow in on eth0 proto tcp from any to any port 3129 comment 'Allow in SSL webtraffic redirect to Proxy (port 3128,8080/tcp)'"  >> /etc/ufw/personal-script
    echo "# Spamassassin (Pyzor/DCC)" >> /etc/ufw/personal-script
    echo "ufw allow in from any port 24441 comment 'Allow in Spammassassin/Pyzor (port 24441)'"  >> /etc/ufw/personal-script
    echo "ufw allow in from any proto udp port 6277 to any comment 'Allow in Spammassassin/DCC (sport 6277/udp)'"  >> /etc/ufw/personal-script
    echo " " >> /etc/ufw/personal-script
    echo " " >> /etc/ufw/personal-script
    echo "#    # mail settings (Kopano)"  >> /etc/ufw/personal-script
    echo "#    ufw allow in 236/tcp comment 'Allow in Kopano insecure (236/tcp)'"  >> /etc/ufw/personal-script
    echo "#    ufw allow in 237/tcp comment 'Allow in Kopano secure (237/tcp)'"  >> /etc/ufw/personal-script
    echo "#    # Generic mail settings"  >> /etc/ufw/personal-script
    echo "#    ufw allow in Postfix comment 'Allow in Postfix (25/tcp)'"  >> /etc/ufw/personal-script
    echo "#    ufw allow in POP3 comment 'Allow in pop insecure (110/tcp)'"  >> /etc/ufw/personal-script
    echo "#    ufw allow in POP3S comment 'Allow in pop secure (995/tcp)'"  >> /etc/ufw/personal-script
    echo "#    ufw allow in IMAP comment 'Allow in imap insecure (143/tcp)'"  >> /etc/ufw/personal-script
    echo "#    ufw allow in IMAPS comment 'Allow in imaps secure (993/tcp)'"  >> /etc/ufw/personal-script
    echo " " >> /etc/ufw/personal-script
    echo "# Lan related settings last, add your own here."  >> /etc/ufw/personal-script
    echo "#    ufw allow 25,587,465/tcp comment 'Allow in, mailservers, (25,587,465/tcp)'" >> /etc/ufw/personal-script
#
#### UFW FIREWALL SETTINGS ENDS HERE

else
    echo "file: /etc/ufw/personal-script already exist, not changing anything."
    echo "type: bash /etc/ufw/personal-script to enable all new rules."
fi

# remove variable leftovers.
unset setdns
unset setntp
unset setMX
}

## 

if [ "$1" == "reset" ]; then
    ufw --force reset
    if [ -e /etc/ufw/personal-script ]; then 
        cp /etc/ufw/personal-script{,.${RUNDATE}}
	rm /etc/ufw/personal-script
    fi
    ufw --force disable

    Ufw_create_personalscript
    sleep 0.1
    bash /etc/ufw/personal-script
    ufw --force enable
fi
if [ "$1" == "restart" ]; then
    ufw --force disable
    sleep 0.1
    ufw --force enable
fi
if [ "$1" == "reload" ]; then
    ufw --force reload
fi
if [ "$1" == "show" ]; then
    echo "Ufw by default does not show the order of rules, but here you go."
    ufw verbose numbered
fi
if [ "$1" == "ipv6" ]; then
    EnableDisableIPv6
    ufw --force reload
fi
if [ "$1" == "icmpout" ]; then
    EnablePingOutIPv4
    ufw --force reload
fi
if [ "$1" == "nosyslog" ]; then
    NoSysLog
fi

if [ "$1" == "test" ]; then
    # test your new functions here.
    Get_DomainMXserver
fi
