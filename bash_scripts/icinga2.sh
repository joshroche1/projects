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
sudo -u postgres createdb --owner=icinga icingaweb
sudo -u postgres psql --command="ALTER ROLE icinga WITH LOGIN PASSWORD 'icinga'"
sed -i '79 i local   icinga          icinga                                  md5' /etc/postgresql/13/main/pg_hba.conf
systemctl restart postgresql
#
apt-get install -y icinga2 monitoring-plugins icinga2-ido-pgsql
psql -U icinga -d icinga < /usr/share/icinga2-ido-pgsql/schema/pgsql.sql
icinga2 api setup
icinga2 daemon -C
systemctl restart icinga2
#
apt-get install -y nginx php-fpm php-pgsql
#
apt-get update

wget -O - https://packages.icinga.com/icinga.key | apt-key add -

DIST=$(awk -F"[)(]+" '/VERSION=/ {print $2}' /etc/os-release); \
 echo "deb https://packages.icinga.com/debian icinga-${DIST} main" > \
 /etc/apt/sources.list.d/${DIST}-icinga.list
 echo "deb-src https://packages.icinga.com/debian icinga-${DIST} main" >> \
 /etc/apt/sources.list.d/${DIST}-icinga.list

apt-get update
#
apt-get install -y icingaweb2 icingacli
echo '
library "db_ido_pgsql"

object IdoPgsqlConnection "ido-pgsql" {
  user = "icinga"
  password = "icinga"
  host = "localhost"
  database = "icinga"
  enable_ha = false
}' > /etc/icinga2/features-available/ido-pgsql.conf
ln -s /etc/icinga2/features-available/ido-pgsql.conf /etc/icinga2/features-enabled/ido-pgsql.conf
#
openssl \
    req \
    -nodes \
    -newkey rsa:4096 \
    -keyout server.key \
    -out server.csr \
    -subj "/C=/ST=/L=/O=/OU=/CN=/"
openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt
cp server.crt /etc/ssl/certs
cp server.key /etc/ssl/private
#
echo '
server {
        listen 80;
        listen [::]:80;

        server_name 192.168.2.221;

        return 301 https://$server_name$request_uri;
}
server {
        listen 443 ssl;
        listen [::]:443 ssl;

        server_name 192.168.2.221;

        ssl_certificate                 /etc/ssl/certs/server.crt;
        ssl_certificate_key             /etc/ssl/private/server.key;

        index index.htm index.html index.php;

        root /var/www/html;

        location ~ ^/icingaweb2/index\.php(.*)$ {
                fastcgi_pass unix:/var/run/php/php7.4-fpm.sock;
                fastcgi_index index.php;
                include fastcgi_params;
                fastcgi_param SCRIPT_FILENAME /usr/share/icingaweb2/public/index.php;
                fastcgi_param ICINGAWEB_CONFIGDIR /etc/icingaweb2;
                fastcgi_param REMOTE_USER $remote_user;
        }

        location ~ ^/icingaweb2(.+)? {
                alias /usr/share/icingaweb2/public;
                index index.php;
                try_files $1 $uri $uri/ /icingaweb2/index.php$is_args$args;
        }

}
' > /etc/ngins/sites-available/icinga
ln -s /etc/nginx/sites-available/icinga /etc/nginx/sites-enabled/icinga
rm /etc/nginx/sites-enabled/default
systemctl restart nginx
#
