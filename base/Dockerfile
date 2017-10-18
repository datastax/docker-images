# Copyright DataStax, Inc, 2017
#   Please review the included LICENSE file for more information.
#
FROM ubuntu:16.04

MAINTAINER "DataStax, Inc <info@datastax.com>"

ENV DEBIAN_FRONTEND noninteractive

ENV JAVA_HOME=/usr/lib/jvm/default-jvm \
    PATH=${PATH}:/usr/lib/jvm/default-jvm/bin/

RUN apt-get update && \

    apt-get install -y software-properties-common && \

    add-apt-repository ppa:webupd8team/java -y && \

    apt-get update && \

    # make installation not to ask
    echo debconf shared/accepted-oracle-license-v1-1 select true |  debconf-set-selections && \
    echo debconf shared/accepted-oracle-license-v1-1 seen true |  debconf-set-selections && \

    # install neede packages
    apt-get install  -y --no-install-recommends ca-certificates && \

    apt-get -y dist-upgrade && \

    # install java
    apt-get install -y --no-install-recommends oracle-java8-installer && \
    apt-get install -y --no-install-recommends oracle-java8-set-default && \
    apt-get autoremove -y && \

    # remove download
    rm -rf /var/cache/oracle-jdk8-installer && \

    # fix default setting
    ln -s java-8-oracle  /usr/lib/jvm/default-jvm && \

    # remove apt cache from image
    apt-get clean all

ADD files /
