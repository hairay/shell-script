#!/bin/sh

while true
do
    echo mem > /sys/power/state
	busybox devmem 0x88CF0004 32 >> s3test.log
	num=$RANDOM*30/32768+15
	echo $((num))
    sleep $((num))
done


