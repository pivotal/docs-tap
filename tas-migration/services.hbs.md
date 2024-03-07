# Comparison of services on Tanzu Application Service and Tanzu Application Platform

This topic compares how you manage services on Tanzu Application Service (commonly known as TAS)
with how you manage services on Tanzu Application Platform (commonly known as TAP).

## Overview

Tanzu Application Service and Tanzu Application Platform both provide service binding
capabilities to declaratively connect applications to their backing services.

However, the catalog of available services, the user experience, and the mechanics of this capability differ.

On TAP, there are several [package profiles](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.7/tap/about-package-profiles.html).
The enabling package for services is called Services Toolkit and is installed by default in TAP
Run and Iterate profiles. Services are deployed alongside Workloads in the same Kubernetes cluster.
In contrast, TAS registers service brokers with CF marketplace which can be running anywhere, but are
commonly run as BOSH or cf deployments.

## Service offering functionality

| Functionality                           | TAS                                                                                                                                                                                                                                                           | TAP                                                                                                                                                                                                                                                                                                                                                                                                                  |
| --------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Deploy an API for service instance CRUD | Services are packaged in a [Tile](https://docs.vmware.com/en/Tile-Developer-Guide/3.0/tile-dev-guide/tile-basics.html) which provision an [OSBAPI-compliant](https://github.com/openservicebrokerapi/servicebroker/blob/v2.13/spec.md) API (“service broker”) | Services are packaged as [Crossplane Composition](https://docs.crossplane.io/latest/concepts/compositions/) and [XRD](https://docs.crossplane.io/latest/concepts/composite-resource-definitions/), and Services Toolkit [ClusterInstanceClass](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.7/tap/services-toolkit-reference-api-clusterinstanceclass-and-classclaim.html#clusterinstanceclass-0). |
| Publish a service offering              | When a tile is installed, it can then be registered in the Services Marketplace. Service brokers include catalog metadata that is used by Services Marketplace in order to.                                                                                   | A ClusterInstanceClass Kubernetes resource is created to reference a Crossplane Composition.                                                                                                                                                                                                                                                                                                                         |
| List available service offerings        | CLI: `cf marketplace`                                                                                                                                                                                                                                         | CLI: `tanzu service class list`                                                                                                                                                                                                                                                                                                                                                                                      |
| Service Plans                           | Defined in the service broker implementation                                                                                                                                                                                                                  | There is no concept of plans. Parameters can be exposed to the user and wired through Crossplane composition, XRD, and ClusterInstanceClass. Multiple compositions could be created to offer different variants of a service (e.g. {small, large})                                                                                                                                                                   |
| Get Service offering details            | CLI: `cf marketplace -s SERVICE_NAME`                                                                                                                                                                                                                         | CLI: `tanzu service class get SERVICE_NAME`                                                                                                                                                                                                                                                                                                                                                                          |

## Available Out-of-the-Box Services

Services offered out of the box are very similar to offerings in `cf marketplace`.
The following services are available on TAP out of the box as provisioner-based classes that and
require little to no configuration for a user to self-provision:

- Dev Backing Services by Bitnami: Redis, RabbitMQ, mySQL, postgreSQL, Kafka, MongoDB
- AWS Services: RDS (postgreSQL and mySQL) and AWS MQ (rabbitmq)

For services not offered out of the box, TAP also has a workflow for user-provided service instances
called Direct Secret Reference (referenced below).

## Service Compatibility and Creating New Service Offerings

Virtually any service that can be integrated with TAP workloads. There are
[four levels of services consumption on TAP](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.7/tap/services-toolkit-concepts-service-consumption.html).
On one end of the spectrum, TAP has a concept similar to TAS’s [user provided service instances](https://docs.cloudfoundry.org/devguide/services/user-provided.html)
called [direct secret references](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.7/tap/services-toolkit-tutorials-direct-secret-references.html).
User-provided service instances and direct secret references allow you to use services that are not
available in the Marketplace by providing the credentials and network endpoint.
On the other end of the spectrum, a platform operator could write Crossplane compositions to offer a
provisioner-based class.
With each level comes more complexity but provides a more integrated self-service offering.
Use the highest-level abstraction you can to make lifecycle management of the services as easy to use
as possible.

A key difference between TAS and TAP is that TAS requires a much more rigid implementation that requires
the build and release of a new versioned Tile. Whereas on TAP the approach is much more modular and
can be updated by modifying YAML to modify settings or exposed parameters.

TAP also offers a layer of abstraction called pooled classes where pre-provisioned services can be
grouped together by service type (e.g. MySQL) and those instances can be claimed without having to
specify a particular service instance.
This is a great option for still being able to offer developer self-service in organizations that
have advanced service configuration requirements managed by a central services team

- Using Direct Secret references (Level 1) https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.7/tap/services-toolkit-tutorials-direct-secret-references.html
- Create a Tanzu RabbitMQ service offering (Level 4) https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.7/tap/services-toolkit-tutorials-setup-dynamic-provisioning.html
- Create a Tanzu PostgreSQL service offering (Level 4) https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.7/tap/services-toolkit-how-to-guides-dynamic-provisioning-tanzu-postgresql.html
- Create a service offering for a cloud service (Level 4) https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.7/tap/services-toolkit-tutorials-integrate-cloud-services.html

## Service Binding Workflow

### Out of the box services

| Functionality                    | TAS                                                     | TAP                                                                      |
| -------------------------------- | ------------------------------------------------------- | ------------------------------------------------------------------------ |
| List available service offerings | `cf marketplace`                                        | `tanzu service class list`                                               |
| Provision a service instance     | `cf create-service SERVICE-CLASS PLAN SERVICE-INSTANCE` | `tanzu service class-claim create SERVICE-INSTANCE –class SERVICE-CLASS` |
| Bind a service to app            | `cf bind-service APP-NAME SERVICE-INSTANCE`             | `tanzu apps workload update APP-NAME --service-ref SERVICE-INSTANCE`     |
| Unbind a service to app          | `cf unbind-service APP-NAME SERVICE-INSTANCE`           | `tanzu apps workload update my-app --service-ref=SERVICE-INSTANCE:-`     |
| Delete a service instance        | `cf delete-service SERVICE-INSTANCE`                    | `tanzu service class-claim delete SERVICE-INSTANCE`                      |

### User-provided services

| Functionality              | TAS                                                                          | TAP                                                                                                                |
| -------------------------- | ---------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------ |
| Create service credentials | `cf cups SERVICE-INSTANCE -p '{"username":"USERNAME", "password":"PASSWORD"}'` | Create a [Kubernetes secret](https://kubernetes.io/docs/concepts/configuration/secret/) containing key/value pairs |
| Bind a service to app      | `cf bind-service APP-NAME SERVICE-INSTANCE`                                    | `tanzu apps workload update APP-NAME --service-ref SERVICE-INSTANCE`                                                |
| Unbind a service to app    | `cf unbind-service APP-NAME SERVICE-INSTANCE`                                  | `tanzu apps workload update my-app --service-ref=SERVICE-INSTANCE:-`                                                 |

## At a Glance

### Common Operations

#### Service Author Perspective

| Requirement                                       | TAS                                                                                                     | TAP                                                                                                                                                                                       |
| ------------------------------------------------- | ------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| To integrate my backing service with the platform | <ul><li>Develop and maintain an OSBAPI Service Broker</li><li>Develop and maintain a TAS Tile</li></ul> | <ul><li>Develop and maintain a Kubernetes Operator</li><li>Develop and maintain a set of Crossplane and Services Toolkit configuration (XRD, Composition, ClusterInstanceClass)</li></ul> |

#### Service Operator Perspective

| Requirement                                                                                           | TAS                                            | TAP                                                                                            |
| ----------------------------------------------------------------------------------------------------- | ---------------------------------------------- | ---------------------------------------------------------------------------------------------- |
| To offer a given backing service for self-serve consumption to application developers on the platform | Install the TAS Tile                           | Install the Kubernetes Operator                                                                |
| To ensure that all service instances on the platform meet all compliance and security requirements    | Configure settings in the Tile via Ops Manager | Configure the Crossplane XRD/Composition and Services Toolkit ClusterInstanceClass accordingly |

#### Application Developer Perspective

| Requirement                                                                                           | TAS                                                                                                     | TAP                                                                                                                                             |
| ----------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------- |
| To discover the list of backing services that are available to me                                     | CLI: cf marketplace                                                                                     | CLI: tanzu service class list                                                                                                                   |
| To see detailed information about a particular backing service                                        | CLI: cf marketplace (viewing of plans) (TBC)                                                            | CLI: tanzu service class get <CLASS NAME>                                                                                                       |
| To create a new service instance of one of the available backing services                             | CLI: cf create-service SERVICE_CLASS PLAN SERVICE_INSTANCE                                              | CLI: tanzu service class-claim create <INSTANCE NAME> --class <CLASS NAME> --parameter foo=bar                                                  |
| To bind a service instance to an application workload                                                 | CLI: cf bind-service APP_NAME SERVICE_INSTANCE                                                          | CLI: tanzu apps workload update my-app --service-ref <CLASS CLAIM REF>                                                                          |
| To bind a User Provided Service to an application workload                                            | CLI: cf cups SERVICE_INSTANCE -p '{"username":"admin","password":"pa55woRD"} then run cf bind-service … | Create a Kubernetes Secret containing the required credentials then run tanzu apps workload update my-app --service-ref <KUBERNETES SECRET REF> |
| To bind two application workloads to the same service instance in the same TAS Space or TAP namespace | Run the cf bind-service … command twice, one for each app                                               | Run the tanzu apps workload update … twice, one for each app                                                                                    |
| To share a service instance with another TAS Space or TAP namespace                                   | CLI: cf share-service SERVICE_INSTANCE -s OTHER_SPACE [-o OTHER_ORG]                                    | Not currently supported                                                                                                                         |

### Key differences

- TAP does not use OSBAPI to provide backing service integrations, instead the
  [Service Binding Specification for Kubernetes](https://github.com/servicebinding/spec) is used
- TAP does not have a concept of “Service Plans” as such, however TAP’s ClusterInstanceClasses can be
  configured to expose 0 or more properties which give developers the ability to configure certain
  parameters for service instances to meet their needs. Defaults can also be set for those parameters
  - This approach is arguably much more flexible as these properties can be configured/updated by
    Service Operators as/when needed without requiring code changes and version bumps to the
    corresponding OSBAPI brokers
- TAP does not currently have a GUI element for services
- In TAS when you bind a service instance to an application workload, each separate binding is guaranteed
  to receive a unique set of credentials for access to the service instance, this is not guaranteed in TAP
  - The behavior here depends entirely on the backing Kubernetes Operator

## End-to-end example deploying an app

for a step-by-step workflow of deploying an app with a service, see the
[Spring Data Services](https://docs.google.com/document/d/1-Sp_a9eXKGgFz9pQH7uX74GdxHudOidFUnnAiHV7OVg/edit#heading=h.b996pm8sk7t5)
documentation. <!-- is this the Spring Data Services migration doc (spring-data-services.hbs.md)? -->
