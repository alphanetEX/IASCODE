#!/bin/bash

Green='\033[0;32m'
Yellow='\033[0;33m'
Red='\033[0;31m'
Blue='\033[0;34m'
Cyan='\033[0;36m'
NC='\033[0m'


function PrinterLog {
    #codigo de procedimientos 
    if [[ $1 == 0 ]]; then
        dateX=$(date +"%H:%M:%S")
        message=$(printf "${dateX} - ${Blue}$2 |${Cyan} $3 ${NC}\n")
        printf "${message}\n"; printf "${message}\n" >> general.log
    #codigos de backups 
    elif [[ $1 == 1 ]]; then 
        dateX=$(date +"%H:%M:%S")
        message=$(printf "${dateX} - ${Blue}$2 |${Green} $3 ${NC}\n")
        printf "${message}\n"; printf "${message}\n" >> general.log 
    #codigos de monior
    elif [[ $1 == 2 ]]; then 
        dateX=$(date +"%H:%M:%S")
        message=$(printf "${dateX} - ${Blue}$2 |${Yellow} $3 ${NC}\n")
        printf "${message}\n"; printf "${message}\n" >> general.log 
    #codigos de error 
    elif [[ $1 == 3 ]]; then
        dateX=$(date +"%H:%M:%S")
        message=$(printf "${dateX} - ${Blue}$2 |${Red} $3 ${NC}\n")
        printf "${message}\n"; printf "${message}\n" >> general.log 
    fi
}


