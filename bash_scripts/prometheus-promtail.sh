#!/bin/bash

#
cd /opt
mkdir promtail
cd /opt/promtail
apt update && apt install -y unzip
wget https://github.com/grafana/loki/releases/download/v2.8.2/promtail-linux-amd64.zip
#wget https://raw.githubusercontent.com/grafana/loki/main/clients/cmd/promtail/promtail-local-config.yaml
unzip promtail-linux-amd64.zip
/usr/sbin/adduser --system --disabled-password --shell /usr/sbin/nologin --gecos "" prometheus
chown -R prometheus: /opt/promtail
echo '
server:
  http_listen_port: 9080
  grpc_listen_port: 0

positions:
  filename: /opt/promtail/positions.yaml

clients:
  - url: http://192.168.2.206:3100/loki/api/v1/push

scrape_configs:

- job_name: syslog
  static_configs:
  - targets:
      - localhost
    labels:
      job: syslog
      __path__: /var/log/syslog*

- job_name: authlog
  static_configs:
  - targets:
      - localhost
    labels:
      job: authlog
      __path__: /var/log/auth.log*
' > promtail.yml
echo '
[Unit]
Description=Prometheus Promtail
After=network.target

[Service]
User=prometheus
Type=simple
ExecStart=/opt/promtail/promtail-linux-amd64 \
  --config.file=/opt/promtail/promtail.yml

[Install]
WantedBy=multi-user.target' > promtail.service
chown -R prometheus: /opt/promtail
cp promtail.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable promtail.service
systemctl start promtail.service
