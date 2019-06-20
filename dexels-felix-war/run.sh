#!/bin/sh
curl -o navajo.war https://51-192688421-gh.circle-artifacts.com/0/navajo-felix.war
docker build . -t dexels/dexels-base-war:1.0.0
docker run -p 8080:8080 \
	dexels/dexels-base-war:1.0.0
