#!/bin/bash

#
cd /opt
wget https://github.com/prometheus/alertmanager/releases/download/v0.25.0/alertmanager-0.25.0.linux-amd64.tar.gz
tar xvzf alertmanager-0.25.0.linux-amd64.tar.gz
mv alertmanager-0.25.0.linux-amd64 alertmanager
mkdir -p /opt/alertmanager/data
/usr/sbin/adduser --system --disabled-password --shell /usr/sbin/nologin --gecos "" prometheus
chown -R prometheus: /opt/alertmanager/
echo '
[Unit]
Description=Prometheus - Alert Manager
After=network.target

[Service]
User=prometheus
Type=simple
ExecStart=/opt/alertmanager/alertmanager \
  --config.file="/opt/alertmanager/alertmanager.yml" \
  --storage.path="/opt/alertmanager/data/"

[Install]
WantedBy=multi-user.target' > alertmanager.service
cp alertmanager.service /etc/systemd/system/
chown -R prometheus: /opt/alertmanager/
systemctl daemon-reload
systemctl enable alertmanager.service
systemctl start alertmanager.service
