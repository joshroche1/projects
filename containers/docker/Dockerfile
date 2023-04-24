# Dockerfile example

FROM debian

WORKDIR /opt/app

COPY app.tar ./

RUN tar xvf app.tar

WORKDIR /opt/app/workdir

RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip

RUN pip install --no-cache-dir bcrypt

#RUN pip3 install --no-cache-dir -r requirements.txt

EXPOSE 8000

#ENTRYPOINT ["/bin/bash"]
CMD ["/usr/bin/python3", "app.py"]
