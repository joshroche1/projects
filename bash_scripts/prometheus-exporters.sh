#!/bin/bash

mkdir -p /opt/prometheus_exporters
cd /opt/prometheus_exporters

# Blackbox exporter
wget https://github.com/prometheus/blackbox_exporter/releases/download/v0.23.0/blackbox_exporter-0.23.0.linux-amd64.tar.gz
# PostgreSQL exporter
wget https://github.com/prometheus-community/postgres_exporter/releases/download/v0.11.1/postgres_exporter-0.11.1.linux-amd64.tar.gz
# haproxy exporter
wget https://github.com/prometheus/haproxy_exporter/releases/download/v0.13.0/haproxy_exporter-0.13.0.linux-amd64.tar.gz
# nginx exporter
wget https://github.com/hnlq715/nginx-vts-exporter/archive/refs/tags/v0.10.7.tar.gz
# ssh exporter
wget https://github.com/Nordstrom/ssh_exporter/releases/download/v2.0.0/ssh_exporter-linux-amd64
# certificate exporter
wget https://github.com/enix/x509-certificate-exporter/releases/download/v3.6.0-beta.2/x509-certificate-exporter-linux-amd64.tar.gz
# snmp exporter
wget https://github.com/prometheus/snmp_exporter/releases/download/v0.21.0/snmp_exporter-0.21.0.freebsd-amd64.tar.gz

ls -al
