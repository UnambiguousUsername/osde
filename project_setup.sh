#!/bin/bash

# help output
help="Purpose: Run this file to set up everything needed for this project.

Options:      
    -h      Print info about this script.
    -l      Log output to a file (in the same directory as this script).
    -v      Print out informational messages during execution.
"

# look at supplied arguments
while getopts hlv option
do
    case $option in
        h) echo "${help}"; exit 0;;
        l) readonly log_file_path="$(dirname $(readlink -f "${0}"))/project_setup.log";;
        v) verbose=true;;
        *) echo "Unknown flags supplied.";;
    esac
done

# printf function so i dont need to type newline for every string
say(){
    printf "$1\n"
}

# create log file
if [ -v log_file_path ]; then
    if [ ! -f "${log_file_path}" ]; then
        touch "${log_file_path}" &&
            [[ "${verbose}" = true ]] && say "Created log file." && log=true ||
            [[ "${verbose}" = true ]] && say "Unable to create log file." && log=false
    else
        [[ "${verbose}" = true ]] && say "Log file already exists." && log=true
    fi
else
    log=false
fi

# clear log file
[[ "${log}" = true ]] && printf "" > "${log_file_path}"

# check for python
if command -v python3 &> /dev/null; then
    [[ "${verbose}" = true ]] && say "Python3 is installed."
    [[ "${log}" = true ]] && say "Python3 is installed." >> "${log_file_path}"
else
    [[ "${verbose}" = true ]] && say "Installing Python3."
    [[ "${log}" = true ]] && say "Installing Python3." >> "${log_file_path}"
fi

printf "fin"