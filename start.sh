#!/bin/bash
#AUTHOR: AlphanetEX, execution for ROOT user
unset password 
unset user
unset pwx_0
unset pwx_1 
unset passw
unset directory
unset kernel_data[6]
unset tegra_version[3]
unset cpu_verstion
unset confirm
unset dateX
source /opt/tp/scripts/start.sh 1

Green='\033[0;32m'
Red='\033[0;31m'
Blue='\033[0;34m'
Cyan='\033[0;36m'
NC='\033[0m'



GlobalSwHwConf(){
    #tipo de procesador             
    kernel_data[0]=$(lscpu | sed -n 1p | sed -r 's/.*\ +(\w+).*/\1/')
    #tipo de sistema operativo 
    kernel_data[1]=$(uname -s)
    #version completa del kernel 
    kernel_data[2]=$(uname -r | sed -r 's/-[a-z]+//')
    #version partida del kernel 
    kernel_data[3]=$(uname -r | sed -r 's/([0-9]+.[0-9]+).*/\1/')
    #version del sistema operativo
    if [[ -e "/etc/lsb-release"  ]]; then   
    kernel_data[4]=$(cat /etc/lsb-release  | sed -n 2p | sed -r 's/.*([0-9][0-9]+\.[0-9]+).*/\1/')
    else
    kernel_data[4]=$(cat /etc/os-release | sed -n 4p | sed -r 's/.*([0-9][0-9])\ \(([a-z]+)\).*/\1 \2/')
    fi 
    #modelo del procesador
    #kernel_data[5]=$(cat /proc/cpuinfo | sed -n 5p)
    kernel_data[5]=$(cat /proc/cpuinfo | grep -P "model name" | sed -n 1p)

    printf "${Blue} Processor Architecture: ${Green} ${kernel_data[0]} \n"
    printf "${Blue} CPU Model:              ${Green} ${kernel_data[5]:13} \n"
    printf "${Blue} Operative Version:      ${Green} ${kernel_data[4]} \n"
    printf "${Blue} Kernel Version:         ${Green} ${kernel_data[2]} ${NC}\n"

}


# Seccion de validacion para la carga de dependencia tanto como de una SBC o Cloud 
VerifyKernelConf(){
    #tipo de procesador      
    kernel_data[0]=$(lscpu | sed -n 1p | sed -r 's/.*\ +(\w+).*/\1/')
    #tipo de sistema operativo 
    kernel_data[1]=$(uname -s)  

if [[ ${kernel_data[0]} == "x86_64" && ${kernel_data[1]} == "Linux" ]]; then
    printf "${Cyan} This is a AMD/INTEL X86-64 device ${NC} \n"
    
    GlobalSwHwConf

elif [[ ${kernel_data[0]} == "aarch64" && ${kernel_data[1]} == "Linux" ]]; then

    printf "${Cyan} This is a ARM-DEVICE ${NC}\n"
    #jetson AGX-X
    tegra_version[0]=$(cat /etc/nv_tegra_release | cut -d " " -f2 | sed -r 's/\w([0-9]+)/\1/')
    tegra_version[1]=$(cat /etc/nv_tegra_release | cut -d " " -f5 | sed -r 's/([0-9]+.[0-9]),/\1/')
    #version de las librerias de L4T(linux for tegra)
    tegra_version[2]="${tegra_version[0]}.${tegra_version[1]}"

    GlobalSwHwConf

    if [[ -f "/etc/nv_tegra_release" ]]; then
    printf "${Blue} Library of jetson L4T:  ${Green} ${tegra_version[2]}${NC} \n"
    fi
#si en caso no es detectado el tipo de procesador
elif [[ ${kernel_data[0]} == "unknown" || ${kernel_data[1]} == "Linux" ]]; then
    GlobalSwHwConf
    printf "${Red}Warning the CPU architecture was'nt recognized its possible of any building not works ${NC} \n"
else 
    printf "${Red}Warning this Operative System was not contenplated on this automatization ${NC} \n"
    #configuracion de la instalacion del driver RTC
    #configuracuon de la instalacion del driver de Mavlink 
    #desion de configuracion de de LVM 
    #Configuracion de instalacion de k8s
fi
}

