#!/bin/bash

# install and config Apache
apt-get update -y
sleep 3
apt-get -f install apache2 php libapache2-mod-php -y

a2enmod rewrite

# configure site app2
rm /etc/apache2/sites-available/000-default.conf
rm /var/www/html/index.*
rm /var/www/html/.htaccess

if [[ ! -f /etc/apache2/sites-available/000-default.conf ]] || [[ ! -f /var/www/html/index.php ]] || [[ ! -f /var/www/html/.htaccess ]]
then
/usr/bin/wget https://raw.githubusercontent.com/olliveirarodolfo/labterra/main/configfiles/app2/000-default.conf -O /etc/apache2/sites-available/000-default.conf 
/usr/bin/wget https://raw.githubusercontent.com/olliveirarodolfo/labterra/main/configfiles/app2/index.php -O /var/www/html/index.php 
/usr/bin/wget https://raw.githubusercontent.com/olliveirarodolfo/labterra/main/configfiles/app2/htaccess -O /var/www/html/.htaccess
fi

systemctl restart apache2.service
exit 0