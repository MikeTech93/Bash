#!/bin/bash
# simple script to demonstrate a while loop

# script start

clear
echo "This script will loop through a Hello World statement x number of times"
echo "Please enter how many times you would like it to loop through"
read NUMBER

COUNT=1

while [ $COUNT -le $NUMBER ];
do
	echo "Hello World $COUNT"
	COUNT="`expr $COUNT + 1`"
done

# script end

