# automatedArch! My Light Touch, High Volume deployment solution for installing Arch Linux  
## Automated Insttall
## Works with SATA, VIRTIO, and NVME disks  
How to start:  
on booting of the arch iso run these commands:  
pacman -Sy git  
git clone https:github.com/dominicbauers/automatedArch  
cd automatedArch/  
./install.sh  
*This installs the base system, NetworkManager, KDE PLASMA, and Firefox

## Guided, Wizard Install (Currently in Development).
In case this script errors out or for some reason does not boot,
use ./wizard.sh for a guided install.
