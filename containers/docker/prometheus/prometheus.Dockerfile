# Dockerfile - Prometheus, Node Exporter, Blackbox Exporter

FROM debian:11.6

# Prometheus

WORKDIR /opt

RUN apt-get update && apt-get install -y wget

RUN wget https://github.com/prometheus/prometheus/releases/download/v2.44.0-rc.0/prometheus-2.44.0-rc.0.linux-amd64.tar.gz
#COPY prometheus-2.44.0-rc.0.linux-amd64.tar.gz ./

RUN tar xvzf prometheus-2.44.0-rc.0.linux-amd64.tar.gz

RUN mv /opt/prometheus-2.44.0-rc.0.linux-amd64 /opt/prometheus

RUN mkdir -p /opt/prometheus/configs

WORKDIR /opt/prometheus/configs

COPY prometheus.yml ./

COPY rules.yml ./

WORKDIR /opt/prometheus

RUN mkdir -p /opt/prometheus/targets

VOLUME ["/opt/prometheus/targets", "/opt/prometheus/configs"]

# Node Exporter

WORKDIR /opt

RUN wget https://github.com/prometheus/node_exporter/releases/download/v1.5.0/node_exporter-1.5.0.linux-amd64.tar.gz
#COPY node_exporter-1.5.0.linux-amd64.tar.gz ./

RUN tar xvzf node_exporter-1.5.0.linux-amd64.tar.gz

RUN mv /opt/node_exporter-1.5.0.linux-amd64 /opt/node_exporter

RUN /opt/node_exporter/node_exporter &

# Blackbox Exporter

WORKDIR /opt

RUN wget https://github.com/prometheus/blackbox_exporter/releases/download/v0.23.0/blackbox_exporter-0.23.0.linux-amd64.tar.gz
#COPY blackbox_exporter-0.23.0.linux-amd64.tar.gz ./

RUN tar xvzf blackbox_exporter-0.23.0.linux-amd64.tar.gz

RUN mv blackbox_exporter-0.23.0.linux-amd64 blackbox_exporter

RUN mkdir -p /opt/blackbox_exporter/configs

WORKDIR /opt/blackbox_exporter/configs

COPY blackbox.yml ./

VOLUME ["/opt/blackbox_exporter/configs"]

RUN /opt/blackbox_exporter/blackbox_exporter --config.file=/opt/blackbox_exporter/configs/blackbox.yml &

#

EXPOSE 9090
EXPOSE 9100
EXPOSE 9115

#ENTRYPOINT ["/bin/bash"]
ENTRYPOINT ["/opt/prometheus/prometheus", "--config.file=/opt/prometheus/configs/prometheus.yml"]