#/bin/bash
build_prj_name=fastdfs
echo "begin to clear environment stibel_${build_prj_name}"

docker stop $(docker ps |grep stibel_${build_prj_name}_0 |awk '{print $1}')
docker rm $(docker ps -q -f status=exited)
docker rmi stibel_${build_prj_name}:v1.0

echo "end to clear environment stibel_${build_prj_name}"

echo "begin to build stibel_${build_prj_name}"

cp ./environment/${build_prj_name}.env .env

docker-compose up -d

echo "end to build stibel_${build_prj_name}"