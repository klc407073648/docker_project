#/bin/bash
echo "begin to clear environment stibel_redis"

docker stop $(docker ps |grep stibel_redis_0 |awk '{print $1}')
docker rm $(docker ps -q -f status=exited)
docker rmi stibel_redis:v1.0

echo "end to clear environment stibel_redis"

echo "begin to build stibel_redis"

cp ./environment/redis.env .env

docker-compose up -d

echo "end to build stibel_redis"
