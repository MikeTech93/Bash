#!/bin/bash
# script demonstration how to perform a "for" statement

# script start

echo "List all the shell scripts contents of the current directory"

SHELLSCRIPTS=`ls *.sh`

for SCRIPT in $SHELLSCRIPTS;
do
	DISPLAY="`cat $SCRIPT`"
	echo "File:$SCRIPT -Contents $DISPLAY"
done

# script end
