#!/bin/bash

# DEPENDENCIES
apt update; apt upgrade -y
apt install -y python3 python3-pip \
        python3-flask python3-flask-sqlalchemy \
        python3-wtforms python3-dotenv python3-psycopg2
pip3 install flask-mobility
#
# POSTGRESQL
apt install -y postgresql python3-psycopg2

#
sudo -u postgres createuser -l -P webapp
sudo -u postgres createdb -O webapp webapp
sed -i '80 i local   webapp          webapp                                  scram-sha-256' /etc/postgresql/15/main/pg_hba.conf
systemctl restart postgresql
#
