#!/bin/sh

apps="eagle.axf outnetlog.axf netmanager ParserTest.axf netmngtptcl WOL_Setup"
for f in $apps
do	
	echo "statm ${f}..." > ${f}.txt	
done
	
while true
do
    for f in $apps
    do
        p=$(pidof ${f})        
        cat /proc/$p/statm >> ${f}.txt
    done
    sleep 30
done


