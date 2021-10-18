#!/bin/sh

sleep 90

while true
do
    for f in x2030.axf UIAgent_X2030 UI_X2030 ParserTest.axf netmanager netmngtptcl AVIWeChatPay ScanFlow   
    do
        #echo ${f}
        pidof -s ${f} > /dev/null
        if [ $? -ne 0 ]; then
		   echo "********fail_ap********" | /opt/app/outlog.axf
           date >> /opt/setting/fail_ap.log 
           uptime >> /opt/setting/fail_ap.log 
           echo "fail_ap:"${f} >> /opt/setting/fail_ap.log
		   echo "fail_ap:"${f} | /opt/app/outlog.axf
		   cat /opt/setting/fail_ap.log | /opt/app/outlog.axf
		   sync		
           sleep 1		   
           reboot
        fi
    done
    sleep 30
done