FROM alpine:3.6

ENV INTERVAL_IN_SECONDS=10

RUN apk add --update --no-cache \
    bash \
    curl

ADD https://bin.equinox.io/c/ekMN3bCZFUn/forego-stable-linux-amd64.tgz /forego.tgz
RUN cd /usr/local/bin && tar xfz /forego.tgz && chmod +x /usr/local/bin/forego && rm /forego.tgz

WORKDIR /opt

RUN echo $'#!/bin/bash\n\
\n\
set -e \n\
while true; do\n\
  curl $SCRAPE_URL | curl --data-binary @- PUSHGATEWAY_URL \n\
  sleep $(( INTERVAL_IN_SECONDS ))\n\
done' > push.sh && chmod +x push.sh

RUN echo 'push: /opt/push.sh' >> Procfile

CMD [ "forego", "start" ]