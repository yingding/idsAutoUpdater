#!/bin/sh
#
#
sh 01_preparing.sh;
sh 02_install.sh;
sh 03_postconfigIDSDB.sh;
sh 04_upgradingIDSDB.sh

echo "Upgrading IDS done"
echo "thanks for you advice to improve the migrator"

