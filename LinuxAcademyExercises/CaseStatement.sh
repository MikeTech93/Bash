#!/bin/bash
# simple 3 choice menu created using a case statement

# script start

clear
echo "====================="
echo "==== MENU SYSTEM ===="
echo "1) Echo Hello World"
echo "2) Echo Hello World 2"
echo "3) Echo Hello World 3"
echo ""
echo "Please enter your choice from menu selection above"
read CHOICE

case $CHOICE in
	1) echo "Hello World";;
	2) echo "Hello World2";;
	3) echo "Hello World3";;
	*) echo "You entered an incorrect choice";;
esac

# script end
