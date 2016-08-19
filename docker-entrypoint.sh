#!/bin/bash
set -e
if [ "${1:0:1}" = "-" ]
  then
    set -- kibana "$@"
  fi
if [ "$1" = "kibana" -a "$(id -u)" = "0" ]
  then
    set -- su-exec kibana tini -- "$@"
  fi
exec "$@"