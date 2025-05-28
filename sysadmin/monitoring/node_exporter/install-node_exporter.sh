#!/bin/bash

NODEURL=https://github.com/prometheus/node_exporter/releases/download/v1.9.1/node_exporter-1.9.1.linux-amd64.tar.gz
NODEPKG=node_exporter-1.9.1.linux-amd64

cd /opt
wget $NODEURL
tar xvzf $NODEPKG.tar.gz
mv $NODEPKG node_exporter

/usr/sbin/adduser --disabled-password --disabled-login --no-create-home --gecos "" node_exporter

mkdir -p /opt/node_exporter/tls

openssl req -newkey rsa:4096 -nodes -keyout /opt/node_exporter/tls/node_exporter.key -x509 -out /opt/node_exporter/tls/node_exporter.crt -subj "/C=/ST=/L=/O=/OU=/CN=/"

echo '[Unit]
Description=Prometheus - Node Exporter
After=network.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/opt/node_exporter/node_exporter \
 --web.config.file="/opt/node_exporter/web.yml"
ExecReload=/bin/kill -HUP $MAINPID
Restart=on-failure

[Install]
WantedBy=multi-user.target' > /opt/node_exporter/node_exporter.service

echo 'tls_server_config:
  cert_file: /opt/node_exporter/tls/node_exporter.crt
  key_file: /opt/node_exporter/tls/node_exporter.key' > /opt/node_exporter/web.yml

chown -R node_exporter: /opt/node_exporter

ln -s /opt/node_exporter/node_exporter.service /etc/systemd/system/node_exporter.service

rm /opt/$NODEPKG.tar.gz

systemctl daemon-reload
systemctl enable node_exporter.service
systemctl start node_exporter.service
