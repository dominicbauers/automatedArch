#!/bin/sh
echo 'virtio disk selected'
timedatectl set-ntp true
parted /dev/vda --script mklabel gpt
parted /dev/vda --script mkpart primary fat32 1MiB 512MiB
parted /dev/vda --script mkpart primary linux-swap 512MiB 8512Mib
parted /dev/vda --script mkpart primary ext4 8512Mib 100%
parted /dev/vda --script set 1 esp on

mkfs.vfat /dev/vda1
mkswap /dev/vda2
swapon /dev/vda2
mkfs.ext4 /dev/vda3

mount /dev/vda3 /mnt
mkdir /mnt/boot
mount /dev/vda1 /mnt/boot

pacstrap /mnt --quiet base base-devel linux linux-firmware networkmanager vim man-db man-pages grub efibootmgr

genfstab -U /mnt >> /mnt/etc/fstab

cp -r postChroot /mnt


arch-chroot /mnt <<EOF
echo 'y' | pacman -S linux
ln -sf /usr/share/zoneinfo/America/Detroit /etc/localtime
hwclock --systohc
cp /postChroot/locale.gen /etc/locale.gen
locale-gen
echo 'LANG=en_US.UTF-8' > /etc/locale.conf
echo 'archbox' > /etc/hostname
cp postChroot/hosts /etc/hosts
echo "root:password" | chpasswd
grub-install --target=x86_64-efi --efi-directory-/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
cp -R postChroot/sudoers /etc/sudoers
cp -r postChroot/bootstrap /home 
rm -rf postChroot
systemctl enable NetworkManager
EOF
reboot
