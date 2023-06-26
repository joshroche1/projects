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

# For SSL/TLS monitoring
mkdir -p /opt/prometheus/certs
cd /opt/prometheus/certs
openssl req -newkey rsa:4096 -nodes -keyout ca.key -x509 -out ca.crt -subj "/C=/ST=/L=/O=/OU=/CN=prometheus/"
openssl genrsa -out monitoring.key 4096
openssl req -new -key monitoring.key -out monitoring.csr -subj "/C=/ST=/L=/O=/OU=/CN=monitoring/"
openssl x509 -req -in monitoring.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out monitoring.crt
#

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
  --web.console.libraries=/opt/prometheus/console_libraries \
  --storage.tsdb.retention.time=70d
ExecReload=/bin/kill -HUP $MAINPID
Restart=on-failure
RestartSec=20

[Install]
WantedBy=multi-user.target
' > prometheus.service
cp prometheus.service /etc/systemd/system
systemctl daemon-reload
systemctl start prometheus.service
systemctl enable prometheus.service

cd /opt/prometheus
mv prometheus.yml prometheus.yml.BAK
# prometheus.yml
echo "global:
  scrape_interval: 60s # Default
  evaluation_interval: 60s # Default
  scrape_timeout: 10s # Default
alerting:
  alertmanagers:
    - static_configs:
        - targets:
          - 'localhost:9093'
rule_files:
  - rules.yml
scrape_configs:
  - job_name: prometheus
    honor_labels: true
    static_configs:
      - targets: ['localhost:9090']
  - job_name: node
    honor_labels: true
    file_sd_configs:
      - files:
          - scrape_configs/*.yml
    static_configs:
      - targets: ['localhost:9100']
" > /opt/prometheus/prometheus.yml

mkdir -p /opt/prometheus/scrape_configs
echo "# Example LXD Container
- targets: ['10.0.0.2:9100']
  labels:
    job_name: pgsql
" > /opt/prometheus/scrape_configs/lxd.yml

touch rules.yml
#rules.yml
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

chown -R prometheus: /opt/prometheus

systemctl restart prometheus
