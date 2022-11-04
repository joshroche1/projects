#!/bin/bash

CERT_SUBJ="/C=/ST=/L=/O=/OU=/CN=/"
# "/C=DE/ST=NRW/L=Berlin/O=My Inc/OU=DevOps/CN=jar.net/emailAddress=admin@jar.net

openssl \
    req \
    -nodes \
    -newkey rsa:4096 \
    -keyout server.key \
    -out server.csr \
    -subj $CERT_SUBJ
openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt
cp server.crt /etc/ssl/certs
cp server.key /etc/ssl/private
