#!/bin/bash
#montioring the free fs space disk
FU=$(df -h | egrep -v "Filesystem|tmpfs" | grep "vagrant" | awk '{print $5}'| tr -d %)
TO="samplee_email@gmail.com"
if [[ $FU -ge 70 ]]
then 
    echo "Warning, disk space is low for vagrant directory: ${FU}" | mail -s "DISK SPACE ALERT" $TO
else
    echo "All good"
fi
