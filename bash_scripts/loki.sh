#!/bin/bash

cd /opt
mkdir loki
cd /opt/loki
wget https://github.com/grafana/loki/releases/download/v2.8.2/loki-linux-amd64.zip
#wget https://github.com/grafana/loki/releases/download/v2.8.2/loki-linux-arm64.zip
wget https://github.com/grafana/loki/releases/download/v2.8.2/promtail-linux-amd64.zip
#wget https://github.com/grafana/loki/releases/download/v2.8.2/promtail-linux-arm64.zip
wget https://raw.githubusercontent.com/grafana/loki/main/cmd/loki/loki-local-config.yaml
wget https://raw.githubusercontent.com/grafana/loki/main/clients/cmd/promtail/promtail-local-config.yaml
unzip loki-linux-amd64.zip
#unzip loki-linux-arm64.zip
unzip promtail-linux-amd64.zip
#unzip promtail-linux-arm64.zip

chown -R prometheus: /opt/loki
echo '[Unit]
Description=Grafana Loki - Logging System
After=network.target

[Service]
User=prometheus
Type=simple
ExecStart=/opt/loki/loki-linux-amd64 \
  --config.file=/opt/loki/loki-local-config.yml

[Install]
WantedBy=multi-user.target' > loki.service
echo '[Unit]
Description=Grafana Promtail
After=network.target

[Service]
User=prometheus
Type=simple
ExecStart=/opt/loki/promtail-linux-amd64 \
  --config.file=/opt/loki/promtail-local-config.yml

[Install]
WantedBy=multi-user.target' > promtail.service
cp loki.service /etc/systemctl/system/
cp promtail.service /etc/systemctl/system/
systemctl daemon-reload
systemctl enable loki.service
systemctl enable promtail.service
systemctl start loki.service
systemctl start promtail.service