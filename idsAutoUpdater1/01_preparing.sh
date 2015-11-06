#!/bin/sh
#
# written by Yingding Wang 
# 
# Run this script as user root
#
#
INFORMIXHOME=/opt/informix-11.70.FC7
# informixhome is the name of the folder where informix physical installed
INFORMIXDIR=/opt/informix
# informixdir is the path need by informix, and will be the symbollink to informixhome
INFORMIXTEMP=/tmp/infinstall
#only the current IDS version will be save to the local directory als .tar Date
#this line read the current tar name
IDSSOFTWARE=`ls *.tar`
MyPropertiesPath=silentProperties
echo IDSSOFTWARE

echo "Please do the following action first before migration!!"
echo "1- Force to next logical log with: onstat -l"
echo "2- Do checkpoint with: onmode -c" 
echo "3- Make a level 0 Backup with: ontape -s -L -0"
echo "4- Write out all online log to files with: ontape -a"
echo "5- Stop IDS Server with: onmode -yuk"

read -n 1 -e -p "finished all required actions and want to migrate?y/[n]: " yesno
        case ${yesno} in
                y) return ;;
                n) exit 6;;
        esac

# enable verbose executables
set -x

loopcheck='n'
while [ $loopcheck != 'y' ]

do

echo "Generating preinstall informations"

echo "Please give the DBServer name and press[ENTER]"
read dbname
echo "DB Server name is: $dbname"

echo "Please give the hostname/IP for sqlhost Datei and press[ENTER]"
read hostname
echo "DB Server port is: $hostname"

echo "Please give the onsoctcp port number and press[ENTER]"
read dbport
echo "DB Server port is: $dbport"

echo "dbname: $dbname"
echo "port: $dbport"
echo "you want to go on? with [y] otherwith with [n] to correct your entry"
read loopcheck

done

#substitute value DBSERVERNAME with new DBSERVERNAME
sed s/\DBSERVERNAME\ .*/\DBSERVERNAME\ $dbname/g <onconfig.tmp> onconfig
#substitute value INFORMIXSERVER with new INFORMIXSERVER
sed s/\INFORMIXSERVER=.*/\INFORMIXSERVER=$dbname/g <profile_local.tmp> profile.local
sed s/\INFORMIXSERVER=.*/\INFORMIXSERVER=$dbname/g <AutoBackup.tmp> AutoBackup.sh
sed s/\INFORMIXSERVER=.*/\INFORMIXSERVER=$dbname/g <informix_startup.tmp> informix_startup
#substitute value dbhost, host, port in sqlhosts
sed s/demo\ /$dbname\ /g <sqlhosts.tmp> sqlhosts1
sed s/nil\ /$hostname\ /g <sqlhosts1> sqlhosts2
sed s/1528/$dbport/g <sqlhosts2> sqlhosts
#delete temp file sqlhosts1,sqlhost2 
rm sqlhosts1
rm sqlhosts2


echo "Using existing users and usergroup informix"
#do nothing
#mkdir /home/informix 
#groupadd informix 
#useradd -u 1000 -g informix -m -d /home/informix informix 
#chown -R informix:informix /home/informix 

#echo informix | passwd --stdin informix
#echo 'Setting "informix" as default password for user: informix'


echo "Creating temp Directory for install"
mkdir $INFORMIXTEMP
chown -R informix:informix $INFORMIXTEMP

echo "Copying/Getting IDS Server Sources"
#echo "giving passwd of admin in oat server to get the IDS software"
sudo -u informix cp $IDSSOFTWARE $INFORMIXTEMP/$IDSSOFTWARE

echo "Creating profile.local from template"
cp profile.local /etc/profile.local
. /etc/profile.local

echo "Updating informix home"
mkdir $INFORMIXHOME 
chown -R informix:informix $INFORMIXHOME
# delelte the symlink for old version
if [ -L $INFORMIXDIR ]
then  
        echo "removing previous symlink"
	rm $INFORMIXDIR
fi
ln -s $INFORMIXHOME $INFORMIXDIR 

echo "Preparing informix installer"
chown informix:informix $INFORMIXTEMP/$IDSSOFTWARE

currentDir=`pwd`
cd $INFORMIXTEMP 
sudo -u informix tar -xvf $IDSSOFTWARE
cd $currentDir

