#!/bin/sh

# The nginx image used as a proxy server doesn't resolve DNS names using the configuration that docker provides.
# Therefore, it doesn't know docker service names or hostnames or localhost, for example.
# This entrypoint gets automatically appended to the image's entrypoint and addds the resolutions.
# adapted from https://github.com/jetbrains-infra/docker-nginx-resolver/blob/master/entrypoint.sh

set -e

# Writes to the folder that the image expects to contain additional nginx configs
echo resolver $(awk 'BEGIN{ORS=" "} $1=="nameserver" {print $2}' /etc/resolv.conf) ";" > /etc/nginx/conf.d/resolver.conf

exec "$@"
