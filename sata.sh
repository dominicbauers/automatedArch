#!/bin/sh
echo 'sata'
parted /dev/sda --script mklabel gpt
parted /dev/sda --script mkpart primary vfat 1MiB 512MiB
parted /dev/sda --script mkpart primary linux-swap 512MiB 8512Mib
parted /dev/sda --script mkpart primary ext4 8512Mib 100%

