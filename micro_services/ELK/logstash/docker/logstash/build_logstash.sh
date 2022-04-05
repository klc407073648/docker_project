#/bin/bash

chmod 777 -R ./pipeline/
chmod 777 -R ./data/
chmod 777 -R ./config/

docker-compose up -d
