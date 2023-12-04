# Debian Linux

### References

[https://debian.org](https://debian.org)
[https://wiki.debian.org](https://wiki.debian.org)

## Package Management - APT

```
apt update
```

## Service Management - systemd

```
systemctl
systemctl daemon-reload
systemctl start|stop|status|restart|reload|enable|disable $SERVICENAME
  start|stop|restart|reload # basic defined functions
  enable|disable            # allows service to start on boot or not
```
Service files are normally located here: `/etc/systemd/system/`

## Networking

Configuration could be in these locations:
```
/etc/network/interfaces
/etc/network/interfaces.d/FILE
/etc/dhcpcd.conf 
/etc/dhcp/dhclient.conf
/etc/wpa_supplicant/
/etc/systemd/network/FILE
```

For /etc/network/interfaces, to define a network interface, use this format:
```
auto $INTF
iface $INTF inet static
    address 1.2.3.4/24
    gateway 1.2.3.254
    post-up route add -A inet default gw 1.2.3.254 || true
    pre-down route del -A inet default gw 1.2.3.254 || true
```
To Manage interfaces:
```
ifup $INTF
ifdown $INTF

# check IP
ip a
# or
ifconfig

# check IP routing
ip r
```

## /etc/fstab & such
Steps to add external storage (SSD,NVMe,HDD,ect...):

See if drive is available:
```
lsblk
```
If you see something like this, with nothing after 'disk':
```
sdb       8:16   0  1000G  0 disk 
```
Then you have a drive that can be added.
Use Parted to label the drive for GPT:
```
parted --script -a optimal /dev/sdb mklabel gpt
```
Then use Parted to create a primary partition:
```
parted --script -a optimal /dev/sdb mkpart primary 0% 100%
```
Now with `lsblk` you should see the created partition:
```
sdb       8:16   0  1000G  0 disk 
└─sdb1    8:17   0  1000G  0 part
```
Format the partition to ext4, or another type:
```
mkfs.ext4 /dev/sdb1
```
Get the UUID of the new filesystem:
```
blkid
```
It should show something like this:
```
/dev/sdb1: UUID="7afec6eb-e549-4334-b108-45909c6f83e7" BLOCK_SIZE="4096" TYPE="ext4" PARTLABEL="primary" PARTUUID="58d31bfc-1d16-4178-b26b-402577b91615"
```
Edit the /etc/fstab file by adding the following line (remove quotation marks from UUID):
```
UUID=7afec6eb-e549-4334-b108-45909c6f83e7  /mnt/data  ext4  defaults  0  0
```
Reload systemd so the OS can see the changes to /etc/fstab:
```
systemctl daemon-reload
```
You can immediately mount the FS with:
```
mount /mnt/data
```
