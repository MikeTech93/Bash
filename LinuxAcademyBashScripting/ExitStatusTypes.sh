#!/bin/bash
# this is a script demonstrating how to use Exit Status Types

# start function definitions 

funcCheckExitStatus () {
	
	EXITSTATUS=$?
	
	echo "The Exit Status of the previous command was $EXITSTATUS"

	if [ $EXITSTATUS -eq 0 ]
		then 
	                echo "This means the previous statement ran succesfully as the ExitStatus was $EXITSTATUS"
        	else
                	echo "This means some issues were found as the ExitStatus was $EXITSTATUS"
	fi
}

# end function definitions

# start script

clear

echo "Adding 10 + 10"

expr 10 + 10

funcCheckExitStatus


echo "Removing file FileDoesNotExist.txt"

rm FileDoesNotExist.txt

funcCheckExitStatus


echo "Adding 20 + 20"

expr 20 + 20

funcCheckExitStatus

# end script
