# Dockerfile - Prometheus, Node Exporter

FROM debian:11.6

# Prometheus

WORKDIR /opt

RUN apt-get update && apt-get install -y wget

RUN wget https://github.com/prometheus/prometheus/releases/download/v2.44.0-rc.0/prometheus-2.44.0-rc.0.linux-amd64.tar.gz

RUN tar xvzf prometheus-2.44.0-rc.0.linux-amd64.tar.gz

RUN mv /opt/prometheus-2.44.0-rc.0.linux-amd64 /opt/prometheus

WORKDIR /opt/prometheus

#COPY prometheus.yml ./

#COPY rules.yml ./

RUN mkdir -p /opt/prometheus/scrape_configs

# Node Exporter

WORKDIR /opt

RUN wget https://github.com/prometheus/node_exporter/releases/download/v1.5.0/node_exporter-1.5.0.linux-amd64.tar.gz

RUN tar xvzf node_exporter-1.5.0.linux-amd64.tar.gz

RUN mv /opt/node_exporter-1.5.0.linux-amd64 /opt/node_exporter

RUN /opt/node_exporter/node_exporter &

#

EXPOSE 9090
EXPOSE 9100

ENTRYPOINT ["/bin/bash"]
#ENTRYPOINT ["/opt/prometheus/prometheus", "--config.file=/opt/prometheus/prometheus.yml"]
