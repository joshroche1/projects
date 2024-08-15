#!/bin/bash

# Set variables here
HOSTNAME="samba"
REALM="JAR.NET"
DOMAIN="JAR"
FQDN="samba.jar.net"
IPADDR=192.168.2.240
PASSWORD="P@55w0rd!"

#
hostnamectl set-hostname $HOSTNAME
echo '$IPADDR $HOSTNAME $FQDN' >> /etc/hosts
apt-get update; apt-get upgrade -y; apt dist-upgrade -y; apt-get install samba smbclient winbind krb5-kdc krb5-user krb5-config libpam-winbind libnss-winbind libpam-krb5 -y -q
mv /etc/samba/smb.conf /etc/samba/smb.conf.OLD
mv /etc/krb5.conf /etc/krb5.conf.OLD
samba-tool domain provision --use-rfc2307 --domain=$DOMAIN --realm=$REALM --adminpass=$PASSWORD --dns-backend=SAMBA_INTERNAL --server-role=dc
cp /var/lib/samba/private/krb5.conf /etc/krb5.conf
systemctl mask smbd nmbd winbind
systemctl disable smbd nmbd winbind
systemctl stop smbd nmbd winbind
systemctl unmask samba-ad-dc
systemctl start samba-ad-dc
systemctl enable samba-ad-dc
systemctl stop systemd-resolved
systemctl disable systemd-resolved
unlink /etc/resolv.conf
echo 'nameserver $IPADDR' >> /etc/resolv.conf
echo 'search $REALM' >> /etc/resolv.conf
systemctl restart samba-ad-dc 
