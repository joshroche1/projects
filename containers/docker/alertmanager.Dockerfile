# Dockerfile - Alert Manager

FROM debian:11.6

WORKDIR /opt

RUN apt-get update && apt-get install -y wget

RUN wget https://github.com/prometheus/alertmanager/releases/download/v0.25.0/alertmanager-0.25.0.linux-amd64.tar.gz
#COPY alertmanager-0.25.0.linux-amd64.tar.gz ./

RUN tar xvzf alertmanager-0.25.0.linux-amd64.tar.gz

RUN mv /opt/alertmanager-0.25.0.linux-amd64 /opt/alert_manager

RUN mkdir -p /opt/alert_manager/configs

WORKDIR /opt/alert_manager/configs

COPY alertmanager.yml ./

VOLUME ["/opt/alert_manager/configs"]

EXPOSE 9093

ENTRYPOINT ["/opt/alert_manager/alertmanager", "--config.file=/opt/alert_manager/configs/alertmanager.yml"]