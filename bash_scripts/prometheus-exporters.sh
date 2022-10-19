#!/bin/bash

cd /opt
echo 'Fetching Exporters for Prometheus'

echo 'PostgreSQL'
wget https://github.com/prometheus-community/postgres_exporter/releases/download/v0.11.1/postgres_exporter-0.11.1.linux-amd64.tar.gz

echo 'HAProxy'
wget https://github.com/prometheus/haproxy_exporter/releases/download/v0.13.0/haproxy_exporter-0.13.0.linux-amd64.tar.gz

echo 'NGINX metrics (git)'
git clone https://github.com/knyar/nginx-lua-prometheus.git

echo 'NGINX VTS'
wget https://github.com/hnlq715/nginx-vts-exporter/archive/refs/tags/v0.10.7.tar.gz

echo 'SSH Exporter - run commands on remote hosts'
wget https://github.com/Nordstrom/ssh_exporter/releases/download/v2.0.0/ssh_exporter-linux-amd64

echo 'x509 Certificate'
wget https://github.com/enix/x509-certificate-exporter/releases/download/v3.6.0-beta.2/x509-certificate-exporter-linux-amd64.tar.gz

echo 'Pimoroni enviroPi (git)'
git clone https://github.com/terradolor/prometheus-enviro-exporter.git

echo ''
wget 


#tar xvzf node_exporter-1.4.0.linux-amd64.tar.gz
#mv node_exporter-1.4.0.linux-amd64 node_exporter
#adduser --disabled-password --shell /usr/sbin/nologin --gecos "" prometheus

#echo '
#[Unit]
#Description=Prometheus Node Exporter
#After=network.target
#
#[Service]
#User=prometheus
#Type=simple
#ExecStart=/opt/node_exporter/node_exporter
#
#[Install]
#WantedBy=multi-user.target' > node_exporter.service
#cp node_exporter.service /etc/systemd/system/
#systemctl daemon-reload
#systemctl enable node_exporter.service
#systemctl start node_exporter.service
