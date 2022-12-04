FROM alpine:latest
LABEL maintainer "cloudwindy <skey@skc0.com>"

WORKDIR /root

ENV PYTHONUNBUFFERED="1"

RUN set -ex && \
    apk update && \
    apk upgrade && \
    apk add --no-cache bash jq python3 tzdata openssl ca-certificates wget && \
    ln -sf python3 /usr/bin/python && \
    python3 -m ensurepip && \
    pip3 install --no-cache --upgrade pip setuptools && \
    pip3 install --no-cache yq && \
    mkdir -p /etc/v2ray /usr/local/share/v2ray /var/log/v2ray

ADD https://github.com/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip v2ray.zip

RUN set -ex && \
    unzip v2ray.zip && \
    chmod +x v2ray && \
    mv v2ray /usr/bin/ && \
    mv geosite.dat geoip.dat /usr/local/share/v2ray/ && \
    mv config.json /etc/v2ray/config.json && \
    rm -rf *

CMD [ "/bin/bash", "-c", "yq . /etc/v2ray/config.yaml | v2ray" ]
