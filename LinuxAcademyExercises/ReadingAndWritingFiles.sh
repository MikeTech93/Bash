#!/bin/bash
# simple script showing how to read and write to files using file descriptors 

# start script

echo "Enter a filename to read:"
read FILE

exec 5<>$FILE # This opens the file handle; using file descriptor 5 as 0,1,2 are all reserved so good practice to start at 5

while read -r SUPERHERO;
do
	echo "Superhero Name: $SUPERHERO"
done<&5 # This is where the file descriptor is read into the while loop

echo "File was read on `date`">&5 # This is adding a new line to the bottom of the file

exec 5>&- # This closes the file handle

# script end
