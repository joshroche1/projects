#!/bin/bash

apt update; apt install unzip
cd /opt
mkdir -p /opt/loki
mkdir -p /opt/promtail

cd /opt/loki
wget https://github.com/grafana/loki/releases/download/v2.8.2/loki-linux-amd64.zip
unzip loki-linux-amd64.zip
# wget https://github.com/grafana/loki/releases/download/v2.8.2/loki-linux-arm64.zip # ARM64
# unzip loki-linux-arm64.zip

cd /opt/promtail
wget https://github.com/grafana/loki/releases/download/v2.8.2/promtail-linux-amd64.zip
unzip promtail-linux-amd64.zip
# wget https://github.com/grafana/loki/releases/download/v2.8.2/promtail-linux-arm64.zip # ARM64
# unzip promtail-linux-arm64.zip

cd /opt
/usr/sbin/adduser --system --disabled-password --shell /usr/sbin/nologin --gecos "" prometheus
echo '
auth_enabled: false

server:
  http_listen_port: 3100
  grpc_listen_port: 9096

common:
  instance_addr: 127.0.0.1
  path_prefix: /opt/loki/data
  storage:
    filesystem:
      chunks_directory: /opt/loki/data/chunks
      rules_directory: /opt/loki/data/rules
  replication_factor: 1
  ring:
    kvstore:
      store: inmemory

query_range:
  results_cache:
    cache:
      embedded_cache:
        enabled: true
        max_size_mb: 100

schema_config:
  configs:
    - from: 2020-10-24
      store: boltdb-shipper
      object_store: filesystem
      schema: v11
      index:
        prefix: index_
        period: 24h

ruler:
  alertmanager_url: http://localhost:9093
' > /opt/loki/loki-local-config.yml
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
Description=Grafana Loki - Logging System
After=network.target

[Service]
User=prometheus
Type=simple
ExecStart=/opt/loki/loki-linux-amd64 \
  --config.file=/opt/loki/loki-local-config.yml

[Install]
WantedBy=multi-user.target' > /opt/loki/loki.service
echo '[Unit]
Description=Grafana Promtail
After=network.target

[Service]
User=prometheus
Type=simple
ExecStart=/opt/loki/promtail-linux-amd64 \
  --config.file=/opt/loki/promtail-local-config.yml

[Install]
WantedBy=multi-user.target' > /opt/promtail/promtail.service
cp /opt/loki/loki.service /etc/systemctl/system/
cp /opt/promtail/promtail.service /etc/systemctl/system/
chown -R prometheus: /opt/loki
chown -R prometheus: /opt/promtail
systemctl daemon-reload
systemctl enable loki.service
systemctl enable promtail.service
systemctl start loki.service
systemctl start promtail.service