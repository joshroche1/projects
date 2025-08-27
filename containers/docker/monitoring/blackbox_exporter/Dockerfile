FROM alpine:3.22.1

ARG PKGURL=https://github.com/prometheus/blackbox_exporter/releases/download/v0.27.0/blackbox_exporter-0.27.0.linux-amd64.tar.gz
ARG PKGNAME=blackbox_exporter-0.27.0.linux-amd64
ARG APPNAME=blackbox_exporter
ARG EXTPORT=9093

RUN apk update
RUN apk add wget

WORKDIR /root

RUN wget $PKGURL
RUN tar xvzf $PKGNAME.tar.gz

RUN adduser -H -s /bin/false -D $APPNAME
RUN mv $PKGNAME/$APPNAME /usr/local/bin/
RUN chown $APPNAME: /usr/local/bin/$APPNAME

RUN mkdir -p /etc/$APPNAME

COPY $APPNAME.yml /etc/$APPNAME/

RUN chown -R $APPNAME: /etc/$APPNAME

WORKDIR /etc/$APPNAME

USER root

EXPOSE $EXTPORT

CMD /usr/local/bin/blackbox_exporter --config.file /etc/blackbox_exporter/blackbox_exporter.yml --log.level debug
