# Copyright DataStax, Inc, 2017
#   Please review the included LICENSE file for more information.
#

FROM dse-base as studio-base

# Set up configuration variables
ENV STUDIO_HOME=/opt/datastax-studio

RUN set -x \
# Add Studo  user
    && groupadd -r studio --gid=997 \
    && useradd -m -d "$STUDIO_HOME" -r -g studio --uid=997 studio

FROM studio-base as base

# Get commandline parameters
ARG VERSION=[=version]
ARG TARBALL=datastax-studio-${VERSION}.tar.gz
ARG DOWNLOAD_URL=${URL_PREFIX}/${STUDIO_TARBALL}

COPY /* /

# Download DataStax Studio if needed
RUN set -x \
    && if test ! -e /${TARBALL}; then wget -nv --show-progress --progress=bar:force:noscroll -O /${TARBALL} "$DOWNLOAD_URL"; fi \
    && mkdir -p "$STUDIO_HOME" \
    && tar -C "$STUDIO_HOME"  --strip-components=1 -xzf /$TARBALL \
    && rm /$TARBALL \

# Configure DataStax Studio
    && sed -i "s/httpBindAddress: localhost/httpBindAddress: 0.0.0.0/" ${STUDIO_HOME}/conf/configuration.yaml \
    && sed -i "s/baseDirectory: null/baseDirectory: \/var\/lib\/datastax-studio/" ${STUDIO_HOME}/conf/configuration.yaml


FROM studio-base

MAINTAINER "DataStax, Inc <info@datastax.com>"

# Copy any special files into the image
COPY files /

COPY --chown=studio:studio --from=base $STUDIO_HOME $STUDIO_HOME

# Create volume folders
RUN (for dir in /var/lib/datastax-studio /config; do \
        mkdir -p $dir && chown -R studio:studio $dir && chmod 777 $dir ; \
    done )

USER studio 

# Expose base directory
VOLUME [ "/var/lib/datastax-studio" ] 

# Expose DataStax Studio listening ports
# 9091 - server port
EXPOSE 9091

# Entrypoint script for launching
ENTRYPOINT [ "/entrypoint.sh" ]
