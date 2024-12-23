#!/bin/bash

OUTDIR=${PWD}
OUTFILE_CD=${OUTDIR}/generic-boot-cd.iso
OUTFILE_USB=${OUTDIR}/generic-boot-usb.iso
DIR=${PWD}/Generic_Boot
CDROOT=${DIR}/CD_Root

sudo yum install gcc xz-devel dosfstools syslinux genisoimage

mkdir -p ${DIR}
cp generic-boot-script ${DIR}/script
cp generic-boot-isolinux-cfg ${DIR}/isolinux.cfg
pushd ${DIR}
 git clone git://git.ipxe.org/ipxe.git


 pushd ${DIR}/ipxe/src
  make clean
  make bin/ipxe.lkrn
  make bin-x86_64-efi/ipxe.efi EMBED=${DIR}/script
 popd

 dd if=/dev/zero of=${DIR}/efiboot.img bs=1024 count=2048
 mkfs.fat -s1 -F32 ${DIR}/efiboot.img

 mkdir -p efiboot
 sudo mount -o loop efiboot.img efiboot
 sudo mkdir -p efiboot/EFI/BOOT
 sudo rm -f efiboot/EFI/BOOT/BOOTX64.EFI
 sudo cp ipxe/src/bin-x86_64-efi/ipxe.efi efiboot/EFI/BOOT/BOOTX64.EFI
 sudo umount efiboot
 rmdir efiboot

 mkdir -p ${CDROOT}/EFI/BOOT

 cp efiboot.img ${CDROOT}
 cp script ${CDROOT}
 cp isolinux.cfg ${CDROOT}
 cp ipxe/src/bin-x86_64-efi/ipxe.efi ${CDROOT}/EFI/BOOT/BOOTX64.EFI
 cp ipxe/src/bin/ipxe.lkrn ${CDROOT}/EFI/BOOT
 cp ipxe/src/bin/ipxe.lkrn ${CDROOT}
 cp /usr/share/syslinux/isolinux.bin ${CDROOT}
popd

mkisofs \
  -untranslated-filenames \
  -rational-rock \
  -v \
  -translation-table \
  -input-charset UTF-8 \
  -J \
  -joliet-long \
  -V "Generic Boot" \
  -A "Generic Boot" \
  -volset "Generic Boot" \
  -x ./lost+found \
  -b isolinux.bin \
  -c boot.cat \
  -no-emul-boot \
  -boot-load-size 4 \
  -boot-info-table \
  -eltorito-alt-boot \
  -eltorito-platform 0xEF \
  -efi-boot efiboot.img \
  -no-emul-boot \
  -o ${OUTFILE_CD} \
  ${CDROOT}

cp ${OUTFILE_CD} ${OUTFILE_USB}
/usr/bin/isohybrid -v --uefi ${OUTFILE_USB}