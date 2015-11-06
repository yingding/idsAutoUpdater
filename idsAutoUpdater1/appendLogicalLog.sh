#!/bin/sh
# editted by Brigitta and Yingding on March.29.2010

#
#
DBSPACE=rootdbs
SIZE=20000
ANZAHL=0

echo "geben Sie die DBSPACE NAME für die zu erweiterte logical log files ein. Mit [Enter] bestätigen"

read inDBSPACE

echo "geben Sie die Größe in Byte von die zu erweiterte logical log file ein. Mit [Enter] bestätigen"

read inSIZE



echo "geben Sie die Anzahl von die zu erweiterte logical log file ein. Mit [Enter] bestätigen"
read inANZAHL

#set -x

if [ -z  $inDBSPACE ] || 
 [ -z $inSIZE ] || [ -z $inANZAHL ];
then
echo "falsche Eingaben"
echo "Default is"
echo "DBSPACE =: $DBSPACE"
echo "SIZE(KB)=: $SIZE"
echo "ANZAHL  =: $ANZAHL" 

else
DBSPACE=$inDBSPACE
SIZE=$inSIZE
ANZAHL=$inANZAHL

fi

#set +x

durchlauf=0
while [ $ANZAHL -gt $durchlauf ]
do 
onparams -a -d $DBSPACE -s $SIZE;
#  -i is the option for add logfile after the current used logical log file, is not needed here is the option for add logfile after the current used logical log file, is not needed here.

echo "Durchlauf nummer : $durchlauf"


durchlauf=`expr $durchlauf + 1`


done 


echo "Erfolgreich beendet"


