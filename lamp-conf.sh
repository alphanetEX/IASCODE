#!/bin/bash
#AUTHOR: AlphanetEX, APACHE2 + MYSQL CONFIGURATION
apache_conf="/etc/apache2/sites-available/"
#read .env file it works 
[ ! -f .env ] || export $(grep -v '^#' .env | xargs)

if [[ ! -d /u01 ]]; then
mkdir /u01
fi

if [[ ! -d /u02 ]]; then
mkdir /u02
fi

#cloando el proyecto de github
cd /opt/tp/scripts/
git clone https://github.com/pabloniklas/computacionaplicada.git
cd computacionaplicada/ 
cp db.sql ../
cp index.html ../

#creacion y configuracion de permisos y rutas de apache2
mkdir /u01/proyect-x/
sudo chmod -R 755 /u01/
chown -R root:www-data /u01

cp /var/www/html/index.html /u01/proyect-x/
cd /etc/apache2/sites-available/ 
cp 000-default.conf deployx.conf

#apache configurations 
sed -i '19c\ \n' $apache_conf/deployx.conf
sed -i -e "12s/.*/        DocumentRoot \/u01\/proyect-x/" deployx.conf
sed -i -e "14s/.*/    <Directory \/u01\/proyect-x>/" deployx.conf
sed -i -e "15s/.*/        Options\ FollowSymLinks/" deployx.conf
sed -i -e "16s/.*/        AllowOverride\ None/" deployx.conf
sed -i -e "17s/.*/        Require\ all\ granted/" deployx.conf
sed -i -e "18s/.*/    <\/Directory>/" deployx.conf

a2dissite 000-default.conf 
a2ensite deployx.conf

#systemctl reload apache2
/etc/init.d/apache2 restart

# Automatization for mysql_secure_installation script
sudo mysql --user=root --password=${PASS_MYSQL_ROOT} << EOFMYSQLSECURE
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.db WHERE Db='test' OR Db='test_%';
FLUSH PRIVILEGES;
EOFMYSQLSECURE

# Note down this password. Else you will lose it and you may have to reset the admin password in mySQL
echo -e "SUCCESS! MySQL password is: ${PASS_MYSQL_ROOT}" 

#montar pagina web en apache 




#establecer permisos de un usuario sudo 
#creacion y configuracion de permisos y rutas de mysql 
chown -R mysql:mysql /u02 
systemctl stop mysql
cp -R -p /var/lib/mysql/* /u02
cd /etc/mysql/mysql.conf.d/ 
sed -i -e "32s/.*/datadir         = \/u02/" mysqld.cnf
systemctl start mysql

#importacion de base de datos a mysql


#$passw | sudo -S mysql -u root -p ${PASS_MYSQL_ROOT} < db.sql 
mysql -u root -p ${PASS_MYSQL_ROOT} < db.sql 