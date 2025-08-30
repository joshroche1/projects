#!/bin/bash

AMURL=https://github.com/prometheus/alertmanager/releases/download/v0.28.1/alertmanager-0.28.1.linux-amd64.tar.gz
AMPKG=alertmanager-0.28.1.linux-amd64
#AMURL=https://github.com/prometheus/alertmanager/releases/download/v0.28.1/alertmanager-0.28.1.linux-arm64.tar.gz
#AMPKG=alertmanager-0.28.1.linux-arm64

cd /opt
wget $AMURL
tar xvzf $AMPKG.tar.gz
mv $AMPKG alertmanager
mkdir -p /opt/alertmanager/data

/usr/sbin/adduser --disabled-password --disabled-login --no-create-home --gecos "" alertmanager

echo '[Unit]
Description=Prometheus - Alert Manager
After=network.target

[Service]
User=alertmanager
Type=simple
ExecStart=/opt/alertmanager/alertmanager \
  --config.file="/opt/alertmanager/alertmanager.yml" \
  --storage.path="/opt/alertmanager/data/"

[Install]
WantedBy=multi-user.target' > /opt/alertmanager/alertmanager.service

chown -R alertmanager: /opt/alertmanager

ln -s /opt/alertmanager/alertmanager.service /etc/systemd/system/alertmanager.service
ln -s /opt/alertmanager/alertmanager /usr/local/bin/
ln -s /opt/alertmanager/amtool /usr/local/bin/

rm /opt/$AMPKG.tar.gz

systemctl daemon-reload
systemctl enable alertmanager.service
systemctl start alertmanager.service
