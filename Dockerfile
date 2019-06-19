FROM tomcat:9.0-jre11
MAINTAINER Frank Lyaruu
COPY dexels-felix-war/target/dexels-felix.war  /usr/local/tomcat/webapps/navajo.war
