############################################################
# Dockerfile for Ookla Speedtest Server
# Based on Alpine
############################################################

# Set the base image to Alpine with glibc
FROM frolvlad/alpine-glibc

LABEL maintainer="jsenecal@connectitnet.com"

ENV LANG=C.UTF-8
ENV ALLOWED_DOMAINS *.ookla.com, *.speedtest.net

## Installation
# https://support.ookla.com/hc/en-us/articles/234578568-How-To-Install-Submit-Server

WORKDIR /opt/ookla/

# Install required packages
RUN apk --no-cache add php7 php7-fpm nginx supervisor curl bash

# Download/extract files from ookla
RUN set -o pipefail \
 && curl -O https://install.speedtest.net/httplegacy/http_legacy_fallback.zip \
 && rm -rf /var/www/* \
 && unzip http_legacy_fallback.zip -d /var/www \
 && rm http_legacy_fallback.zip \
 && curl -SL https://install.speedtest.net/ooklaserver/stable/OoklaServer-linux64.tgz | tar -xzoC /opt/ookla/
 
COPY OoklaServer.properties /opt/ookla/OoklaServer.properties

# Copy config files
COPY etc /etc/
COPY ./docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 80 5060 8080 5060/udp 8080/udp
CMD ["/usr/bin/supervisord"]