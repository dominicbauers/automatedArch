#!/bin/env bash

source config.sh

echo "$rootpassword"
systemctl enable NetworkManager
systemctl start NetworkManager
echo "root:"$rootpassword"" | chpasswd
useradd -m -G wheel $username
echo ""$username":"$password"" | chpasswd
if [ $setup = '1' ]; then
	echo 'y' | pacman -S xorg xorg-xinit picom nitrogen sxhkd firefox git pulseaudio
	sxhkd &
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
	cd dotfiles
	cp .xinitrc /home/$username
	cp -R sxhkdrc /home/$username/.config/sxhkd/sxhkdrc
	cd ..
	su dominic << EOF
	pulseauio --start
	systemctl --user enable pulseaudio.socket
	EOF
else
	pacman -S --noconfirm git plasma dolphin sddm konsole firefox
	mkdir /home/$username/builds
	cd /home/$username/builds
	git clone https://aur.archlinux.org/yay.git
	systemctl enable sddm
fi

