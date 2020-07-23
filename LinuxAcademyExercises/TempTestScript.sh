#!/bin/bash
# this is a basic script to show how to pass arguments through at the command line

# global variables start

NUMBER=$1
CORRECTNUMBER=4

# global variables end

# script start

if [ $NUMBER -eq $CORRECTNUMBER ];
then
	echo "Well Done You Picked the Correct number"
else
	echo "That was an incorrect pick, please re run the script and try again"
fi
# script end
