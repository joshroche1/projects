Setup Apache to use Python using WSGI
=====================================

apt-get install libexpat1 apache2-utils ssl-cert libapache2-mod-wsgi

chown www-data: wsgi.py

a2enconf wsgi

systemctl reload/restart apache2

http://SERVERIP/wsgi
