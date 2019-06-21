#!/bin/sh -x
	BASE_VERSION=$(curl -s "https://circleci.com/api/v1.1/project/github/Dexels/dexels-base?circle-token=${CIRCLE_TOKEN}&limit=1&offset=0&filter=successful" | jq '.[0].build_num')
        NAVAJO_VERSION=$(curl -s "https://circleci.com/api/v1.1/project/github/Dexels/navajo?circle-token=${CIRCLE_TOKEN}&limit=1&offset=0&filter=successful" | jq '.[0].build_num')
        ENTERPRISE_VERSION=$(curl -s "https://circleci.com/api/v1.1/project/github/Dexels/enterprise?circle-token=${CIRCLE_TOKEN}&limit=1&offset=0&filter=successful" | jq '.[0].build_num')
	echo "base: ${BASE_VERSION}"
	echo "navajo: ${NAVAJO_VERSION}"
	echo "enterprise: ${ENTERPRISE_VERSION}"
	rm -rf navajo
	rm -rf enterprise
	rm -rf war
	rm -rf target
	  mkdir target
	  mkdir war
          mkdir -p navajo
          mkdir -p enterprise
          mkdir -p war
          curl -s https://132-190362472-gh.circle-artifacts.com/0/dexels-base.tgz?circle-token=${CIRCLE_TOKEN} >target/base.tgz
          curl -s https://${ENTERPRISE_VERSION}-4423339-gh.circle-artifacts.com/0/enterprise_p2.zip?circle-token=${CIRCLE_TOKEN} >enterprise/enterprise.zip
          curl -s https://${NAVAJO_VERSION}-4423334-gh.circle-artifacts.com/0/navajo_p2.zip?circle-token=${CIRCLE_TOKEN} >navajo/navajo.zip
          curl -s https://55-192688421-gh.circle-artifacts.com/0/dexels-felix.war?circle-token=${CIRCLE_TOKEN} >war/dexels-felix.war
          tar xvfz target/base.tgz -C target
	  find target -name *branding* | xargs rm
          rm target/base.tgz
	mkdir target/application
          cd navajo
          unzip navajo.zip -d .
          rm navajo.zip
          cd ../enterprise
          unzip enterprise.zip -d .
          rm enterprise.zip
          cd ..
          cd war
          unzip dexels-felix.war
          cd ..
          echo "Collecting bundles"
          mv navajo/plugins/*.jar target/application/
          mv enterprise/plugins/*.jar target/application/
          rm -rf navajo
          rm -rf enterprise
          echo "Cleaned up folder"
          find target/bundle -name *redis* | xargs rm
          find target/bundle -name *javax.servlet* | xargs rm
          find target/bundle -name *swift* | xargs rm
          echo "Removed swift"
          find target/bundle -name *gogo* | xargs rm
          echo "Removed gogo"
          find target/bundle -name *.tar.gz | xargs rm
          echo "Removed tar.gz"
          find target/bundle -name *jetty* | xargs rm
          echo "Removed jetty"
          find target/bundle -name *pax-web* | xargs rm
          echo "Removed pax web"
          find target/bundle -name *websocket* | xargs rm
          echo "Removed websocket"
          find target/bundle -name *jgit* | xargs rm
          echo "Removed jgit"
          find target/bundle -name *repository.git* | xargs rm
          echo "Removed repository.git"
#          find target/bundle -name *soap* | xargs rm
#          echo "Removed soap"
	  
          find target/bundle -name com.dexels* | grep -v sharedconfigstore | grep -v index | grep -v mgmt | grep -v bundlesync | grep -v resourcebundle | grep -v context | grep -v immutable | grep -v replication | grep -v pubsub | grep -v repository | grep -v hazelcast | xargs -I '{}' echo "Deleting: {}"
          #find target/bundle -name com.dexels* | grep -v sharedconfigstore | grep -v index | grep -v mgmt | grep -v bundlesync | grep -v resourcebundle | grep -v context | grep -v immutable | grep -v replication | grep -v pubsub | grep -v repository | grep -v hazelcast | xargs rm
	  echo "Adding bundles: "
	  ls  target/bundle/*
	  mkdir war/WEB-INF/application
          cp target/bundle/* war/WEB-INF/bundles/
          cp target/application/* war/WEB-INF/application/
          echo "Removed unwanted bundles"
          cd war
          zip -r navajo-felix.war META-INF/* WEB-INF/*
	cp navajo-felix.war ~/temp/war/
	cd ~/temp/war
	./run.sh
