# How-to-Setup-UFW-Firewall-on-Debian

Install UFW Firewall on Debian

The UFW (Uncomplicated Firewall) should be installed by default in Ubuntu and Debian, if not, install it using the APT package manager using following command.

    sudo apt install ufw

Check UFW Firewall
Once the installation is completed you can check the status of UFW by typing.

    sudo ufw status verbose

On first install, the UFW firewall is disabled by default, the output will similar to below.

    Status: inactive

Enable UFW Firewall

You can activate or enable UFW firewall using the following command, which should load the firewall and enables it to start on boot.

    sudo ufw enable

To disable UFW firewall, use the following command, which unloads the firewall and disables it from starting on boot.

    sudo ufw disable 

UFW Default Policies

By default, the UFW firewall denies every incoming connections and only allow all outbound connections to server. This means, no one can access your server, unless you specifically open the port, while all the running services or applications on your server can be able to access the outside network.

The default UFW firewall polices are placed in the /etc/default/ufw file and can be altered using the following command.

    sudo ufw default deny incoming
    sudo ufw default allow outgoing

    sudo ufw disable
    sudo ufw enable

Allow SSH Connections on UFW

If you’ve enabled UFW firewall by now, it would block all incoming connections and if you are connected to your server over SSH from a remote location, you will no longer able to connect it again.

Let’s enable SSH connections to our server to stop that from happening using the following command:

    sudo ufw allow ssh

If you are using custom SSH port (for example port 2222), then you need to open that port on UFW firewall using the following command.

    sudo ufw allow 2222/tcp

To block all SSH connections type the following command.

    sudo ufw deny ssh/tcp
    sudo ufw deny 2222/tcp  [If using custom SSH port]

Enable Specific Ports on UFW

You can also open a specific port in the firewall to allow connections via it to a certain service. For example, if you want to setup a web server which listens on port 80 (HTTP) and 443 (HTTPS) by default.

Below are the few examples of how to allow incoming connections to Apache services.
Open Port 80 HTTP on UFW

    sudo ufw allow http     [By service name]
    sudo ufw allow 80/tcp   [By port number]
    sudo ufw allow 'Apache' [By application profile]

Open Port 443 HTTPS on UFW

    sudo ufw allow https
    sudo ufw allow 443/tcp
    sudo ufw allow 'Apache Secure'

Allow Port Ranges on UFW

Assuming you have some applications that you want to run on a range of ports (5000-5003), you can add all these ports using following commands.

    sudo ufw allow 5000:5003/tcp
    sudo ufw allow 5000:5003/udp

Allow Specific IP Addresses

If you want to allow connections on all ports from specific IP address 192.168.56.1, then you need to specify from before the IP address.

    sudo ufw allow from 192.168.56.1

Allow Specific IP Addresses on Specific Port

To allow connection on a specific port (for example port 22) from your home machine with IP address of 192.168.56.1, then you need to add any port and the port number after the IP address as shown.

    sudo ufw allow from 192.168.56.1 to any port 22

Allow Network Subnets to Specific Port

To allow connections for particular IP addresses ranging from 192.168.1.1 to 192.168.1.254 to port 22 (SSH), run the following command.

    sudo ufw allow from 192.168.1.0/24 to any port 22

Allow Specific Network Interface

To allow connections to specific network interface eth2 for a particular port 22 (SSH), run the following command.

    sudo ufw allow in on eth2 to any port 22

Deny Connections on UFW

By default, all incoming connections are blocked, unless you have specifically open the connection on UFW. For example, you have opened the ports 80 and 443 and your web server is under attack from the unknown network 11.12.13.0/24.

To block all connections from this particular 11.12.13.0/24 network range, you can use the following command.

    sudo ufw deny from 11.12.13.0/24

If you only want to block connections on ports 80 and 443, you can use the following commands.

    sudo ufw deny from 11.12.13.0/24 to any port 80
    sudo ufw deny from 11.12.13.0/24 to any port 443

Delete UFW Rules

There are 2 ways to delete UFW rules, by rule number and by actual rule.

To delete a UFW rules by using rule number, first you need to list rules by numbers using the following command.

    sudo ufw status numbered

Sample Output

    Status: active

     To                         Action      From
     --                         ------      ----
    [ 1] 22/tcp                     ALLOW IN    Anywhere
    [ 2] 80/tcp                     ALLOW IN    Anywhere

To delete rule number 1, use the following command.

    sudo ufw delete 1

The second method is to delete a rule by using the actual rule, for example to delete a rule, specify the port number with protocol as shown.

    sudo ufw delete allow 22/tcp

Dry Run UFW Rules

You can run any ufw commands without actually making any changes in the system firewall using the --dry-run flag, this simply shows the changes that where suppose to happen.

    sudo ufw --dry-run enable

Reset UFW Firewall

For one reason or the other, if you wish to delete / reset all firewall rules, type the following commands, it will revert all of your changes and start fresh.

    sudo ufw reset
    sudo ufw status

UFW Advanced Functionality

The UFW firewall can manage to do anything that iptables does. This can be done with different sets of rules files, which are nothing, but simple iptables-restore text files.

Tuning of UFW firewall or adding additional iptables commands are not permitted via ufw command, is a just matter of altering following text files

    /etc/default/ufw: The main configuration file with pre-defined rules.
    /etc/ufw/before[6].rules: In this file rules are calculated before adding via ufw command.
    /etc/ufw/after[6].rules: In this file rules are calculated after adding via ufw command.
    /etc/ufw/sysctl.conf: This file is used to tune kernel network.
    /etc/ufw/ufw.conf: This file enable the ufw on boot.

