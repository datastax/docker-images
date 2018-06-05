#!/usr/bin/env bash

#
# All changes to the original code are Copyright DataStax, Inc.
#
# Please see the included license file for details.
#

#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# This file is sourced when running various Spark programs.
# Copy it as spark-env.sh and edit that to configure Spark for your site.

# Options read when launching programs locally with
# ./bin/run-example or ./bin/spark-submit
# - HADOOP_CONF_DIR, to point Spark towards Hadoop configuration files
# - SPARK_LOCAL_IP, to set the IP address Spark binds to on this node
# - SPARK_PUBLIC_DNS, to set the public dns name of the driver program
# - SPARK_CLASSPATH, default classpath entries to append

# Options read by executors and drivers running inside the cluster
# - SPARK_LOCAL_IP, to set the IP address Spark binds to on this node
# - SPARK_PUBLIC_DNS, to set the public DNS name of the driver program
# - SPARK_CLASSPATH, default classpath entries to append
# - SPARK_LOCAL_DIRS, storage directories to use on this node for shuffle and RDD data

# Options for the daemons used in the standalone deploy mode
# - SPARK_MASTER_IP, to bind the master to a different IP address or hostname
# - SPARK_MASTER_PORT / SPARK_MASTER_WEBUI_PORT, to use non-default ports for the master
# - SPARK_MASTER_OPTS, to set config properties only for the master (e.g. "-Dx=y")
# - SPARK_WORKER_HOST, to bind the worker to a different IP address or hostname
# - SPARK_WORKER_CORES, to set the number of cores to use on this machine
# - SPARK_WORKER_MEMORY, to set how much total memory workers have to give executors (e.g. 1000m, 2g)
# - SPARK_WORKER_PORT / SPARK_WORKER_WEBUI_PORT, to use non-default ports for the worker
# - SPARK_WORKER_DIR, to set the working directory of worker processes
# - SPARK_WORKER_OPTS, to set config properties only for the worker (e.g. "-Dx=y")
# - SPARK_HISTORY_OPTS, to set config properties only for the history server (e.g. "-Dx=y")
# - SPARK_SHUFFLE_OPTS, to set config properties only for the external shuffle service (e.g. "-Dx=y")
# - SPARK_DAEMON_JAVA_OPTS, to set config properties for all daemons (e.g. "-Dx=y")
# - SPARK_PUBLIC_DNS, to set the public dns name of the master or workers

# Generic options for the daemons used in the standalone deploy mode
# - SPARK_CONF_DIR      Alternate conf dir. (Default: ${SPARK_HOME}/conf)
# - SPARK_LOG_DIR       Where log files are stored.  (Default: ${SPARK_HOME}/logs)
# - SPARK_PID_DIR       Where the pid file is stored. (Default: /tmp)
# - SPARK_IDENT_STRING  A string representing this instance of spark. (Default: $USER)
# - SPARK_NICENESS      The scheduling priority for daemons. (Default: 0)

# Host and port which Spark SQL Thrift Server binds to; Remember that Spark SQL Thrift Server clients
# Be careful when exposing Spark SQL Thrift server since in most cases it doesn't require authentication
# from its clients
# export HIVE_SERVER2_THRIFT_PORT=10000
# export HIVE_SERVER2_THRIFT_BIND_HOST=127.0.0.1

# Remember to set these ports identically on each node
export SPARK_MASTER_PORT=7077
export SPARK_MASTER_WEBUI_PORT=7080
export SPARK_WORKER_WEBUI_PORT=7081

# The hostname or IP address Cassandra rpc/native protocol is bound to:
# export SPARK_CASSANDRA_CONNECTION_HOST="127.0.0.1"

# The hostname or IP address for the driver to listen on. If there is more network interfaces you
# can specify which one is to be used by Spark Shell or other Spark applications.
# export SPARK_DRIVER_HOST="127.0.0.1"

# Set the amount of memory used by Spark Worker - if uncommented, it overrides the setting initial_spark_worker_resources in dse.yaml.
# export SPARK_WORKER_MEMORY=2048m

# Set the number of cores used by Spark Worker - if uncommented, it overrides the setting initial_spark_worker_resources in dse.yaml.
# export SPARK_WORKER_CORES=4

# The amount of memory used by the Spark Driver JVM
# export SPARK_DRIVER_MEMORY="1024M"

# Warning: Be careful when changing temporary subdirectories. Make sure they different for different Spark components
# and they are set with spark.local.dir for Spark Master and Spark Worker, and with java.io.tmpdir for Spark executor,
# Spark shell(repl) and Spark applications. Jobs may not finish properly (hang) if temporary directories overlap.
#
# Warning: When changing temporary or logs locations, consider permissions and ownership of files created by particular
# Spark components. Wrongly specified directories here may result in security related errors.

# This is a base directory for Spark Worker work files.
if [ "x$SPARK_WORKER_DIR" = "x" ]; then
    export SPARK_WORKER_DIR="/var/lib/spark/worker"
fi

if [ "x$SPARK_LOCAL_DIRS" = "x" ]; then
    export SPARK_LOCAL_DIRS="/var/lib/spark/rdd"
fi

# This is a base directory for Spark Worker logs.
if [ "x$SPARK_WORKER_LOG_DIR" = "x" ]; then
    export SPARK_WORKER_LOG_DIR="/var/log/spark/worker"
fi

# This is a base directory for Spark Master logs.
if [ "x$SPARK_MASTER_LOG_DIR" = "x" ]; then
    export SPARK_MASTER_LOG_DIR="/var/log/spark/master"
fi

# These Java options will be passes to Spark Master processOA
export SPARK_MASTER_OPTS="$SPARK_MASTER_OPTS"

# These Java options will be passed to Spark Worker process
export SPARK_WORKER_OPTS="$SPARK_WORKER_OPTS"

# Node local extra Java options which will be added to the command line of Spark driver if it is run
# on this node, no matter whether in cluster or client mode
export LOCAL_SPARK_DRIVER_OPTS="$LOCAL_SPARK_DRIVER_OPTS"

# Node local extra Java options which will be added to the command line of Spark executors if they are
# run on this node
export LOCAL_SPARK_EXECUTOR_OPTS="$LOCAL_SPARK_EXECUTOR_OPTS"

# Extra Java options which will be added to the command line of Spark driver if the application is
# submitted from this node
export SPARK_DRIVER_OPTS="$SPARK_DRIVER_OPTS"

# Extra Java options which will be added to the command line of Spark executors if the application is
# submitted from this node
export SPARK_EXECUTOR_OPTS="$SPARK_EXECUTOR_OPTS"

. "$SPARK_CONF_DIR"/dse-spark-env.sh
