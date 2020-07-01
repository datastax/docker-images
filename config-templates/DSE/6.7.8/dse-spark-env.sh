#!/bin/sh

# DSE Config Version: 6.7.8-4e44cda

log_config() {
    result="-Dlogback.configurationFile=$1 -Dcassandra.logdir=$CASSANDRA_LOG_DIR"
    if [ "$2" != "" ] && [ "$3" != "" ]; then
        result="$result -Dspark.log.dir=$2 -Dspark.log.file=$3"
    fi
    echo "$result"
}

if [ -z "$SPARK_WORKER_DIR" ]; then
    export SPARK_WORKER_DIR="/var/lib/spark/worker"
fi

if [ -z "$SPARK_LOCAL_DIRS" ]; then
    if [ -n "$TMPDIR" ]; then
        export SPARK_LOCAL_DIRS="$TMPDIR"
    elif [ -n "$HOME" ]; then
        export SPARK_LOCAL_DIRS="$HOME/.spark"
    fi
fi

if [ -z "$SPARK_EXECUTOR_DIRS" ]; then
    export SPARK_EXECUTOR_DIRS="/var/lib/spark/rdd"
fi

if [ -z "$SPARK_WORKER_LOG_DIR" ]; then
    export SPARK_WORKER_LOG_DIR="/var/log/spark/worker"
fi

if [ -z "$SPARK_MASTER_LOG_DIR" ]; then
    export SPARK_MASTER_LOG_DIR="/var/log/spark/master"
fi

if [ -z "$ALWAYSON_SQL_LOG_DIR" ]; then
    export ALWAYSON_SQL_LOG_DIR="/var/log/spark/alwayson_sql"
fi

# Library paths... not sure whether they are required for
# TODO consider using LD_LIBRARY_PATH or DYLD_LIBRARY_PATH env variables
SPARK_DAEMON_JAVA_OPTS="$SPARK_DAEMON_JAVA_OPTS -Djava.library.path=$JAVA_LIBRARY_PATH -Dcassandra.logdir=$CASSANDRA_LOG_DIR"

# Memory options
export SPARK_DAEMON_JAVA_OPTS="$SPARK_DAEMON_JAVA_OPTS -XX:MaxHeapFreeRatio=50 -XX:MinHeapFreeRatio=20"  # don't use too much memory

# Set library paths for Spark daemon process as well as to be inherited by executor processes
if [ "$(echo "$OSTYPE" | grep "^darwin")" != "" ]; then
    # For MacOS...
    export DYLD_LIBRARY_PATH="$HADOOP2_JAVA_LIBRARY_PATH"
else
    # For any other Linux-like OS
    export LD_LIBRARY_PATH="$HADOOP2_JAVA_LIBRARY_PATH"
fi

export SPARK_SERVER_LOGBACK_CONF_FILE="$SPARK_CONF_DIR/logback-spark-server.xml"

SPARK_EXECUTOR_LOGBACK_CONF_FILE="$SPARK_CONF_DIR/logback-spark-executor.xml"

logConfFile="logback-spark.xml"
if [ ! -z "$SHELL_LOG_CONF_FILE" ]; then
    logConfFile="$SHELL_LOG_CONF_FILE"
fi

if [ "$logConfFile" = "logback-spark-shell.xml" ]; then
    if [ -z "$SPARK_SHELL_LOG_FILE" ]; then
        export SPARK_SHELL_LOG_FILE="$HOME/.spark-shell.log"
    fi
    echo "The log file is at ${SPARK_SHELL_LOG_FILE}" 1>&2
elif [ "$logConfFile" = "logback-spark-sql.xml" ]; then
    if [ -z "$SPARK_SQL_SHELL_LOG_FILE" ]; then
        export SPARK_SQL_SHELL_LOG_FILE="$HOME/.spark-sql-shell.log"
    fi
    echo "The log file is at ${SPARK_SQL_SHELL_LOG_FILE}" 1>&2
elif [ "$logConfFile" = "logback-spark-beeline.xml" ]; then
    if [ -z "$SPARK_BEELINE_LOG_FILE" ]; then
        export SPARK_BEELINE_LOG_FILE="$HOME/.spark-beeline.log"
    fi
    echo "The log file is at ${SPARK_BEELINE_LOG_FILE}" 1>&2
elif [ "$logConfFile" = "logback-sparkR.xml" ]; then
    if [ -z "$SPARKR_LOG_FILE" ]; then
        export SPARKR_LOG_FILE="$HOME/.sparkR.log"
    fi
    echo "The log file is at ${SPARKR_LOG_FILE}" 1>&2
fi


SPARK_SUBMIT_LOGBACK_CONF_FILE="${SPARK_SUBMIT_LOGBACK_CONF_FILE:-"$SPARK_CONF_DIR/$logConfFile"}"

# spark.kryoserializer.buffer.mb has been removed since it is deprecated in Spark 1.4 and we actually do
# not use Kryo by default.
export SPARK_COMMON_OPTS="$DSE_OPTS "

export LOCAL_SPARK_EXECUTOR_OPTS="$LOCAL_SPARK_EXECUTOR_OPTS -Djava.library.path=$HADOOP2_JAVA_LIBRARY_PATH"
export LOCAL_SPARK_EXECUTOR_OPTS="$LOCAL_SPARK_EXECUTOR_OPTS $SPARK_COMMON_OPTS "
export LOCAL_SPARK_EXECUTOR_OPTS="$LOCAL_SPARK_EXECUTOR_OPTS $(log_config "$SPARK_EXECUTOR_LOGBACK_CONF_FILE") "
export LOCAL_SPARK_EXECUTOR_OPTS="$LOCAL_SPARK_EXECUTOR_OPTS -Ddse.client.configuration.impl=com.datastax.bdp.transport.client.HadoopBasedClientConfiguration "

export LOCAL_SPARK_DRIVER_OPTS="$LOCAL_SPARK_DRIVER_OPTS $SPARK_COMMON_OPTS "
export LOCAL_SPARK_DRIVER_OPTS="$LOCAL_SPARK_DRIVER_OPTS $(log_config "$SPARK_SUBMIT_LOGBACK_CONF_FILE") "
export LOCAL_SPARK_DRIVER_OPTS="$LOCAL_SPARK_DRIVER_OPTS -Ddse.client.configuration.impl=com.datastax.bdp.transport.client.HadoopBasedClientConfiguration "
export LOCAL_SPARK_DRIVER_OPTS="$LOCAL_SPARK_DRIVER_OPTS -Dderby.stream.error.method=com.datastax.bdp.derby.LogbackBridge.getLogger "

export SPARK_SUBMIT_OPTS="$SPARK_SUBMIT_OPTS $LOCAL_SPARK_DRIVER_OPTS $SPARK_DRIVER_OPTS "

export HWI_WAR_FILE="$(find "$SPARK_HOME"/lib -name 'hive-hwi-*.jar')"

export SPARK_HADOOP_UTIL="org.apache.hadoop.security.DseSparkHadoopUtil"

export SPARK_SCALA_VERSION="2.11"
