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

The code in this repository will build the images listed above. To build all of them please run the following command specifying the Version for each image:

```./gradlew buildServerImage -PserverVersion=6.0 -PopscenterVersion=6.5 -PstudioVersion=6.0./gradlew buildImages -PdownloadUsername=<your_DataStax_Acedemy_username> -PdownloadPassword=<your_DataStax_Acedemy_passwd>
```

By default, [Gradle](https://gradle.org) will download DataStax tarballs from [DataStax Academy](https://downloads.datastax.com).
Therefore you need to provide your credentials either via the command line, or in `gradle.properties` file located
in the project root.

Run `./gradlew tasks` to get the list of all available tasks.

# License

Use the following links to review the license:

* [DataStax License Terms](https://www.datastax.com/terms)
