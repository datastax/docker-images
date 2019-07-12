#!/bin/bash
# -*- mode: sh -*-
#
# Copyright DataStax, Inc, 2017
#   Please review the included LICENSE file for more information.
#

set -e

. /base-checks.sh

link_external_config "${OPSCENTER_HOME}"

############################################
# Set up variables/configure the image
############################################

############################################
# Run the command
############################################
echo "Starting OpsCenter with $@"
exec "$OPSCENTER_HOME/bin/opscenter" "$@"
