#!/bin/bash

apt-get update; apt-get upgrade -y
apt install default-jdk

wget https://github.com/wildfly/wildfly/releases/download/26.1.1.Final/wildfly-26.1.1.Final.tar.gz
tar xvzf wildfly-26.1.1.Final.tar.gz
mv wildfly-26.1.1.Final wildfly
cd wildfly/bin
./add-user.sh --user admin --password admin --silent --enable

echo '
[Unit]
Description=Wildfly Application Server
After=network.target

[Service]
Type=forking
ExecStart=/opt/wildfly/bin/standalone.sh

[Install]
WantedBy=multi-user.target' > wildfly.service

cp wildfly.service /etc/systemd/system
systemctl daemon-reload
systemctl start wildfly.service
systemctl enable wildfly.service
