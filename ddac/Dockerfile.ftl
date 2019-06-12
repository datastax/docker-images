# Copyright DataStax, Inc, 2017
#   Please review the included LICENSE file for more information.
#

FROM dse-base as ddac-base

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

FROM ddac-base as base

ARG VERSION=[=version]
ARG TARBALL=ddac-${VERSION}-bin.tar.gz
ARG DOWNLOAD_URL=${URL_PREFIX}/${DDAC_TARBALL}

RUN set -x \
# Download DDAC tarball if needed
    && if test ! -e /${TARBALL}; then wget -nv --show-progress --progress=bar:force:noscroll -O /${TARBALL} ${DOWNLOAD_URL} ; fi \
# Unpack tarball
    && tar -C "$DDAC_HOME" --strip-components=1 -xzf /${TARBALL} \
    && rm /${TARBALL}

FROM ddac-base

MAINTAINER "DataStax, Inc <info@datastax.com>"

COPY files /

COPY --chown=cassandra:cassandra --from=base $DDAC_HOME $DDAC_HOME

# Create folders
RUN (for dir in /var/log/cassandra /var/lib/cassandra /config ; do \
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
