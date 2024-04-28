#!/bin/bash

# help output
help="Purpose: Run this file to set up everything needed for this project, with su privileges.

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
        *) echo 'Unknown flags supplied.';;
    esac
done 

# printf function so i dont need to type newline for every string
say(){
    printf "$1\n"
}

# check for sudo privilege
say 'Checking for su.'
sudo true && say 'Nice.' || say 'Su privilege is necessary for me to work, bye.' && exit 1

# create log file
if [ -v log_file_path ]; then
    if [ ! -f "${log_file_path}" ]; then
        touch "${log_file_path}" &&
            [[ "${verbose}" = true ]] && say 'Created log file.' && log=true ||
            [[ "${verbose}" = true ]] && say 'Unable to create log file.' && log=false
    else
        [[ "${verbose}" = true ]] && say 'Log file already exists.' && log=true
    fi
else
    log=false
fi

# clear log file
[[ "${log}" = true ]] && printf '' > "${log_file_path}"

# check for python
if command -v python3 &> /dev/null; then
    [[ "${verbose}" = true ]] && say 'Python3 is installed.'
    [[ "${log}" = true ]] && say 'Python3 is installed.' >> "${log_file_path}"
else
    [[ "${verbose}" = true ]] && say 'Installing Python3.'
    [[ "${log}" = true ]] && say 'Installing Python3.' >> "${log_file_path}"
    apt-get install -y python3.10
    if command -v python3 &> /dev/null; then
        [[ "${verbose}" = true ]] && say 'Python3 was installed.'
        [[ "${log}" = true ]] && say 'Python3 was installed.' >> "${log_file_path}"
    else
        [[ "${verbose}" = true ]] && say 'Failed to install Python3.'
        [[ "${log}" = true ]] && say 'Failed to install Python3.' >> "${log_file_path}"
    fi
fi

# check for pip
if command -v pip &> /dev/null; then
    [[ "${verbose}" = true ]] && say 'Pip is installed.'
    [[ "${log}" = true ]] && say 'Pip is installed.' >> "${log_file_path}"
else
    [[ "${verbose}" = true ]] && say 'Installing Pip.'
    [[ "${log}" = true ]] && say 'Installing Pip.' >> "${log_file_path}"
    apt-get install python3-pip
    if command -v pip &> /dev/null; then
        [[ "${verbose}" = true ]] && say 'Pip was installed.'
        [[ "${log}" = true ]] && say 'Pip was installed.' >> "${log_file_path}"
    else
        [[ "${verbose}" = true ]] && say 'Failed to install Pip.'
        [[ "${log}" = true ]] && say 'Failed to install Pip.' >> "${log_file_path}"
    fi
fi

# check for venv


# check for postgresql
if command -v psql &> /dev/null; then
    [[ "${verbose}" = true ]] && say 'Postgresql is installed.'
    [[ "${log}" = true ]] && say 'Postgresql is installed.' >> "${log_file_path}"
else
    [[ "${verbose}" = true ]] && say 'Installing Postgresql.'
    [[ "${log}" = true ]] && say 'Installing Postgresql.' >> "${log_file_path}"
    apt-get install -y postgresql
    if command -v psql &> /dev/null; then
        [[ "${verbose}" = true ]] && say 'Postgresql was installed.'
        [[ "${log}" = true ]] && say 'Postgresql was installed.' >> "${log_file_path}"
    else
        [[ "${verbose}" = true ]] && say 'Failed to install Postgresql.'
        [[ "${log}" = true ]] && say 'Failed to install Postgresql.' >> "${log_file_path}"
    fi
fi

# check for apache airflow
if command -v airflow &> /dev/null; then
    [[ "${verbose}" = true ]] && say 'Apache Airflow is installed.'
    [[ "${log}" = true ]] && say 'Apache Airflow is installed.' >> "${log_file_path}"
else
    [[ "${verbose}" = true ]] && say 'Installing Apache Airflow.'
    [[ "${log}" = true ]] && say 'Installing Apache Airflow.' >> "${log_file_path}"
    python3 -m pip install apache-airflow
    if command -v airflow &> /dev/null; then
        [[ "${verbose}" = true ]] && say 'Apache Airflow was installed.'
        [[ "${log}" = true ]] && say 'Apache Airflow was installed.' >> "${log_file_path}"
    else
        [[ "${verbose}" = true ]] && say 'Failed to install Apache Airflow.'
        [[ "${log}" = true ]] && say 'Failed to install Apache Airflow.' >> "${log_file_path}"
    fi
fi

# postgresql setup


# apache airflow setup


say 'fin'