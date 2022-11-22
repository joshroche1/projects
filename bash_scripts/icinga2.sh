#!/bin/bash

apt-get update
apt-get -y install apt-transport-https wget gnupg

wget -O - https://packages.icinga.com/icinga.key | apt-key add -

DIST=$(awk -F"[)(]+" '/VERSION=/ {print $2}' /etc/os-release); \
 echo "deb https://packages.icinga.com/debian icinga-${DIST} main" > \
 /etc/apt/sources.list.d/${DIST}-icinga.list
 echo "deb-src https://packages.icinga.com/debian icinga-${DIST} main" >> \
 /etc/apt/sources.list.d/${DIST}-icinga.list

apt-get update

DIST=$(awk -F"[)(]+" '/VERSION=/ {print $2}' /etc/os-release); \
 echo "deb https://deb.debian.org/debian ${DIST}-backports main" > \
 /etc/apt/sources.list.d/${DIST}-backports.list

apt-get update

apt-get install -y postgresql
sudo -u postgres createuser --login icinga
sudo -u postgres createdb --owner=icinga icinga
sudo -u postgres psql --command="ALTER ROLE icinga WITH LOGIN PASSWORD 'icinga'"
sed -i '79 i local   icinga          icinga                                  md5' /etc/postgresql/13/main/pg_hba.conf
systemctl restart postgresql
#
apt-get install -y icinga2 monitoring-plugins
icinga2 api setup
icinga2 daemon -C
systemctl restart icinga2
#
apt-get install -y nginx php-fpm
#
