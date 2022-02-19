#!/bin/bash

cd /home/redis/install/redis-6.2.0
make
make PREFIX=/usr/local/redis install 

cp /home/redis/redis-6379.conf /usr/local/redis/