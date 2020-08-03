#!/bin/bash
# script to demonstrate how to use a simple input box, storing the users input in a tmpfile and reading it back

# global variables start

INPUTBOX=${INPUTBOX=dialog}
TITLE="Default"
MESSAGE="Something to display"
XCOORD=10
YCOORD=20

# global variables end

# function declarations start

# display the input box
funcDisplayInputBox () {
	$INPUTBOX --title "$1" --inputbox "$2" "$3" "$4" 2>tmpfile.txt

	# The data that dialog takes in (such as a string entered into a input box)
	# is normally returned on standard error. This is because dialog uses standard 
	# output to display text on the terminal when it is drawing the dialog box itself.
}

# function declarations stop

# script start

funcDisplayInputBox "Display File Name" "Which file in the current directory do you want to display?" "$XCOORD" "$YCOORD"

OUTPUT=`cat tmpfile.txt` # we cat tmpfile.txt as this is what our put is from the funcDisplayInputBox
rm tmpfile.txt

if [ -f $OUTPUT  ];
then
	clear && cat $OUTPUT
	
else
	clear && echo "The file $OUTPUT does not exist or can not be read"
fi

# script stop

