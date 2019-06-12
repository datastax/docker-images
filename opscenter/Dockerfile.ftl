# Copyright DataStax, Inc, 2017
#   Please review the included LICENSE file for more information.
#
FROM dse-base as opscenter-base

# Set up configuration variables
ENV OPSCENTER_HOME=/opt/opscenter

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
    && rm -rf /var/lib/{apt,dpkg,cache,log}/ \

# Add Opscenter  user
    && groupadd -r opscenter --gid=998 \
    && useradd -m -d "$OPSCENTER_HOME" -r -g opscenter --uid=998 opscenter

FROM opscenter-base as base

ARG VERSION=[=version]
ARG TARBALL=opscenter-${VERSION}.tar.gz
ARG DOWNLOAD_URL=${URL_PREFIX}/${OPSCENTER_TARBALL}

COPY /* /

# Download DataStax Opscenter if needed
RUN set -x \
    && if test ! -e /$TARBALL; then wget -nv --show-progress --progress=bar:force:noscroll -O "/$TARBALL" "$DOWNLOAD_URL"; fi \
# Unpack the tar ball
    && mkdir -p "$OPSCENTER_HOME" \
    && tar -C "$OPSCENTER_HOME"  --strip-components=1 -xzf /$TARBALL \
    && rm /$TARBALL

FROM opscenter-base

MAINTAINER "DataStax, Inc <info@datastax.com>"

# Copy any special files into the image
COPY files /

COPY --chown=opscenter:opscenter --from=base $OPSCENTER_HOME $OPSCENTER_HOME

# Create volume folders
RUN (for dir in /var/lib/opscenter /config ; do \
        mkdir -p $dir && chown -R opscenter:opscenter $dir && chmod 777 $dir ; \
    done )

USER opscenter

VOLUME [ "/var/lib/opscenter" ]

# Expose OpsCenter listening ports
# 8888 - web ui
# 50031 - job tracker HTTP proxy
# 61620 - agent monitoring
EXPOSE 8888 50031 61620

# Entrypoint script for launching
ENTRYPOINT [ "/entrypoint.sh", "-f" ]
