#!/bin/bash
# simple demo of an input dialog box

# global variables / default values
INPUTBOX=${INPUTBOX=dialog}
TITLE="Default"
MESSAGE="Something to display"
XCOORD=10
YCOORD=20

# function declarations start

# display the input box
funcDisplayInputBox () {
	$INPUTBOX --title "$1" --inputbox "$2" "$3" "$4" 2>tmpfile.txt
}

# function declarations stop

# script start

funcDisplayInputBox "Display File Name" "Which file in the current directory do yo uwant to display?" "10" "20"

if [ "`cat tmpfile.txt`" != "" ];
	then
		clear && cat "`cat tmpfile.txt`"
		rm tmpfile.txt
	else
		clear && echo "Nothing to do"
		rm tmpfile.txt
fi

# script stop

