#!/bin/bash

#
cd /opt
wget https://github.com/prometheus/node_exporter/releases/download/v1.5.0/node_exporter-1.5.0.linux-amd64.tar.gz
tar xvzf node_exporter-1.5.0.linux-amd64.tar.gz
mv node_exporter-1.5.0.linux-amd64 node_exporter
/usr/sbin/adduser --system --disabled-password --shell /usr/sbin/nologin --gecos "" prometheus
echo 'tls_server_config:
  cert_file: /opt/node_exporter/certs/server.crt
  key_file: /opt/node_exporter/certs/server.key' > /opt/node_exporter/web.yml
mkdir -p /opt/node_exporter/certs
openssl req -newkey rsa:4096 -nodes -keyout /opt/node_exporter/certs/server.key -x509 -out /opt/node_exporter/certs/server.crt -subj "/C=/ST=/L=/O=/OU=/CN=/"
chown -R prometheus: /opt/node_exporter
echo '
[Unit]
Description=Prometheus - Node Exporter
After=network.target

[Service]
User=prometheus
Type=simple
ExecStart=/opt/node_exporter/node_exporter \
  --web.config.file=/opt/node_exporter/web.yml

[Install]
WantedBy=multi-user.target' > node_exporter.service
chown -R prometheus: /opt/node_exporter
cp node_exporter.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable node_exporter.service
systemctl start node_exporter.service
