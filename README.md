# automatedArch! My Light Touch, High Volume deployment solution for installing Arch Linux  
## Works with SATA (NVME and VIRTIO disks coming soon) disks  
How to start:  
on booting of the arch iso run these commands:  
pacman -Sy git  
git clone https:github.com/dominicbauers/automatedArch  
cd automatedArch/  
./autoarch.sh  
*This installs the base system with the root password being "password"*  
## Bootstrap time! (not working yet)  
cd bootstrap  
edit the config file at config.sh  
./bootstrap.sh  
*This enables networking, creates your user, installs programs*
