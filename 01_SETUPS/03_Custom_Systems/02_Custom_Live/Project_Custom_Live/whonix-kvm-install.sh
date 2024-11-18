#!/usr/bin/env bash

########################################################################
# CREDITS: https://github.com/brunodupim08
# Download the files to KVM from the WHONIX website.
# Do not extract the files, he will do everything alone: 
# Make sure the “whonix-kvm-install-script.sh” has executable
# and run the script at the same location as the Whonix kvm
# compacted file downloaded: 
# $ sudo chmod +x whonix-kvm-install-script.sh
# $ sudo bash ./whonix-kvm-install-script.sh
########################################################################

version='1.1'

# Check if the user has UID 0 (root)
if [ "$EUID" -ne 0 ]; then
    echo -e "\n#### Error: This script must be run as root. ####\n"
    exit 1
fi


extract(){
    echo -e "\n#### Extract ####"
    
    # Find the Whonix archives
    whonix_archives=(Whonix*.libvirt.xz)

    # Check if any Whonix archive exists
    if [ ${#whonix_archives[@]} -eq 0 ]; then
        echo "Error: No Whonix archive (*.libvirt.xz) found in this directory."
        exit 2
    # If there are multiple archives, prompt the user to choose one
    elif [ ${#whonix_archives[@]} -gt 1 ]; then
        echo "Multiple Whonix archives found:"
        select chosen_archive in "${whonix_archives[@]}"; do
            if [ -n "$chosen_archive" ]; then
                break
            fi
        done
    else
        chosen_archive="${whonix_archives[0]}"
    fi

    # Remove the whonix-install directory if it exists
    if [ -d "/tmp/whonix-install" ]; then
        rm -rf "/tmp/whonix-install"
    fi

    # Create whonix-install directory
    mkdir -p /tmp/whonix-install
    # Extract the chosen file from the archive into whonix-install directory
    tar -xvf "$chosen_archive" -C /tmp/whonix-install 2>/dev/null || { echo "Error: Failed to extract the chosen archive."; exit 3; }

}

import_networks(){
    echo -e "\n#### Import Networks ####"
    
    # Check if the networks and domains exist and prompt for replacement
    networks_to_remove=()
    virsh net-list --name | grep -q -w "Whonix-External" && networks_to_remove+=("Whonix-External")
    virsh net-list --name | grep -q -w "Whonix-Internal" && networks_to_remove+=("Whonix-Internal")

    if [ ${#networks_to_remove[@]} -gt 0 ]; then
        read -rp "The following networks already exist: ${networks_to_remove[*]}. Do you want to replace them? (y/n): " answer
        if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
            for net_name in "${networks_to_remove[@]}"; do
                virsh net-destroy "$net_name" >/dev/null 2>&1 && echo "Network '$net_name' destroyed."
                virsh net-undefine "$net_name" >/dev/null 2>&1 && echo "Network '$net_name' undefined."
            done
        fi
    fi

    # info virbr number. 
    echo -e "\n###############\n# Attention ! #\n###############\n\nCheck in virtual networks which virbr devices are already in use, if you use a virbr in use an error may occur.\n"

    # Ask the user which number to use for virbr1 and virbr2
    read -rp "Enter the number to use for virbr Whonix-External (default: 1): " number_virbr1
    number_virbr1=${number_virbr1:-1}
    read -rp "Enter the number to use for virbr Whonix-Internal (default: 2): " number_virbr2
    number_virbr2=${number_virbr2:-2}

    # Update the XML files with the chosen bridge names
    sed -i 's/\bvirbr1\b/virbr'"$number_virbr1"'/g' Whonix_external*.xml
    sed -i 's/\bvirbr2\b/virbr'"$number_virbr2"'/g' Whonix_internal*.xml

    # Add to virtual networks.
    virsh net-define Whonix_external*.xml >/dev/null 2>&1 && echo "Whonix-External network defined."
    virsh net-define Whonix_internal*.xml >/dev/null 2>&1 && echo "Whonix-Internal network defined."

    # Activate the virtual networks.
    virsh net-autostart Whonix-External >/dev/null 2>&1 && echo "Whonix-External network marked as auto-started."
    virsh net-start Whonix-External >/dev/null 2>&1 && echo "Whonix-External network started."
    virsh net-autostart Whonix-Internal >/dev/null 2>&1 && echo "Whonix-Internal network marked as auto-started."
    virsh net-start Whonix-Internal >/dev/null 2>&1 && echo "Whonix-Internal network started."
}

import_images() {
    echo -e "\n#### Import Images ####"
    
    # Check if the VM images exist and prompt for removal
    images_to_remove=()
    for vm_name in "Whonix-Gateway" "Whonix-Workstation"; do
        if virsh dominfo "$vm_name" &>/dev/null; then
            images_to_remove+=("$vm_name")
        fi
    done

    if [ ${#images_to_remove[@]} -gt 0 ]; then
        while true; do
            read -rp "The following VM images already exist: ${images_to_remove[*]}. Do you want to remove them? (y/n): " answer
            case $answer in
                [Yy])
                    for vm_name in "${images_to_remove[@]}"; do
                        if virsh domstate "$vm_name" | grep -q "running"; then
                            virsh destroy "$vm_name" >/dev/null 2>&1 && echo "Domain '$vm_name' has been destroyed."
                        fi
                        virsh undefine "$vm_name" >/dev/null 2>&1 && echo "Domain '$vm_name' has been undefined."
                        rm -f "/var/lib/libvirt/images/$vm_name.qcow2" >/dev/null 2>&1 && echo "Image '/var/lib/libvirt/images/$vm_name.qcow2' removed."
                    done
                    break
                    ;;
                [Nn])
                    break
                    ;;
                *)
                    echo "Invalid choice. Please enter 'y' or 'n'."
                    ;;
            esac
        done
    fi
    
    # Move the images to /var/lib/libvirt/images/ with new name.
    mv Whonix-Gateway*.qcow2 /var/lib/libvirt/images/Whonix-Gateway.qcow2 >/dev/null 2>&1
    mv Whonix-Workstation*.qcow2 /var/lib/libvirt/images/Whonix-Workstation.qcow2 >/dev/null 2>&1
    # Import the Whonix ™ Gateway and Workstation images.
    virsh define Whonix-Gateway*.xml >/dev/null 2>&1 && echo "Domain 'Whonix-Gateway' defined from Whonix-Gateway-Xfce-17.0.3.0.xml."
    virsh define Whonix-Workstation*.xml >/dev/null 2>&1 && echo "Domain 'Whonix-Workstation' defined from Whonix-Workstation-Xfce-17.0.3.0.xml."
}

logo() {
    echo '
     ___       __    ___  ___   ________   ________    ___      ___    ___ 
    |\  \     |\  \ |\  \|\  \ |\   __  \ |\   ___  \ |\  \    |\  \  /  /|
    \ \  \    \ \  \\ \  \\\  \\ \  \|\  \\ \  \\ \  \\ \  \   \ \  \/  / /
     \ \  \  __\ \  \\ \   __  \\ \  \\\  \\ \  \\ \  \\ \  \   \ \    / / 
      \ \  \|\__\_\  \\ \  \ \  \\ \  \\\  \\ \  \\ \  \\ \  \   /     \/  
       \ \____________\\ \__\ \__\\ \_______\\ \__\\ \__\\ \__\ /  /\   \ 
        \|____________| \|__|\|__| \|_______| \|__| \|__| \|__|/__/ /\ __\
                                                               |__|/ \|__|
    Whonix KVM Install Script'
    echo -e "    version: $version\n    Altor: https://github.com/brunodupim08\n"
}

#--------------------- Run -------------------#
logo
extract
# Enter the whonix-install directory
cd /tmp/whonix-install || exit 4
import_networks
import_images
# Return to the original directory
cd ..
# Remove the whonix-install directory
rm -rf whonix-install
echo -e "\n#### Whonix setup completed successfully. ####\n"
exit 0
