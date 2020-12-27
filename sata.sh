#!/bin/sh
echo 'sata'
timedatectl set-ntp true
parted /dev/sda --script mklabel gpt
parted /dev/sda --script mkpart primary fat32 1MiB 512MiB
parted /dev/sda --script mkpart primary linux-swap 512MiB 8512Mib
parted /dev/sda --script mkpart primary ext4 8512Mib 100%
parted /dev/sda --script set 1 esp on

mkfs.vfat /dev/sda1
mkswap /dev/sda2
swapon /dev/sda2
mkfs.ext4 /dev/sda3

mount /dev/sda3 /mnt
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot

pacstrap /mnt --quiet base base-devel linux linux-firmware networkmanager vim man-db man-pages

genfstab -U /mnt >> /mnt/etc/fstab

cp -r postChroot /mnt

UUID=$(lsblk -no UUID /dev/sda3)

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
bootctl --path=/boot install
echo $'default/tarch-*' >> /boot/loader/loader.conf
cp postChroot/arch.conf /boot/loader/entries/arch.conf
echo $'options\troot=UUID=$UUID rw' >> /boot/loader/entries/arch.conf
cp -R postChroot/sudoers /etc/sudoers
cp -r postChroot/bootstrap /root 
rm -rf postChroot
EOF
reboot
