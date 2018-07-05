# We are now on DOCKER HUB

# Contents
* [DataStax Platform Overview](#datastax-platform-overview)
* [Getting Started with DataStax and Docker](#getting-started-with-datastax-and-docker)
* [Prerequisites](#prerequisites)
* [Next Steps](next-steps)
* [Building](#building)
* [Quick Reference](#quick-reference )
* [Licensing](#license)

# Quick Reference 
### Where to get help:
[DataStax Academy](https://academy.datastax.com/), [DataStax Slack](https://academy.datastax.com/slack)

For documentation and tutorials head over to [DataStax Academy](https://academy.datastax.com/quick-downloads?utm_campaign=Docker_2019&utm_medium=web&utm_source=docker&utm_term=-&utm_content=Web_Academy_Downloads). On Academy you’ll find everything you need to configure and deploy the DataStax Docker Images. 

Featured Tutorial - [DataStax Enterprise 6 Guided Tour](https://academy.datastax.com/resources/guided-tour-dse-6-using-docker)

# What is DataStax Enterprise

Built on the best distribution of Apache Cassandra™, DataStax Enterprise is the always-on database designed to allow you to effortlessly build and scale your apps, integrating graph, search, analytics, administration, developer tooling, and monitoring into a single unified platform. We power your apps' real-time moments so you can create instant insights and powerful customer experiences.


![](https://upload.wikimedia.org/wikipedia/commons/e/e5/DataStax_Logo.png)


# Getting Started with DataStax and Docker

DataStax Docker images are licensed only for Development purposes in non-production environments. You can use these images to learn [DSE](https://hub.docker.com/r/datastax/dse-server), [OpsCenter](https://hub.docker.com/r/datastax/dse-opscenter) and [DataStax Studio](https://hub.docker.com/r/datastax/dse-studio), to try new ideas, to test and demonstrate your application.

# Prerequisites

* Basic understanding of Docker images and containers. 

* Docker installed on your local system, see [Docker Installation Instructions](https://docs.docker.com/engine/installation/). 

* When [building](#building) custom images from the DataStax github repository, a [DataStax Academy account](https://academy.datastax.com/). 

# Next Steps

For documentation including configuration options, environment variables, and compose examples head over to [DataStax Academy](https://academy.datastax.com/quick-downloads?utm_campaign=Docker_2019&utm_medium=web&utm_source=docker&utm_term=-&utm_content=Web_Academy_Downloads). 

On Academy you’ll also find step by step tutorials and examples. 

# Building

The code in this repository will build the DSE, Opscenter and Studio Docker images. To get started, clone this repo and modify for your requirements. DataStax uses gradle to build these images.

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
./gradlew buildServerImage -PserverVersion=5.1 -PopscenterVersion=6.1 -PstudioVersion=2.0./gradlew buildImages -PdownloadUsername=<your_DataStax_Acedemy_username> -PdownloadPassword=<your_DataStax_Acedemy_passwd>
```

Run `./gradlew tasks` to get the list of all available tasks.

# License

Use the following links to review the license:

* [DataStax License Terms](https://www.datastax.com/terms)
