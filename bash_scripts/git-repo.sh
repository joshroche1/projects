#!/bin/bash


#
apt update ; apt install git

adduser git

sudo -u git sshkeygen -t ed25519

# copy SSH key pub to /home/git/.ssh/authorized_keys

sudo -u git mkdir -p /home/git/repositories/project.git

cd /home/git/repositories/project.git

sudo -u git git init --bare

echo'On Local System:'
echo
echo ' cd ../project/dir'
echo ' git init'
echo ' add files'
echo ' git add .'
echo ' git commit -m "MESSAGE"'
echo ' git remote add origin git@SERVERIP:/home/git/repositories/project.git'
echo ' git push --set-upstream origin master'
echo
echo 'To Clone:'
echo
echo ' git clone git@SERVERIP:/home/git/repositories/project.git'
