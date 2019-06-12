#!/bin/bash
# -*- mode: sh -*-
#
# Copyright DataStax, Inc, 2017
#   Please review the included LICENSE file for more information.
#

set -e

. /base-checks.sh

link_external_config "${STUDIO_HOME}"

############################################
# Set up variables/configure the image
############################################

############################################
# Run the command
############################################
echo "Starting DataStax Studio"
exec "${STUDIO_HOME}/bin/server.sh"
