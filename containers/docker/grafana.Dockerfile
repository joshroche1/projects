# Dockerfile - Grafana

FROM debian:11.6

WORKDIR /opt

RUN apt-get update && apt-get install -y wget \
    apt-transport-https \
    software-properties-common
RUN wget -q -O /usr/share/keyrings/grafana.key https://apt.grafana.com/gpg.key
RUN echo "deb [signed-by=/usr/share/keyrings/grafana.key] https://apt.grafana.com stable main" | tee -a /etc/apt/sources.list.d/grafana.list

RUN apt-get update && apt-get install -y grafana

#RUN grafana-cli --config /etc/grafana/grafana.ini admin reset-admin-password grafana

EXPOSE 3000

#ENTRYPOINT ["/bin/bash"]
ENTRYPOINT ["/usr/sbin/grafana-server","--config=/etc/grafana/grafana.ini","--homepath=/usr/share/grafana"]