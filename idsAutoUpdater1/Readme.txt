/++++++++++++
/+Autor Yingding Wang, Anwendungsbetreuung , 30.Juni.2010
/++++++++++++


Um diese AutoInstaller zu Benutzen müssen

1. die Datei profile_local.tmp,sqlhosts.tmp, onconfig.tmp, AutoBackup.tmp, informix_startup.tmp anpassen. 

Es ist nicht notwendig die Portsnummer oder Datenbank Server nummer anzugeben, für ein Instanz installation wird die Datenbank port nummer und Datenbank Server name automatisch angepasst und erzeugt durch 01_preconfigIDSDB.sh skript
Meistens wird nur profile_local.tmp und onconfig.tmp angepasst

2. die Datei myServer.ini anpassen

Für die automatisch installation ausgeführt be 02_install.sh skript wird ein vordefiniert installationsprofile z.B. myServer.ini eingelesen. Diese myServer.ini ist während letzten gültige installation mit Befehl: "./ids_install -gui -record myServer.ini" erzeugt werden. Diese Datei kann angepasst werden oder durch neu myServer.ini ersetzt werden.

3. die Datei 04_postinstall.sh anpassen

In diesem Datei wird die Chunksize für tempdb, userdb und anderen festgelegt. Es kann auch entsprechend angepasst werden.

4. die Datei 01_preconfigIDSDB.sh anpassen

Sie können den Parameter INFORMIXHOME entsprechende anpassen, das ist das Physikalsiche Ordner, wo alles source installiert werden.
Verändern Sie auf keinen Fall den Parameter INFORMIXDIR, es ist das informixhome.
Wenn Sie nicht sicher, dann ändernen Sie nichts weiteres außer INFORMIXHOME

Sie können auch neu IDS Server source in idsAutoInstaller Verzeichnis reinkopieren, die bereits vorhandelne xxxx.tar datei ersetzten. Achten Sie darauf dass es immer nur ein xxx.tar als installationssource in idsAutoInstaller vorhandeln ist. Der installationsskript 01_preconfigIDSDB.sh sucht die einzige xxx.tar datei und entpackt es automatisch.
   
5. Automatisch installieren
Nach dem Anpassung von 1-4 , führen sie als root den Befehl: "sh run_ids_installer" aus.

6 Manuell Ausführung in problemfall.
Fall die Schritt 5 Autoinstall ist auf Fehler gelaufen, es wird abgebrochen.
Sie können die skripte 01_preconfigIDSDB.sh, 02_install.sh, 03_postconfigIDSDB.sh, 04_postinstall.sh manuell in der Reihenfolgen ausführen.

7 Verifizierung
Nach dem Schritt 5 wird ein Instanz von DB Server automatisch hoch gefahren, kontrollieren Sie die zustand.

8 Admin Skript / Admin Tool

Es wird in /backup/configurations/administration/ Ordner administrationsskript abgelagert.
Führen Sie als root backupconfigIDSDB.sh aus um die wichtige Configurationsdatei von Server zu sichern
Führen Sie als root appendLogicalLog.sh aus um die anzahl von logical log zu erhöhen.
Führen Sie als root deleteLogicalLog.sh aus um die entsprechend logical log zu löschen.
nach dem löschen von logical log ist meistens ein level0 sicherung erforderlich.

