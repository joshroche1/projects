#!/bin/bash

cp server.xml /opt
cp tomcat-users.xml /opt
cp context.xml /opt
cd /opt
apt-get update && apt-get upgrade -y
apt-get install openjdk-16-jdk maven
wget https://downloads.apache.org/tomee/tomee-9.0.0-M7/apache-tomee-9.0.0-M7-webprofile.tar.gz
tar xvzf apache-tomee-9.0.0-M7-webprofile.tar.gz
mv apache-tomee-webprofile-9.0.0-M7/ tomee/
iptables -A PREROUTING -t nat -i eth0 -p tcp --dport 80 -j REDIRECT --to-port 8080
iptables -A PREROUTING -t nat -i eth0 -p tcp --dport 443 -j REDIRECT --to-port 8443
iptables-save
useradd -p $(openssl passwd -crypt ApacheTomEE) tomee
mkdir /home/tomee
chown -R tomee: /home/tomee
cp tomee.service /etc/systemd/system/
systemctl daemon-reload
cd /opt/tomee/bin
keytool -genkey -alias tomee -keyalg RSA -storepass ApacheTomEE
cd /opt
cp server.xml /opt/tomee/conf/server.xml
cp tomcat-users.xml /opt/tomee/conf/tomcat-users.xml
cp context.xml /opt/tomee/webapps/manager/META-INF/context.xml
cp context.xml /opt/tomee/webapps/host-manager/META-INF/context.xml
chown -R tomee: tomee/
systemctl start tomee 
