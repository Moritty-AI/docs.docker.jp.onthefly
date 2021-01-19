%This is the change file for the original Docker's Documentation file.
%This is part of Japanese translation version for Docker's Documantation.

@x
---
title: ECS integration architecture
description: Mapping of Docker compose entities to Amazon constructs
keywords: Docker, Amazon, Integration, ECS, Compose, architecture, mapping
---
# Architecture
@y
---
title: ECS integration architecture
description: Mapping of Docker compose entities to Amazon constructs
keywords: Docker, Amazon, Integration, ECS, Compose, architecture, mapping
---
# Architecture
@z

@x
ECS integration relies on CloudFormation to manage AWS resrouces as an atomic operation.
This document describes the mapping between compose application model and AWS components
@y
ECS integration relies on CloudFormation to manage AWS resrouces as an atomic operation.
This document describes the mapping between compose application model and AWS components
@z

@x
## Overview
@y
## Overview
@z

@x
This diagram shows compose model and on same line AWS components that get created as equivalent resources
@y
This diagram shows compose model and on same line AWS components that get created as equivalent resources
@z

@x
```
+----------+                                +-------------+                              +-------------------+
| Project  |  . . . . . . . . . . . . . .   | Cluster     |    . . . . . . .             | LoadBalancer      |
+-+--------+                                +-------------+                              +-------------------+
  |
  |    +----------+                         +-------------++-------------------+         +-------------------+
  +----+ Service  |   . . . . . . . . . .   | Service     || TaskDefinition    |         | TargetGroup       |
  |    +--+-------+                         +-------------++-------------------+-+       +-------------------+
  |       |                                                  | TaskRole          |
  |       |                                                  +-------------------+-+
  |       |  x-aws-role, x-aws-policies     . . . . . . . .    | TaskExecutionRole |
  |       |                                                    +-------------------+
  |       |  +---------+
  |       +--+ Deploy  |
  |       |  +---------+                    +-------------------+
  |       |  x-aws-autoscaling  . . . . . . | ScalableTarget    |
  |       |                                 +-------------------+---+
  |       |                                     | ScalingPolicy     |
  |       |                                     +-------------------+-+
  |       |                                       | AutoScalingRole   |
  |       |                                       +-------------------+
  |       |
  |       |  +---------+                    +-------------+                              +-------------------+
  |       +--+ Ports   |   . . . . . . .    | IngressRule +-----+                        | Listener          |
  |       |  +---------+                    +-------------+     |                        +-------------------+
  |       |                                                     |
  |       |  +---------+                    +---------------+ +------------------+
  |       +--+ Secrets |   . . . . . . .    | InitContainer | |TaskExecutionRole |
  |       |  +---------+                    +---------------+ +------------+-----+
  |       |                                                     |          |
  |       |  +---------+                                        |          |
  |       +--+ Volumes |                                        |          |
  |       |  +---------+                                        |          |
  |       |                                                     |          |
  |       |  +---------------+                                  |          |         +-------------------+
  |       +--+ DeviceRequest |  . . . . . . . . . . . . .  . .  | . . . .  | . . .   | CapacityProvider  |
  |          +---------------+                                  |          |         +-------------------+--------+
  |                                                             |          |                | AutoscalingGroup    |
  |   +------------+                        +---------------+   |          |                +---------------------+
  +---+ Networks   |   . . . . . . . . .    | SecurityGroup +---+          |                | LaunchConfiguration |
  |   +------------+                        +---------------+              |                +---------------------+
  |                                                                        |
  |   +------------+                        +---------------+              |
  +---+ Secret     |   . . . . . . . . .    | Secret        +--------------+
      +------------+                        +---------------+
```
@y
```
+----------+                                +-------------+                              +-------------------+
| Project  |  . . . . . . . . . . . . . .   | Cluster     |    . . . . . . .             | LoadBalancer      |
+-+--------+                                +-------------+                              +-------------------+
  |
  |    +----------+                         +-------------++-------------------+         +-------------------+
  +----+ Service  |   . . . . . . . . . .   | Service     || TaskDefinition    |         | TargetGroup       |
  |    +--+-------+                         +-------------++-------------------+-+       +-------------------+
  |       |                                                  | TaskRole          |
  |       |                                                  +-------------------+-+
  |       |  x-aws-role, x-aws-policies     . . . . . . . .    | TaskExecutionRole |
  |       |                                                    +-------------------+
  |       |  +---------+
  |       +--+ Deploy  |
  |       |  +---------+                    +-------------------+
  |       |  x-aws-autoscaling  . . . . . . | ScalableTarget    |
  |       |                                 +-------------------+---+
  |       |                                     | ScalingPolicy     |
  |       |                                     +-------------------+-+
  |       |                                       | AutoScalingRole   |
  |       |                                       +-------------------+
  |       |
  |       |  +---------+                    +-------------+                              +-------------------+
  |       +--+ Ports   |   . . . . . . .    | IngressRule +-----+                        | Listener          |
  |       |  +---------+                    +-------------+     |                        +-------------------+
  |       |                                                     |
  |       |  +---------+                    +---------------+ +------------------+
  |       +--+ Secrets |   . . . . . . .    | InitContainer | |TaskExecutionRole |
  |       |  +---------+                    +---------------+ +------------+-----+
  |       |                                                     |          |
  |       |  +---------+                                        |          |
  |       +--+ Volumes |                                        |          |
  |       |  +---------+                                        |          |
  |       |                                                     |          |
  |       |  +---------------+                                  |          |         +-------------------+
  |       +--+ DeviceRequest |  . . . . . . . . . . . . .  . .  | . . . .  | . . .   | CapacityProvider  |
  |          +---------------+                                  |          |         +-------------------+--------+
  |                                                             |          |                | AutoscalingGroup    |
  |   +------------+                        +---------------+   |          |                +---------------------+
  +---+ Networks   |   . . . . . . . . .    | SecurityGroup +---+          |                | LaunchConfiguration |
  |   +------------+                        +---------------+              |                +---------------------+
  |                                                                        |
  |   +------------+                        +---------------+              |
  +---+ Secret     |   . . . . . . . . .    | Secret        +--------------+
      +------------+                        +---------------+
```
@z

