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

# Add dsbulk user
RUN set -x \
    && groupadd -r dsbulk --gid=999 \
    && useradd -m -d "$DSBULK_HOME" -r -g dsbulk --uid=999 dsbulk

RUN set -x \
# Download DSBULK tarball if needed
    && if test ! -e /${DSBULK_TARBALL}; then wget -q -O /${DSBULK_TARBALL} ${DSBULK_DOWNLOAD_URL} ; fi \
# Unpack tarball
    && tar -C "$DSBULK_HOME" --strip-components=1 -xzf /${DSBULK_TARBALL} \
    && rm /${DSBULK_TARBALL} \
    && mkdir -p $DSBULK_HOME/logs $DSBULK_HOME/data \
    && chown -R dsbulk:dsbulk ${DSBULK_HOME}

ENV PATH $DSBULK_HOME/bin:$PATH
ENV HOME $DSBULK_HOME
WORKDIR $HOME

USER dsbulk

# Run 
ENTRYPOINT [ "/dsbulk/bin/dsbulk" ]
