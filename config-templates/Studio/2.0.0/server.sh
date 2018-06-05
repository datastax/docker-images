#!/bin/bash

cd "$(dirname "$0")"/../

#find env files that may contain STUDIO_JVM_ARGS
for env in bin/setenv.sh bin/setenv_*.sh; do
    if [ -r $env ]; then
        echo "Importing environment variables file $env"
        . $env
    fi
done

# Find the jar and deps
for include in  ./ target; do 
    server_jar=$include/studio-server*.jar
    if [ -r $server_jar ]; then
        SERVER_CLASSPATH=`echo $server_jar`

        for war in $include/lib/studio-api*.war; do
            API_WAR=$war
        done

        for war in $include/lib/com.datastax.studio.ide.gremlin.web*.war; do
            GREMLIN_IDE_WAR=$war
        done

        for war in $include/lib/com.datastax.studio.ide.cql.web*.war; do
            CQL_IDE_WAR=$war
        done

        for jar in $include/lib/*.jar; do
            SERVER_CLASSPATH=$SERVER_CLASSPATH:$jar
        done
        break
    fi
done

# Find the ui dir
for include in  ./ui target/studio-ui; do
    if [ -r $include ]; then
        UI_DIR=$include
        break
    fi
done

# Use JAVA_HOME if set, otherwise look for java in PATH
if [ -x "$JAVA_HOME/bin/java" ]; then
    JAVA="$JAVA_HOME/bin/java"
elif [ "`uname`" = "Darwin" ]; then
    export JAVA_HOME=$(/usr/libexec/java_home)
    if [ -x "$JAVA_HOME/bin/java" ]; then
      JAVA="$JAVA_HOME/bin/java"
    fi
else
    JAVA="`which java`"
    if [ "$JAVA" = "" -a -x "/usr/lib/jvm/default-java/bin/java" ]; then
        # Use the default java installation
        JAVA="/usr/lib/jvm/default-java/bin/java"
    fi
    if [ "$JAVA" != "" ]; then
        export JAVA_HOME=$(readlink -f "$JAVA" | sed "s:bin/java::")
    fi
fi
export JAVA

if [ "x$JAVA" = "x" ]; then
    echo "Java executable not found (hint: set JAVA_HOME)" >&2
    exit 1
fi

MAIN_CLASS=com.datastax.studio.server.Bootstrap
exec $JAVA $STUDIO_JVM_ARGS -cp $SERVER_CLASSPATH $MAIN_CLASS $UI_DIR $API_WAR $GREMLIN_IDE_WAR $CQL_IDE_WAR

