# Using Docker compose for automated provisioning

Bootstrapping a multi-node cluster with OpsCenter and Studio can be elegantly automated with [Docker Compose](https://docs.docker.com/compose/). These compose yamls are a starting point to easily start a multi-node cluster. You can customize these compose files to meet your requirements.  See Dockers documentation on the [compose file](https://docs.docker.com/compose/compose-file/)for advanced configuation options.


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
