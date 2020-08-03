#!/bin/bash
# script to show how to use IFS and delimiting 

# start script

clear

echo "What Delimiter value would you like to use?"
read IFSVALUE

echo "What file would you like to parse?"
read FILE

IFS=$IFSVALUE

echo "The Delimter is now set to $IFS and we will start parsing $FILE"


while read -r CPU MEMORY DISK;
do
	echo "CPU: $CPU"
	echo "Memory: $MEMORY"
	echo "Disk: $DISK"
done<"$FILE"


