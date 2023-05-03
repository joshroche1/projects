# Dockerfile - Alert Manager

FROM debian:11.6

WORKDIR /opt

RUN apt-get update && apt-get install -y wget

#RUN wget https://github.com/prometheus/alertmanager/releases/download/v0.25.0/alertmanager-0.25.0.linux-amd64.tar.gz
COPY alertmanager-0.25.0.linux-amd64.tar.gz ./

RUN tar xvzf alertmanager-0.25.0.linux-amd64.tar.gz

RUN mv /opt/alertmanager-0.25.0.linux-amd64 /opt/alertmanager

WORKDIR /opt/alertmanager

EXPOSE 9093

ENTRYPOINT ["/opt/alertmanager/alertmanager"]