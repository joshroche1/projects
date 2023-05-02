#!/bin/bash

#
cd /opt
wget https://github.com/prometheus/alertmanager/releases/download/v0.25.0/alertmanager-0.25.0.linux-amd64.tar.gz
mkdir alertmanager
tar xvzf alertmanager-0.25.0.linux-amd64.tar.gz
mv alertmanager-0.25.0* alertmanager
adduser --system --disabled-password --shell /usr/sbin/nologin --gecos "" prometheus
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
# cp alertmanager.service /etc/systemd/system/
# systemctl daemon-reload
# systemctl enable node_exporter.service
# systemctl start node_exporter.service
