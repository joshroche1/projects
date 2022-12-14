#!/bin/bash

# DEPENDENCIES
apt update; apt upgrade -y
apt install -y python3 python3-pip \
        python3-flask python3-flask-sqlalchemy \
        python3-wtforms python3-dotenv python3-psycopg2
pip3 install flask-mobility
#
# OTHER DB OPTIONS
#apt install postgresql
#
