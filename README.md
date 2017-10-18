# Contents
* [DataStax Platform Overview](#datastax-platform-overview)
* [Getting Started with DataStax and Docker](#getting-started-with-datastax-and-docker)
* [Prerequisites](#prerequisites)
* [Creating a DataStax Enterprise Container](#creating-a-datastax-enterprise-container)
* [Enabling Advanced Functionality](#enabling-advanced-functionality)
* [DSE Examples](#examples)
* [Managing the Configuration](managing-the-configuration)
* [Using the DSE Conf Volume](#using-the-dse-conf-volume)
* [Using Environment Variables](#using-environment-variables)
* [Volumes and Data](#volumes-and-data)
* [Exposing DSE public ports](#exposing-dse-public-ports)
* [Running DSE Commands and Viewing Logs](#running-dse-commands-and-viewing-logs)
* [Creating an OpsCenter Container](#creating-an-opscenter-container)
* [Creating a Studio Container](#creating-a-studio-container)
* [Using Docker Compose for Automated Provisioning](#using-docker-compose-for-automated-provisioning)
* [Building](#building)
* [Getting Help](#getting-help)
* [Licensing](#license)


# DataStax Platform Overview

Built on the 
best distribution of Apache Cassandra™, DataStax Enterprise is the always-on 
data platform designed to allow you to effortlessly build and scale your apps, 
integrating graph, search, analytics, administration, developer tooling, 
and monitoring into a single unified platform. We power your 
apps' real-time moments so you can create instant insights 
and powerful customer experiences.

![](https://upload.wikimedia.org/wikipedia/commons/e/e5/DataStax_Logo.png)


# Getting Started with DataStax and Docker

Use DataStax provided Docker images in non-production environments for development, to learn DataStax Enterprise, OpsCenter and DataStax Studio, to try new ideas, or to test and demonstrate an application. The following images are available:

Docker Store (Login to docker store and subscribe to the image):
* [DataStax Enterprise](https://store.docker.com/images/datastax): The best distribution of Apache Cassandra™ with integrated Search, Analytics, and Graph capabilities

Docker Hub:
* [DataStax Studio](https://hub.docker.com/r/datastax/dse-studio/): An interactive developer’s tool for DataStax Enterprise which is designed to help your DSE database, Cassandra Query Language (CQL), DSE Graph, and Gremlin Query Language development.
* [DataStax Enterprise OpsCenter](https://hub.docker.com/r/datastax/dse-opscenter/): The web-based visual management and monitoring solution for DataStax Enterprise (DSE)



# Prerequisites

* Basic understanding of Docker images and containers. 

* Docker installed on your local system, see [Docker Installation Instructions](https://docs.docker.com/engine/installation/). 

* When [building](#building) custom images from the DataStax github repository, a [DataStax Academy account](https://academy.datastax.com/). 

# Creating a DataStax Enterprise Container

Use the options describe in this section to create DataStax Enterprise server containers. For a list of available DSE versions see [Docker Hub tags](https://hub.docker.com/r/datastax/dse-server/tags/). 

## Docker run options
Use the following options to set up a DataStax Enterprise server container. 

Option | Description
------------- | -------------
`-e` | (**Required**) Sets [Environment variables](#using-environment-variables) to accept the licensing agreement and <BR> (optional) change the initial configuration.
`-d` | (Recommended) Starts the container in the background.
`-p` | Publish container ports on the host computer to allow remote access to DSE, OpsCenter, and Studio. See [Exposing DSE public ports](#exposing-dse-public-ports)
`-v` | Bind mount a directory on the local host to a DSE Volume to manage configuration or preserve data. See [Volumes and data](#volumes-and-data). 
`--name` |Assigns a name to the container.

These are the most commonly used `docker run` switches used in deploying DSE.  For a full list please see [docker run](https://docs.docker.com/engine/reference/commandline/run/) reference.

## Enabling advanced functionality

By default, the DSE server image is set up as a transactional (database) node.
To set up the node with DSE advanced functionality, add the option that enables feature to the end of the `docker run` command.

Option | Description
------------- | -------------
-s | Enables and starts DSE Search.
-k | Enables and starts Analytics.
-g | Enables and starts a DSE Graph.

You can combine the options to run more than one feature. For more examples, see the Starting [DSE documentation](http://docs.datastax.com/en/dse/5.1/dse-admin/datastax_enterprise/operations/startStop/startDseStandalone.html).

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

## Managing the configuration

Manage the DSE configuration using one of the following options:  

* [DSE configuration volume](#using-the-dse-conf-volume) use configuration files from a mounted host directory without replacing or customizing the containers. 

* [DSE environment variables](#using-environment-variables) that change the configuration at runtime. 

* Docker file/directory volume mounts

* Docker overlay file system

### Using the DSE conf volume

DataStax provided Docker images include a start up script that swaps DSE configuration files found in the Volume `/conf` with the configuration file in the default location on the container. 

To use this feature: 

1. Create a directory on your local host. 

2. Add the configuration files you want to replace.
The file name must match a corresponding configuration file in the image and include all the required values, for example `cassandra.yaml`, `dse.yaml`, `opscenterd.conf`. For a full list of config files please see these links

* [DSE](https://github.com/datastax/docker-images/blob/master/server/5.1/files/overwritable-conf-files)

* [OPSCENTER](https://github.com/datastax/docker-images/blob/master/opscenter/6.1/files/overwritable-conf-files)

* [STUDIO](https://github.com/datastax/docker-images/blob/master/studio/2.0/files/overwritable-conf-files)

3. Mount the local directory to the exposed Volume `/conf`.

4. Start the container. For example to start a transactional node:
 
```
docker run -e DS_LICENSE=accept --name my-dse -d  -v /dse/conf:/conf datastax/dse-server
```

### Using environment variables


Configure the DSE image by setting environment variables when the container is created using the docker run command `-e` flag.

Variable | Setting    | Description                
------------ | ------------- | -------------------- 
`DS_LICENSE` | accept | **Required**. Set to accept to acknowledge that you agree with the terms of the DataStax license. To show the license, set the variable `DS_LICENSE` to the value `accept`. *The image only starts if the variable set to accept.*
`LISTEN_ADDRESS` | *IP_address* | The IP address to listen for connections from other nodes. Defaults to the container's IP address.
`BROADCAST_ADDRESS` | *IP_address* | The IP address to advertise to other nodes. Defaults to the same value as the `LISTEN_ADDRESS`.
`RPC_ADDRESS` |*IP_address* | The IP address to listen for client/driver connections. Default: `0.0.0.0`.
`BROADCAST_RPC_ADDRESS` | *IP_address* | The IP address to advertise to clients/drivers. Defaults to the same value as the `BROADCAST_ADDRESS`.
`SEEDS` | *IP_address* | The comma-delimited list of seed nodes for the cluster. Defaults to this node's `BROADCAST_ADDRESS`. 
`START_RPC` | `true` \| `false` | Whether or not to start the Thrift RPC server. Will leave the default in the `cassandra.yaml` file if not set.
`CLUSTER_NAME` | *string* | The name of the cluster. Default: `Test Cluster`.
`NUM_TOKENS`|*int*|The number of tokens randomly assigned to the node. Default: `8`.
`DC` | *string* | Datacenter name. Default: `Cassandra`.
`RACK` | *string* | Rack name. Default: `rack1`.
`OPSCENTER_IP` | *IP_address* \| *string* | Address of OpsCenter instance to use for DSE management; it can be specified via linking the OpsCenter container using opscenter as the name.


## Volumes and data

DSE images expose the following volumes.  

* For DataStax Enterprise Transactional, Search, Graph, and Analytics workloads:
	* `/var/lib/cassandra`: Data from Cassandra
	* `/var/lib/spark`: Data from DSE Analytics w/ Spark
	* `/var/lib/dsefs`: Data from DSEFS
	* `/var/log/cassandra`: Logs from Cassandra
	* `/var/log/spark`: Logs from Spark
	* `/conf`: Directory to add custom config files for the container to pickup.

* For OpsCenter: `/var/lib/opscenter`

* For Studio: `/var/lib/datastax-studio`

### Preserving data
To persist data, pre-create directories on the local host and map the directory to the corresponding volume using the docker run `-v` flag. 

**NOTE:** If the volumes are not mounted from the local host, all data is lost when the container is removed.

* DSE Transactional, Search, Graph, and Analytics nodes:
 * `/var/lib/cassandra/data`  
 * `/var/lib/cassandra/commit_logs` 
 * `/var/lib/cassandra/saved_caches`

* OpsCenter: `/var/lib/opscenter`

* Studio: `/var/lib/datastax-studio`

To mount a volume, use the following syntax:  

```
docker run -v <local_directory>:<container_volume>
```
**Example**
Mount the host directory /dse/conf to the DSE volume /conf to manage configuration files.
```
docker run -e DS_LICENSE=accept --name my-dse -d  -v /dse/conf:/conf datastax/dse-server
```

See [Docker's Use volumes](https://docs.docker.com/engine/tutorials/dockervolumes/#mount-a-host-directory-as-a-data-volume) for more information.

## Exposing DSE public ports

To allow remote hosts to access a DataStax Enterprise node, OpsCenter, or Studio, map the DSE public port to a host port using the docker run `-p` flag. 

For a complete list of ports see [Securing DataStax Enterprise ports](http://docs.datastax.com/en/dse/5.1/dse-admin/datastax_enterprise/security/secFirewallPorts.html#secFirewallPorts).
 
**NOTE**: When mapping a container port to a local host port ensure that host port is not already in use by another container or the host.
   
### Example

To allow access to the OpsCenter from browser on a remote host, open port `8888`:  
```
docker run -e DS_LICENSE=accept --name my-opscenter -d -p 8888:8888 datastax/dse-opscenter
```

# Running DSE commands and viewing logs


Use the `docker exec -it <container_name>` command to run DSE tools and other operations. 

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

To exit the shell without stopping the container use *`ctl P ctl Q`*


## Viewing logs

You can view the DSE logs using the Docker log command. For example:

```
docker logs my-dse
```

You can also use your favorite viewer/editor to see individual log files.

`docker exec -it <container_name> <viewer/editor> <path_to_log>`

For example, to view the system.log:

```
docker exec -it my-dse less /var/log/cassandra/system.log
```

## Using DSE tools

Use` docker exec` to run other tools. 

**For example**

`nodetool status` command:

```
docker exec -it my-dse nodetool status
```

See [DSE documentation](http://docs.datastax.com/en/dse/5.1/dse-admin/) for further info on usage/configuration 



# Creating an OpsCenter container

1. Create an OpsCenter container:

```docker run -e DS_LICENSE=accept --name my-opscenter -d -p 8888:8888 datastax/dse-opscenter
```


For a list of available OpsCenter versions see Docker Hub tags.

2. Create DataStax Enterprise server nodes, providing the link to the OpsCenter container using the Docker name.

```docker run -e DS_LICENSE=accept --link my-opscenter:opscenter --name my-dse -d datastax/dse-server
```
Where my-dse is the DSE node.

3. Find the ip of the DSE container 

```
docker inspect my-dse | grep '"IPAddress":'
```
or

```
docker exec -it my-dse nodetool status
```


4. Open a browser and point to http://DOCKER_HOST_IP:8888. The Create the new connection dialog displays.
5. Click Manage existing cluster.
6. Enter ipaddress obtained in step 3 as the host name.
7. Choose Install agents manually.

The agent is already available on the DSE node, no installation is required.

See [OpsCenter documentation](http://docs.datastax.com/en/opscenter/6.1/) for further info on usage/configuration.

# Creating a Studio container

1. Create a Studio container:

```
docker run -e DS_LICENSE=accept --link my-dse --name my-studio -p 9091:9091 -d datastax/dse-studio
```

2. Open your browser and point to `http://DOCKER_HOST_IP:9091`, create the new connection using my-dse as the hostname. 

Check [Studio documentation](http://docs.datastax.com/en/dse/5.1/dse-dev/datastax_enterprise/studio/stdToc.html) for further instructions.



# Using Docker Compose for Automated Provisioning

Bootstrapping a multi-node cluster with OpsCenter and Studio can be elegantly automated with [Docker Compose](https://docs.docker.com/compose/). To get sample `compose.yml` files visit the following links.  

* [DSE](https://github.com/datastax/docker-images/blob/master/docker-compose.yml)  

* [OpsCenter](https://github.com/datastax/docker-images/blob/master/docker-compose.opscenter.yml)  

* [Studio](https://github.com/datastax/docker-images/blob/master/docker-compose.studio.yml)


**3-Node Setup**

```
docker-compose  -f docker-compose.yml up -d --scale node=2
```

**3-Node Setup with OpsCenter**

```
docker-compose -f docker-compose.yml -f docker-compose.opscenter.yml up -d --scale node=2
```

**3-Node Setup with OpsCenter and Studio**

```
docker-compose -f docker-compose.yml -f docker-compose.opscenter.yml -f docker-compose.studio.yml up -d --scale node=2
```

**Single Node Setup with Studio**

```
docker-compose -f docker-compose.yml -f docker-compose.studio.yml up -d --scale node=0
```

# Building

The code in this repository will build the images listed above. To build all of them please run the following commands:

```console
./gradlew buildImages -PdownloadUsername=<your_DataStax_Acedemy_username> -PdownloadPassword=<your_DataStax_Acedemy_passwd>
```

By default, [Gradle](https://gradle.org) will download DataStax tarballs from [DataStax Academy](https://downloads.datastax.com).
Therefore you need to provide your credentials either via the command line, or in `gradle.properties` file located
in the project root.

Run `./gradlew tasks` to get the list of all available tasks.

# Getting Help

If you are a customer of DataStax, please use the official support channels for any help you need.

[datastax-enterprise](http://www.datastax.com/products/datastax-enterprise)
[docker-hub-tags](https://hub.docker.com/r/datastax/dse-server/tags/)
[start-dse](http://docs.datastax.com/en/dse/5.1/dse-admin/datastax_enterprise/operations/startStop/startDseStandalone.html)
[dse-ports](http://docs.datastax.com/en/dse/5.1/dse-admin/datastax_enterprise/security/secFirewallPorts.html)
[opscenter-docs](http://docs.datastax.com/en/opscenter/6.1/index.html)
[studio-docs](http://docs.datastax.com/en/dse/5.1/dse-dev/datastax_enterprise/studio/stdToc.html)

# Known Issues

* CFS is not supported
* Changing any file not included in the list of approved configuration files will require an additional host volume or customization of the image. An example is SSL key management.



# License

Please review the included LICENSE file.




