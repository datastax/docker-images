# Copyright DataStax, Inc, 2017
#   Please review the included LICENSE file for more information.
#

# Based on ubi7 for Python 2 support, when moving to Python 3 use ubi8
FROM registry.access.redhat.com/ubi7/ubi-minimal:latest

MAINTAINER "DataStax, Inc <info@datastax.com>"

RUN microdnf update && rm -rf /var/cache/yum

# Missing sysstat package, en_US.UTF-8 is the default, and only, locale in ubi-minimal
RUN microdnf install wget java-1.8.0-openjdk lm_sensors-libs  && microdnf clean all
# 	# Comment out Assistive Technologies to run the grimlin console from docker exec
#          sed -i -e '/^assistive_technologies=/s/^/#/' /etc/java-*-openjdk/accessibility.properties

# HACK: This is janky and needs to be reviewed
RUN set -x \
# Download sysstat RPM and install
    && wget -nv http://mirror.centos.org/centos/8/AppStream/x86_64/os/Packages/sysstat-11.7.3-2.el8.x86_64.rpm \
    && rpm -i ./sysstat* \
    && rm sysstat-*

ADD files /
