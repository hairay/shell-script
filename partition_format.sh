#!/bin/sh

# usage: sh partition_format.sh <device>
#
# example: sh /sbin/partition_format.sh /dev/mmcblk0
#
#
# This script is to partition and format an eMMC or SD device.
#
# It will first attempt to partition the device with this result:
#
# # fdisk /dev/mmcblk0
# 
# The number of cylinders for this disk is set to 119296.
# There is nothing wrong with that, but this is larger than 1024,
# and could in certain setups cause problems with:
# 1) software that runs at boot time (e.g., old versions of LILO)
# 2) booting and partitioning software from other OSs
#    (e.g., DOS FDISK, OS/2 FDISK)
# 
# Command (m for help): p
# 
# Disk /dev/mmcblk0: 3909 MB, 3909091328 bytes
# 4 heads, 16 sectors/track, 119296 cylinders
# Units = cylinders of 64 * 512 = 32768 bytes
# 
#         Device Boot      Start         End      Blocks  Id System
# /dev/mmcblk0p1               1           8         248  83 Linux
# /dev/mmcblk0p2               9         264        8192  83 Linux
# /dev/mmcblk0p3             265        8456      262144  83 Linux
#
# If there are errors (for example, if there is already a partition
# table), it will exit. If there are no errors it will put an ext2
# file system on partitions 2 and 5, and it will zero partitions 1 and
# 3.
#
# If busybox is updated to a newer fdisk, this might need to be
# updated.
create_partition() {
    
    FDISK='fdisk -u'

    (
      echo o

      echo n # new
      echo p
      echo 1
      echo 512
      echo 16895
                            
      echo n # new
      echo p
      echo 2
      echo 16896
      echo 2114047
      
      echo n # new
      echo p
      echo 3
      echo 2114048
      echo 2138623

      echo n # new
      echo p
      echo 4
      echo 2138624
      echo 6332927
            
      echo a # bootable flag
      echo 1
      echo w
    ) | ${FDISK} ${1} 2>&1 >/dev/null    
}

BEFORESUM=`dd if=${1} bs=1 count=512 | sha1sum`
echo Try partitioning ${1}
umount ${1}p3
umount ${1}p4
create_partition ${1}
AFTERSUM=`dd if=${1} bs=1 count=512 | sha1sum`

if [ "$BEFORESUM" = "$AFTERSUM" ]
then
    echo Starting partition table not as expected, not formatting ${1}.
else
    echo format ${1}

    dd if=/dev/zero of=${1}p1 bs=1M
    yes | mkfs.ext4 -L inferno ${1}p2 || exit 1
	yes | mkfs.ext4 -L settings ${1}p3 || exit 1
	yes | mkfs.ext4 -L others ${1}p4 || exit 1
    echo
    echo Done partitioning and formatting.
fi
