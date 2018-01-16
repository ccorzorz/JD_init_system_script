#!/bin/sh

cd /opt
mkdir -p /export
fdisk -l |grep vdb

if [[ $? -eq 0 ]]; then
	sed -i '$s/#//' /etc/fstab
	fdisk /dev/vdb << EOF
n
p
1


w
EOF
	sleep 2
	mkfs.ext4 /dev/vdb1 && mount -a

else
	sed -i '$d' /etc/fstab

fi

sed -i '/auto_disk.sh/d' /etc/rc.local
#rm -rf /root/script

