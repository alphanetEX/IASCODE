#!/bin/bash
source /opt/tp/scripts/general_print.sh
#recorrido de apache2, mysqld, mdadm, lvm
SERVICE=$1 
# agregar una negacion con if de corchetes 
if ! pgrep -x "$SERVICE" > /dev/null 
then
    PrinterLog 2 "Monitor" "el proceso ${SERVICE} no se esta ejecutando"
fi