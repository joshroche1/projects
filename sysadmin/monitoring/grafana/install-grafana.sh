#!/bin/bash

sudo apt-get install -y apt-transport-https software-properties-common wget
sudo mkdir -p /etc/apt/keyrings/
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
sudo apt-get update
apt-get install grafana

systemctl daemon-reload
systemctl enable grafana-server

echo 'Grafana Dashboards:'
echo
echo ' [1860]: Node Exporter'
echo ' [13659]: Blackbox Exporter (HTTP Prober)'
echo ' [14055]: Loki Metrics'
echo ' [10619]: Docker'
echo ' [12273]: PostgreSQL Exporter'
echo ' [9628]: PostgreSQL'
echo ' [13918]: barman exporter'
echo ' [14057]: MySQL Exporter'
echo ' [11304]: cardinality exporter'
echo
