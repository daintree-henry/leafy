#!/bin/sh
set -e

# Substitute environment variables in default.conf.template and save the result to default.conf
envsubst '${BACKEND_HOST} ${BACKEND_PORT}' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf

# Run the next command
exec "$@"
