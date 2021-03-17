#!/bin/env bash

source config.sh

echo "$rootpassword"
systemctl enable NetworkManager
systemctl start NetworkManager
echo "root:"$rootpassword"" | chpasswd
useradd -m -G wheel $username
echo ""$username":"$password"" | chpasswd
	pacman -S --noconfirm git plasma dolphin sddm konsole firefox
	mkdir /home/$username/builds
	cd /home/$username/builds
	git clone https://aur.archlinux.org/yay.git
	systemctl enable sddm
reboot

