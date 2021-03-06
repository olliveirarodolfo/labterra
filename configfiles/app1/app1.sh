#!/bin/bash

# install and config Apache
#repeated lines to solve a azure ubuntu repo problem
/usr/bin/apt-get update -y
touch /tmp/f1
/usr/bin/apt update -y
touch /tmp/f2
/usr/bin/apt-get update -y
touch /tmp/f3
/usr/bin/apt update -y
touch /tmp/f4

sleep 3
/usr/bin/apt-get -f install apache2 php libapache2-mod-php -y

a2enmod rewrite

# configure site app2
rm /etc/apache2/sites-available/000-default.conf
rm /var/www/html/index.*
rm /var/www/html/.htaccess

if [[ ! -f /etc/apache2/sites-available/000-default.conf ]] || [[ ! -f /var/www/html/index.php ]] || [[ ! -f /var/www/html/.htaccess ]]
then
/usr/bin/wget https://raw.githubusercontent.com/olliveirarodolfo/labterra/main/configfiles/app1/000-default.conf -O /etc/apache2/sites-available/000-default.conf 
/usr/bin/wget https://raw.githubusercontent.com/olliveirarodolfo/labterra/main/configfiles/app1/index.php -O /var/www/html/index.php
/usr/bin/wget https://raw.githubusercontent.com/olliveirarodolfo/labterra/main/configfiles/app1/htaccess -O /var/www/html/.htaccess
fi

systemctl restart apache2.service

touch /tmp/teste
exit 0