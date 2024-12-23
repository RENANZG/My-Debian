#!/usr/bin/env bash

version='2.0'
project='https://github.com/brunodupim08/Whonix-KVM-Install-Script.git'
author='brunodupim08'
path_extract=$(mktemp -d /tmp/whonix-kvm-install-script-extract-XXXXXXXXXXXXXXXXXXXXXXXXXXXX)
archives_to_extract=""



function check_archives_to_extract() {
    local filed_files=(Whonix*.libvirt.xz)
    
    # Check if any Whonix archive exists
    if [ ${#filed_files[@]} -eq 0 ]; then
        echo "Error: No Whonix archive (*.libvirt.xz) found in this directory."
        exit 2
    # If there are multiple archives, prompt the user to choose one
    elif [ ${#filed_files[@]} -gt 1 ]; then
        echo "Multiple Whonix archives found:"
        select archives_to_extract in "${filed_files[@]}"; do
            if [ -n "$archives_to_extract" ]; then
                break
            fi
        done
    else
        archives_to_extract="${filed_files[0]}"
    fi
}

function extract(){
    {
        echo -e "\n#### Extracting ####\n"
        # Extract the chosen file from the archive into whonix-install directory
        tar -xvf "$archives_to_extract" -C $path_extract 2>/dev/null || { echo "Error: Failed to extract the chosen archive."; cleanup; exit 3; }
    }
}

cleanup() {
    {
        # Remove the path extract
        rm -rf "$path_extract"
    }
}

function import_networks(){
    local used_virbr=()
    local networks=$(virsh net-list --all --name)
    local network number_virbr1 number_virbr2

    for network in $networks; do
        used_virbr+=($(virsh net-dumpxml "$network" | sed -n 's/.*<bridge name='\''virbr\([0-9]\+\)'\''.*/\1/p'))
    done
    # Inform the user about used bridge interface numbers
    if [ ${#used_virbr[@]} -gt 0 ]; then
        {
            echo -e "\nThe following virbr numbers are already in use: [ ${used_virbr[*]} ]"
        }
    fi
    # Ask the user which number to use for virbr1 and virbr2
    while true; do
        read -rp 'Enter the number to use for virbr Whonix-External: ' number_virbr1
        if [[ ! "$number_virbr1" =~ ^[0-9]+$ ]]; then
            continue
        # Check if the chosen number is already in use by existing networks
        elif [[ " ${used_virbr[@]} " =~ " $number_virbr1 " ]]; then
            echo "Error: virbr$number_virbr1 is already in use by an existing network."
            continue
        else
            break
        fi
    done
    while true; do
        read -rp 'Enter the number to use for virbr Whonix-Internal: ' number_virbr2
        # Check if the chosen number is already in use by existing networks or if it's the same as number_virbr1
        if [[ ! "$number_virbr2" =~ ^[0-9]+$ ]]; then
            continue
        elif [[ "$number_virbr2" == "$number_virbr1" ]]; then
            echo "Error: Whonix-Internal cannot be the same as Whonix-External."
            continue
        elif [[ " ${used_virbr[@]} " =~ " $number_virbr2 " ]]; then
            echo "Error: virbr$number_virbr2 is already in use by an existing network."
            continue
        else
            break
        fi
    done
    {
        echo -e "\n#### Importing Networks ####\n"
        # Update the XML files with the chosen bridge names
        sed -i 's/\bvirbr1\b/virbr'"$number_virbr1"'/g' Whonix_external*.xml
        sed -i 's/\bvirbr2\b/virbr'"$number_virbr2"'/g' Whonix_internal*.xml
        # Add to virtual networks.
        virsh net-define Whonix_external*.xml >/dev/null 2>&1 && echo "Whonix-External network defined."
        virsh net-define Whonix_internal*.xml >/dev/null 2>&1 && echo "Whonix-Internal network defined."
        # Activate the virtual networks.
        virsh net-autostart Whonix-External >/dev/null 2>&1 && echo "Whonix-External network marked as auto-started."
        virsh net-autostart Whonix-Internal >/dev/null 2>&1 && echo "Whonix-Internal network marked as auto-started."
        virsh net-start Whonix-External >/dev/null 2>&1 && echo "Whonix-External network started."
        virsh net-start Whonix-Internal >/dev/null 2>&1 && echo "Whonix-Internal network started."
    }
}

function import_images() { 
    {
        echo -e "\n#### Importing Images ####\n"
        # Move the images to /var/lib/libvirt/images/ with new name.
        mv Whonix-Gateway*.qcow2 /var/lib/libvirt/images/Whonix-Gateway.qcow2 >/dev/null 2>&1
        mv Whonix-Workstation*.qcow2 /var/lib/libvirt/images/Whonix-Workstation.qcow2 >/dev/null 2>&1
        # Import the Whonix ™ Gateway and Workstation images.
        virsh define Whonix-Gateway*.xml >/dev/null 2>&1 && echo "Domain 'Whonix-Gateway' defined from Whonix-Gateway-Xfce-17.0.3.0.xml."
        virsh define Whonix-Workstation*.xml >/dev/null 2>&1 && echo "Domain 'Whonix-Workstation' defined from Whonix-Workstation-Xfce-17.0.3.0.xml."
    }
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
    echo -e "    version: $version\n    Author: $author\n    Project: $project\n"
}

function main() {
    local vnets_to_remove=($(virsh net-list --all --name | grep -E 'Whonix-(External|Internal)'))
    local vms_to_remove=($(virsh list --all --name | grep -E 'Whonix-(Gateway|Workstation)'))
    local answer net_name vm_name

    {
        trap 'cleanup; exit 0' INT TERM
        logo
        check_archives_to_extract
        extract
        cd $path_extract || exit 4
    }
    while true; do
        if [[ ${#vnets_to_remove[@]} -gt 0 ]]; then
            echo -e "\nThe following networks already exist: ${vnets_to_remove[*]}."
            read -rp 'Do you want to replace them? (y/n): ' answer
            case "$answer" in
                [yY])
                    # Remove virtual network
                    echo -e "\n#### Removing existing virtual networks ####\n"
                    for net_name in "${vnets_to_remove[@]}"; do
                        {
                            virsh net-destroy "$net_name" >/dev/null 2>&1 && echo "Network '$net_name' destroyed."
                            virsh net-undefine "$net_name" >/dev/null 2>&1 && echo "Network '$net_name' undefined."
                        }
                    done
                    import_networks
                    break ;;
                [nN]) 
                    break ;;
                *) 
                    echo "Invalid input. Please enter 'y' or 'n'." ;;
            esac
        else
            import_networks
            break
        fi
    done
    while true; do
        if [[ ${#vms_to_remove[@]} -gt 0 ]]; then
            echo -e "\nThe following VM images already exist: ${vms_to_remove[*]}."
            read -rp 'Do you want to remove them? (y/n): ' answer
            case $answer in
                [Yy])
                    # Remove virtual machine
                    echo -e "\n#### Removing existing VMs ####\n"
                    for vm_name in "${vms_to_remove[@]}"; do
                        local imgs_to_remove=($(virsh domblklist $vm_name | awk '{ if ($1 ~ /^vd[a-z]$/) {print $2} }'))

                        if virsh domstate "$vm_name" | grep -q "running"; then
                            {
                                # Stop the virtual machine
                                virsh destroy "$vm_name" >/dev/null 2>&1 && echo "The virtual machine '$vm_name' has been successfully stopped."
                                sleep 3s
                            }
                        fi
                        {
                            virsh undefine "$vm_name" >/dev/null 2>&1 && echo "Domain '$vm_name' has been undefined."
                            rm -f $imgs_to_remove >/dev/null 2>&1 && echo "Image '$imgs_to_remove' removed."
                        }
                    done
                    import_images
                    break
                    ;;
                [Nn])
                    break
                    ;;
                *)
                    echo "Invalid choice. Please enter 'y' or 'n'."
                    ;;
            esac
        else
            import_images
            break
        fi
    done
    {
        cd ..
        echo -e "\nConcluded!\n"
        cleanup
    }
}

# Check if the script is being executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # Check if the user has UID 0 (root)
    if [[ "$(id -u)" -eq 0 ]]; then
        main
    else
        echo -e "\nThis script must be run as root.\n"
        exit 1
    fi
fi