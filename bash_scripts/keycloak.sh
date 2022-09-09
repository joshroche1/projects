#!/bin/bash


apt-get update; apt-get upgrade -y
apt-get install default-jdk

apt-get install postgresql
sudo -u postgres createuser -l -P keycloak
sudo -u postgres createdb -O keycloak keycloak
sed -i '85i local keycloak  keycloak  md5' /etc/postgresql/14/main/pg_hba.conf
systemctl restart postgresql

wget https://github.com/keycloak/keycloak/releases/download/19.0.1/keycloak-19.0.1.tar.gz

tar xvzf keycloak-19.0.1.tar.gz
mv keycloak-19.0.1 keycloak
cd keycloak/bin
./kc.sh build --db=postgres
