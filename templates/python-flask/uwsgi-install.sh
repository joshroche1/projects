#!/bin/bash

#
apt-get update; apt-get upgrade -y
#
apt install -y uwsgi uwsgi-plugin-python3 uwsgi-plugin-sqlite3
#
echo '[uwsgi]
socket = 0.0.0.0:9090
chdir = /opt/smc/flask
wsgi-file = wsgi.py
uid=smc
gid=smc
callable = app
processes = 4
threads = 2
buffer-size = 65535
stats = 0.0.0.0:9091
plugins = python3' > /etc/uwsgi/apps-available/uwsgi.ini
#
ln -s /etc/uwsgi/apps-available/uwsgi.ini /etc/uwsgi/apps-enabled/uwsgi.ini
#
systemctl restart uwsgi
