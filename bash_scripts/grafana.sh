#!/bin/bash

# Install Grafana

apt-get install -y apt-transport-https
apt-get install -y software-properties-common wget
wget -q -O /usr/share/keyrings/grafana.key https://apt.grafana.com/gpg.key

echo "deb [signed-by=/usr/share/keyrings/grafana.key] https://apt.grafana.com stable main" | tee -a /etc/apt/sources.list.d/grafana.list

apt-get update
apt-get install grafana

systemctl daemon-reload
systemctl enable grafana-server

grafana-cli admin reset-admin-password admin

echo 'Grafana Dashboards:'
echo
echo '1860: Node Exporter'
echo '13659: Blackbox Exporter (HTTP Prober)'
echo '14055: Loki Metrics'