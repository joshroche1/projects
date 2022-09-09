#!/bin/bash


apt-get update; apt-get upgrade -y
apt-get install default-jdk

wget https://github.com/keycloak/keycloak/releases/download/19.0.1/keycloak-19.0.1.tar.gz

tar xvzf keycloak-19.0.1.tar.gz
mv keycloak-19.0.1 keycloak
cd keycloak
