FROM alpine:3.22.1

ARG PKGURL=https://github.com/prometheus/alertmanager/releases/download/v0.28.1/alertmanager-0.28.1.linux-amd64.tar.gz
ARG PKGNAME=alertmanager-0.28.1.linux-amd64

RUN apk update
RUN apk add wget

WORKDIR /root

RUN wget $PKGURL
RUN tar xvzf $PKGNAME.tar.gz

RUN adduser -H -s /bin/false -D alertmanager
RUN chown alertmanager: /root/$PKGNAME
RUN mv $PKGNAME/alertmanager /usr/local/bin/
RUN mv $PKGNAME/amtool /usr/local/bin/

RUN mkdir -p /etc/alertmanager
RUN mkdir -p /mnt/alertmanager

COPY alertmanager.yml /etc/alertmanager/

RUN chown -R alertmanager: /etc/alertmanager
RUN chown -R alertmanager: /mnt/alertmanager

USER alertmanager

EXPOSE 9093

CMD ["/usr/local/bin/alertmanager", "--config.file", "/etc/alertmanager/alertmanager.yml", "--storage.path", "/mnt/alertmanager/", "--log.level=debug"]
