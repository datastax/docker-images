# Copyright DataStax, Inc, 2017
#   Please review the included LICENSE file for more information.
#

FROM dse-base

MAINTAINER "DataStax, Inc <info@datastax.com>"

# Get commandline parameters
ARG VERSION=2.0.0
ARG URL_PREFIX=http://localhost
ARG STUDIO_TARBALL=datastax-studio-${VERSION}.tar.gz
ARG STUDIO_DOWNLOAD_URL=${URL_PREFIX}/${STUDIO_TARBALL}


# Set up configuration variables
ENV STUDIO_HOME=/opt/datastax-studio

# Copy any special files into the image
COPY files /

# Download DataStax Studio if needed
RUN set -x \
    && if test ! -e /${STUDIO_TARBALL}; then wget -q -O /${STUDIO_TARBALL} "$STUDIO_DOWNLOAD_URL"; fi \
    && mkdir -p "$STUDIO_HOME" \
    && tar -C "$STUDIO_HOME"  --strip-components=1 -xzf /$STUDIO_TARBALL \
    && rm /$STUDIO_TARBALL \
# Configure DataStax Studio
    && sed -i "s/httpBindAddress: localhost/httpBindAddress: 0.0.0.0/" ${STUDIO_HOME}/conf/configuration.yaml \
    && sed -i "s/baseDirectory: null/baseDirectory: \/var\/lib\/datastax-studio/" ${STUDIO_HOME}/conf/configuration.yaml \
# Create volume folders
    && mkdir -p /var/lib/datastax-studio

# Expose base directory
VOLUME [ "/var/lib/datastax-studio" ] 

# Expose DataStax Studio listening ports
# 9091 - server port
EXPOSE 9091

# Entrypoint script for launching
ENTRYPOINT [ "/entrypoint.sh" ]
