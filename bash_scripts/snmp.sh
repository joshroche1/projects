#!/bin/bash

apt install snmp snmp-mibs-downloader
apt-get update
apt install snmpd
sed -i '/mibs/c\#mibs:' /etc/snmp/snmp.conf
sed -i '/agentaddress/c\agentaddress udp:161' /etc/snmp/snmpd.conf
service snmpd restart
