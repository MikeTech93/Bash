#!/bin/bash

# small script to how how to use Arrays 

# global variables start

SERVERLIST=("Server1" "Server2" "Server3" "Server4")

# global variables end


# start script"

COUNT=0
 
for INDEX in ${SERVERLIST[@]}; do

  echo "Processing Server: ${SERVERLIST[COUNT]}"

  COUNT="`expr $COUNT + 1`"

done

# end sript
