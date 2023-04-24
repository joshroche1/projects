# LXD/LXC

<https://linuxcontainers.org/>

## Quick Reference:

> lxc list

> lxc launch images:debian/12 NAME

> lxc exec NAME -- bash

> lxc stop NAME

> lxc network attach lxdbr0 NAME eth0 eth0

> lxc config device set NAME eth0 ipv4.address A.B.C.D

> lxc start NAME
