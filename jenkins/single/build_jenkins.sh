#/bin/bash
build_prj_name=jenkins
echo "begin to clear environment stibel_${build_prj_name}"
cur_path=`pwd`
if [ ! -d ${cur_path}/data ]; then
    echo "$cur_path/data"
    mkdir -p ${cur_path}/data
    chown -R 1000:1000 ${cur_path}/data
fi

docker stop $(docker ps |grep stibel_${build_prj_name}_0 |awk '{print $1}')
docker rm $(docker ps -q -f status=exited)
#docker rmi stibel_${build_prj_name}:v1.0

echo "end to clear environment stibel_${build_prj_name}"

echo "begin to build stibel_${build_prj_name}"

docker-compose up -d

echo "end to build stibel_${build_prj_name}"