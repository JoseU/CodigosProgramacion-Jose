#!/bin/sh

#  postcheck.sh
#  Lili
#
#  Copyright (c) 2012 LogMeIn. All rights reserved.
#
#  Runs as the current user

LOGFILE=$1
exec 2>&1 # >>$LOGFILE   We do not need this anymore, script runners capture script outputs

BUNDLEPATH=$2
ROOTPATH=$3

echo "postcheck: started with file $FILELIST on path $ROOTPATH and bundlepath $BUNDLEPATH"
echo "current uid=${UID}, euid=${EUID}, user=${USER}"

echo "postcheck: finished"

# return 0 in case of success
# return 253 in case of success but signal user logoff required to finalize install
# return 254 in case of success but signal OS restart required to finalize install
# return 255 or a negative value in case of errors

exit 0
