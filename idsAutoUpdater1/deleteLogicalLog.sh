#!/bin/sh
# editted by Brigitta and Yingding on March.29.2010

#
#
echo `basename $0`
declare -i eins=1
StartNr=1
EndNr=1


echo "geben Sie die Anfangsnummer von logical file, die Sie löschen wollen. Mit [Enter] bestätigen"
echo "Die Anfangsnummer darf nicht kleiner als 1 sein"

read inStartNr

echo "geben Sie die Endnummer von logical file, die Sie löschen wollen. Mit [Enter] bestätigen"
echo "Die Endnummer darf nicht kleiner als Anfangsnummer sein, gleich ist erlaubt"

read inEndNr

#set -x

if [ -z $inStartNr ] || [ -z $inEndNr ];
then
echo "leer Eingabe von Anfangsnummer oder Endnummer"
exit 1

fi 

if [[ $inStartNr != [0-9]* ]] || [[ $inEndNr != [0-9]* ]];
then
echo "Anfangsnummer oder Endnummer ist nicht ein integerzahl groesser als 0"
exit 1
fi 

if [ $inStartNr -lt $eins  ] || [ $inStartNr -gt $inEndNr ];
then
echo "Falsch Angabe"
echo "Anfangsnummer kleiner 1 oder Endnummer kleiner als Anfangsnummer"
exit 1
fi

StartNr=$inStartNr
EndNr=$inEndNr

























while [ $StartNr -le $EndNr ]
do 
echo "LogNummer: $StartNr wird geloescht"
onparams -d -l $StartNr -y;





StartNr=`expr $StartNr + 1`


done 

echo ""
echo "Das Program ist erfolgreich beendet."
echo ""
echo "================================================================"
echo "Denken Sie daran ein level 0 Sicherung zu machen, damit die als <D> gekennzeichnet log file auch gelöscht werden können."
echo "Überprüfen Sie mit onstat -l als user informix nach dem level 0 Sicherung."
echo "Wenn ein log in use ist, kann es nicht gelöscht werden, löschen sie diesen log file in einem spätere Zeitpunkt."



