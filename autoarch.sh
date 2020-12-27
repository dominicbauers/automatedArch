#!/bin/sh
echo "Enter number for machine disk type: 1-Sata 2-nvme 3-virtio: " 
read disk
if [ $disk -eq 1 ] ; then
	sh sata.sh
elif [ $disk -eq 2 ] ; then
	sh nvme.sh
elif [ $disk -eq 3 ] ; then
	sh virtio.sh
else
	echo "error, retry typing number of disk"
fi
