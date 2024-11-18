#!/bin/bash

echo "Installing complete environment for web development in HTML, PHP, and hidden services..."

# Update package lists
sudo apt update

# Install Apache web server
sudo apt install -y apache2

# Install PHP and necessary modules
sudo apt install -y php libapache2-mod-php php-mysql php-curl php-gd php-xml php-mbstring

# Install MySQL database server
sudo apt install -y mysql-server

# Secure MySQL installation (optional step)
sudo mysql_secure_installation

# Install Tor for setting up hidden services
sudo apt install -y tor

# Configure Tor hidden service for Apache
sudo cp /etc/tor/torrc /etc/tor/torrc.backup
echo "HiddenServiceDir /var/lib/tor/hidden_service/" | sudo tee -a /etc/tor/torrc
echo "HiddenServicePort 80 127.0.0.1:80" | sudo tee -a /etc/tor/torrc

# Restart Tor service
sudo systemctl restart tor

# Retrieve .onion address
echo "Your Tor hidden service address (onion address):"
sudo cat /var/lib/tor/hidden_service/hostname

echo "Installation completed successfully!"
