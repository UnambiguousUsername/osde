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
        l) readonly directory_path="$(dirname $(readlink -f "${0}"))";;
        v) verbose=true;;
        *) echo 'Unknown flags supplied.';;
    esac
done

log_file_path="${directory_path}/project_setup.log"
venv_path="${directory_path}/venv/"
venv_source_path="${venv_path}/bin/activate"

# printf function so i dont need to type newline for every string
say(){
    { date +"%F %T" | tr -d "\n"; printf " - $1\n"; }
}

# check for sudo privilege
say 'Checking for su.'
sudo true && say 'Nice.' || say 'Su privilege is necessary for me to work, bye.' && exit 1

# create log file
if [ -v log_file_path ]; then
    if [ ! -f "${log_file_path}" ]; then
        touch "${log_file_path}" &> /dev/null &&
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
    apt-get install -y python3.10 &> /dev/null
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
    apt-get install python3-pip &> /dev/null
    if command -v pip &> /dev/null; then
        [[ "${verbose}" = true ]] && say 'Pip was installed.'
        [[ "${log}" = true ]] && say 'Pip was installed.' >> "${log_file_path}"
    else
        [[ "${verbose}" = true ]] && say 'Failed to install Pip.'
        [[ "${log}" = true ]] && say 'Failed to install Pip.' >> "${log_file_path}"
    fi
fi

# check for postgresql
if command -v psql &> /dev/null; then
    [[ "${verbose}" = true ]] && say 'Postgresql is installed.'
    [[ "${log}" = true ]] && say 'Postgresql is installed.' >> "${log_file_path}"
else
    [[ "${verbose}" = true ]] && say 'Installing Postgresql.'
    [[ "${log}" = true ]] && say 'Installing Postgresql.' >> "${log_file_path}"
    apt-get install -y postgresql &> /dev/null
    if command -v psql &> /dev/null; then
        [[ "${verbose}" = true ]] && say 'Postgresql was installed.'
        [[ "${log}" = true ]] && say 'Postgresql was installed.' >> "${log_file_path}"
    else
        [[ "${verbose}" = true ]] && say 'Failed to install Postgresql.'
        [[ "${log}" = true ]] && say 'Failed to install Postgresql.' >> "${log_file_path}"
    fi
fi


# check for venv directory
if [ -d "${venv_path}" ]; then
    [[ "${verbose}" = true ]] && say 'Venv directory found.'
    [[ "${log}" = true ]] && say 'Venv directory found.' >> "${log_file_path}"
else
    [[ "${verbose}" = true ]] && say 'Creating venv directory.'
    [[ "${log}" = true ]] && say 'Creating venv directory.' >> "${log_file_path}"
    mkdir "${venv_path}" &> /dev/null
    if [ -d "${venv_path}" ]; then
        [[ "${verbose}" = true ]] && say 'Venv directory created.'
        [[ "${log}" = true ]] && say 'Venv directory created.' >> "${log_file_path}"
    else
        [[ "${verbose}" = true ]] && say 'Failed to create venv directory. Exiting.'
        [[ "${log}" = true ]] && say 'Failed to create venv directory. Exiting.' >> "${log_file_path}"
        exit 1
    fi
fi

# check for venv
if [ -d "${venv_source_path}" ]; then
    [[ "${verbose}" = true ]] && say 'Venv found.'
    [[ "${log}" = true ]] && say 'Venv found.' >> "${log_file_path}"
else
    [[ "${verbose}" = true ]] && say 'Creating venv.'
    [[ "${log}" = true ]] && say 'Creating venv.' >> "${log_file_path}"
    python3 -m venv "${venv_path}" &> /dev/null
    if [ -d "${venv_source_path}" ]; then
        [[ "${verbose}" = true ]] && say 'Venv created.'
        [[ "${log}" = true ]] && say 'Venv created.' >> "${log_file_path}"
    else
        [[ "${verbose}" = true ]] && say 'Failed to create venv. Exiting.'
        [[ "${log}" = true ]] && say 'Failed to create venv. Exiting.' >> "${log_file_path}"
        exit 1
    fi
fi

# switch to venv
source "${venv_source_path}" &> /dev/null
if command -v python3 | grep "${venv_source_path}" &> /dev/null; then
    [[ "${verbose}" = true ]] && say 'Switch to venv successful.'
    [[ "${log}" = true ]] && say 'Switch to venv successful.' >> "${log_file_path}"
else
    [[ "${verbose}" = true ]] && say 'Switch to venv failed. Exiting.'
    [[ "${log}" = true ]] && say 'Switch to venv failed. Exiting.' >> "${log_file_path}"
    exit 1
fi

# check for apache airflow
if command -v airflow &> /dev/null; then
    [[ "${verbose}" = true ]] && say 'Apache Airflow is installed.'
    [[ "${log}" = true ]] && say 'Apache Airflow is installed.' >> "${log_file_path}"
else
    [[ "${verbose}" = true ]] && say 'Installing Apache Airflow.'
    [[ "${log}" = true ]] && say 'Installing Apache Airflow.' >> "${log_file_path}"
    python3 -m pip install apache-airflow &> /dev/null
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

deactivate
say 'fin'