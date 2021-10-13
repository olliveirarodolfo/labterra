#!/bin/bash

# install and config DB
apt-get update -y
sleep 3
apt-get -f install mysql-server -y


exit 0