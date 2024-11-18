# Change-Default-Network-Name-ens33-to-eth0

Disable Consistent Interface Device Naming

Install development tools on Debian

The development tools packages are available under default apt repositories for most of the Debian based systems. The build-essential package includes all the packages as dependencies required for the development tools. You can simply install build-essential on Debian Linux.

sudo apt update
sudo apt install build-essential


To regain the ethX back, edit the grub file.

sudo nano /etc/default/grub

Look for GRUB_CMDLINE_LINUX line and add net.ifnames=0 biosdevname=0.

FROM:

GRUB_CMDLINE_LINUX=""

TO:

GRUB_CMDLINE_LINUX="net.ifnames=0 biosdevname=0"

sudo grub-mkconfig -o /boot/grub/grub.cfg

sudo reboot


