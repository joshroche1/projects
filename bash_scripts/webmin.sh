#!/bin/bash

cd /opt
wget https://prdownloads.sourceforge.net/webadmin/webmin-1.974.tar.gz
tar zxvf webmin-1.974.tar.gz
cd webmin-1.974
./setup.sh

# localhost:10000
