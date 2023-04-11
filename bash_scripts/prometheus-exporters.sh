#!/bin/bash

mkdir -p /opt/prometheus_exporters
cd /opt/prometheus_exporters

fetcharr[0]='https://github.com/prometheus-community/postgres_exporter/releases/download/v0.11.1/postgres_exporter-0.11.1.linux-amd64.tar.gz'
fetcharr[1]='https://github.com/prometheus/haproxy_exporter/releases/download/v0.13.0/haproxy_exporter-0.13.0.linux-amd64.tar.gz'
fetcharr[2]='https://github.com/hnlq715/nginx-vts-exporter/archive/refs/tags/v0.10.7.tar.gz'
fetcharr[3]='https://github.com/Nordstrom/ssh_exporter/releases/download/v2.0.0/ssh_exporter-linux-amd64'
fetcharr[4]='https://github.com/enix/x509-certificate-exporter/releases/download/v3.6.0-beta.2/x509-certificate-exporter-linux-amd64.tar.gz'

# for fetchitem in ${fetcharr[@]}
# do
# done

echo 'Fetching Exporters for Prometheus'
for fetchitem in ${fetcharr[@]}
do
  echo 'Fetching: $fetchitem'
  wget $fetchitem
done

git clone https://github.com/knyar/nginx-lua-prometheus.git
git clone https://github.com/terradolor/prometheus-enviro-exporter.git

#tar xvzf node_exporter-1.4.0.linux-amd64.tar.gz
#mv node_exporter-1.4.0.linux-amd64 node_exporter

#
adduser --system --disabled-password --shell /usr/sbin/nologin --gecos "" prometheus
echo 'Systemd service file template:'
echo ''
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
# cp node_exporter.service /etc/systemd/system/
# systemctl daemon-reload
# systemctl enable node_exporter.service
# systemctl start node_exporter.service
