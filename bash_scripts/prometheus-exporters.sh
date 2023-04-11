#!/bin/bash

mkdir -p /opt/prometheus_exporters
cd /opt/prometheus_exporters

# Blackbox exporter
fetcharr[0]='https://github.com/prometheus/blackbox_exporter/releases/download/v0.23.0/blackbox_exporter-0.23.0.linux-amd64.tar.gz'
# PostgreSQL exporter
fetcharr[1]='https://github.com/prometheus-community/postgres_exporter/releases/download/v0.11.1/postgres_exporter-0.11.1.linux-amd64.tar.gz'
# haproxy exporter
fetcharr[2]='https://github.com/prometheus/haproxy_exporter/releases/download/v0.13.0/haproxy_exporter-0.13.0.linux-amd64.tar.gz'
# nginx exporter
fetcharr[3]='https://github.com/hnlq715/nginx-vts-exporter/archive/refs/tags/v0.10.7.tar.gz'
# ssh exporter
fetcharr[4]='https://github.com/Nordstrom/ssh_exporter/releases/download/v2.0.0/ssh_exporter-linux-amd64'
# certificate exporter
fetcharr[5]='https://github.com/enix/x509-certificate-exporter/releases/download/v3.6.0-beta.2/x509-certificate-exporter-linux-amd64.tar.gz'

echo 'Fetching Exporters for Prometheus'
for fetchitem in ${fetcharr[@]}
do
  echo 'Fetching: $fetchitem'
  wget $fetchitem
#done
echo

# adduser --system --disabled-password --shell /usr/sbin/nologin --gecos "" prometheus
echo 'Systemd service file template:'
echo '=============================='
echo
echo '[Unit]'
echo 'Description=Prometheus - NAME Exporter'
echo 'After=network.target'
echo ''
echo '[Service]'
echo 'User=prometheus'
echo 'Type=simple'
echo 'ExecStart=/opt/DIRECTORY/EXECUTABLE'
echo ''
echo '[Install]'
echo 'WantedBy=multi-user.target'
echo
echo '=============================='
echo
echo '> Copy systemd service file to: /etc/systemd/system/'
echo '> chown -R prometheus: /opt/DIRECTORY'
echo '> systemctl daemon-reload'
echo '> systemctl enable node_exporter.service'
echo '> systemctl start node_exporter.service'
echo
echo '=============================='
echo 'Exporters downloaded:'
echo '=============================='
for fileitem in $(ls /opt/prometheus_exporters/)
do
  echo $fileitem
done
echo
echo 'Done'
