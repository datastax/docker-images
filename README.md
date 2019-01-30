# Contents
* [Quick Reference](#quick-reference)
* [Prerequisites](#prerequisites)
* [Creating a DataStax Enterprise Container](#creating-a-datastax-enterprise-container)
   * [Container examples](#examples)
   * [Managing the configuration](#managing-the-configuration)
   * [Volumes and Data](#volumes-and-data)
* [Running DSE Commands and Viewing Logs](#running-dse-commands-and-viewing-logs)
* [Creating an OpsCenter Container](#creating-an-opscenter-container)
* [Creating a Studio Container](#creating-a-studio-container)
* [Building](#building)
* [Licensing](#license)

The DataStax base image now uses OpenJDK.  Previously we were building with Oracle JDK.  Starting with the below image versions and moving forward, prebuilt images on [Docker Hub](https://hub.docker.com/u/datastax/) will include OpenJDK.  If you would like to use OpenJDK with a version that was built with Oracle JDK we have built new images including OpenJDK with a tag of `version-openjdk8`

* DSE `6.0.2` and `5.1.11`
* OpsCenter `6.5.1` and `6.1.7`
* Studio `6.0.1`

# Quick Reference 
### Where to get help:
[DataStax Docker Docs](https://academy.datastax.com/quick-downloads?utm_campaign=Docker_2019&utm_medium=web&utm_source=docker&utm_term=-&utm_content=Web_Academy_Downloads), [DataStax Slack](https://academy.datastax.com/slack), [Github](https://github.com/datastax/docker-images)

Full documentation and advanced tutorials are located within [DataStax Academy](https://academy.datastax.com/quick-downloads?utm_campaign=Docker_2019&utm_medium=web&utm_source=docker&utm_term=-&utm_content=Web_Academy_Downloads). Docker Compose examples for deploying DataStax Enterprise with [Opscenter](https://hub.docker.com/r/datastax/dse-opscenter/) and [Studio](https://hub.docker.com/r/datastax/dse-studio/) are available on our [Github](https://github.com/datastax/docker-images/tree/master/example_compose_yamls) page 

### Featured Tutorial - [DataStax Enterprise 6 Guided Tour](https://academy.datastax.com/resources/guided-tour-dse-6-using-docker)

### Where to file issues:
https://github.com/datastax/docker-images/issues

### Maintained by 
[DataStax](https://www.datastax.com/) 



# What is DataStax Enterprise

Built on the best distribution of Apache Cassandra™, DataStax Enterprise is the always-on database designed to allow you to effortlessly build and scale your apps, integrating graph, search, analytics, administration, developer tooling, and monitoring into a single unified platform. We power your apps' real-time moments so you can create instant insights and powerful customer experiences.


# Prerequisites

* Basic understanding of Docker images and containers. 

* Docker installed on your local system, see [Docker Installation Instructions](https://docs.docker.com/engine/installation/). 

* When [building](#building) custom images from the DataStax github repository, a [DataStax Academy account](https://academy.datastax.com/).

* When using Docker for Mac or Docker for Windows, the default resources allocated to the linux VM running docker are 2GB RAM and 2 CPU's. Make sure to adjust these resources to meet the resource requirements for the containers you will be running. More information can be found here on adjusting the resources allocated to docker.

[Docker for mac](https://docs.docker.com/docker-for-mac/#advanced)

[Docker for windows](https://docs.docker.com/docker-for-windows/#advanced)

# Creating a DataStax Enterprise container

Use the options described in this section to create DataStax Enterprise server containers. 


By default, the DSE server image runs in Cassandra-only mode.. To run with advanced DSE  functionality, add the option that enables any combination of search, analytics, and graph to the end of the docker run command.

Option | Description
------------- | -------------
-s | Enables and starts DSE Search.
-k | Enables and starts Analytics.
-g | Enables and starts a DSE Graph.

Combine startup options to run more than one feature. For more examples, see  [Starting DataStax Enterprise as a stand-alone process ](http://docs.datastax.com/en/dse/6.0/dse-admin/datastax_enterprise/operations/startStop/startDseStandalone.html).

## Examples


### Create a DSE database container


```
docker run -e DS_LICENSE=accept --name my-dse -d datastax/dse-server
```

### Create a DSE container with Graph enabled

```
docker run -e DS_LICENSE=accept --name my-dse -d datastax/dse-server -g
```

### Create a DSE container with Analytics (Spark) enabled

```
docker run -e DS_LICENSE=accept --name my-dse -d datastax/dse-server -k
```

### Create a DSE container with Search enabled

```
docker run -e DS_LICENSE=accept --name my-dse -d datastax/dse-server -s
```

### Create a DSE container with Search, Analytics, and Graph enabled

```
docker run -e DS_LICENSE=accept --name my-dse -d datastax/dse-server -s -k -g
```

## Managing the configuration

Manage the DSE configuration using one of the following options:  

* [DSE configuration volume](https://docs.datastax.com/en/docker/doc/docker/docker60/dockerDSEVolumes.html) For configuration management, we’re providing a simple mechanism to let you provide custom configuration file(s) without customizing the containers or over using host volumes. You can add any of the [approved config files](https://github.com/datastax/docker-images/tree/master/config-templates) to a single mounted host volume and we’ll handle the hard work of mapping them within the container.


* [DSE environment variables](#using-environment-variables) that change the configuration at runtime. 
    * Environment variables will trump any other settings meaning that if you set a custom snitch in cassandra.yaml and then a different one with an environment variable, the environment variable setting will be used.
    * DSE uses the default values defined for environment variables unless they are explicitly set at run time or unless overridden with the DSE_AUTO_CONF_OFF environment variable.


* Docker file/directory volume mounts

* Docker overlay file system

* DSE uses the default values defined for the environment variables unless explicitly set at run time.  

* **NOTE** When using memory resource contraints, you must must set JVM heap size using the environment variable `JVM_EXTRA_OPTS` or custom `cassandra-env.sh` or DSE running inside the container due to java not honoring resource limits set for the container. Java utilizes the resources (memory and CPU) of the host. Otherwise DSE will set the heap to 1/4 of the physical ram of the docker host.

### Using the DSE conf volume

To use this feature:

1. Create a directory on your local host.
2. Download and customize the configuration files you want to use from the [config-templates](https://github.com/datastax/docker-images/tree/master/config-templates) page.  
3. Add the custom configuration files to the host directory you created.
    * The file name must match a corresponding configuration file in the image and include all the required values, for example cassandra.yaml, dse.yaml. 
4. Mount the exposed Volume /config to the local directory.
5. Start the container. For example to start a database node:

```
docker run -e DS_LICENSE=accept --name my-dse  -v /dse/config:/config -d datastax/dse-server
```
**Note** When you make changes to or add config files to the `/config` volume, you will need to restart your container with `docker restart container_name` for DSE to pickup the changes. Restarting the container will restart DSE.

### Using environment variables


Configure the DSE image by setting environment variables when the container is created using the docker run command `-e` flag.

Variable | Setting        | Description                
------------ | ----------------- | -------------------- 
`DS_LICENSE` | accept | **Required**. Set to accept to acknowledge that you agree with the terms of the DataStax license. To show the license, set the variable `DS_LICENSE` to the value `accept`. *The image only starts if the variable set to accept.*
`LISTEN_ADDRESS` | *IP_address* | The IP address to listen for connections from other nodes. Defaults to the container's IP address.
`BROADCAST_ADDRESS` | *IP_address* | The IP address to advertise to other nodes. Defaults to the same value as the `LISTEN_ADDRESS`.
`NATIVE_TRANSPORT_ADDRESS` |*IP_address* | The IP address to listen for client/driver connections. Default: `0.0.0.0`.
`NATIVE_TRANSPORT_BROADCAST_ADDRESS` | *IP_address* | The IP address to advertise to clients/drivers. Defaults to the same value as the `BROADCAST_ADDRESS`.
`SEEDS` | *IP_address* | The comma-delimited list of seed nodes for the cluster. Defaults to this node's `BROADCAST_ADDRESS`. 
`START_RPC` | `true` \| `false` | Whether or not to start the Thrift RPC server. Will leave the default in the `cassandra.yaml` file if not set.
`CLUSTER_NAME` | *string* | The name of the cluster. Default: `Test Cluster`.
`NUM_TOKENS`|*int*|The number of tokens randomly assigned to the node. Default: not set .
`DC` | *string* | Datacenter name. Default: `Cassandra`.
`RACK` | *string* | Rack name. Default: `rack1`.
`OPSCENTER_IP` | *IP_address* \| *string* | Address of OpsCenter instance to use for DSE management; it can be specified via linking the OpsCenter container using opscenter as the name.
`JVM_EXTRA_OPTS` | *string* |  Allows setting custom Heap using -Xmx and -Xms.
`LANG` | *string* |  Allows setting custom Locale
`SNITCH` | *string* |  This variable sets the snitch implementation this node will use. It will set the endpoint_snitch option of cassandra.yaml. Default: GossipingPropertyFileSnitch
`DSE_AUTO_CONF_OFF` | *string* | Sometimes users want to set all variables in the config files. For these situations one must prevent default environment variables from overriding those values. This setting lets you provide a comma-separated list of filenames (options are  cassandra.yaml and cassandra-rackdc.properties) that will not accept the Environmental variables or can be set to 'all' to disable default environment variables being set within either file.



## Volumes and data

To persist data, pre-create directories on the local host and map the directory to the corresponding volume using the docker run `-v` flag. 

**NOTE:** If the volumes are not mounted from the local host, all data is lost when the container is removed.

DSE images expose the following volumes.  

* For DataStax Enterprise Transactional, Search, Graph, and Analytics workloads:
   * `/var/lib/cassandra`: Data from Cassandra
   * `/var/lib/spark`: Data from DSE Analytics w/ Spark
   * `/var/lib/dsefs`: Data from DSEFS
   * `/var/log/cassandra`: Logs from Cassandra
   * `/var/log/spark`: Logs from Spark
   * `/config`: Directory to add custom config files for the container to pickup.

* For OpsCenter: `/var/lib/opscenter`

* For Studio: `/var/lib/datastax-studio`

```
docker run -v <local_directory>:<container_volume>
```

See Docker docs > [Use volumes](https://docs.docker.com/engine/tutorials/dockervolumes/#mount-a-host-directory-as-a-data-volume) for more information.


# Running DSE commands and viewing logs


Use the `docker exec -it <container_name>` command to specific commands. 

```
docker exec -it my-dse nodetool status
```

## Opening an interactive bash shell

If the container is running in the background (using the `-d`), use the following command to open an interactive bash shell to run DSE commands. 

```
docker exec -it <container_name> bash
```

To exit the shell without stopping the container type exit.

## Opening an interactive CQL shell (cqlsh)

Use the following command to open cqlsh. 

```
docker exec -it <container_name> cqlsh
```


## Viewing logs

You can view the DSE logs using the Docker log command. For example:

```
docker logs my-dse
```

## Creating an Opscenter Container

Follow these steps to create an Opscenter container and a connected DataStax Enterprise server container on the same Docker host. 

To create and connect the containers:

1. First create an OpsCenter container.

    * `docker run -e DS_LICENSE=accept -d -p 8888:8888 --name my-opscenter datastax/dse-opscenter`

    * See [OpsCenter Docker run options](#OpsCenter-Docker-run-options) for additional options that persist data or manage configuration.

2. Create a [DataStax Enterprise (DSE) server](https://hub.docker.com/r/datastax/dse-server/) container that is linked to the OpsCenter container. 

    * `docker run -e DS_LICENSE=accept --link my-opscenter:opscenter --name my-dse -d datastax/dse-server`


3. Get the DSE container IP address:

    * On the host running the DSE container run

    * `docker inspect my-dse | grep '"IPAddress":' `


4. Open a browser and go to `http://DOCKER_HOST_IP:8888`.
5. Click `Manage existing cluster`. 
6. In `host name`, enter the DSE IP address.
7. Click `Install agents manually`. Note that the agent is already installed on the DSE image; no installation is required.

OpsCenter is ready to use with DSE. See the [OpsCenter User Guide](http://docs.datastax.com/en/opscenter/6.5/) for detailed usage and configuration instructions.

## Creating a Studio Container
Follow these steps to create a DataStax Studio container that is connected to a [DataStax Enterprise (DSE) server](https://hub.docker.com/r/datastax/dse-server) container on the same Docker host.

To create and connect the containers:

1. Create a DataStax Studio container:

```
docker run -e DS_LICENSE=accept --link my-dse --name my-studio -p 9091:9091 -d datastax/dse-studio
```
2. Open a browser and go to `http://DOCKER_HOST_IP:9091`

3. Create the new connection using my-dse as the hostname, see DataStax Studio User Guide > [Creating a new connection](http://docs.datastax.com/en/dse/5.1/dse-dev/datastax_enterprise/studio/stdToc.html) for further instructions.

Studio is ready to use with DSE. See [DataStax Studio User Guide](http://docs.datastax.com/en/dse/5.1/dse-dev/datastax_enterprise/studio/stdAbout.html) for detailed usage and configuration instructions.

# Building

The code in this repository will build the DSE, Opscenter and Studio Docker images. To get started, clone this repo and modify for your requirements. 

This repo uses Gradle to build the images.

By default, [Gradle](https://gradle.org) will download DataStax tarballs from [DataStax Academy](https://downloads.datastax.com).
Therefore you need to provide your credentials either via the command line, or in `gradle.properties` file located
in the project root.

DataStax uses two separate Dockerfiles to build the individual images, a base for the OS and individual Dockerfiles for (server, opscenter, studio).  

If you would like to customize the OS, install additional packages etc, you would modify the base Dockerfile. 

If you would like to customize DSE, Opscenter or Studio you would modify their corresponding Dockerfile. 
For example: if you wanted to build DSE 5.1.10 with datastax-agent 6.1.4, you would modify the server 5.1 Dockerfile with

```
ARG VERSION=5.1.10
ARG DSE_AGENT_VERSION=6.1.4
```

To build specific versions of OpsCenter and Studio, you would modify `ARG VERSION=` in their corresponding Dockerfile.

Currently you have to build all 3 images

To build the images from your customized Dockerfile(s) run the following command specifying the Version branch for each image: 
For example to build DSE 5.1.10 with OpsCenter 6.1.4 and Studio 2.0 you would run the following adding your DataStax Academy Credentials

```
./gradlew buildServerImage -PserverVersion=5.1 -PopscenterVersion=6.1 -PstudioVersion=2.0 buildImages -PdownloadUsername=<your_DataStax_Acedemy_username> -PdownloadPassword=<your_DataStax_Acedemy_passwd>
```

Run `./gradlew tasks` to get the list of all available tasks.

# Next Steps

Head over to [DataStax Academy](https://academy.datastax.com/quick-downloads?utm_campaign=Docker_2019&utm_medium=web&utm_source=docker&utm_term=-&utm_content=Web_Academy_Downloads) for advanced documentation including

* Apache Cassandra™/Datastax configuration management
* Using environment variables
* Persisting data
* Exposing public ports
* Volumes and data directories
* Docker Compose examples to spin up connected clusters of DataStax Enterprise, Studio, and Opscenter (also on [github](https://github.com/datastax/docker-images/tree/master/example_compose_yamls))
* Step-by-step tutorials and examples
* How to build applications using Apache Cassandra™/ DataStax

# Known Limitations
* CFS is not supported.
* LCM is not supported.
* Changing any file not included in the list of approved configuration files will require an additional host volume or customization of the image. An example is SSL key management.
* The JVM heap size must be set for DataStax Enterprise (DSE) running inside the container using the JVM_EXTRA_OPTS variable or custom cassandra-env.sh. If not set, Java does not honor resource limits set for the container, and will peer through the container to use resources (memory and CPU) of the host. See the JVM_EXTRA_OPTS variable in Using environment variables for more information.


# License

* [DataStax License Terms](https://www.datastax.com/terms)
* [OpsCenter License Terms](https://www.datastax.com/datastax-opscenter-license-terms)
* [DataStax License Terms](https://www.datastax.com/terms)
