# Copyright DataStax, Inc, 2017
#   Please review the included LICENSE file for more information.
#

FROM dse-base

MAINTAINER "DataStax, Inc <info@datastax.com>"

ARG VERSION=6.0.7
ARG URL_PREFIX=http://localhost
ARG DSE_TARBALL=dse-${VERSION}-bin.tar.gz
ARG DSE_DOWNLOAD_URL=${URL_PREFIX}/${DSE_TARBALL}

ARG DSE_AGENT_VERSION=6.7.0
ARG DSE_AGENT_TARBALL=datastax-agent-${DSE_AGENT_VERSION}.tar.gz
ARG DSE_AGENT_DOWNLOAD_URL=${URL_PREFIX}/${DSE_AGENT_TARBALL}

ENV DSE_HOME /opt/dse
ENV DSE_AGENT_HOME /opt/agent

RUN set -x \
# Add DSE user
    && groupadd -r dse --gid=999 \
    && useradd -m -d "$DSE_HOME" -r -g dse --uid=999 dse

# Install missing packages
RUN set -x \
    && apt-get update -qq \
    && apt-get install -y python adduser lsb-base procps gzip zlib1g wget debianutils libaio1 sudo \
    && apt-get remove -y python3 \
    && apt-get autoremove --yes \
    && apt-get clean all \
    && rm -rf /var/lib/{apt,dpkg,cache,log}/

COPY files /

RUN set -x \
# Download DSE tarball if needed
    && if test ! -e /${DSE_TARBALL}; then wget -q -O /${DSE_TARBALL} ${DSE_DOWNLOAD_URL} ; fi \
# Unpack tarball
    && tar -C "$DSE_HOME" --strip-components=1 -xzf /${DSE_TARBALL} \
    && rm /${DSE_TARBALL} \
    && chown -R dse:dse ${DSE_HOME} \
# Download Agent tarball if needed
    && if test ! -e /${DSE_AGENT_TARBALL}; then wget -q -O /${DSE_AGENT_TARBALL} ${DSE_AGENT_DOWNLOAD_URL} ; fi \
    && mkdir -p "$DSE_AGENT_HOME" \
    && tar -C "$DSE_AGENT_HOME" --strip-components=1 -xzf /${DSE_AGENT_TARBALL} \
    && rm /${DSE_AGENT_TARBALL} \
    && chown -R dse:dse ${DSE_AGENT_HOME} \
# Create folders
    && (for dir in /var/lib/cassandra /var/lib/spark /var/lib/dsefs /var/lib/datastax-agent /var/log/cassandra /var/log/spark /config ; do \
        mkdir -p $dir && chown -R dse:dse $dir && chmod 777 $dir ; \
    done )

ENV PATH $DSE_HOME/bin:$PATH
ENV HOME $DSE_HOME
WORKDIR $HOME

USER dse

# Expose DSE folders
VOLUME ["/var/lib/cassandra", "/var/lib/spark", "/var/lib/dsefs", "/var/log/cassandra", "/var/log/spark"]

# CASSANDRA PORTS (INTRA-NODE, TLS INTRA-NODE, JMX, CQL, THRIFT, DSEFS INTRA-NODE, INTRA-NODE MESSAGING SERVICE)
EXPOSE 7000 7001 7199 8609 9042 9160

# DSE SEARCH (SOLR)
EXPOSE 8983 8984

# DSE ANALYTICS (SPARK)
EXPOSE 4040 7077 7080 7081 8090 9999 18080

# DSE GRAPH
EXPOSE 8182

# DSEFS
EXPOSE 5598 5599

# Run DSE in foreground by default
ENTRYPOINT [ "/entrypoint.sh", "dse", "cassandra", "-f" ]
