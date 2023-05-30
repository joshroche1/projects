# Dockerfile - Prometheus, Node Exporter

FROM debian:11.6

# Prometheus

WORKDIR /opt

RUN apt-get update && apt-get install -y wget

RUN wget https://github.com/prometheus/prometheus/releases/download/v2.44.0-rc.0/prometheus-2.44.0-rc.0.linux-amd64.tar.gz
#COPY prometheus-2.44.0-rc.0.linux-amd64.tar.gz ./

RUN tar xvzf prometheus-2.44.0-rc.0.linux-amd64.tar.gz

RUN mv /opt/prometheus-2.44.0-rc.0.linux-amd64 /opt/prometheus

WORKDIR /opt/prometheus

RUN mkdir -p /opt/prometheus/configs

WORKDIR /opt/prometheus/configs

COPY prometheus.0.1.yml ./

COPY rules.yml ./

WORKDIR /opt/prometheus

RUN mkdir -p /opt/prometheus/targets

VOLUME ["/opt/prometheus/targets", "/opt/prometheus/configs"]
#

EXPOSE 9090

#ENTRYPOINT ["/bin/bash"]
ENTRYPOINT ["/opt/prometheus/prometheus", "--config.file=/opt/prometheus/configs/prometheus.0.1.yml"]
