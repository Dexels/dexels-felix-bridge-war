#!/bin/sh
mvn clean install -U
docker build . -t dexels/dexels-base-war:1.0.0
docker run -p 8080:8080 \
	dexels/dexels-base-war:1.0.0
