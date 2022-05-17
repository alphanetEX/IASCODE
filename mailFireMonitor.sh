#!/bin/bash 
#config this file for monitor and mail dependencies 
source /opt/tp/scripts/start.sh 1

#creacion de los folderes de mutt
if [[ ! -d ~/.mutt ]]; then 
    mkdir -p ~/.mutt/cache/headers
    mkdir ~/.mutt/cache/bodies
    touch ~/.mutt/certificates
    touch ~/.mutt/muttrc
fi

function mailConf {
    read -p "Ingrese su Correo electronico(gmail): " email
    read -p "Ingrese su nombre de Mail: " namemail
    read -p "Ingrese el mail destinatario de los logs: " destemail
    echo "DESTEMAIL=${destemail}" >> .env
    Password_Hider "ingrese la contrasenia del correo: " 
    pwx_0=$password

cat <<EOF >> ~/.mutt/muttrc
set ssl_starttls=yes
set ssl_force_tls=yes
 
set imap_user = '$email'
set imap_pass = '$pwx_0'
 
set from='$email'
set realname='$namemail'
 
set folder = imaps://imap.gmail.com/
set spoolfile = imaps://imap.gmail.com/INBOX
set postponed="imaps://imap.gmail.com/[Gmail]/Drafts"
 
set header_cache = "~/.mutt/cache/headers"
set message_cachedir = "~/.mutt/cache/bodies"
set certificate_file = "~/.mutt/certificates"
 
set smtp_url = 'smtps://$email:$pwx_0@smtp.gmail.com:465/'
 
set move = no
set imap_keepalive = 900 
EOF


}

mailConf



# cat <<EOF >> var/spool/cron/crontabs/root
# 00 11 * * * /opt/tp/scripts/backup_full.sh BackupA
# 00 11 * * 0 /opt/tp/scripts/backup_full.sh BackupB 
# EOF


#seccion de monitoreo 


#seccion de iptables