PasswordHider() {
    echo -n "$1"
    password=""
    while IFS= read -r -n1 -s char; do
    case $char in
    $'\0') break;; #enter code
    $'\177')  #backspace code
    if [[ ${#password} -gt 0 ]]; then
        echo -ne "\b \b" #\b) borra el char \b) mueve el curso al anterior char
        password="${password:0:-1}" #expancion de substring
    fi
    ;;
    *)
        echo -n "*"
        password+="$char"
    ;;
    esac
    done
    echo -ne "\n"
}

CheckPasswdChain(){
    passwx=$1
    result=$(echo "$passwx" | cracklib-check | sed -r 's/[a-z]+:\ //')
    if [[ $result != "OK" ]]; then
    printf "${Cyan}Password with low special characters \n ${NC}"
    PasswordHider "ingress your new password:"
    passwx=$password
    CheckPasswdChain $passwx
    fi
}


valPasswd(){
    pwx_0=$1
    pwx_1=$2

    if [[ $pwx_0 != $pwx_1  ]]; then
    printf "${Red}Passwords do not match \n${NC}"
    PasswordHider "ingress your new password:" 
    pwx_0=$password
    CheckPasswdChain $pwx_0
    PasswordHider "repeat the new password:"  
    pwx_1=$password

    valPasswd $pwx_0 $pwx_1
    fi 
}



CreateUser(){
    #Generacion de Usuarios 
    read -p "User: " user
    PasswordHider "ingress your new password:"
    pwx_0=$password
    CheckPasswdChain $pwx_0
    PasswordHider "repeat the new password:"
    pwx_1=$password
    valPasswd $pwx_0 $pwx_1
    validate=$pwx_1
    directory="/home/$user/"

    data="$validate
    $validate
    #\n
    #\n
    #\n
    #\n
    #\n
    Y
    " 
    sudo -S sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' <<< $data | adduser $user >> general.log 
    usermod -aG sudo $user

    read -p "Desea crear otro usuario y/n?: " confirm
    if [[ $confirm == "y" || $confirm == "Y" ]]; then
        CreateUser
    fi

}

Menu(){
opcion=0
while : #: ecuals to true
do 
    #limpiar la pantalla 
    clear 
    #deplegar el menu de opciones
    echo "--------------------------------------------"
    echo "SRV-02TP - PROGRAMA DE ADMINISTACION DE SERVER"
    echo "--------------------------------------------"
    echo "              MENU PRINCIPAL                "
    echo "--------------------------------------------"

    echo "0. Salir"
    echo "1. Automatizacion de entorno de desarrollo"
    echo "2. Formateo de discos"

    #capture data
    
    read -n1 -p "ingrese una opcion [1-5]: " opcion 
    
    #validar la opcion ingresada 
    echo -e "\n"
    case $opcion in 
        
        1) PrinterLog 0 "Ejecutando packages.sh" "Instalando dependencias del servidor"
           bash $PWD/packages.sh
           PrinterLog 0 "Ejecutando disk_formatter.sh" "Formateando discos fisicos a formato RAID"
           bash $PWD/diskFormatter.sh 2 1
           PrinterLog 0 "Ejecutando conf_raid.sh" "Configurando RAID 1 + LVM, asignando montaje en FSTAB"
           bash $PWD/confRaid.sh
           PrinterLog 0 "Ejecutando lamp-conf.sh" "Configurando Apache2 + mysql para despliege de produccion"
           bash $PWD/lampConf.sh
           PrinterLog 0 "Ejecutando mailFireMonitor.sh" "Configurando dependencias de mail, crontab y firewall"
           bash $PWD/mailFireMonitor.sh
           Menu
           ;;
        2) bash $PWD/diskFormatter.sh 
           PrinterLog 0 "Ejecutando disk_formatter.sh" "Formateando discos"
           Menu 
           ;;
        0) echo "Salir"
           exit 0         #saliendose de la aplicacion
           ;;
    esac 
done

}



Main(){
#Caracteristicas del Sistema operativo
if [[ $1 != "1" ]]; then 
    VerifyKernelConf    
    #Creacion de usuarios
    read -p " Desea crear usuarios adicionales (y/n)?: " confirm
    if [[ $confirm == "y" || $confirm == "Y" ]]; then CreateUser ;fi

    Menu

fi
#terminar este bloque de ejecucion 
}

:<< '###BLOCK_COMMENT'
EL flag 1 en main indica que solo se necesitan las funciones de este script 
para importarse en otro script si en caso no llega el flag se ejecutara 
con las serie de funciones a ejecutar

###BLOCK_COMMENT


Main $1