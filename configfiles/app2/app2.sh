#!/bin/bash

# install apache
apt update
apt install apache2 -y
apt install php libapache2-mod-php -y

# configure site app2
wget https://github.com/olliveirarodolfo/labterra/raw/main/configfiles/app2/000-default.conf -c /etc/apache2/sites-available/
wget https://github.com/olliveirarodolfo/labterra/raw/main/configfiles/app2/index.php -c /var/www/html/

systemctl restart apache2.service