@x
Each compose application service is mapped to an ECS `Service`. A `TaksDefinition` is created according to compose definition.
Actual mapping is constrained by both Cloud platform and Fargate limitations. Such a `TaskDefinition` is set with a single container,
according to the compose model which doesn't offer a syntax to support sidecar containers.
@y
Each compose application service is mapped to an ECS `Service`. A `TaksDefinition` is created according to compose definition.
Actual mapping is constrained by both Cloud platform and Fargate limitations. Such a `TaskDefinition` is set with a single container,
according to the compose model which doesn't offer a syntax to support sidecar containers.
@z

@x
An IAM Role is created and configured as `TaskRole` to grant service access to additional AWS resources when required. For this
purpose, user can set `x-aws-policies` or define a fine grained `x-aws-role` IAM role document.
@y
An IAM Role is created and configured as `TaskRole` to grant service access to additional AWS resources when required. For this
purpose, user can set `x-aws-policies` or define a fine grained `x-aws-role` IAM role document.
@z

@x
Service's ports get mapped into security group's `IngressRule`s and load balancer `Listener`s.
Compose application whith HTTP services only (using ports 80/443 or `x-aws-protocol` set to `http`) get an Application Load Balancer
created, otherwise a Network Load Balancer is used.
@y
Service's ports get mapped into security group's `IngressRule`s and load balancer `Listener`s.
Compose application whith HTTP services only (using ports 80/443 or `x-aws-protocol` set to `http`) get an Application Load Balancer
created, otherwise a Network Load Balancer is used.
@z

@x
A `TargetGroup` is created per service to dispatch traffic by load balancer to the matching containers
@y
A `TargetGroup` is created per service to dispatch traffic by load balancer to the matching containers
@z

@x
Secrets bound to a service get translated into an `InitContainer` added to the service's `TaskDefinition`. This init container is
responsible to create a `/run/secrets` file for secret to match docker secret model and make application code portable.
A `TaskExecutionRole` is also created per service, and is updated to grant access to bound secrets.
@y
Secrets bound to a service get translated into an `InitContainer` added to the service's `TaskDefinition`. This init container is
responsible to create a `/run/secrets` file for secret to match docker secret model and make application code portable.
A `TaskExecutionRole` is also created per service, and is updated to grant access to bound secrets.
@z

@x
Services using a GPU (`DeviceRequest`) get the `Cluster` extended with an EC2 `CapacityProvider`, using an `AutoscalingGroup` to manage
EC2 resources allocation based on a `LaunchConfiguration`. The latter uses ECS recommended AMI and machine type for GPU.
@y
Services using a GPU (`DeviceRequest`) get the `Cluster` extended with an EC2 `CapacityProvider`, using an `AutoscalingGroup` to manage
EC2 resources allocation based on a `LaunchConfiguration`. The latter uses ECS recommended AMI and machine type for GPU.
@z

@x
Service to declare `deploy.x-aws-autoscaling` get a `ScalingPolicy` created targeting specified the configured CPU usage metric
@y
Service to declare `deploy.x-aws-autoscaling` get a `ScalingPolicy` created targeting specified the configured CPU usage metric
@z
