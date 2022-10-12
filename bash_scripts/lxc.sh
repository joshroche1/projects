#!/bin/bash

snap install lxd
usermod -aG lxd $USER
lxd init
lxc launch ubuntu:20.04 $ALIAS
lxc exec $ALIAS $COMMAND
lxc config device add $ALIAS myport80 proxy listen=tcp:0.0.0.0:80 connect=tcp:127.0.0.1:80
lxc config device add $ALIAS myport443 proxy listen=tcp:0.0.0.0:443 connect=tcp:127.0.0.1:443

lxc list
lxc remote list
lxc image list ubuntu:
lxc stop $ALIAS
lxc delete $ALIAS
