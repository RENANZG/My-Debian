#!/bin/bash

# Basic environment for php developers on Debian GNU/Linux

set -e
clear

if [[ $UID -ne 0 ]]; then
	echo "You need to be root"
	sleep 1
	exit
fi

#
echo -e "$Updating and upgrading to start auto-setup script"; $r
sudo apt update && sudo apt upgrade -y

#Installing curl and wget
echo -e "${c}Installing Curl and wget"; $r
sudo apt-get install -y wget curl

#Setting up Git
echo -e "Git"

read -p "${y}Do you want to setup Git global config? (y/n): " -r; $r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
	echo -e "${c}Setting up global git config at ~/.gitconfig"; $r
	git config --global color.ui true
	read -p "Enter Your Full Name: " name
	read -p "Enter Your Email: " email
	git config --global user.name "$name"
	git config --global user.email "$email"
	echo -e "${c}Git Setup Successfully!"; $r
else
	echo -e "${c}Skipping!"; $r && :
fi

#
echo -e "NeoVim"

#
echo -e "Lamp+phpmyadmin"

#
echo -e "Mysql Workbench SQLMAP"

#
echo -e "$Updating and upgrading to finish auto-setup script"; $r
sudo apt update && sudo apt upgrade -y
