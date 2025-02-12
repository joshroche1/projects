### SHELL SCRIPTS ###
#
#=====[nping]
#
nping   # generate IP traffic
nping --tcp -p 80,443 {$TARGETHOST|...}
stress    # HW stress testing
#
#=====[CURL]
#
curl --header "Content-Type: application/json" \
  --request POST https://12.34.56.78:9000/api/login \
  --data ''
#
# https://localhost:5665/v1/objects/hosts?host=www-console
#
curl -k -i -u cli:123456789abcddef \
  -H 'Accept: application/json' \
  -H 'X-HTTP-Method-Override: GET' \
  -X POST 'https://localhost:5665/v1/objects/services' \
  -d '
{
  "attrs": [ "last_check_result" ],
  "joins": [ "host.name", "host.address" ], 
  "filter": [ "host.name==\"icinga\" && service.name==\"memory\"" ], 
  "pretty": true 
}'
#
#=====[Shell Loops]
#
cids="111111111 222222222 333333333 444444444"
for cid in ${cids}; do
  ./query-sessions-table.py cid ${cid} 2022-08-25 2023-03-15
done
#
#=====[Environment Variables]
#
# load env variables from a file
export $(grep -v '^#' .env | xargs)
#
#=====[OpenSSH]
#
ssh -p 12345 -i ~/.ssh/id_rsa username@11.22.33.44
#
# Generate SSH Key/Cert
ssh-keygen -t ed25519 -b 4096 -N "" -f ~/.ssh/id_ed25519
#
# Remove host from known_hosts
ssh-keygen -R $HOSTNAME_OR_IPADDRESS -f ~/.ssh/known_hosts
#
# Port Forwarding
ssh -L 8006:localhost:8006 -A -p 42222 root@HOST
ssh -L 8000:172.17.17.161:443 -A -p 42222 root@HOST
#
/usr/bin/ssh -NTq -c aes256-gcm@openssh.com -o ServerAliveInterval=60 -o ServerAliveCountMax=3 -o ExitOnForwardFailure=yes -p 42222 -l autossh -L 12003:localhost:2003 111.222.33.44
#
/usr/bin/ssh -NTCq \
-c aes256-gcm@openssh.com \
-o ServerAliveInterval=60 \
-o ServerAliveCountMax=3 \
-o ExitOnForwardFailure=yes \
-p 42222 \
-L 18000:localhost:8000 \
-l autossh \
11.22.33.44
#
ssh
  -A    # ssh-agent authentication
  -l $USER
  -L SRCPORT:DSTHOST:DSTPORT    # port forwarding
  -p SRCPORT
#
#=====[OpenSSL]
#
# Test TLS connection
openssl s_client -connect DSTHOST:PORT
#
# Generate TLS key pair
openssl req -newkey rsa:4096 -nodes -keyout server.key -x509 -out server.crt -subj "/C=/ST=/L=/O=/OU=/CN=/"
openssl req \
  -newkey \
  rsa:4096 \
  -nodes \
  -keyout server.key \
  -x509 \
  -out server.crt \
  -subj "/C=DE/ST=Baden-Wuerttemburg/L=Stuttgart/O=JederTisch/OU=OPS/CN=my.jedertisch.de/"
#
# view certificate details
openssl x509 -in CERTIFICATE.PEM -text
#
# Random HEX number
openssl rand -hex 9
#
# Generate CA private key and certificate
openssl req -x509 -sha256 -days 3650 -newkey rsa:4096 -noenc -keyout ca.key -out ca.crt
# Generate client key and CSR
openssl req -newkey rsa:4096 -nodes -keyout client.key -out client.csr
# Generate Signed Client certificate
openssl x509 -req -in client.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out client.crt
#
openssl dhparam -outform PEM -out dhparam.pem 4096
openssl genrsa -out client.key 4096
openssl req -new -key client.key -out client.csr
openssl x509 -req -in client.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out client.crt
#
#=====[sed]
#
sed -i 's/regex/replace/flags' filename
# -i edit file in place
# /g global flag - replaces all matched instances
#
#=====[LXD]
#
lxc image list images:debian/11
lxc launch images:debian/11 DEBIAN-1
lxc exec DEBIAN-1 -- bash
lxc stop c1
lxc network attach lxdbr0 c1 eth0 eth0
lxc config device set c1 eth0 ipv4.address 10.99.10.42
lxc start c1
### GET NETWORKING WORKING AGAIN WITH DOCKER
iptables -A FORWARD -o lxdbr0 -j ACCEPT
iptables -A FORWARD -i lxdbr0 -j ACCEPT
iptables-save
#
#=====[tcpdump]
#
tcpdump host 1.2.3.4
tcpdump src port 5432
#
#=====[date formatting]
#
date +%d-%m-%y
date +%d-%m-%y_%H:%M:%S
#
#=====[iptables]
#
apt install netfilter-persistent
iptables -L -vn
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
netfilter-persistent save
#
#/etc/iptables/rules.v4
# -A INPUT -p tcp -m tcp -s SOURCEIP --dport PORT -j ACCEPT
#
#=====[ufw]
ufw enable
ufw status
ufw add 80/tcp
ufw allow in on eth0 to any port 80
ufw deny http|from 1.2.3.4
#
