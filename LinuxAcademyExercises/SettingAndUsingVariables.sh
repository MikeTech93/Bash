#!/bin/bash

clear

STARTOFSCRIPT=$(date -u)

echo "This script shows how to set variables"
echo "======================================"

MYUSERNAME="Mike"
MYPASSWORD="Password123"

echo ""
echo "MYUSERNAME variable = $MYUSERNAME"
echo "MYPASSWORD variable = $MYPASSWORD"
echo "The time the script started was $STARTOFSCRIPT"

ENDOFSCRIPT=$(date -u)

echo "The time the script ended was $ENDOFSCRIPT"
echo ""

