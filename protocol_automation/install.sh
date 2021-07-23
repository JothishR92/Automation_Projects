#!/bin/sh
./environment_variable.sh
var=$PROTOCOL_NAME
if [ $var == "cifs" ]
then
        robot protocols/cifs/server/protocol_servers.robot
elif [ $var == "sftp" ]
then
        echo "this is not equal"

fi

