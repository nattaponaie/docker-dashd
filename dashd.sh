#!/bin/bash
set -e

docker=$(which docker)

case "$1" in
  install)
    "$docker" pull thelazier/docker-dashd:latest
    ;;
  start)
    "$docker" run -d -p 0.0.0.0:9999:9999 -p 0.0.0.0:9998:9998 --name dashd thelazier/docker-dashd:latest
    ;;
  stop)
    "$docker" stop dashd
    ;;

  uninstall)
    "$docker" rm dashd
    "$docker" rmi thelazier/docker-dashd
    ;;
  *)
    echo "Usage: $0 [install|start|stop|uninstall]"
    exit 1
    ;;
esac

