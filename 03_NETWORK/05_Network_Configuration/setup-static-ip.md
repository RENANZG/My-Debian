Assign Static IP Address

Edit the network configuration file by running the following command.
    sudo cp /etc/network/interfaces /etc/network/interfaces.backup 
    sudo nano /etc/network/interfaces

This file may look like the following.

Edit the configuration as follows.

# The loopback network interface
    auto lo
    iface lo inet loopback

# The primary network interface
    allow-hotplug eth0
    #iface ens32 inet dhcp
    auto eth0
    iface eth0 inet static
           address 192.168.233.167
           netmask 255.255.255.0
           dns-nameservers 8.8.8.8 8.8.4.4
           gateway 192.168.233.2
           
           
# Make sure not to change the loopback adapter config. After the change, it will look something like the following screenshot.

Save the file and exit from the editor.
Step 5: Restart Networking Service

Restart the networking service so that the updated configuration can be applied. Run the command.

     sudo systemctl restart networking
