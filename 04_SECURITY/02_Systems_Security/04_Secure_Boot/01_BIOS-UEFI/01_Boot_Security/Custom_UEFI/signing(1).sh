#!/bin/bash
#pushd /boot/efi/EFI/centos
#mkdir backup
#cp -rf shim.efi grubaa64.efi backup
# Signing shim.efi
sbsign --key PK.key --cert PK.crt --output /boot/efi/EFI/centos/shim.efi /boot/efi/EFI/centos/backup/shim.efi
sbsign --key KEK.key --cert KEK.crt --output /boot/efi/EFI/centos/shim.efi /boot/efi/EFI/centos/backup/shim.efi
sbsign --key DB.key --cert DB.crt --output /boot/efi/EFI/centos/shim.efi /boot/efi/EFI/centos/backup/shim.efi
# Signing grubaa64.efi
sbsign --key PK.key --cert PK.crt --output /boot/efi/EFI/centos/grubaa64.efi /boot/efi/EFI/centos/backup/grubaa64.efi
sbsign --key KEK.key --cert KEK.crt --output /boot/efi/EFI/centos/grubaa64.efi /boot/efi/EFI/centos/backup/grubaa64.efi
sbsign --key DB.key --cert DB.crt --output /boot/efi/EFI/centos/grubaa64.efi /boot/efi/EFI/centos/backup/grubaa64.efi
