#!/bin/bash

########################################################################
# File Name    : setup_php_env.sh
# Description  : This script sets up a PHP development environment
#                including Apache web server, PHP, MariaDB/MySQL, and
#                optional tools like phpMyAdmin, MySQL Workbench, and SQLMAP.
# Usage        : • Make the script executable with:
#                  sudo chmod +x setup_php_env.sh
#                • Run the script with:
#                  sudo bash setup_php_env.sh
# Author       : Me and the bois
# License      : Free of charge, no warranty
########################################################################

# Function to update package lists
update_package_lists() {
    echo "Updating package lists to ensure you get the latest versions of software..."
    sudo apt update
}

# Function to install Apache web server
install_apache() {
    echo "Installing Apache web server..."
    sudo apt install -y apache2
}

# Function to install PHP and necessary modules
install_php() {
    echo "Installing PHP and necessary modules..."
    sudo apt install -y php libapache2-mod-php php-mysql php-curl php-gd php-xml php-mbstring
}

# Function to install MariaDB/MySQL server
install_database_server() {
    # Prompt user to choose between MariaDB or MySQL
    read -p "Do you want to install MariaDB or MySQL? (m for MariaDB, y for MySQL): " db_choice
    if [ "$db_choice" = "m" ]; then
        echo "Installing MariaDB Server..."
        sudo apt install -y mariadb-server
    else
        echo "Installing MySQL Server..."
        sudo apt install -y mysql-server
    fi

    # Start database service
    sudo systemctl start mysql
    # Enable database to start on boot
    sudo systemctl enable mysql
}

# Function to install Composer (PHP dependency manager)
install_composer() {
    echo "Installing Composer..."
    # Download and install Composer
    EXPECTED_SIGNATURE=$(curl -s https://composer.github.io/installer.sig)
    sudo php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    ACTUAL_SIGNATURE=$(php -r "echo hash_file('sha384', 'composer-setup.php');")
    
    # Verify Composer installer integrity
    if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ]; then
        >&2 echo 'ERROR: Invalid installer signature'
        sudo rm composer-setup.php
        exit 1
    fi
    
    # Install Composer globally
    sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
    
    # Clean up Composer installer
    sudo rm composer-setup.php
}

# Function to enable Apache modules
enable_apache_modules() {
    echo "Enabling Apache modules..."
    sudo a2enmod rewrite
    sudo systemctl restart apache2
}

# Function to install phpMyAdmin
install_phpmyadmin() {
    echo "Installing phpMyAdmin..."
    sudo apt install -y phpmyadmin
    # Enable mbstring PHP extension for phpMyAdmin
    sudo phpenmod mbstring
    sudo systemctl restart apache2
}

# Function to install MySQL Workbench
install_mysql_workbench() {
    echo "Installing MySQL Workbench..."
    sudo apt install -y mysql-workbench
}

# Function to install SQLMAP
install_sqlmap() {
    echo "Installing SQLMAP..."
    sudo apt install -y sqlmap
}

# Main script execution
echo "Setting up LAMP stack for PHP development..."

update_package_lists
install_apache
install_php
install_database_server
install_composer
enable_apache_modules

echo "LAMP stack installation completed successfully!"

# Prompt user for optional installations
echo
read -p "Do you want to install additional tools for PHP development? (phpMyAdmin, MySQL Workbench, SQLMAP) (y/n): " install_optional_tools

if [ "$install_optional_tools" = "y" ]; then
    echo "Installing additional tools..."
    
    read -p "Do you want to install phpMyAdmin? (y/n): " install_phpmyadmin
    if [ "$install_phpmyadmin" = "y" ]; then
        install_phpmyadmin
    fi

    read -p "Do you want to install MySQL Workbench? (y/n): " install_workbench
    if [ "$install_workbench" = "y" ]; then
        install_mysql_workbench
    fi

    read -p "Do you want to install SQLMAP? (y/n): " install_sqlmap
    if [ "$install_sqlmap" = "y" ]; then
        install_sqlmap
    fi
else
    echo "Skipping installation of additional tools."
fi

# References for PHP development
echo
echo "### References for PHP Development ###"
echo "- PHP: https://www.php.net/"
echo "- Apache HTTP Server: https://httpd.apache.org/"
echo "- MariaDB: https://mariadb.org/ (or MySQL: https://www.mysql.com/)"
echo "- Composer: https://getcomposer.org/"
echo "- phpMyAdmin: https://www.phpmyadmin.net/"
echo "- MySQL Workbench: https://www.mysql.com/products/workbench/"
echo "- SQLMAP: https://github.com/sqlmapproject/sqlmap"
echo "###########################################"
