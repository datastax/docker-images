# Short Description
DataStax OpsCenter is a web-based visual management and monitoring solution for DataStax Enterprise [DSE](https://store.docker.com/images/datastax).
![](https://upload.wikimedia.org/wikipedia/commons/e/e5/DataStax_Logo.png)
# Overview
DataStax OpsCenter is a web-based visual management and monitoring solution for DataStax Enterprise (DSE). 

## Supported tags
* 6.1.4 ([6.1.4/Dockerfile](https://github.com/datastax/docker-images/blob/master/opscenter/6.1/Dockerfile))
 

# Getting started

Use the DataStax provided Docker images in non-production environments for development, to learn, try new ideas, and to test or demonstrate your application. 

## Creating a container

Follow these steps to create an Opscenter container and a connected DataStax Enterprise server container on the same Docker host. 

To create and connect the containers:

1. First create an OpsCenter container.

 ```
docker run -e DS_LICENSE=accept -d -p 8888:8888 --name my-opscenter
```
See [OpsCenter Docker run options](#OpsCenter-Docker-run-options) for additional options that persist data or manage configuration.

2. Create a [DataStax Enterprise (DSE) server](https://store.docker.com/images/datastax) container that is linked to the OpsCenter container. 

 ```
docker run -e DS_LICENSE=accept --link my-opscenter:opscenter --name my-dse -d store/datastax/dse-server:5.1.5
```

3. Get the DSE container IP address:

 
 ```
docker exec -it my-dse nodetool status
```

5. Open a browser and go to `http://DOCKER_HOST_IP:8888`.
6. Click `Manage existing cluster`. 
7. In `host name`, enter the DSE IP address.
8. Click `Install agents manually`. Note that the agent is already installed on the DSE image; no installation is required.

OpsCenter is ready to use with DSE. See the [OpsCenter User Guide](http://docs.datastax.com/en/opscenter/6.1/) for detailed usage and configuration instructions.

## OpsCenter Docker run options
Use the following options when creating an OpsCenter Docker container. 

Option | Description
------------- | -------------
`-e` | (**Required**) Set `DS_LICENSE=accept` to accept the [OpsCenter licensing agreement](https://www.datastax.com/datastax-opscenter-license-terms).
`-d` | (Recommended) Starts the container in the background.
`-p` | Publish OpsCenter port on the host computer and allow remote access. For example map, the HTTP port to allow browser access `-p 8888:8888`.
`-v` | (Optional) Bind mount local host directories to exposed volumes to [manage the configuration](#Managing-the-configuration) or [persist data](#Persisting-data). For example, `-v /dse/conf/opscenter:/conf`. 
`--name` |Assigns a name to the container.

These are the most commonly used `docker run` switches used in deploying OpsCenter.  For a full list please see [docker run](https://docs.docker.com/engine/reference/commandline/run/) reference.


### Managing the configuration

DataStax provided OpsCenter images have a startup script that replaces the configuration files found in volume (`/conf`) with the corresponding file in the image. This allows you to manage the configuration from the host computer by bind mounting the local directory that contains OpsCenter configuration files to the exposed `conf` volume.
 
To manage the configuration: 

1. Create a directory on the Docker host. 

2. Add the configuration files.
The file name must match a corresponding configuration file in the image and include all the required values, for example `opscenterd.conf`. For a full list of config files see [Opscenter Configuration File list](https://github.com/datastax/docker-images/blob/master/opscenter/6.1/files/overwritable-conf-files).

3. Bind mount the local directory to the exposed Volume `/conf` by starting the container with the `-v` flag.

```
docker run -e DS_LICENSE=accept -d -v /dse/conf/opscenter:/conf datastax/dse-opscenter --name my-opscenter
```

### Persisting data

DataStax provided OpsCenter images expose the data volume `/var/lib/opscenter`.

To persist data:

1. Create a directory on the Docker host. 

3. Bind mount the local directory to the exposed Volume `/var/lib/opscenter` by starting the container with the `-v` flag.
```
docker run -e DS_LICENSE=accept -d -v /dse/data/opscenter:/var/lib/opscenter datastax/dse-opscenter --name my-opscenter
```

See [Docker volumes doc](https://docs.docker.com/engine/tutorials/dockervolumes/#mount-a-host-directory-as-a-data-volume) for more information on mounting Volumes.

# Attaching to a container

If the container was created using the Docker run `-d` option, it runs in the background. You can attach to the container and use bash instead of `docker exec` for individual commands.

To open a bash session on the container, use the following command:

```
docker exec -it container_name bash
```

**For example**

```
docker exec -it my-opscenter bash
```

To exit the shell without stopping the container use *`ctl P ctl Q`*

# Quick Reference 
## Locating DataStax Docker images

Use the Docker images maintained by [DataStax](https://www.datastax.com/):

* Docker Store (Login to docker store and subscribe to the image):

 * [DataStax Enterprise](https://store.docker.com/images/datastax): The best distribution of Apache Cassandra™ with integrated Search, Analytics, and Graph capabilities

* Docker Hub:
 * [DataStax Studio](https://hub.docker.com/r/datastax/dse-studio/): An interactive developer’s tool for DataStax Enterprise which is designed to help your DSE database, Cassandra Query Language (CQL), DSE Graph, and Gremlin Query Language development.
 * [DataStax OpsCenter](https://hub.docker.com/r/datastax/dse-opscenter/): The web-based visual management and monitoring solution for DataStax Enterprise (DSE)

## Getting help 
 * Learn about using OpsCenter at [DataStax Academy](https://academy.datastax.com/)
 * Read about usage and configuration in the [OpsCenter User Guide](http://docs.datastax.com/en/opscenter/6.1/)  
 * Ask questions in the [DataStax Slack](https://academy.datastax.com/slack) channel
* Report issues [https://github.com/datastax/docker-images/issues](https://github.com/datastax/docker-images/issues)


## Licensing terms
* [OpsCenter License Terms](https://www.datastax.com/datastax-opscenter-license-terms)
* [DataStax License Terms](https://www.datastax.com/terms)
* [DataStax License Terms](https://www.datastax.com/terms)