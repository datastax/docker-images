# Copyright DataStax, Inc, 2017
#   Please review the included LICENSE file for more information.
#

FROM python:2.7-alpine

MAINTAINER "DataStax, Inc <info@datastax.com>"

ARG VERSION=${VERSION}
ARG URL_PREFIX=http://localhost
ARG DSE_TARBALL=dse-${VERSION}-bin.tar.gz
ARG DSE_DOWNLOAD_URL=${URL_PREFIX}/${DSE_TARBALL}

ENV DSE_HOME /opt/dse

# Install missing packages
RUN set -x \
    && apk update \
    && apk add wget \
    && rm -rf /var/cache/apk

RUN set -x \
# Download DSE tarball if needed
    && if test ! -e /${DSE_TARBALL}; then wget -q -O /${DSE_TARBALL} ${DSE_DOWNLOAD_URL} ; fi \
# Unpack tarball
    && mkdir -p "$DSE_HOME" \
    && tar -C "$DSE_HOME" --strip-components=1 -xzf /${DSE_TARBALL} dse-${VERSION}/resources/cassandra/pylib dse-${VERSION}/resources/cassandra/bin/cqlsh dse-${VERSION}/resources/cassandra/bin/cqlsh.py dse-${VERSION}/resources/cassandra/bin/dsecqlsh.py dse-${VERSION}/resources/cassandra/lib \
    && rm -f /${DSE_TARBALL} \
    && rm -f ${DSE_HOME}/resources/cassandra/lib/*.jar \
    && rm -f ${DSE_HOME}/resources/cassandra/lib/snappy-java* \
    && rm -rf ${DSE_HOME}/resources/cassandra/lib/sigar-bin \
    && chown -R nobody:nobody ${DSE_HOME}

ENV PATH $DSE_HOME/resources/cassandra/bin:$PATH
ENV HOME $DSE_HOME
WORKDIR $HOME

USER nobody

# Run DSE in foreground by default
ENTRYPOINT [ "cqlsh" ]
