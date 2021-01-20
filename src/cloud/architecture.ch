%This is the change file for the original Docker's Documentation file.
%This is part of Japanese translation version for Docker's Documantation.

@x
---
title: Compose cli architecture
description: General Compose cli architecture
keywords: Docker, Amazon, Azure, Integration, ECS, ACI, Compose, architecture, mapping
---
@y
---
title: Compose cli architecture
description: General Compose cli architecture
keywords: Docker, Amazon, Azure, Integration, ECS, ACI, Compose, architecture, mapping
---
@z

@x
# Architecture
@y
# Architecture
@z

@x
This CLI has the following high level design goals:
1. Provide a way for the Docker experience to be mapped to different container
   runtimes
1. Provide a way to automatically generate high quality SDKs in popular
   languages
1. Ensure that existing Docker CLI commands continue to work as before
@y
This CLI has the following high level design goals:
1. Provide a way for the Docker experience to be mapped to different container
   runtimes
1. Provide a way to automatically generate high quality SDKs in popular
   languages
1. Ensure that existing Docker CLI commands continue to work as before
@z

@x
These constraints resulted in the following architecture:
@y
These constraints resulted in the following architecture:
@z

@x
![CLI architecture](./images/cli-architecture.png)
@y
![CLI architecture](./images/cli-architecture.png)
@z

@x
What follows is a list of useful links to help navigate the code:
* The CLI UX code is in [`cli/`](../cli)
* The backend interface is defined in [`backend/`](../backend)
  * An example backend can be found in [`example/`](../example)
* The API is defined by protobufs that can be found in [`protos/`](../protos)
* The API server is in [`server/`](../server)
* The context management and interface can be found in [`context/`](../context)
* The Node SDK is autogenerated (except for default endpoints managed by Docker Desktop), and can be found in
  [`docker/node-sdk`](https://github.com/docker/node-sdk)
@y
What follows is a list of useful links to help navigate the code:
* The CLI UX code is in [`cli/`](../cli)
* The backend interface is defined in [`backend/`](../backend)
  * An example backend can be found in [`example/`](../example)
* The API is defined by protobufs that can be found in [`protos/`](../protos)
* The API server is in [`server/`](../server)
* The context management and interface can be found in [`context/`](../context)
* The Node SDK is autogenerated (except for default endpoints managed by Docker Desktop), and can be found in
  [`docker/node-sdk`](https://github.com/docker/node-sdk)
@z