# automatedArch! My Light Touch, High Volume deployment solution for installing Arch Linux  
## Automated Install, Works with SATA, VIRTIO, and NVME disks  
How to start:  
on booting of the arch iso run these commands:  
pacman -Sy git  
git clone https:github.com/dominicbauers/automatedArch  
cd automatedArch/  
Choose the script for what you want installed,
ex: installBASE.sh for just the base system, installKDE.sh for KDE plasma
Will prompt you to enter type of disks then automatically installs the rest

## Guided, Wizard Install (Currently in Development).
In case this script errors out or for some reason does not boot,
use ./wizard.sh for a guided install.
