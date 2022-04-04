#!/bin/bash
# Run test consul. usage: test-consul.sh start|stop

conf_json=''

if [ "$1"x == "server"x ] || [ "$1"x == "client"x ]; then
    conf_json=${1}.json
    echo "conf_json:${conf_json}"
else
    echo "Usage: start.sh server|client start|stop"
    exit 1
fi

case "$2" in
start)
    CONSUL_VERSION=`consul --version`
    echo "$CONSUL_VERSION"

    consul info >/dev/null
    if [ $? -eq 0 ]; then
        echo "Consul is already running"
        exit 1
    fi

    DATA_DIR=/home/consul/data
    rm -rf "$DATA_DIR" || (echo "Can not delete data dir" && exit 1)
    consul agent -config-dir=../conf/${conf_json} >/dev/null &
    sleep 3s
    consul info >/dev/null
    if [ $? -ne 0 ]; then
        echo "Failed to start consul"
        exit 1
    else
        echo "Consul started successfully"
    fi
    ;;
stop)
    consul info >/dev/null
    if [ $? -ne 0 ]; then
        echo "Consul is not running"
        exit 0
    fi
    consul leave || exit 1
    ;;
*)
    echo "Usage: start.sh server|client start|stop"
    exit 2
    ;;
esac
