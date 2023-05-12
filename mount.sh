#!/bin/sh

# data
mkdir "/data"
mkdir "/data/www"

# log
mkdir "/data/log"
mkdir "/data/log/nodejs"
mkdir "/data/log/nodejs/app-nodejs"

# app
mkdir "/data/www/app-nodejs"
mkdir "/data/www/app-nodejs/log"

# drop
docker rmi -f "alpine-nodejs"

# build
docker build --no-cache -t "alpine-nodejs" "/data/container/alpine-nodejs/."

# test
rm -rfv "/data/www/app-nodejs"
cp -rfv "/data/container/alpine-nodejs/_app/" "/data/www/app-nodejs"

# drop
docker rm -f "app-nodejs"

# run
docker run --name "app-nodejs" \
	-p 7000:80 \
	-v "/etc/hosts":"/etc/hosts" \
	-v "/data/log/nodejs/app":"/data/log" \
	-v "/data/www/app-nodejs":"/data" \
	--restart=always \
	-d "alpine-nodejs":"latest"

# attach
docker attach "app-nodejs"
docker exec -it "app-nodejs" "/bin/bash"

# start
docker start "app-nodejs"

# app
docker exec -d "app-nodejs" "/bin/bash" nodejs -v
docker exec -d "app-nodejs" "/bin/bash" npm install

#
