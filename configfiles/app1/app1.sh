#!/bin/bash

# install apache
apt update
apt install apache2 -y
apt install php libapache2-mod-php -y

# configure site app2
rm /etc/apache2/sites-available/000-default.conf
rm /var/www/html/index.*

if [[ ! -f /etc/apache2/sites-available/000-default.conf ]] || [[ ! -f /var/www/html/index.php ]]
then
/usr/bin/wget https://raw.githubusercontent.com/olliveirarodolfo/labterra/main/configfiles/app2/000-default.conf -O /etc/apache2/sites-available/000-default.conf 
/usr/bin/wget https://raw.githubusercontent.com/olliveirarodolfo/labterra/main/configfiles/app2/index.php -O /var/www/html/index.php 
fi

systemctl restart apache2.service
exit 0