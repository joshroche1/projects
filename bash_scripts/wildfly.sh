#!/bin/bash

cd /opt
wget https://github.com/wildfly/wildfly/releases/download/26.1.1.Final/wildfly-26.1.1.Final.tar.gz
tar xvzf wildfly-26.1.1.Final.tar.gz
mv wildfly-26.1.1.Final wildfly
adduser --disabled-password --shell /usr/sbin/nologin --gecos "" wildfly
chown -R wildfly:wildfly /opt/wildfly
cd wildfly/bin
./add-user.sh --user admin --password admin --silent --enable

chown -R wildfly: /opt/smc

# To run the server:
sudo -u wildfly ./standalone &

# If you want to use systemd to run the application:
#
touch wildfly.service
echo '
[Unit]
Description=Wildfly Application Server
Wants=network-online.target
After=network-online.target

[Service]
Type=simple
User=wildfly
ExecStart=/opt/wildfly/bin/standalone.sh
Restart=always
RestartSec=20

[Install]
WantedBy=multi-user.target' >> wildfly.service
cp wildfly.service /etc/systemd/system
#systemctl daemon-reload
#systemctl start wildfly.service
#systemctl enable wildfly.service
