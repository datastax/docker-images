#!/bin/sh

# add any environment overrides you need here. This is where users
# may set thirdparty variables.

# This is here so the installer can force set DSE_HOME
#DSE_HOME="/usr/share/dse"
#export DSE_HOME

# ==================================
# don't change after this.
export DSE_MODE="1"

if [ "$DSE_HOME" = "" ]; then
  if [ -x "/usr/share/dse" ]; then
    DSE_HOME="/usr/share/dse"
    export DSE_HOME
  fi
fi

if [ -r "`dirname "$0"`/dse.in.sh" ]; then
    # File is right where the executable is
    . "`dirname "$0"`/dse.in.sh"
elif [ -r "/usr/share/dse/dse.in.sh" ]; then
    # Package install location
    . "/usr/share/dse/dse.in.sh"
elif [ -r "$DSE_HOME/bin/dse.in.sh" ]; then
    # Package install location
    . "$DSE_HOME/bin/dse.in.sh"
else
    # Go up directory tree from where we are and see if we find it
    DIR="`dirname $0`"
    for i in 1 2 3 4 5 6; do
        if [ -r "$DIR/bin/dse.in.sh" ]; then
            DSE_IN="$DIR/bin/dse.in.sh"
            break
        fi
        DIR="$DIR/.."
    done
    if [ -r "$DSE_IN" ]; then
        . "$DSE_IN"
    else
        echo "Cannot determine location of dse.in.sh"
        exit 1
    fi
fi
