#!/bin/bash
set -e

# Legacy
# Loop through ALLOWED_DOMAINS
IFS=, read -ra domains <<< "$ALLOWED_DOMAINS"
COUNTER=0
echo '''<?xml version="1.0"?>
<cross-domain-policy>''' > /var/www/crossdomain.xml
for domain in "${domains[@]}"
do
    echo "  <allow-access-from domain=\"$(echo -e ${domain} | tr -d '[:space:]')\" />" >> /var/www/crossdomain.xml
done
echo "</cross-domain-policy>" >> /var/www/crossdomain.xml

# OoklaServer
echo OoklaServer.allowedDomains = "$ALLOWED_DOMAINS" >> /opt/ookla/OoklaServer.properties

exec "$@"