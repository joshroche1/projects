#!/bin/bash

BBURL=https://github.com/prometheus/blackbox_exporter/releases/download/v0.26.0/blackbox_exporter-0.26.0.linux-amd64.tar.gz
BBPKG=blackbox_exporter-0.26.0.linux-amd64

cd /opt
wget $BBURL
tar xvzf $BBPKG.tar.gz
mv $BBPKG blackbox_exporter

/usr/sbin/adduser --disabled-password --disabled-login --no-create-home --gecos "" blackbox_exporter

echo '[Unit]
Description=Prometheus - Blackbox Exporter
After=network.target

[Service]
User=blackbox_exporter
Type=simple
ExecStart=/opt/blackbox_exporter/blackbox_exporter \
  --config.file="/opt/blackbox_exporter/blackbox.yml"
ExecReload=/bin/kill -HUP $MAINPID
Restart=on-failure

[Install]
WantedBy=multi-user.target' > /opt/blackbox_exporter/blackbox_exporter.service

chown -R blackbox_exporter: /opt/blackbox_exporter

ln -s /opt/blackbox_exporter/blackbox_exporter.service /etc/systemd/system/blackbox_exporter.service

rm /opt/$BBPKG.tar.gz

systemctl daemon-reload
systemctl enable blackbox_exporter.service
systemctl start blackbox_exporter.service
