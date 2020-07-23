#!/bin/bash
# simple script showing how an if/then/else statement works

# script start

clear
echo "Enter a number between 1 and 3"
read CHOICE

echo "You chose $CHOICE"

if [ $CHOICE -ge 1 2>/dev/null ] && [ $CHOICE -le 3 2>/dev/null ];
then
	echo "Well done you entered a number between 1 and 3"
else
	echo "you entered an incorrect value! please try again!"
fi

# script end
