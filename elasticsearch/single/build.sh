# !/bin/bash

docker network rm es-net
docker network create es-net
mkdir -p es-data
mkdir -p es-plugins

chown -R 1000:1000 ./es-data
chown -R 1000:1000 ./es-plugins

docker-compose up -d