echo "Copying properties file for silent installation"
cp -R $MyPropertiesPath/ $INFORMIXTEMP/$MyPropertiesPath/
chown informix:informix $INFORMIXTEMP/$MyPropertiesPath/
chmod 644 $INFORMIXTEMP/$MyPropertiesPath/*.properties

echo "Using existign Backup Struktur"
#sudo -u informix mkdir /home/informix/Backup_Scripts
#mkdir /backup
#mkdir /backup/configurations
#mkdir /backup/db-backup
#mkdir /backup/db-l
#mkdir /backup/db-level-backup
#mkdir /backup/informix
#mkdir /backup/informix/tapedev
#mkdir /backup/informix/tapedev/logical-logs
#mkdir /backup/configurations/administration

#chmod 755 /backup
#chmod 755 /backup/configurations
#chmod 755 /backup/db-backup
#chmod 755 /backup/db-l
#chmod 755 /backup/db-level-backup
#chmod 755 /backup/informix
#chmod 755 /backup/informix/tapedev 
#chmod 755 /backup/informix/tapedev/logical-logs
#chmod 755 /backup/configurations/administration

#chown informix:informix /backup
#chown informix:informix /backup/configurations
#chown informix:informix /backup/db-backup
#chown informix:informix /backup/db-l
#chown informix:informix /backup/db-level-backup
#chown informix:informix /backup/informix
#chown informix:informix /backup/informix/tapedev
#chown informix:informix /backup/informix/tapedev/logical-logs
#chown root:root /backup/configurations/administration

echo "keeping existing tapedev und ltapedev files"
#touch /backup/informix/tapedev/tapedev
#touch /backup/informix/tapedev/ltapedev
#chmod 660 /backup/informix/tapedev/tapedev
#chmod 660 /backup/informix/tapedev/ltapedev
#chown informix:informix /backup/informix/tapedev/tapedev
#chown informix:informix /backup/informix/tapedev/ltapedev

echo "keeping existing DB-spaces strukture"
#mkdir /db-spaces
#mkdir /db-spaces/01
#chmod 755 /db-spaces
#chmod 755 /db-spaces/01
#chown informix:informix /db-spaces
#chown informix:informix /db-spaces/01

echo "keeping existing DB-chunks"
#touch /db-spaces/01/rootdbs
#touch /db-spaces/01/blob-space01
#touch /db-spaces/01/dbs-temp01
#touch /db-spaces/01/datadbs00

#chown informix:informix /db-spaces/01/rootdbs
#chown informix:informix /db-spaces/01/blob-space01
#chown informix:informix /db-spaces/01/dbs-temp01
#chown informix:informix /db-spaces/01/datadbs00

#chmod 660 /db-spaces/01/rootdbs
#chmod 660 /db-spaces/01/blob-space01
#chmod 660 /db-spaces/01/dbs-temp01
#chmod 660 /db-spaces/01/datadbs00

echo "Keeping existing Additional-chunks"

#touch /db-spaces/01/dbphysical01
#touch /db-spaces/01/dblogical01

#chown informix:informix /db-spaces/01/dbphysical01
#chown informix:informix /db-spaces/01/dblogical01

#chmod 660 /db-spaces/01/dbphysical01
#chmod 660 /db-spaces/01/dblogical01

echo "keeping DB-log structure"
#mkdir /var/informix
#chmod 755 /var/informix
#chown informix:informix /var/informix

echo "Updating administration script"
cp backupconfigIDSDB.sh /backup/configurations/administration/backupconfigIDSDB.sh
cp appendLogicalLog.sh  /backup/configurations/administration/appendLogicalLog.sh
cp deleteLogicalLog.sh  /backup/configurations/administration/deleteLogicalLog.sh
cp 04_postinstall.sh    /backup/configurations/administration/04_postinstall.sh 

echo "brending scripts for informix user"
chown informix:informix /backup/configurations/administration/appendLogicalLog.sh
chown informix:informix /backup/configurations/administration/deleteLogicalLog.sh
chmod 753 /backup/configurations/administration/appendLogicalLog.sh
chmod 751 /backup/configurations/administration/deleteLogicalLog.sh

echo "Hinweis:"
echo "legen Sie profile.local file"
echo "bearbeiten Sie nach der IDS installation"
echo "ONCONFIG und SQLHOSTS"
echo "legen Sie log_full.sh file in $INFORMIXDIR/etc/"
echo "erzeugen informix_start skript in /etc/init.d/ "
echo "kopieren und erzeugen autobackup,appendLogicalLog.sh,deleteLogicalLog.sh,postinstall.sh in /home/informix/Backup_Scripts"
