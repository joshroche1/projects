#!/bin/bash
# Ubuntu

apt-get install samba ntfs-3g -y
cat > /etc/samba/smb.conf << EOL
[global]
	workgroup = WORKGROUP
	security = user
	server string = %h server (Samba, Ubuntu)
	log file = /var/log/samba/log.%m
	max log size = 1000
	logging = file
	panic action = /usr/share/samba/panic-action %d
	server role = standalone server
	obey pam restrictions = yes
	unix password sync = yes
	passwd program = /usr/bin/passwd %u
	passwd chat = *Enter\snew\s*\spassword:* %n\n *Retype\snew\s*\spassword:* %n\n *password\supdated\ssuccessfully* .
	pam password change = yes
	map to guest = Bad User
	userhare allow guest = no
	min protocol = SMB2
[homes]
	read only = no
[printers]
	comment = All Printers
	browseable = no
	path = /var/spool/samba
	printable = yes
	guest ok = no
	read only = yes
	create mask = 0700
[print$]
	comment = Print Drivers
	path = /var/lib/samba/printers
	browseable = yes
	read only = yes
	guest ok = no
[share]
	path = /srv/share/
	read only = no
	browseable = yes
	valid users = ubuntu
	guest ok = no
	create mask = 0755
EOL

service smbd restart
# smbpasswd -a USERNAME