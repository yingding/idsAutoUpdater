#!/bin/sh

#set -x
echo "Silent install IDS Server Component... this may take several minutes"
#getting local env variables for subshell
. /etc/profile.local
currentDir=`pwd`

#change to Install Directory
cd /tmp/infinstall

#execute Silient Installation for IDS 11.70 FCx
/tmp/infinstall/ids_install -i silent -f /tmp/infinstall/silentProperties/installer.properties -DLICENSE_ACCEPTED=TRUE;
#installation log will be save automatically in INFORMIXDIR

echo "Server Silent installation Closed"
cd $currentDir
exit 0
