#
# written by Yingding Wang 
# Run this script as user root
#
#

INFORMIXDIR=/opt/informix
BACKUP=/backup/configurations
# informixdir is the path need by informix, and will be the symbollink to informixhome

cp -p $INFORMIXDIR/etc/onconfig /$BACKUP/onconfig
cp -p $INFORMIXDIR/etc/sqlhosts /$BACKUP/sqlhosts
cp -p $INFORMIXDIR/etc/log_full.sh /$BACKUP/log_full.sh
cp -p /home/informix/Backup_Scripts/AutoBackup.sh /$BACKUP/AutoBackup.sh
cp -p /etc/init.d/informix_startup /$BACKUP/informix_startup
cp -p /etc/profile.local /$BACKUP/profile.local
cp -p /etc/X11/xorg.conf /$BACKUP/xorg.conf







