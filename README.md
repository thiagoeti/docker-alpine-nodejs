# Docker - Alpine - NodeJS

Container to run PHP.

Create **data**.

```console
mkdir "/data"
mkdir "/data/www"
```

Create **log**.

```console
mkdir "/data/log"
mkdir "/data/log/nodejs"
mkdir "/data/log/nodejs/app-php"
```

Create repository for **app**.

```console
mkdir "/data/www/app-nodejs"
mkdir "/data/www/app-nodejs/log"
```

#### Dockerfile

File *dockerfile* for mount machine.

```dockerfile
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

# start app
ENTRYPOINT ["/usr/bin/node", "app.js", "-D", "FOREGROUND"]
```

## Build Machine

```console
docker build --no-cache -t "alpine-nodejs" "/data/container/alpine-nodejs/."
```

### APP

Copy script for test APP.

```console
cp -rfv "/data/container/alpine-nodejs/_app/" "/data/www/app-nodejs"
```

Script APP.

```js
const http = require('http');

const hostname = '0.0.0.0';
const port = 80;

const server = http.createServer((req, res) => {
	res.statusCode = 200;
	res.setHeader('Content-Type', 'text/plain');
	res.end('Hello World\n');
});

server.listen(port, hostname, () => {
	console.log(`Server running at http://${hostname}:${port}`);
});
```

Run container APP.

```console
docker run --name "app-nodejs" \
	-p 7003:80 \
	-v "/etc/hosts":"/etc/hosts" \
	-v "/data/log/nodejs/app":"/data/log" \
	-v "/data/www/app-nodejs":"/data" \
	--restart=always \
	-d "alpine-nodejs":"latest"
```

> Important: **/etc/hosts** shared to configuration all server.

Attach container.

```console
docker attach "app-nodejs"
docker exec -it "app-nodejs" "/bin/bash"
```

Run in container.

```console
docker exec -d "app-nodejs" "/bin/bash" nodejs -v
docker exec -d "app-nodejs" "/bin/bash" npm install
```
