# Alpine Linux

### References

[https://alpinelinux.org](https://alpinelinux.org)
[https://wiki.alpinelinux.org/wiki/Main_Page](https://wiki.alpinelinux.org/wiki/Main_Page)

Examples and snippets for managing Alpine Linux.

## Package Management

```
apk update

apk add PACKAGENAME
```

## OpenRC

[https://github.com/OpenRC/openrc](https://github.com/OpenRC/openrc)

Get status of all services
```
rc-status
```
Get status of single service
```
rc-service SERVICENAME status
```
Service Commands
```
rc-service SERVICENAME stop|start|restart|reload...
```
Add a service (Must have init file: /etc/init.d/INITFILE)
```
rc-update add SVCNAME default
```
