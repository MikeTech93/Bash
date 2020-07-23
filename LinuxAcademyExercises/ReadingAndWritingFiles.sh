#!/bin/bash
# simple script showing how to read and write to files using file descriptors 

# start script

echo "Enter a filename to read:"
read FILE

exec 5<>$FILE # This opens the file handle

while read -r SUPERHERO;
do
	echo "Superhero Name: $SUPERHERO"
done<&5

echo "File was read on `date`">&5

exec 5>&- # This closes the file handle
