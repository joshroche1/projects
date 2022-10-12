#!/bin/bash

snap install certbot --classic
DOMAIN=www.example.com
certbot --apache -n \
		-m user@example.com \
		-d $DOMAIN \
		--agree-tos
/etc/letsencrypt/live/$DOMAIN/
ln -s /etc/letsencrypt/live/ /etc/ssl/
sed -i '/SSLCertificateFile/c\SSLCertificateFile /etc/ssl/$DOMAIN/cert.pem' /etc/apache2/sites-available/default-ssl.conf
sed -i '/SSLCertificateKeyFile/c\SSLCertificateKeyFile /etc/ssl/$DOMAIN/privkey.pem' /etc/apache2/sites-available/default-ssl.conf
systemctl reload apache2
