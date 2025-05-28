#!/bin/bash

LOKIURL=https://github.com/grafana/loki/releases/download/v3.5.1/loki-linux-amd64.zip
LOKIPKG=loki-linux-amd64

apt-get update
apt-get install -y unzip

cd /opt
wget $LOKIURL
unzip $LOKIPKG.zip
mv $LOKIPKG loki

/usr/sbin/adduser --disabled-password --disabled-login --no-create-home --gecos "" loki

echo 'auth_enabled: false

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

echo '[Unit]
Description=Grafana Loki - Logging System
After=network.target

[Service]
User=loki
Type=simple
ExecStart=/opt/loki/loki-linux-amd64 \
  --config.file=/opt/loki/loki-local-config.yml
ExecReload=/bin/kill -HUP $MAINPID
Restart=on-failure

[Install]
WantedBy=multi-user.target' > /opt/loki/loki.service

chown -R loki: /opt/loki

ln -s /opt/loki/loki.service /etc/systemd/system/loki.service

systemctl daemon-reload
systemctl enable loki.service
systemctl start loki.service
