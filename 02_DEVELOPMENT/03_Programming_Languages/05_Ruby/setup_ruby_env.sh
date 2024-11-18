#!/bin/bash

########################################################################
# File Name    : setup_ruby_env.sh
# Description  : This script sets up a basic Ruby development environment.
# Usage        : • Make the script executable with:
#                  sudo chmod +x setup_ruby_env.sh
#                • Run the script with:
#                  sudo bash setup_ruby_env.sh
# Author       : Me and the bois
# License      : Free of charge, no warranty
########################################################################

# Print a message indicating the start of the installation process
echo "Installing basic environment for Ruby development..."

# Update package lists to ensure you get the latest versions of software
echo "Updating package lists..."
sudo apt update

# Install Ruby using APT (system package manager)
echo "Installing Ruby..."
sudo apt install -y ruby-full
# ruby-full includes the full Ruby interpreter and essential libraries

# Verify installation by displaying Ruby version
echo "Verifying Ruby installation..."
ruby --version

# Install RubyGems (Ruby package manager)
echo "Installing RubyGems (Ruby package manager)..."
sudo apt install -y rubygems
# RubyGems is used for installing Ruby libraries and applications

# Install Bundler (Ruby dependency manager)
echo "Installing Bundler (Ruby dependency manager)..."
sudo gem install bundler
# Bundler manages Ruby application dependencies and ensures consistent versions

# Optional: Install additional Ruby tools or libraries as needed
# Example: Install Rails (Ruby on Rails web application framework)
# echo "Installing Ruby on Rails (web application framework)..."
# sudo gem install rails

# Optional: Install SQLite (if using Rails or other applications needing a database)
# echo "Installing SQLite (simple and lightweight database)..."
# sudo apt install -y sqlite3 libsqlite3-dev

# Provide completion message indicating successful installation
echo "Installation completed successfully!"

# References for Ruby development
echo
echo "### References for Ruby Development ###"
echo "- Ruby Programming Language: https://www.ruby-lang.org"
echo "- RubyGems (Ruby package manager): https://rubygems.org"
echo "- Bundler (Ruby dependency manager): https://bundler.io"
echo "#########################################"
