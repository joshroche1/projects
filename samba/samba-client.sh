#!/bin/bash

# set variables here
HOSTNAME="smbclient"
WORKGROUP="JAR"
REALM="JAR.NET"
PDCIPADDR=192.168.2.240
PASSWORD='P@55w0rd!'
#
apt-get update; apt-get upgrade -y; apt-get install samba krb5-user krb5-config winbind libpam-winbind libnss-winbind -y -q
echo '$PASSWORD' | kinit Administrator
klist
mv /etc/samba/smb.conf /etc/samba/smb.conf.OLD
echo '[global]' > /etc/samba/smb.conf
echo 'workgroup = $WORKGROUP' >> /etc/samba/smb.conf
echo 'realm = $REALM' >> /etc/samba/smb.conf
echo 'netbios name = $HOSTNAME' >> /etc/samba/smb.conf
echo 'security = ads' >> /etc/samba/smb.conf
echo 'dns forwarder = $PDCIPADDR' >> /etc/samba/smb.conf
echo 'idmap config * : backend = tdb' >> /etc/samba/smb.conf
echo 'idmap config *:range = 10000-100000' >> /etc/samba/smb.conf
echo 'template homedir = /home/%D/%U' >> /etc/samba/smb.conf
echo 'template shell = /bin/bash' >> /etc/samba/smb.conf
echo 'winbind use default domain = true' >> /etc/samba/smb.conf
echo 'winbind offline logon = false' >> /etc/samba/smb.conf
echo 'winbind nss info = rfc2307' >> /etc/samba/smb.conf
echo 'winbind enum users = yes' >> /etc/samba/smb.conf
echo 'winbind enum groups = yes' >> /etc/samba/smb.conf
echo 'vfs objects = acl_xattr' >> /etc/samba/smb.conf
echo 'map acl inherit = yes' >> /etc/samba/smb.conf
echo 'store dos attributes = yes' >> /etc/samba/smb.conf
systemctl restart smbd nmbd
net ads join -U Administrator
systemctl restart winbind
systemctl enable smbd nmbd winbind
# wbinfo -u
# wbinfo -g
