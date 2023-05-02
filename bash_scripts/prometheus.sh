#!/bin/bash

cd /opt
wget https://github.com/prometheus/prometheus/releases/download/v2.44.0-rc.0/prometheus-2.44.0-rc.0.linux-amd64.tar.gz
# wget https://github.com/prometheus/prometheus/releases/download/v2.44.0-rc.0/prometheus-2.44.0-rc.0.linux-arm64.tar.gz
tar xvzf prometheus-2.44.0-rc.0.linux-amd64.tar.gz
mv prometheus-2.44.0-rc.0.linux-amd64 prometheus
/usr/sbin/adduser --system --disabled-password --shell /usr/sbin/nologin --gecos "" prometheus
chown -R prometheus: /opt/prometheus
cd /opt/prometheus
mkdir tsdb

# To run the server:
# sudo -u prometheus ./prometheus &

# If you want to use systemd to run the application:
#
touch prometheus.service
echo '
[Unit]
Description=Prometheus Monitoring Server
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Type=simple
ExecStart=/opt/prometheus/prometheus \
  --config.file /opt/prometheus/prometheus.yml \
  --storage.tsdb.path /opt/prometheus/tsdb/ \
  --web.console.templates=/opt/prometheus/consoles \
  --web.console.libraries=/opt/prometheus/console_libraries
Restart=always
RestartSec=20

[Install]
WantedBy=multi-user.target
' > prometheus.service
cp prometheus.service /etc/systemd/system
systemctl daemon-reload
systemctl start prometheus.service
systemctl enable prometheus.service
