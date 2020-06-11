#!/bin/bash
# run as root
cd /opt
apt-get update
apt-get upgrade -y
apt-get install default-jdk maven unzip mysql-server
wget http://apache.mirrors.pair.com/tomee/tomee-8.0.2/apache-tomee-8.0.2-webprofile.zip
unzip apache-tomee-8.0.2-webprofile.zip
mv apache-tomee-webprofile-8.0.2/ tomee/

iptables -A PREROUTING -t nat -i eth0 -p tcp --dport 80 -j REDIRECT --to-port 8080
iptables -A PREROUTING -t nat -i eth0 -p tcp --dport 443 -j REDIRECT --to-port 8443
iptables-save

useradd tomee
username=tomee
PASSWORD=????
echo "$PASSWORD" | passwd --stdin "tomee"

SVCFILE=/etc/systemd/system/tomee.service
(
cat <<'EOF'
[Unit]
Description=Apache TomEE
After=network.target

[Service]
User=tomee
Type=forking
Environment=JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
Environment=CATALINA_PID=/opt/tomee/temp/tomee.pid
Environment=CATALINA_HOME=/opt/tomee
Environment=CATALINA_BASE=/opt/tomee
Environment=CATALINA_OPTS='-server'
Environment=JAVA_OPTS='-Djava.awt.headless=true'
ExecStart=/opt/tomee/bin/startup.sh
ExecStop=/opt/tomee/bin/shutdown.sh
KillSignal=SIGCONT

[Install]
WantedBy=multi-user.target
EOF
) > $SVCFILE

systemctl daemon-reload
systemctl tomee start

cd /opt/tomee/bin
keytool -genkey -alias tomee -keyalg RSA pass??
/opt/tomee/conf/server.xml << <connector ssl>???
/opt/tomee/conf/tomcat-users.xml << roles,user
/opt/tomee/webapp/manager/META-INF/context.xml << valve
/opt/tomee/webapp/host-manager/META-INF/context.xml << valve
systemctl restart tomee

mysql_secure_installation | n | PASSWORD | PASSWORD | y | n | y | y
mysql -uroot -p | PASSWORD | CREATE DATABASE tomee; | CREATE USER tomee@localhost IDENTIFIED BY '$PASSWORD'; | GRANT ALL PRIVILEGES ON tomee.* TO tomee@localhost; | quit

