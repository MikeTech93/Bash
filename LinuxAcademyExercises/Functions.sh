#!/bin/bash
# simple demonstration on how to use functions

# function definitions start

funcHelloWorld () {
	echo "Hello World from the Function"
}

# function definitions end

# script start

clear
echo "Hello world from a standard echo statement"
funcHelloWorld

# script end
