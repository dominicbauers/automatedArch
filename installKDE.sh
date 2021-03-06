#!/bin/bash
timedatectl set-ntp true
echo Enter 1 for SATA, 2 for NVME, 3 for VIRTIO
read disk
if [ $disk = "1" ]; then
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
elif [ $disk = "2" ]; then
        parted /dev/nvme0n1 --script mklabel gpt
	parted /dev/nvme0n1 --script mkpart Boot fat32 1MiB 512MiB
	parted /dev/nvme0n1 --script mkpart Swap linux-swap 512MiB 8512Mib
	parted /dev/nvme0n1 --script mkpart Root ext4 8512Mib 100%
	parted /dev/nvme0n1 --script set 1 esp on

	mkfs.vfat /dev/nvme0n1p1
	mkswap /dev/nvme0n1p2
	swapon /dev/nvme0n1p2
	mkfs.ext4 /dev/nvme0n1p3

	mount /dev/nvme0n1p3 /mnt
	mkdir /mnt/boot
	mount /dev/nvme0n1p1 /mnt/boot
elif [ $disk = "3" ]; then
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
else
        echo "Invalid input, try again :("
fi

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
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
cp -r postChroot/sudoers /etc/sudoers
cp -r postChroot/bootstrap /home
rm -rf postChroot
systemctl enable NetworkManager
echo "root:password" | chpasswd
useradd -m -G wheel user
echo "user:password" | chpasswd
pacman -S --noconfirm git plasma dolphin sddm konsole firefox
systemctl enable sddm
EOF
reboot

