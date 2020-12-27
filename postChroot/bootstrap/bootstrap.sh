#!/bin/env bash

source config.sh

echo "root:"$rootpassword"" | chpasswd
useradd -m -G wheel $username
echo ""$username":"$password"" | chpasswd
if [ $setup = '1' ]; then
	echo '' | pacman -S --noconfirm xorg xorg-xinit picom nitrogen sxhkd firefox git pulseaudio
	cd /home/$username
	git clone https://github.com/dominicbauers/dotfiles
	mkdir builds
	cd builds
	git clone https://github.com/dominicbauers/db-dwm
	git clone https://github.com/dominicbauers/db-st
	git clone https://git.suckless.org/slstatus
	git clone https://git.suckless.org/dmenu
	git clone https://aur.archlinux.org/yay.git
	cd db-dwm
	make clean install
	cd ..
	cd db-st
	make clean install
	cd ..
	cd slstatus
	make clean install
	cd ..
	cd dmenu
	make clean install
	cd ..
	cd ..
	mkdir Wallpapers
	mkdir .config
	mkdir .config/sxhkd
	cd dotfiles
	cp .xinitrc /home/$username
	cp -R sxhkdrc /home/$username/.config/sxhkd/sxhkdrc
else
	pacman -S --noconfirm git plasma dolphin sddm konsole firefox
	mkdir /home/$username/builds
	cd /home/$username/builds
	git clone https://aur.archlinux.org/yay.git
	systemctl enable sddm
fi
rm -rf /home/bootstrap
reboot
