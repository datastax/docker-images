# Copyright DataStax, Inc, 2017
#   Please review the included LICENSE file for more information.
#
FROM openjdk:8u171-jdk-stretch

MAINTAINER "DataStax, Inc <info@datastax.com>"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install wget sysstat locales -y --no-install-recommends && \
	apt-get autoclean && apt-get --purge -y autoremove && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
	echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
	# set the locale of the container:
    locale-gen

ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8

ADD files /
