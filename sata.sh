#!/bin/sh
echo 'sata'
parted /dev/sda --script mklabel gpt
parted /dev/sda --script mkpart primary fat32 1MiB 512MiB
parted /dev/sda --script mkpart primary linux-swap 512MiB 8512Mib
parted /dev/sda --script mkpart primary ext4 8512Mib 100%
parted /dev/sda --script set 1 esp on

mkfs.vfat /dev/sda1
mkswap /dev/sda2
swapon /dev/sda3
mkfs.ext4 /dev/sda3

mount /dev/sda3 /mnt
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot

genfstab -U /mnt >> /mnt/etc/fstab

#pacstrap /mnt --quiet base base-devel linux linux-firmware networkmanager vim man-db man-pages

#echo "after pacman"

#cp -r /postChroot /mnt

#arch-chroot /mnt ./postChroot/postChroot.sh
