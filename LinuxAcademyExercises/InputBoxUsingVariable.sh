#!/bin/bash
# script to demonstrate how to use a simple input box, storing the users input in a variable and reading it
# back without the need of a tmpfile

# global variables start

INPUTBOX=${INPUTBOX=dialog}
TITLE="Default"
MESSAGE="Something to display"
XCOORD=10
YCOORD=20

# Duplicate file descriptor 1 on descriptor 3
exec 3>&1

# global variables end

# function declarations start

# display the input box
funcDisplayInputBox () {
        $INPUTBOX --title "$1" --inputbox "$2" "$3" "$4" 2>&1 1>&3

        # The data that dialog takes in (such as a string entered into a input box)
        # is normally returned on standard error. This is because dialog uses standard
        # output to display text on the terminal when it is drawing the dialog box itself.
}

# function declarations end

# script start

OUTPUT=`funcDisplayInputBox "Display File Name" "Which file in the current directory do you want to display?" "$XCOORD" "$YCOORD"`

# close file descriptor 3
exec 3>&-

if [ -f $OUTPUT  ];
then
        clear && cat $OUTPUT

else
        clear && echo "The file $OUTPUT does not exist or can not be read"
fi

# script end
