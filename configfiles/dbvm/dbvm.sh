#!/bin/bash

# install and config DB
apt-get update
apt-get -f install mysql-server -y

# workarround to avoid azure ubuntu repos problems
apt-get -f install mysql-server -y

exit 0