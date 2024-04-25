#!/bin/bash

help="Purpose: Run this file to set up everything needed for this project.

Options:      
    -h      Print info on this script.
    -l      Log output to a file (in the same directory as this script).
    -m      Output missing packages/software.
    -v      Print out informational messages during execution.
"

while getopts h option
do
    case $option in
        h) echo "$help"; exit 0;;
        *) echo "Unknown flags supplied.";;
    esac
done

echo "fin"