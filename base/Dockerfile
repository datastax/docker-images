# Copyright DataStax, Inc, 2017
#   Please review the included LICENSE file for more information.
#
FROM ubuntu:16.04

MAINTAINER "DataStax, Inc <info@datastax.com>"

ENV DEBIAN_FRONTEND noninteractive

ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
ENV JRE_HOME ${JAVA_HOME}/jre
ENV PATH=${PATH}:/usr/lib/jvm/default-jvm/bin/
ENV LANG=en_US.UTF-8

RUN apt-get update && apt-get install ca-certificates curl wget sysstat \
	-y --no-install-recommends && \
	curl --silent --location --retry 3 --cacert /etc/ssl/certs/GeoTrust_Global_CA.pem \
	http://repo.datastax.com/jdk-distributions/jdk-8u152-linux-x64.tar.gz \
	| tar xz -C /tmp && \
	mkdir -p /usr/lib/jvm && mv /tmp/jdk* "${JAVA_HOME}" && \
	apt-get autoclean && apt-get --purge -y autoremove && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \

    update-alternatives --install "/usr/bin/java" "java" "${JRE_HOME}/bin/java" 1 && \
	update-alternatives --install "/usr/bin/javaws" "javaws" "${JRE_HOME}/bin/javaws" 1 && \
	update-alternatives --install "/usr/bin/javac" "javac" "${JAVA_HOME}/bin/javac" 1 && \
	update-alternatives --set java "${JRE_HOME}/bin/java" && \
	update-alternatives --set javaws "${JRE_HOME}/bin/javaws" && \
	update-alternatives --set javac "${JAVA_HOME}/bin/javac"

ADD files /
