#!/bin/sh

#initial DB Server as user informix 
set -x 
loopcheck='n'
while [ $loopcheck != 'y' ]

do 

echo "Please give the path to the home dir of your PREVIOUS Informix home"
echo "Example: /opt/informix-11.50.xxx, if you are updating to ids 11.70"
read preIDSHOME
echo "The PREVIOUS Informix home is: $preIDSHOME"

echo "you want to go on? with [y] otherwith with [n] to correct your entry"
read loopcheck

done


#set local env variables for subshell
. /etc/profile.local
echo $INFORMIXDIR

echo "copying the files from old server version"
cp -p $preIDSHOME/etc/onconfig $INFORMIXDIR/etc/;
cp -p $preIDSHOME/etc/log_full.sh $INFORMIXDIR/etc/;
cp -p $preIDSHOME/etc/sqlhosts $INFORMIXDIR/etc/;

#Starting Server for inPlace migration with oninit -v
su informix -c 'oninit -v';
su informix -c 'onstat -'

echo "End of the inPlace migration"

echo "Keeping existing IDS Start Script in Runlevel"
#insserv /etc/init.d/informix_startup;
#echo "Finished Insert IDS Start Script in Runlevel"

echo "please execute:"
echo "/backup/configurations/administration/appendLogicalLog.sh"
echo "to append new logs."
echo "For 30GB logical log you can use size 100000 (200MB) each logfile"
echo "And 120 Logs in total."
echo "After log appendence please execute:"
echo "/backup/configurations/administration/deleteLogicalLog.sh"
echo "to delete the old log files."
echo `whoami`
exit 0







