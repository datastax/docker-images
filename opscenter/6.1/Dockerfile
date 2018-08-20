# Copyright DataStax, Inc, 2017
#   Please review the included LICENSE file for more information.
#

FROM dse-base

MAINTAINER "DataStax, Inc <info@datastax.com>"

ARG VERSION=6.1.7
ARG URL_PREFIX=http://localhost
ARG OPSCENTER_TARBALL=opscenter-${VERSION}.tar.gz
ARG OPSCENTER_DOWNLOAD_URL=${URL_PREFIX}/${OPSCENTER_TARBALL}

# Install missing packages
RUN apt-get update -qq \
    && apt-get install -y python2.7 \
                          openssl \
                          python-openssl \
                          curl \
                          ca-certificates \
                          lsb-base \
                          procps \
                          zlib1g \
                          gzip \
                          ntp \
                          tree \
    && apt-get clean autoclean autoremove --yes \
    && rm -rf /var/lib/{apt,dpkg,cache,log}/


# Set up configuration variables
ENV OPSCENTER_HOME=/opt/opscenter

# Copy any special files into the image
COPY files /

# Download DataStax Studio if needed
RUN set -x \
    && if test ! -e /$OPSCENTER_TARBALL; then wget -q -O "/$OPSCENTER_TARBALL" "$OPSCENTER_DOWNLOAD_URL"; fi \
# Unpack the tar ball
    && mkdir -p "$OPSCENTER_HOME" \
    && tar -C "$OPSCENTER_HOME"  --strip-components=1 -xzf /$OPSCENTER_TARBALL \
    && rm /$OPSCENTER_TARBALL \
    && mkdir /var/lib/opscenter

VOLUME [ "/var/lib/opscenter" ]

# Expose OpsCenter listening ports
# 8888 - web ui
# 50031 - job tracker HTTP proxy
# 61620 - agent monitoring
EXPOSE 8888 50031 61620

# Entrypoint script for launching
ENTRYPOINT [ "/entrypoint.sh", "-f" ]
