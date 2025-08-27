FROM alpine:3.22.1

ARG PKGURL=https://github.com/prometheus/prometheus/releases/download/v3.5.0/prometheus-3.5.0.linux-amd64.tar.gz
ARG PKGNAME=prometheus-3.5.0.linux-amd64

RUN apk update
RUN apk add wget

WORKDIR /root

RUN wget $PKGURL
RUN tar xvzf $PKGNAME.tar.gz

RUN adduser -H -s /bin/false -D prometheus
RUN chown prometheus: /root/$PKGNAME
RUN mv $PKGNAME/prometheus /usr/local/bin/
RUN mv $PKGNAME/promtool /usr/local/bin/

RUN mkdir -p /etc/prometheus/consoles
RUN mkdir -p /etc/prometheus/console_libraries
RUN mkdir -p /etc/prometheus/scrape_targets
RUN mkdir -p /etc/prometheus/targets
RUN mkdir -p /etc/prometheus/rules
RUN mkdir -p /mnt/prometheus

COPY prometheus.yml /etc/prometheus/

RUN chown -R prometheus: /etc/prometheus
RUN chown -R prometheus: /mnt/prometheus

USER prometheus

EXPOSE 9090

CMD ["/usr/local/bin/prometheus", "--config.file", "/etc/prometheus/prometheus.yml", "--storage.tsdb.path", "/mnt/prometheus/", "--log.level=debug"]
