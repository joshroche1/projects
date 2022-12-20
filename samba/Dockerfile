FROM ubuntu:20.04

ENV HOSTNAME="samba"
ENV REALM="JAR.NET"
ENV DOMAIN="JAR"
ENV FQDN="samba.jar.net"
ENV IPADDR=192.168.2.240
ENV PASSWORD="P@55w0rd!"
RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y \
  samba smbclient winbind krb5-kdc \
  krb5-user krb5-config libpam-winbind \
  libnss-winbind libpam-krb5 -y -q
RUN mv /etc/samba/smb.conf /etc/samba/smb.conf.OLD
RUN mv /etc/krb5.conf /etc/krb5.conf.OLD
RUN samba-tool domain provision --use-rfc2307 \
  --domain=$DOMAIN --realm=$REALM --adminpass=$PASSWORD \
  --dns-backend=SAMBA_INTERNAL --server-role=dc
RUN cp /var/lib/samba/private/krb5.conf /etc/krb5.conf
RUN systemctl mask smbd nmbd winbind; systemctl disable smbd nmbd winbind; \
  systemctl stop smbd nmbd winbind; systemctl unmask samba-ad-dc; 
  systemctl start samba-ad-dc; systemctl enable samba-ad-dc; \
  systemctl stop systemd-resolved; systemctl disable systemd-resolved; \
  unlink /etc/resolv.conf
RUN echo 'nameserver $IPADDR' >> /etc/resolv.conf; \
  echo 'search $REALM' >> /etc/resolv.conf
RUN systemctl restart samba-ad-dc 
EXPOSE ["53/tcp","80/tcp","88/tcp","389/tcp","443/tcp","636/tcp"]
EXPOSE ["137/tcp","138/tcp","139/tcp","445/tcp","464/tcp"]
