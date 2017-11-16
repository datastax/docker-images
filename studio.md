# Short Description
DataStax Studio is an interactive tool for CQL (Cassandra Query Language) and DataStax Enterprise Graph. 
![](https://upload.wikimedia.org/wikipedia/commons/e/e5/DataStax_Logo.png)

Studio is official tooling for DataStax Enterprise which also had an [docker image](https://store.docker.com/images/datastax). 

# Supported Tags
* 2.0 ([2.0/Dockerfile](https://github.com/datastax/docker-images/blob/master/studio/2.0/Dockerfile))

# Quick Reference 
### Where to get help:
[DataStax Academy](https://academy.datastax.com/), [DataStax Slack](https://academy.datastax.com/slack)

### Where to file issues:
https://github.com/datastax/docker-images/issues

### Maintained by 
[DataStax](https://www.datastax.com/) 

# What is DataStax Studio

DataStax Studio is an interactive tool for CQL (Cassandra Query Language) and [DataStax Enterprise](https://store.docker.com/images/datastax) Graph. 

DataStax Enterprise is the best distribution of Apache Cassandra™ with integrated Search, Analytics, and Graph capabilities. Get the DataStax Enterprise Docker image [here](https://store.docker.com/images/datastax).  

# Getting Started with DataStax and Docker

The DataStax provided Docker images are intended to be used for Development purposes in non-production environments. You can use these images to learn [DSE](https://store.docker.com/images/datastax), [OpsCenter](https://hub.docker.com/r/datastax/dse-opscenter) and [DataStax Studio](https://hub.docker.com/r/datastax/dse-studio), to try new ideas, and to test and demonstrate your application.


# EULA Acceptance
In order to use these images, it is necessary to accept the terms of the DataStax license. This is done by setting the environment variable `DS_LICENSE` to the value accept when running containers based on the produced images. To show the license included in the images, set the variable `DS_LICENSE` to the value `accept`. *The images will not start without the variable set to the accept value.*

[DataStax License Terms](https://www.datastax.com/terms)

```
docker run -e DS_LICENSE=accept --link my-dse --name my-studio -p 9091:9091 -d datastax/dse-studio

```

# Single Mount Configuration Management

DataStax has made it easy to make configuration changes by creating a script that looks in the exposed Volume `/conf` for any added configuration files and loads them at container start. 

To take advantage of this feature, you will need to create a mount directory on your host, mount your local directory to the exposed Volume `/conf`, place you modified configuration files in the mount directory on your host machine and start the container. 

These files will override the existing configuration files. 
To use this feature: 

1. Create a directory on your local host. 

2. Add the configuration files you want to replace.
The file name must match a corresponding configuration file in the image and include all the required values, for example `configuration.yaml`. For a full list of config files please see

* [Studio Config Files](https://github.com/datastax/docker-images/blob/master/studio/2.0/files/overwritable-conf-files)

3. Mount the local directory to the exposed Volume `/conf` and start the container with the -v option.

**For example let’s mount the host directory /dse/conf/studio on the exposed volume /conf**

```
docker run -e DS_LICENSE=accept --name my-studio -p 9091:9091 -d -v /dse/conf/studio:/conf datastax/dse-studio
```


# Database and Data Storage

The following volumes are created and exposed with the images:  

**Studio**

* `/var/lib/datastax-studio`: Studio data

To persist data it is recommended that you pre-create directories and map them via the Docker run command also.

**DataStax recommends the following mounts be made** 

**Users that do not expose the following mounts outside of the container will lose all data**

For Studio: `/var/lib/datastax-studio`


To mount a volume, you would use the `-v` flag with the docker run command when starting the container with the following syntax.  

```
docker run -v <some_root_dir>:<container_volume>:<options>
```


**For example let’s mount the host directory /dse/conf/studio on the exposed volume /conf**

```
docker run -e DS_LICENSE=accept --name my-studio -p 9091:9091 -d -v /dse/conf/studio:/conf datastax/dse-studio
```

Please referece the [Docker volumes doc](https://docs.docker.com/engine/tutorials/dockervolumes/#mount-a-host-directory-as-a-data-volume) for more information on mounting Volumes


# Starting a Studio container

```
docker run -e DS_LICENSE=accept --link my-dse --name my-studio -p 9091:9091 -d datastax/dse-studio
```

Open your browser and point to `http://DOCKER_HOST_IP:9091`, create the new connection using my-dse as the hostname. Check [Studio docs](http://docs.datastax.com/en/dse/5.1/dse-dev/datastax_enterprise/studio/stdToc.html) for further instructions.


# Attaching to running container

If you used the -d flag to start you containers in the background, instead of using docker exec for individual commands you may want a bash shell to run commands. To do this use 

```
docker exec -it <container_name> bash
```

**For example**

```
docker exec -it my-studio bash
```

To exit the shell without stopping the container use *`ctl P ctl Q`*

# Licensing
[Studio License Terms](https://www.datastax.com/terms/datastax-studio-license-terms)
[DataStax License Terms](https://www.datastax.com/terms)
