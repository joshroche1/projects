#!/bin/bash

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
  - job_name: micrometer
    honor_labels: true
    metrics_path: /realms/master/metrics
    static_configs:
      - targets: ['10.0.0.15:8080']
" > /opt/prometheus/prometheus.yml

mkdir -p /opt/prometheus/scrape_configs
echo "# LXD Containers
- targets: ['10.0.0.2:9100']
  labels:
    job_name: pgsql
" > /opt/prometheus/scrape_configs/lxc.yml

mv rules.yml rules.yml.BAK
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
