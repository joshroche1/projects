#!/bin/bash

cd /opt
wget https://github.com/keycloak/keycloak/releases/download/19.0.3/keycloak-19.0.3.tar.gz
wget https://github.com/keycloak/keycloak/releases/download/19.0.3/keycloak-saml-wildfly-adapter-19.0.3.tar.gz
tar keycloak-19.0.3.tar.gz
mv keycloak-19.0.3 keycloak
adduser --disabled-password --shell /usr/sbin/nologin --gecos "" keycloak
chown -R keycloak:keycloak /opt/keycloak
cd keycloak/bin

echo '
export KEYCLOAK_ADMIN=admin
export KEYCLOAK_ADMIN_PASSWORD=admin
' > ../.env

# To run the server:
sudo -u keycloak ./kc.sh start-dev &

# If you want to use systemd to run the application:
#
touch keycloak.service
echo '
[Unit]
Description=Keycloak Server
Wants=network-online.target
After=network-online.target

[Service]
Type=simple
User=keycloak
EnvironmentFile=/opt/keycloak/.env
ExecStart=/opt/keycloak/bin/kc.sh start-dev
Restart=always
RestartSec=20

[Install]
WantedBy=multi-user.target' >> keycloak.service
cp keycloak.service /etc/systemd/system
#systemctl daemon-reload
#systemctl start keycloak.service
#systemctl enable keycloak.service
