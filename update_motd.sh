#!/bin/bash
#Script to update motd with relevant information.
# Place in /usr/bin and update /etc/pam.d/system-login

#Define output file
motd="/etc/motd"

# Collect information
# $USER is automatically defined
HOSTNAME=`uname -n`
KERNEL=`uname -r`
CPU=`awk -F '[ :][ :]+' '/^model name/ { print $2; exit; }' /proc/cpuinfo`
ARCH=`uname -m`
PACMAN=`pacman -Qu | wc -l`
DISC=`df -h | grep /dev/nvme0n1p3 | awk '{print $5 }'`
IFS=" " read USED FREE TOTAL <<<$(free -htm | grep "Mem" | awk {'print $3,$4,$2'})
PSA=`ps -Afl | wc -l`
PSU=`ps U $PAM_USER h | wc -l`

PROCESS=`ps -eo user=|sort|uniq -c | awk '{ print $2 " " $1 }'`
PROCESS_ALL=`echo "$PROCESS"| awk {'print $2'} | awk '{ SUM += $1} END { print SUM }'`
PROCESS_ROOT=`echo "$PROCESS"| grep root | awk {'print $2'}`
PROCESS_USER=`echo "$PROCESS"| grep -v root | awk {'print $2'} | awk '{ SUM += $1} END { print SUM }'`

#Time of day
HOUR=$(date +"%H")
if [ $HOUR -lt 12  -a $HOUR -ge 0 ]
then   TIME="morning"
elif [ $HOUR -lt 17 -a $HOUR -ge 12 ]
then   TIME="afternoon"
else   TIME="evening"
fi

#System uptime
uptime=`cat /proc/uptime | cut -f1 -d.`
upDays=$((uptime/60/60/24))
upHours=$((uptime/60/60%24))
upMins=$((uptime/60%60))
upSecs=$((uptime%60))


#System load
LOAD1=`cat /proc/loadavg | awk {'print $1'}`
LOAD5=`cat /proc/loadavg | awk {'print $2'}`
LOAD15=`cat /proc/loadavg | awk {'print $3'}`


#Color variables
W="\033[00;37m"
B="\033[01;36m"
R="\033[01;34m"
X="\033[01;37m"
A="\033[01;32m"

#Clear screen before motd
clear > $motd

ARCH="
        $A. $X
       $A/#\ $X                     _     $A _ _
      $A/###\ $X      __ _ _ __ ___| |__  $A| (_)_ __  _   ___  __ 
     $A/#####\ $X    / _' | '__/ __| '_ \ $A| | | '_ \| | | \ \/ /
    $A/##.-.##\ $X  | (_| | | | (__| | | |$A| | | | | | |_| |>  <  
   $A/##(   )##\ $X  \__,_|_|  \___|_| |_|$A|_|_|_| |_|\__,_/_/\_\\
  $A/#.--   --.#\ $X
 $A/'           '\ $B 
">> $motd

#echo -e "$R===============================================================" >> $motd
echo -e "`fortune -o | cowsay -f tux | lolcat -f`" >> $motd

echo -e "$R===============================================================" >> $motd
echo -e "       $W Good $TIME, $B$PAM_USER.$W Welcome to $B$HOSTNAME                " >> $motd
echo -e "       $R KERNEL $W= $KERNEL                                 " >> $motd
echo -e "       $R CPU    $W= $CPU                                    " >> $motd
echo -e "       $R HOSTNAME $W= $HOSTNAME                             " >> $motd
echo -e "       $R ARCH $W= $ARCH                                     " >> $motd
echo -e "       $R SYSTEM $W= $PACMAN packages can be updated         " >> $motd
echo -e "       $R USERS $W= Currently `users | wc -w` users logged on " >> $motd
echo -e "$R===============================================================" >> $motd
echo -e "       $R CPU Usage $W= $LOAD1(1m) $LOAD5(5m) $LOAD15(15m)" >> $motd
echo -e "       $R CPU Temperature $W= `acpi -t | cut -f4 -d' '` C" >> $motd
echo -e "       $R Memory $W= $USED used, $FREE free, $TOTAL total" >> $motd
echo -e "       $R Swap in use $W= `free -m | tail -n 1 | awk '{print $3}'` MB " >> $motd
echo -e "       $R Processes $W= $PROCESS_ROOT(root), $PROCESS_USER(user), $PROCESS_ALL(total) " >> $motd
echo -e "       $R System Uptime $W= $upDays days $upHours hours $upMins minutes $upSecs seconds " >> $motd
echo -e "       $R Disk Space Used $W= $DISC                          " >> $motd
echo -e "$R===============================================================" >> $motd
echo -e "$X" >> $motd
