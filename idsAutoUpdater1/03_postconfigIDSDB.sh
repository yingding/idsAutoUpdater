#!/bin/sh
#
# written by Yingding Wang 
# Run this script as user root
#
#
INFORMIXDIR=/opt/informix
# informixdir is the path need by informix, and will be the symbollink to informixhome
INFORMIXTEMP=/tmp/infinstall
CONFIGFILE=onconfig
SQLHFILE=sqlhosts

set -x
cp $CONFIGFILE $INFORMIXDIR/etc/onconfig
cp $SQLHFILE $INFORMIXDIR/etc/sqlhosts
cp log_full.sh $INFORMIXDIR/etc/log_full.sh
cp AutoBackup.sh /home/informix/Backup_Scripts/AutoBackup.sh
cp informix_startup /etc/init.d/informix_startup

chown informix:informix $INFORMIXDIR/etc/onconfig
chown informix:informix $INFORMIXDIR/etc/sqlhosts
chown informix:informix $INFORMIXDIR/etc/log_full.sh
chown informix:informix /home/informix/Backup_Scripts/AutoBackup.sh

chmod 644 $INFORMIXDIR/etc/onconfig
chmod 644 $INFORMIXDIR/etc/sqlhosts
chmod 755 $INFORMIXDIR/etc/log_full.sh
chmod 755 /home/informix/Backup_Scripts/AutoBackup.sh
chmod 755 /etc/init.d/informix_startup

echo "bitte ONCONFIG, sqlhosts und log_full.sh data in $INFORMIXDIR/etc/ Verzeichnis und informix_startup in /etc/init.d anpassen "






