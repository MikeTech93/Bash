#!/bin/bash
# Simple script demonstating error handling

clear
echo "Enter a directory to perform an ls -al on"
read DIR

cd $DIR 2>/dev/null

if [ "$?" = 0 ];
then
	echo "well done you changed to the correct directory"
else 
	echo "Can't change directories, exiting with an error and no listing"
	exit 111
fi
