#! /bin/bash
#
#  Alarm script for Informix.
#  Author: Bernhard Treutwein
#  Date: Juni, November 2002, Januar, Februar 2003, Juni 2004, Juli 2004
#
# Edited by Yingding Wang 15.05.2012
PATH=$PATH:$INFORMIXDIR/bin
export PATH

PROG=`basename $0`
USER_LIST=informix
#BACKUP_CMD="onbar -b -l"
EXIT_STATUS=0

EVENT_SEVERITY=$1
EVENT_CLASS=$2
EVENT_MSG="$3"
EVENT_ADD_TEXT="$4"
EVENT_FILE="$5"

#LOG_FILE=/backup/informix/tapedev/ltapedev
LOG_FILE=`oncheck -pr | grep " LTAPEDEV "`
LOG_FILE=${LOG_FILE/LTAPEDEV /}

TAPE_DIR=/backup/informix/tapedev/logical-logs
Mail=/usr/bin/Mail
PATH=$PATH:$INFORMIXDIR/bin
export PATH
#
# we want the following minimum number of free logs: 
#
#            40 is sufficient at diashow
#           250 is ok at diapers
#
NEED_FREE=25
#
# strip leading text from event message
#
COMPLETED=${EVENT_MSG#Logical Log }
#
# strip trailing text from event message
#
COMPLETED=${COMPLETED% Complete.}

BACKUP_LOGS=`onstat -l | grep U-B | wc | cut -c 1-8`
onstat -l >> /tmp/bla_bla.log
# bla_bla.log is a snapshot of current logical log status.
FREE_LOGS=`onstat -l | grep F-- | wc | cut -c 1-8`
let "FREE_LOGS += $BACKUP_LOGS"


if [ "0$EVENT_CLASS" -eq "23" ] ; then
     SUBJECT="$HOSTNAME: logfull_sh - ok, $FREE_LOGS logs free"
     if [ "$FREE_LOGS" -le "$NEED_FREE" ] ; then
        MY_MSG="A backup of the logical logs is needed"
	MyDATE=`date '+%Y.%m.%d-%H.%S'`
	LOCK_FILE=/tmp/ontape-running-`date '+%Y.%m.%d'`
	if [ -e $LOCK_FILE ] ; then
	    MY_MSG="Another ontape is running"
	 else
	   touch $LOCK_FILE
	   ONTAPE_OUT=`ontape -a << tape_end

n
tape_end`
	   ONTAPE_RES=$?
	   if [ "$ONTAPE_RES" -ne "0" ] ; then
	       SUBJECT="$HOSTNAME: ontape returned error - $ONTAPE_RES"
	       rm $LOCK_FILE
	     else
	       #
	       # following line gets the string "   nnn - mmm"
	       # from the output of ontape
	       #
	       ONTAPE_LOGS=`echo "$ONTAPE_OUT" | tail -3 | head -1`
	       #
	       # ${ONTAPE// /} strips blanks from the variable
	       # see Advanced Bash Scripting guide, Chap 9.2 (p. 92 of Revision 1.2)
	       #
	       TAPE_FILE=$TAPE_DIR/log_${ONTAPE_LOGS// /}_$MyDATE
               SUBJECT="$HOSTNAME: Automatic backup done. "
	       cp $LOG_FILE $TAPE_FILE 
	       if [ $? ] ; then
	          SUBJECT="$SUBJECT Logfile copied "
		  rm $LOCK_FILE
		  bzip2 $TAPE_FILE && cp /dev/null $LOG_FILE
		  if [ $? ] ; then 
	             SUBJECT="$SUBJECT and compressed."
		    else
	             SUBJECT="$SUBJECT but some errors compressing or zeroing out $LOG_FILE please check results else"	
		  fi
		 else
		  rm $LOCK_FILE
	          SUBJECT="$SUBJECT Some errors saving loglog tape, please check results else"
	       fi
	   fi
	fi
       else
        MY_MSG="There are enough logical logs left"
     fi
   else
     if [ "0$EVENT_SEVERITY" -le "2" ] ; then
         exit 0
       else
         SUBJECT="$3 - $4"
     fi
fi

$Mail -s "$SUBJECT" root  << END-INPUT

  $MY_MSG (number of free logs=$FREE_LOGS)


     PROG=$PROG
     Param \$1=$1
     Param \$2=$2
     Param \$3=$3
     Param \$4=$4
     USER_LIST=$USER_LIST
     EVENT_SEVERITY=$EVENT_SEVERITY
     EVENT_CLASS=$EVENT_CLASS
     EVENT_MSG=$EVENT_MSG
     EVENT_ADD_TEXT=$EVENT_ADD_TEXT
     EVENT_FILE=$EVENT_FILE
     
     Last Completed Log=$COMPLETED

     number of free logs=$FREE_LOGS

     ontape returned: $ONTAPE_RES
     
     ontape outputted: 
     "$ONTAPE_OUT"

     With double quotes: \$ONTAPE_LOGS="$ONTAPE_LOGS"
     Without double quotes: \$ONTAPE_LOGS=$ONTAPE_LOGS
     \$LOG_FILE=$LOG_FILE
     \$TAPE_DIR=$TAPE_DIR
     \$TAPE_FILE=$TAPE_FILE
     \$LOCK_FILE=$LOCK_FILE
     
     SUBJECT=$SUBJECT
     
     SHELL=$SHELL
     
     PATH=$PATH
     
     INFORMIXDIR=$INFORMIXDIR
     ONCONFIG=$ONCONFIG
END-INPUT

exit 0

