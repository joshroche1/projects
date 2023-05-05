#!/bin/bash

cd /opt
#wget https://github.com/keycloak/keycloak/releases/download/21.1.1/keycloak-21.1.1.tar.gz
wget https://github.com/keycloak/keycloak/releases/download/21.1.1/keycloak-21.1.1.zip
unzip keycloak-21.1.1.tar.gz
mv keycloak-21.1.1 keycloak
adduser --disabled-password --shell /usr/sbin/nologin --gecos "" keycloak
cd keycloak/bin

echo '
export KEYCLOAK_ADMIN=admin
export KEYCLOAK_ADMIN_PASSWORD=admin
' > /opt/keycloak/.env

export KEYCLOAK_ADMIN=admin
export KEYCLOAK_ADMIN_PASSWORD=admin

chown -R keycloak: /opt/keycloak

# To run the development server:
# sudo -u keycloak KEYCLOAK_ADMIN=admin KEYCLOAK_ADMIN_PASSWORD=admin /opt/keycloak/bin/kc.sh start-dev

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
ExecStart=/opt/keycloak/bin/kc.sh start
Restart=always
RestartSec=20

[Install]
WantedBy=multi-user.target' >> keycloak.service
cp keycloak.service /etc/systemd/system
systemctl daemon-reload
echo
echo '# Initialize the config by running:'
echo
echo '  /opt/keycloak/bin/kc.sh start-dev'
echo
echo '# Build configuration:'
echo
echo '  /opt/keycloak/bin/kc.sh build'
echo
echo '  systemctl start  keycloak.service  #  to Start Keycloak'
echo '  systemctl enable keycloak.service  #  to enable Keycloak after restarts'
