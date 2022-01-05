#/bin/bash
project_name='stibel'
docker_name='webserver'
docker stop $(docker ps |grep ${webserver} |awk '{print $1}')
docker rm $(docker ps -q -f status=exited)
   
cp ./environment/StiBel.env .env

docker-compose up -d