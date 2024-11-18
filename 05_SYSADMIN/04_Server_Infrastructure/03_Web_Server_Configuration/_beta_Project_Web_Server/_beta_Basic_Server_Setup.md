<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>A Comprehensive Guide for Setting Up a Debian Server</title>
<style>
       body {
            font-family: Arial, sans-serif;
            line-height: 1.6;
            margin: 20px;
            background-color: #f5f5f5;
        }
        h1 {
            text-align: center;
            color: #000000;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: center;
        }
        th {
            background-color: #f9f9f9;
            color: #000000;
        }
        tr:nth-child(even) {
            background-color: #f2f2f2;
        }
        a {
            color: #0056b3;
            text-decoration: none;
        }
</style>
</head>
<body>

<h1>A Comprehensive Guide for Setting Up a Debian Server</h1>

<h3>1. Initial System Setup</h3>
<p>Before you start, ensure that your Debian server is fully updated to have the latest security patches and software updates.</p>
<pre>
sudo apt update && sudo apt upgrade -y
sudo apt autoremove -y && sudo apt autoclean
</pre>

<h3>2. Configure Time Zone and Locale</h3>
<p>Set the correct time zone and locale settings to ensure accurate timestamps and proper locale configurations.</p>
<pre>
sudo dpkg-reconfigure tzdata
sudo dpkg-reconfigure locales
</pre>

<h3>3. Install Essential Packages</h3>
<p>Install essential tools and utilities that are commonly used for server management and security.</p>
<pre>
sudo apt install -y curl vim git net-tools ufw htop
</pre>

<h3>4. Secure SSH Access</h3>
<p>Change the default SSH port and secure your SSH access to prevent unauthorized access.</p>
<pre>
sudo nano /etc/ssh/sshd_config
# Change Port 22 to a non-standard port (e.g., Port 2200)
# Disable root login
PermitRootLogin no
# Restart SSH service
sudo systemctl reload sshd
</pre>

<h3>5. Set Up a Firewall</h3>
<p>Configure UFW (Uncomplicated Firewall) to allow only necessary traffic and improve security.</p>
<pre>
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 2200/tcp  # Replace 2200 with your custom SSH port
sudo ufw allow 80/tcp   # HTTP
sudo ufw allow 443/tcp  # HTTPS
sudo ufw enable
sudo ufw status verbose
</pre>

<h3>6. Install Fail2Ban</h3>
<p>Install Fail2Ban to protect your server from brute-force attacks.</p>
<pre>
sudo apt install -y fail2ban
sudo systemctl enable fail2ban
</pre>

<h3>7. Set Up a SWAP File</h3>
<p>Create and configure a SWAP file to improve system performance and manage memory usage.</p>
<pre>
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo cp /etc/fstab /etc/fstab.bak
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
sudo sysctl vm.swappiness=10
echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf
</pre>

<h3>8. Install and Configure Nginx</h3>
<p>Install Nginx as your web server and configure it for optimal performance and security.</p>
<pre>
sudo apt install -y nginx
sudo systemctl enable nginx
sudo systemctl start nginx
# Set up a basic configuration in /etc/nginx/sites-available/default
sudo nano /etc/nginx/sites-available/default
# Ensure server block includes:
# listen 80;
# server_name example.com;
# root /var/www/html;
# Restart Nginx to apply changes
sudo systemctl restart nginx
</pre>

<h3>9. Obtain and Configure SSL Certificates</h3>
<p>Use Certbot to obtain SSL certificates and configure HTTPS for secure communication.</p>
<pre>
sudo apt install -y certbot python3-certbot-nginx
sudo certbot --nginx -d example.com -d www.example.com
# Follow prompts to configure SSL
</pre>

<h3>10. Set Up Automated Backups</h3>
<p>Automate backups to ensure data integrity and recovery options.</p>
<pre>
# Install rsync for backups
sudo apt install -y rsync
# Create a backup script (e.g., /usr/local/bin/backup.sh)
sudo nano /usr/local/bin/backup.sh
# Example script content:
# #!/bin/bash
# rsync -avz /var/www/html /backup/
# Make the script executable
sudo chmod +x /usr/local/bin/backup.sh
# Set up a cron job to run the backup script daily
sudo crontab -e
# Add the following line to the crontab:
# 0 2 * * * /usr/local/bin/backup.sh
</pre>

<h3>11. Monitor Server Performance</h3>
<p>Install monitoring tools to keep track of server performance and resource usage.</p>
<pre>
sudo apt install -y sysstat
# Set up basic monitoring
sudo nano /etc/default/sysstat
# Set ENABLED="true"
sudo systemctl restart sysstat
</pre>

<h3>12. Install and Configure Additional Services</h3>
<p>Based on your specific needs, you might want to install additional services such as databases, application servers, etc.</p>
<pre>
# Example for installing and securing MySQL
sudo apt install -y mysql-server
sudo mysql_secure_installation
</pre>

<h3>13. Regular Maintenance and Updates</h3>
<p>Regularly update your system and review logs to ensure smooth operation and security.</p>
<pre>
sudo apt update && sudo apt upgrade -y
sudo apt autoremove -y
# Check system logs for any issues
journalctl -p err
</pre>

<h3>14. Useful Commands</h3>
<p>Here are some additional commands that might be useful for server management.</p>
<pre>
netstat -tulnp   # List listening ports and associated processes
df -h            # Check disk usage
free -h           # Check memory usage
uptime            # Check system uptime and load
</pre>

</body>
</html>
