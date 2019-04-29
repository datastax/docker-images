# Copyright DataStax, Inc, 2017
#   Please review the included LICENSE file for more information.
#

FROM dse-base

MAINTAINER "DataStax, Inc <info@datastax.com>"

ARG VERSION=1.3.3
ARG URL_PREFIX=http://localhost
ARG DSBULK_TARBALL=dsbulk-${VERSION}.tar.gz
ARG DSBULK_DOWNLOAD_URL=${URL_PREFIX}/${DSBULK_TARBALL}


ENV DSBULK_HOME /dsbulk

RUN set -x \
# Add cassandra user
    && groupadd -r cassandra --gid=999 \
    && useradd -m -d "$DSBULK_HOME" -r -g cassandra --uid=999 cassandra

# Install missing packages
RUN set -x \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get update -qq \
    && apt-get install -y adduser lsb-base procps gzip wget debianutils \
    && apt-get remove -y python3 \
    && apt-get autoremove --yes \
    && apt-get clean all \
    && rm -rf /var/lib/{apt,dpkg,cache,log}/

RUN set -x \
# Download DSBULK tarball if needed
    && if test ! -e /${DSBULK_TARBALL}; then wget -q -O /${DSBULK_TARBALL} ${DSBULK_DOWNLOAD_URL} ; fi \
# Unpack tarball
    && tar -C "$DSBULK_HOME" --strip-components=1 -xzf /${DSBULK_TARBALL} \
    && rm /${DSBULK_TARBALL} \
    && chown -R cassandra:cassandra ${DSBULK_HOME} \

# Create folders
    && (for dir in $DSBULK_HOME/logs $DSBULK_HOME/data ; do \
        mkdir -p $dir && chown -R cassandra:cassandra $dir ; \
    done ) 

ENV PATH $DSBULK_HOME/bin:$PATH
ENV HOME $DSBULK_HOME
WORKDIR $HOME

USER cassandra

# Expose folders
VOLUME ["/dsbulk/data", "/dsbulk/logs"]

# Run 
ENTRYPOINT [ "/dsbulk/bin/dsbulk" ]
