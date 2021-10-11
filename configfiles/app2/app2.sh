#!/bin/bash

# install apache
apt update
apt install apache2 -y
apt install php libapache2-mod-php -y

# configure site app2
rm /etc/apache2/sites-available/000-default.conf
rm /var/www/html/index.html

wget https://raw.githubusercontent.com/olliveirarodolfo/labterra/main/configfiles/app2/000-default.conf -c /etc/apache2/sites-available/
sleep 1
wget https://raw.githubusercontent.com/olliveirarodolfo/labterra/main/configfiles/app2/index.php -c /var/www/html/

systemctl restart apache2.service
exit 0
