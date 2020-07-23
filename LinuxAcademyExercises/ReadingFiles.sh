#!/bin/bash
# simple script to read files

# script start

echo "Enter a filename to read:"
read FILE

while read -r SUPERHERO;
do
	echo "Superhero Name: $SUPERHERO"
done < "$FILE"

# script end
