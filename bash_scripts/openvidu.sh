#!/bin/bash

cd /opt
apt-get update && apt-get upgrade -y
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common -y
# curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
#sudo add-apt-repository \
#   "deb [arch=amd64] https://download.docker.com/linux/debian \
#   $(lsb_release -cs) \
#   stable"
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io -y
sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
curl https://s3-eu-west-1.amazonaws.com/aws.openvidu.io/install_openvidu_latest.sh | bash
cd openvidu
# nano openvidu/.env
### REPLACE THESE ========================================================
ADDR=www.example.com
EMAIL=user@example.com
### ======================================================================
sed -i 's/DOMAIN_OR_PUBLIC_IP=/DOMAIN_OR_PUBLIC_IP=$ADDR/g' .env
sed -i 's/OPENVIDU_SECRET=/OPENVIDU_SECRET=openvidu/g' .env
sed -i 's/CERTIFICATE_TYPE=selfsigned/CERTIFICATE_TYPE=letsencrypt/g' .env
sed -i 's/LETSENCRYPT_EMAIL=user@example.com/LETSENCRYPT_EMAIL=$EMAIL/g' .env
./openvidu start
# -----Remove-OpenVidu-Call-App-----
# cd /opt/openvidu
# ./openvidu stop
# rm docker-compose.override.yml
