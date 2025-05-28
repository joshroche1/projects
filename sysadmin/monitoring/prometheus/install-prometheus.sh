#!/bin/bash

PROMURL=https://github.com/prometheus/prometheus/releases/download/v2.53.4/prometheus-2.53.4.linux-amd64.tar.gz
PROMPKG=prometheus-2.53.4.linux-amd64

/usr/sbin/adduser --disabled-password --disabled-login --no-create-home --gecos "" prometheus

cd /opt
wget $PROMURL
tar xvzf $PROMPKG.tar.gz
mv $PROMPKG prometheus
mkdir -p /opt/prometheus/targets/hosts
mkdir -p /opt/prometheus/tsdb
mkdir -p /opt/prometheus/certs
mkdir -p /opt/prometheus/scrape_configs

cd /opt/prometheus/certs
openssl req -newkey rsa:4096 -nodes -keyout ca.key -x509 -out ca.crt -subj "/C=/ST=/L=/O=/OU=/CN=prometheus/"
openssl genrsa -out monitoring.key 4096
openssl req -new -key monitoring.key -out monitoring.csr -subj "/C=/ST=/L=/O=/OU=/CN=monitoring/"
openssl x509 -req -in monitoring.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out monitoring.crt

cd /opt/prometheus
mv prometheus.yml prometheus.yml.BAK

echo "global:
  scrape_interval: 60s
  scrape_timeout: 10s
  evaluation_interval: 60s

alerting:
  alertmanagers:
  - static_configs:
    - targets:
      - 'localhost:9093'

rules_files:
  - rules.yml

scrape_config_files:
  - '/opt/prometheus/scrape_configs/*.yaml'
" > /opt/prometheus/prometheus.yml

echo "groups:
- name: AllInstances
  rules:
  - alert: InstanceDown
    expr: up == 0
    for: 1m
    annotations:
      title: 'Instance {{ $labels.instance }} down'
      description: '{{ $labels.instance }} of job {{ $labels.job }} has been down for more than 1 minute.'
    labels:
      severity: 'critical'
" > /opt/prometheus/rules.yml

echo "scrape_configs:

  - job_name: 'prometheus'
    honor_labels: true
    static_configs:
    - targets: ['localhost:9090']

  - job_name: 'jarpi4b8'
    static_configs:
    - targets: ['localhost:9100']" > /opt/prometheus/scrape_configs/prometheus.yaml

echo "[Unit]
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
  --web.console.libraries=/opt/prometheus/console_libraries \
  --storage.tsdb.retention.time=70d
ExecReload=/bin/kill -HUP $MAINPID
Restart=on-failure
RestartSec=20

[Install]
WantedBy=multi-user.target" > /opt/prometheus/prometheus.service

chown -R prometheus: /opt/prometheus

ln -s /opt/prometheus/prometheus.service /etc/systemd/system/prometheus.service

systemctl daemon-reload
systemctl enable prometheus.service
systemctl start prometheus.service
