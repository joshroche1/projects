#!/bin/bash
cd
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install default-jdk maven unzip mysql-server
wget http://apache.mirrors.pair.com/tomee/tomee-8.0.2/apache-tomee-8.0.2-webprofile.zip
sudo cp apache-tomee-8.0.2-webprofile.zip /opt
cd /opt
sudo unzip apache-tomee-8.0.2-webprofile.zip
sudo mv apache-tomee-webprofile-8.0.2 tomee

sudo iptables -A PREROUTING -t nat -i eth0 -p tcp --dport 80 -j REDIRECT --to-port 8080
sudo iptables -A PREROUTING -t nat -i eth0 -p tcp --dport 443 -j REDIRECT --to-port 8443
sudo iptables-save

sudo useradd tomee pass?

tomee.service??
sudo systemctl daemon-reload
sudo systemctl tomee start

cd /opt/tomee/bin
keytool -genkey -alias tomee -keyalg RSA pass??
/opt/tomee/conf/server.xml << <connector ssl>???
/opt/tomee/conf/tomcat-users.xml << roles,user
/opt/tomee/webapp/manager/META-INF/context.xml << valve
/opt/tomee/webapp/host-manager/META-INF/context.xml << valve
sudo systemctl restart tomee

sudo mysql_secure_installation | n | PASSWORD | PASSWORD | y | n | y | y
sudo mysql -uroot -p | PASSWORD | CREATE DATABASE tomee; | CREATE USER tomee@localhost IDENTIFIED BY 'ApacheTomEE'; | GRANT ALL PRIVILEGES ON tomee.* TO tomee@localhost; | quit

