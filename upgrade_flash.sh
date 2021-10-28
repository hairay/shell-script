#!/bin/sh

info()  { echo -e "\x1b[1m* $@\x1b[0m" 1>&2; }
err()   { echo -e "\x1b[31m$@\x1b[0m" 1>&2; }
warn()  { echo -e "\x1b[33m$@\x1b[0m" 1>&2; }
well()  { echo -e "\x1b[32m$@\x1b[0m" 1>&2; }
abort() { E=$1; shift; err "$@"; exit $E; }

check_exist() {
    echo -n checking "$1" ... 1>&2
    [ -z "$1" ] && abort 1 " missing!"
    [ ! -e "$1" ] && abort 1 " missing!"
    well " ok"
}

DEVICE_TO_UPGRADE=`cat /upgrade/device`
check_exist ${DEVICE_TO_UPGRADE}
if [ "$?" = "0" ] ; then
    echo "Found upgrade."
    # We have been told what device to upgrade.
    sh /sbin/partition_format.sh ${DEVICE_TO_UPGRADE} # Non-destructive
						      # if
						      # already
						      # partitioned.
    
    # We now expect these partitions:
    #   1  ext2 "/settings" volume with label "settings"
    #   2  binary image of kernel brn file
    #   3  ext2 "/" volume with label "quasar".

    # Look for possible upgrade files, apply the ones we find.

    # Attempt to write settings file system.
    if test -e /upgrade/settings.tar.bz2 ; then
	echo "Found /upgrade/settings.tar.bz2, mount ${DEVICE_TO_UPGRADE}p1 and untar."
	mkdir /tmp/settings
	mount -t ext4 -o noatime ${DEVICE_TO_UPGRADE}p3 /tmp/settings
	cd /tmp/settings
	rm -rf * .*
	tar xvjf /upgrade/settings.tar.bz2
	cd /
	umount /tmp/settings
    fi
    
    # Attempt to write devtreelinux image.
    if test -e /upgrade/devtreelinux.brn ; then
	echo "Found /upgrade/devtreelinux.brn, dd to ${DEVICE_TO_UPGRADE}p2"
	dd if=/upgrade/devtreelinux.brn of=${DEVICE_TO_UPGRADE}p1 bs=1M
    fi

    # Attempt to write / file system.
    if test -e /upgrade/quasar_rootfs.tar.bz2 ; then
	echo "Found /upgrade/quasar_rootfs.tar.bz2, mount ${DEVICE_TO_UPGRADE}p3 and untar."
	mkdir /tmp/quasar
	mount -t ext4 -o noatime ${DEVICE_TO_UPGRADE}p2 /tmp/quasar
	cd /tmp/quasar
	rm -rf * .*
	tar xvjf /upgrade/quasar_rootfs.tar.bz2
	cd /
	umount /tmp/quasar
    fi
else
    echo "Found /upgrade directory but no '/upgrade/device' file, can't upgrade."
fi
echo
echo "Done with upgrade. You probably want to reboot now."
echo
sleep 10
