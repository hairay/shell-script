#!/bin/sh

if [ $# -eq 0 ]
  then
    echo "No IP supplied"
	exit 22
fi

while true
do
    now=$(date +"%Y_%m_%d_%H_%M_%S")
	echo "log_mice91_$now.txt"
	echo $1
	nc -w 6000 $1 5547 >> "netlog_$now.txt"	&
    sleep 7200
	killall nc
done
