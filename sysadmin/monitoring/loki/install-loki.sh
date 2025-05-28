#!/bin/bash

LOKIURL=https://github.com/grafana/loki/releases/download/v3.5.1/loki-linux-arm64.zip
LOKIPKG=loki-linux-arm64

apt-get update
apt-get install -y unzip

mkdir -p /opt/loki/data
cd /opt/loki
wget $LOKIURL
unzip $LOKIPKG.zip
mv $LOKIPKG loki

/usr/sbin/adduser --disabled-password --disabled-login --no-create-home --gecos "" loki

echo 'auth_enabled: false

server:
  http_listen_port: 3100

common:
  ring:
    instance_addr: 127.0.0.1
    kvstore:
      store: inmemory
  replication_factor: 1
  path_prefix: /opt/loki/data

schema_config:
  configs:
  - from: 2020-05-15
    store: tsdb
    object_store: filesystem
    schema: v13
    index:
      prefix: index_
      period: 24h

storage_config:
  filesystem:
    directory: /opt/loki/data/chunks' > /opt/loki/config.yaml

echo '[Unit]
Description=Grafana Loki - Logging System
After=network.target

[Service]
User=loki
Type=simple
ExecStart=/opt/loki/loki-linux-arm64 \
  --config.file=/opt/loki/config.yaml
ExecReload=/bin/kill -HUP $MAINPID
Restart=on-failure

[Install]
WantedBy=multi-user.target' > /opt/loki/loki.service

chown -R loki: /opt/loki

ln -s /opt/loki/loki.service /etc/systemd/system/loki.service

systemctl daemon-reload
systemctl enable loki.service
systemctl start loki.service
