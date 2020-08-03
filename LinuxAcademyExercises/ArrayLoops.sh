#!/bin/bash
# script to show how to set and loop through an array of items 

# global variables start

SERVERLIST=("Server1" "Server2" "Server3" "Server4")

# global variables end

# start script"

COUNT=0
 
for INDEX in ${SERVERLIST[@]}; 
do
	echo "Processing Server: ${SERVERLIST[COUNT]}"
	COUNT="`expr $COUNT + 1`"
done

# end sript
