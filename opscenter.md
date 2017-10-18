# Short Description
The web-based visual management and monitoring solution for DataStax Enterprise [DSE](https://store.docker.com/images/datastax).
![](https://upload.wikimedia.org/wikipedia/commons/e/e5/DataStax_Logo.png)

# Supported Tags
* 6.1.4 ([6.1.4/Dockerfile](https://github.com/datastax/docker-images/blob/master/opscenter/6.1/Dockerfile))

# Quick Reference 
### Where to get help:
[DataStax Academy](https://academy.datastax.com/), [DataStax Slack](https://academy.datastax.com/slack)

### Where to file issues:
https://github.com/datastax/docker-images/issues

### Maintained by 
[DataStax](https://www.datastax.com/) 

# What is DataStax OpsCenter

OpsCenter is the web-based visual management and monitoring solution for DataStax Enterprise [DSE](https://store.docker.com/images/datastax). 

DataStax Enterprise is the best distribution of Apache Cassandra™ with integrated Search, Analytics, and Graph capabilities. The DataStax Enterprise image can be found [here](https://store.docker.com/images/datastax)  

# Getting Started with DataStax and Docker

The DataStax provided docker images are intended to be used for Development purposes in non-production environments. You can use these images to learn [DSE](https://store.docker.com/images/datastax), [OpsCenter](https://hub.docker.com/r/datastax/dse-opscenter) and [DataStax Studio](https://hub.docker.com/r/datastax/dse-studio), to try new ideas, and to test and demonstrate your application.


# EULA Acceptance
In order to use these images, it is necessary to accept the terms of the DataStax license. This is done by setting the environment variable `DS_LICENSE` to the value accept when running containers based on the produced images. To show the license included in the images, set the variable `DS_LICENSE` to the value `accept`. *The images will not start without the variable set to the accept value.*

```
docker run -e DS_LICENSE=accept --name my-opscenter -d -p 8888:8888 datastax/dse-opscenter
```

# Single Mount Configuration Management

DataStax has made it easy to make configuration changes by creating a script that looks in the exposed Volume `/conf` for any added configuration files and loads them at container start. 

To take advantage of this feature, you will need to create a mount directory on your host, mount your local directory to the exposed Volume `/conf`, place you modified configuration files in the mount directory on your host machine and start the container. 

These files will override the existing configuration files.  The configs must contain all the values to be used along with using the dse naming convention such as cassandra.yaml, dse.yaml, opscenterd.conf 

To use this feature: 

1. Create a directory on your docker host. 

2. Add the configuration files you want to replace.
The file name must match a corresponding configuration file in the image and include all the required values, for example `opscenterd.conf`. For a full list of config files please see 

* [Opscenter Config Files](https://github.com/datastax/docker-images/blob/master/opscenter/6.1/files/overwritable-conf-files)

3. Mount the local directory to the exposed Volume `/conf` by starting the container with the `-v` flag


**For example let’s mount the host directory /dse/conf/opscenter on the exposed volume /conf**

```
docker run -e DS_LICENSE=accept --name my-dse --name my-opscenter -d -p 8888:8888 -v /dse/conf/opscenter:/conf datastax/dse-opscenter
```

 # Database and Data Storage

The following volumes are created and exposed with the images:  

**OpsCenter**

* `/var/lib/opscenter`: OpsCenter data

To persist data it is recommended that you pre-create directories and map them via the Docker run command to.

**DataStax recommends the following mounts be made** 

**Users that do not expose the following mounts outside of the container will lose all data**

For OpsCenter: `/var/lib/opscenter`


To mount a volume, you would use the `-v` flag with the docker run command when starting the container with the following syntax.  

```
docker run -v <some_root_dir>:<container_volume>:<options>
```
**For example let’s mount the host directory /dse/conf/opscenter on the exposed volume /conf**

```
docker run -e DS_LICENSE=accept --name my-dse -d  -v /dse/conf/opscenter:/conf datastax/dse-opscenter
```

Please referece the [Docker volumes doc](https://docs.docker.com/engine/tutorials/dockervolumes/#mount-a-host-directory-as-a-data-volume) for more information on mounting Volumes


# Starting an OpsCenter node

```
docker run -e DS_LICENSE=accept --name my-opscenter datastax/dse-opscenter
```

Now you can start DSE nodes, providing the link to the opscenter Please see *[DSE instructions](https://github.com/datastax/docker-images/blob/master/README.md)* for more detailed information on DSE

```
docker run -e DS_LICENSE=accept --link my-opscenter:opscenter --name my-dse -d datastax/dse-server
```
Find the ip of the DSE container using 

```
docker inspect my-dse | grep '"IPAddress":'
```
or

```
docker exec -it my-dse nodetool status
```

Open your browser and point to `http://DOCKER_HOST_IP:8888`, create the new connection: - Choose "Manage existing cluster" - Use the ip address obtained in the previous step as the host name - Choose "Install agents manually". The agent is already available on the DSE node, no installation is required.

See the [OpsCenter documentation](http://docs.datastax.com/en/opscenter/6.1/) for further info on usage/configuration.

# Attaching to running container

If you used the -d flag to start you containers in the background, instead of using docker exec for individual commands you may want a bash shell to run commands. To do this use 

```
docker exec -it <container_name> bash
```

**For example**

```
docker exec -it my-opscenter bash
```

To exit the shell without stopping the container use *`ctl P ctl Q`*

