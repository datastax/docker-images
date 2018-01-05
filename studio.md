# Short Description
DataStax Studio is an interactive tool for CQL (Cassandra Query Language) and DataStax Enterprise Graph. 
![](https://upload.wikimedia.org/wikipedia/commons/e/e5/DataStax_Logo.png)

#Overview
DataStax Studio is an interactive tool for CQL (Cassandra Query Language) and [DataStax Enterprise](https://store.docker.com/images/datastax) Graph. 

DataStax Enterprise is the best distribution of Apache Cassandra™ with integrated Search, Analytics, and Graph capabilities. Get the DataStax Enterprise Docker image [here](https://store.docker.com/images/datastax).  

# Supported tags
* 2.0 ([2.0/Dockerfile](https://github.com/datastax/docker-images/blob/master/studio/2.0/Dockerfile))

# Getting started

Use the DataStax provided Docker images in non-production environments for development, to learn, try new ideas, and to test or demonstrate your application.

## Creating a container
Follow these steps to create a DataStax Studio container that is connected to a [DataStax Enterprise (DSE) server](https://store.docker.com/images/datastax) container on the same Docker host.

To create and connect the containers:

1. Create a DataStax Studio container:

```
docker run -e DS_LICENSE=accept --link my-dse --name my-studio -p 9091:9091 -d datastax/dse-studio
```
2. Open a browser and go to `http://DOCKER_HOST_IP:9091`

3. Create the new connection using my-dse as the hostname, see DataStax Studio User Guide > [Creating a new connection](http://docs.datastax.com/en/dse/5.1/dse-dev/datastax_enterprise/studio/stdToc.html) for further instructions.

Studio is ready to use with DSE. See [DataStax Studio User Guide](http://docs.datastax.com/en/dse/5.1/dse-dev/datastax_enterprise/studio/stdAbout.html) for detailed usage and configuration instructions.

## Studio docker run options
Use the following options when creating an OpsCenter Docker container. 

Option | Description
------------- | -------------
`-e` | (**Required**) Set `DS_LICENSE=accept` to accept the [DataStax License Terms](https://www.datastax.com/terms).
`-d` | (Recommended) Starts the container in the background.
`-p` | Publish Studio port on the host computer and allow remote access. For example map, the HTTP port to allow browser access `-p 9091:9091`.
`-v` | (Optional) Bind mount local host directories to exposed volumes to [manage the configuration](#Managing-the-configuration) or [persist data](#Persisting-data). For example, `-v /dse/conf/studio:/config`. 
`--name` |Assigns a name to the container.

These are the most commonly used `docker run` switches used in deploying OpsCenter.  For a full list please see [docker run](https://docs.docker.com/engine/reference/commandline/run/) reference.

### Managing the configuration

DataStax provided Studio images have a startup script that replaces the configuration files found in volume (`/config`) with the corresponding file in the image. This allows you to manage the configuration from the host computer by bind mounting the local directory that contains Studio configuration files to the exposed `config` volume.
 
To manage the configuration: 

1. Create a directory on the Docker host. 

2. Add the configuration files.
The file name must match a corresponding configuration file in the image and include all the required values, for example `configuration.yaml`. For a full list of config files see [Studio Configuration File list](https://github.com/datastax/docker-images/blob/master/studio/2.0/files/overwritable-conf-files).

3. Bind mount the local directory to the exposed Volume `/config` by starting the container with the `-v` flag.

```
docker run -e DS_LICENSE=accept --name my-studio -p 9091:9091 -d -v /dse/conf/studio:/config datastax/dse-studio
```

### Persisting data

DataStax provided OpsCenter images expose the data volume `/var/lib/datastax-studio`.

To persist data:

1. Create a directory on the Docker host. 

3. Bind mount the local directory to the exposed Volume `/var/lib/datastax-studio` by starting the container with the `-v` flag.
   
```
docker run -e DS_LICENSE=accept -d -v /dse/data/studio:/var/lib/datastax-studio datastax/dse-studio --name my-studio
```

See [Docker volumes doc](https://docs.docker.com/engine/tutorials/dockervolumes/#mount-a-host-directory-as-a-data-volume) for more information on mounting Volumes.


# Attaching to running container

If the container was created using the Docker run `-d` option, it runs in the background. You can attach to the container and use bash instead of `docker exec` for individual commands.

To open a bash session on the container, use the following command:

```
docker exec -it <container_name> bash
```

**For example**

```
docker exec -it my-studio bash
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
