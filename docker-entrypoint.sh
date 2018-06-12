#!/bin/sh

set -e

if [ -z "${NGINX_HOST}" ]; then
  echo "Error: HTTP_HOST not defined"
  exit 1
fi

# cleanup NGINX_HOST (eventually remove protocol, port etc...)
export NGINX_HOST=`echo $NGINX_HOST | sed 's/^http\(\|s\):\/\/\(.*\)/\2/g' | sed 's/:[0-9]\+//g' | sed 's/\/$//g'`

if [ -z "${CERTS_DIR}" ]; then
  export CERTS_DIR="/etc/nginx/certs/${NGINX_HOST}"
fi

mkdir -p "${CERTS_DIR}"

echo "Replacing environement variables"
echo "CERTS_DIR:  ${CERTS_DIR}"
echo "NGINX_HOST: ${NGINX_HOST}"

if [ "${ENABLE_HTTPS}" = "true" ]; then
  envsubst '$NGINX_HOST,$CERTS_DIR' < /etc/nginx/nginx_ssl.conf.envsubst > /etc/nginx/nginx.conf
else
  envsubst '$NGINX_HOST' < /etc/nginx/nginx.conf.envsubst > /etc/nginx/nginx.conf
fi

cat /etc/nginx/nginx.conf

# Run the CMD 
exec "$@"
