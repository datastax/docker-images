# Copyright DataStax, Inc, 2017
#   Please review the included LICENSE file for more information.
#

FROM dse-base

MAINTAINER "DataStax, Inc <info@datastax.com>"

ARG VERSION=5.1.11
ARG URL_PREFIX=http://localhost
ARG DDAC_TARBALL=ddac-${VERSION}-bin.tar.gz
ARG DDAC_DOWNLOAD_URL=${URL_PREFIX}/${DDAC_TARBALL}


ENV DDAC_HOME /opt/cassandra

RUN set -x \
# Add cassandra user
    && groupadd -r cassandra --gid=999 \
    && useradd -m -d "$DDAC_HOME" -r -g cassandra --uid=999 cassandra

# Install missing packages
RUN set -x \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get update -qq \
    && apt-get install -y python adduser lsb-base procps gzip zlib1g wget debianutils \
    && apt-get remove -y python3 \
    && apt-get autoremove --yes \
    && apt-get clean all \
    && rm -rf /var/lib/{apt,dpkg,cache,log}/

COPY files /

RUN set -x \
# Download DDAC tarball if needed
    && if test ! -e /${DDAC_TARBALL}; then wget -q -O /${DDAC_TARBALL} ${DDAC_DOWNLOAD_URL} ; fi \
# Unpack tarball
    && tar -C "$DDAC_HOME" --strip-components=1 -xzf /${DDAC_TARBALL} \
    && rm /${DDAC_TARBALL} \
    && chown -R cassandra:cassandra ${DDAC_HOME} \

# Create folders
    && (for dir in /var/log/cassandra /var/lib/cassandra /config ; do \
        mkdir -p $dir && chown -R cassandra:cassandra $dir && chmod 777 $dir ; \
    done ) \
    && (for dir in $DDAC_HOME/data $DDAC_HOME/logs ; do \
        mkdir -p $dir && chown -R cassandra:cassandra $dir ; \
    done ) 

ENV PATH $DDAC_HOME/bin:$PATH
ENV HOME $DDAC_HOME
ENV CASSANDRA_HOME $DDAC_HOME
WORKDIR $HOME

USER cassandra

# Expose cassandra folders
VOLUME ["/opt/cassandra/data", "/opt/cassandra/logs"]

# Expose cassandra ports
# 7000: intra-node communication
# 7001: TLS intra-node communication
# 7199: JMX
# 9042: CQL
# 9160: thrift service
EXPOSE 7000 7001 7199 9042 9160


# Run cassandra in foreground by default
ENTRYPOINT [ "/entrypoint.sh", "cassandra", "-f" ]
