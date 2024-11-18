# Shorewall
# Secure your VPS with Shorewall(Firewall for Linux)
# My Suggestion: Open this tutorial in as raw file

# First Install Shorewall 
sudo apt-get install shorewall -y

nano -w /etc/default/shorewall

Change

startup = 0
to
startup = 1

save, and exit.

# Setting Shorewall

The program will not start unless you change the shorewall configuration file /etc/shorewall/shorewall.conf .
You can do this in following way:
nano /etc/shorewall/shorewall.conf

Change the first line from

STARTUP_ENABLED=No
to
STARTUP_ENABLED=Yes

Save and Exit


# Turning on Forwarding

Finally we get to the last necessary file, /etc/shorewall/shorewall.conf. 
This file manages global shorewall options, and you should read it through completely.
nano -w /etc/shorewall/shorewall.conf

We need to find the section of the file that talks about "IP_FORWARDING" and change it from "Off" to "On". 
If you don't, your packets won't be able to get from one interface to the other.

IP_FORWARDING=On

Save and Exit



# Checking Your Configs and Starting Shorewall
shorewall check

# Starting Firewall
systemctl start shorewall

# Enabling service of shorewall firewall
systemctl enable shorewall

For example you have eth0 as your network device (usualy)
Next create or edit sudo nano /etc/shorewall/interfaces
#add this lines 
 
#ZONE   INTERFACE       BROADCAST       OPTIONS
net     eth0            detect          tcpflags,logmartians,nosmurfs
#LAST LINE -- ADD YOUR ENTRIES BEFORE THIS ONE -- DO NOT REMOVE

Save and Exit


# Next create or edit sudo nano /etc/shorewall/policy 
#add this lines

#SOURCE		DEST		POLICY		LOG LEVEL	LIMIT:BURST
fw              all             ACCEPT
net             all             DROP            info
 
#The FOLLOWING POLICY MUST BE LAST
all             all             REJECT          info
#LAST LINE -- ADD YOUR ENTRIES ABOVE THIS LINE -- DO NOT REMOVE

Save and Exit

# Next create or edit sudo nano /etc/shorewall/zones
#add this lines

#ZONE   TYPE    OPTIONS                 IN                      OUT
#                                       OPTIONS                 OPTIONS
fw      firewall
net     ipv4

Save and Exit


# Next create or edit sudo nano /etc/shorewall/rules 
#add this lines

#Forward all ssh and http connection requests from the internet to local system 192.168.1.123
#ACTION SOURCE  DEST            PROTO   DEST    SOURCE  ORIGINAL
#                                       PORT    PORT(S) DEST
ACCEPT  net     $FW:192.168.1.123 tcp   80,443
Ping(DROP)      net               $FW

#LAST LINE -- ADD YOUR ENTRIES BEFORE THIS ONE -- DO NOT REMOVE

Save and Exit


# Checking Your Configs and Starting Shorewall
shorewall check

# ReStarting Firewall
systemctl restart shorewall

# Enabling service of shorewall firewall
systemctl enable shorewall


All done with shorewall install and configuration tweaks!


