# Copyright DataStax, Inc, 2017
#   Please review the included LICENSE file for more information.
#
FROM ubuntu:16.04

MAINTAINER "DataStax, Inc <info@datastax.com>"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get -y dist-upgrade && \
    # install needed packages
    apt-get install -y --no-install-recommends ca-certificates wget && \
    # install java
    apt-get install -y --no-install-recommends openjdk-8-jdk-headless && \
    apt-get autoremove -y && \
    # remove apt cache from image
    apt-get clean all

ADD files /
