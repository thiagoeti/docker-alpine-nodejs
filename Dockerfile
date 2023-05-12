#++++++++++++++++++++++++++++++++++++++
# Docker/Podman - Alpine - NodeJS
#++++++++++++++++++++++++++++++++++++++

# so
FROM alpine:latest

# by
MAINTAINER Thiago Silva - thiagoeti@gmail.com

# update
RUN apk --no-cache update && apk --no-cache upgrade

# bash
RUN apk add bash

# library
RUN apk add wget && \
	apk add curl && \
	apk add git

# nodejs
RUN apk add nodejs && \
	apk add npm && \
	ln -s /usr/bin/node /usr/bin/nodejs

# clear
RUN rm -rfv /var/cache/apk/*

# ports
EXPOSE 80 443 8000

# www
RUN mkdir /data && \
	mkdir /data/log

# work
WORKDIR /data

# run only
#CMD []

# start app
ENTRYPOINT ["/usr/bin/node", "app.js", "-D", "FOREGROUND"]

#
