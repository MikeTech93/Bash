#!/bin/bash
# demo of a simple info box with dialog and ncurses

# global variables / default values

INFOBOX=${INFOBOX=dialog}
TITLE="Default"
MESSAGE="Something to say"
XCOORD=10
YCOORD=20

# function declarations start

# display the infobox and our message

funcDisplayInfoBox () {
	$INFOBOX --title "$1" --infobox "$2" "$3" "$4"
	sleep "$5"
}

# function declarations - stop

# script start

if [ "$1" == "shutdown" ];
	then
		funcDisplayInfoBox "WARNING!" "We are SHUTTING DOWN the system…" "11" "21" "5"
		echo "Shutting Down!"
		# shutdown command here
	else
		funcDisplayInfoBox "Informaton…" "You are not doing anything fun…" "11" "21" "5"
		echo "Not Doing anything…"
fi

# script stop
