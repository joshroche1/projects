#!/bin/bash

cd /opt
wget https://github.com/prometheus/node_exporter/releases/download/v1.4.0/node_exporter-1.4.0.linux-amd64.tar.gz
tar xvzf node_exporter-1.4.0.linux-amd64.tar.gz
mv node_exporter-1.4.0.linux-amd64 node_exporter
adduser --disabled-password --shell /usr/sbin/nologin --gecos "" prometheus

echo '
[Unit]
Description=Prometheus Node Exporter
After=network.target

[Service]
User=prometheus
Type=simple
ExecStart=/opt/node_exporter/node_exporter

[Install]
WantedBy=multi-user.target' > node_exporter.service
cp node_exporter.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable node_exporter.service
systemctl start node_exporter.service
