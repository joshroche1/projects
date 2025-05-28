#!/bin/bash

PTAILURL=https://github.com/grafana/loki/releases/download/v3.5.1/promtail-linux-amd64.zip
PTAILPKG=promtail-linux-amd64

apt-get update
apt-get install -y unzip

cd /opt
wget $PTAILURL
unzip $PTAILPKG.zip

/usr/sbin/adduser --disabled-password --disabled-login --no-create-home --gecos "" promtail

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
' > /opt/promtail/promtail-local-config.yml

echo '[Unit]
Description=Grafana Promtail
After=network.target

[Service]
User=promtail
Type=simple
ExecStart=/opt/loki/promtail-linux-amd64 \
  --config.file=/opt/loki/promtail-local-config.yml
ExecReload=/bin/kill -HUP $MAINPID
Restart=on-failure

[Install]
WantedBy=multi-user.target' > /opt/promtail/promtail.service

chown -R promtail: /opt/promtail

ln -s /opt/promtail/promtail.service /etc/systemd/system/promtail.service

systemctl daemon-reload
systemctl enable promtail.service
systemctl start promtail.service
