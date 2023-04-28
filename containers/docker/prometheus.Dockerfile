# Dockerfile - Prometheus

FROM debian:11.6

WORKDIR /opt

RUN apt-get update && apt-get install -y wget

RUN wget https://github.com/prometheus/prometheus/releases/download/v2.37.5/prometheus-2.37.5.linux-amd64.tar.gz

RUN tar xvzf prometheus-2.37.5.linux-amd64.tar.gz

RUN mv /opt/prometheus-2.37.5.linux-amd64 /opt/prometheus

WORKDIR /opt/prometheus

#COPY prometheus.yml ./

#COPY rules.yml ./

RUN mkdir -p /opt/prometheus/scrape_configs

EXPOSE 9090

ENTRYPOINT ["/bin/bash"]
#ENTRYPOINT ["/opt/prometheus/prometheus", "--config.file=/opt/prometheus/prometheus.yml"]
