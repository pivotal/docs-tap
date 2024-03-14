# Compare service management on Tanzu Application Platform and Tanzu Application Service

This topic compares how you manage services on Tanzu Application Platform (commonly known as TAP)
with how you manage services on Tanzu Application Service (commonly known as TAS).

## <a id="overview"></a> Overview

Tanzu Application Service and Tanzu Application Platform both provide service binding
capabilities to declaratively connect applications to their backing services.
However, the catalog of available services, the user experience, and the mechanics of this capability differ.

For Tanzu Application Platform, the enabling package for services is called Services Toolkit.
Tanzu Application Platform is usually installed using package profiles.
Services Toolkit is installed by default in the Run and Iterate profiles.
For more information, see [Components and installation profiles for Tanzu Application Platform](../about-package-profiles.hbs.md).

In Tanzu Application Platform, services are deployed alongside workloads in the same Kubernetes cluster.
By contrast, Tanzu Application Service registers service brokers with the Cloud Foundry Marketplace
which can run anywhere, but are commonly run as BOSH or Cloud Foundry deployments.

## <a id="service-offerings"></a> Service offerings

The following table compares the services offering capabilities in Tanzu Application Service and
Tanzu Application Platform.

| Feature                                 | Tanzu Application Service                                                                                                                                                                                                                                     | Tanzu Application Platform                                                                                                                                                                                                                                                                                                                         |
| --------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Deploy an API for service instance CRUD | Services are packaged in a [Tile](https://docs.vmware.com/en/Tile-Developer-Guide/3.0/tile-dev-guide/tile-basics.html) which provision an [OSBAPI-compliant](https://github.com/openservicebrokerapi/servicebroker/blob/v2.13/spec.md) API (“service broker”) | Services are packaged as [Crossplane Composition](https://docs.crossplane.io/latest/concepts/compositions/) and [XRD](https://docs.crossplane.io/latest/concepts/composite-resource-definitions/), and Services Toolkit [ClusterInstanceClass](../services-toolkit/reference/api/clusterinstanceclass-and-classclaim.hbs.md#clusterinstanceclass). |
| Publish a service offering              | When a tile is installed, it can then be registered in the Services Marketplace. Service brokers include catalog metadata that is used by services Marketplace.                                                                                               | A ClusterInstanceClass Kubernetes resource is created to reference a Crossplane Composition.                                                                                                                                                                                                                                                       |
| List available service offerings        | CLI: `cf marketplace`                                                                                                                                                                                                                                         | CLI: `tanzu service class list`                                                                                                                                                                                                                                                                                                                    |
| Service Plans                           | Defined in the service broker implementation                                                                                                                                                                                                                  | There is no concept of plans. Parameters can be exposed to the user and wired through Crossplane composition, XRD, and ClusterInstanceClass. Multiple compositions can be created to offer different variants of a service, for example `{small, large}`                                                                                           |
| Get Service offering details            | CLI: `cf marketplace -s SERVICE_NAME`                                                                                                                                                                                                                         | CLI: `tanzu service class get SERVICE_NAME`                                                                                                                                                                                                                                                                                                        |

## <a id="ootb"></a> Available out-of-the-box services

Services offered out of the box are very similar to offerings in `cf marketplace`.
The following services are available on Tanzu Application Platform out of the box as provisioner-based classes that and
require little to no configuration for a user to self-provision:

- Dev Backing Services by Bitnami: Redis, RabbitMQ, MySQL, PostgreSQL, Kafka, MongoDB
- AWS Services: RDS (PostgreSQL and MySQL) and AWS MQ (RabbitMQ)

For services not offered out of the box, Tanzu Application Platform also has a workflow for user-provided service instances
called Direct Secret Reference.

## <a id="service-compatibility"></a> Service compatibility and creating new service offerings

You can integrate most services with Tanzu Application Platform workloads. There are
[four levels of services consumption on Tanzu Application Platform](../services-toolkit/concepts/service-consumption.hbs.md).
On one end of the spectrum, Tanzu Application Platform has a concept similar to Tanzu Application Service’s
[user provided service instances](https://docs.cloudfoundry.org/devguide/services/user-provided.html)
called [direct secret references](../services-toolkit/tutorials/direct-secret-references.hbs.md).
User-provided service instances and direct secret references allow you to use services that are not
available in the Marketplace by providing the credentials and network endpoint.
On the other end of the spectrum, a platform operator can write Crossplane compositions to offer a
provisioner-based class.
With each level comes more complexity but provides a more integrated self-service offering.
Use the highest-level abstraction you can to make life cycle management of the services as easy to use
as possible.

A key difference between Tanzu Application Service and Tanzu Application Platform is that
Tanzu Application Service requires a much more rigid implementation that requires
the build and release of a new versioned Tile. Whereas on Tanzu Application Platform the approach is much more modular and
can be updated by modifying YAML to change settings or exposed parameters.

Tanzu Application Platform also offers a layer of abstraction called pooled classes where pre-provisioned services can be
grouped together by service type, for example, MySQL, and those instances can be claimed without having to
specify a particular service instance.
This is a great option for still being able to offer developer self-service in organizations that
have advanced service configuration requirements managed by a central services team

- Using Direct Secret references (Level 1): See [Using direct secret references](../services-toolkit/tutorials/direct-secret-references.hbs.md)
- Create a Tanzu RabbitMQ service offering (Level 4): See [Set up dynamic provisioning of service instances](../services-toolkit/tutorials/setup-dynamic-provisioning.hbs.md)
- Create a Tanzu PostgreSQL service offering (Level 4): See [Configure dynamic provisioning of VMware SQL with Postgres for Kubernetes service instances](../services-toolkit/how-to-guides/dynamic-provisioning-tanzu-postgresql.hbs.md)
- Create a service offering for a cloud service (Level 4): See [Integrating cloud services into Tanzu Application Platform](../services-toolkit/tutorials/integrate-cloud-services.hbs.md)

## <a id="bind-services"></a> Service binding workflow

This section compares the service binding workflow for Tanzu Application Service to Tanzu Application Platform.

### <a id="bind-ootb"></a> Out of the box services

The following table compares the binding workflow for out of the box services.

| Feature                          | Tanzu Application Service                               | Tanzu Application Platform                                               |
| -------------------------------- | ------------------------------------------------------- | ------------------------------------------------------------------------ |
| List available service offerings | `cf marketplace`                                        | `tanzu service class list`                                               |
| Provision a service instance     | `cf create-service SERVICE-CLASS PLAN SERVICE-INSTANCE` | `tanzu service class-claim create SERVICE-INSTANCE –class SERVICE-CLASS` |
| Bind a service to app            | `cf bind-service APP-NAME SERVICE-INSTANCE`             | `tanzu apps workload update APP-NAME --service-ref SERVICE-INSTANCE`     |
| Unbind a service to app          | `cf unbind-service APP-NAME SERVICE-INSTANCE`           | `tanzu apps workload update my-app --service-ref=SERVICE-INSTANCE:-`     |
| Delete a service instance        | `cf delete-service SERVICE-INSTANCE`                    | `tanzu service class-claim delete SERVICE-INSTANCE`                      |

### <a id="bind-user-provided"></a>User-provided services

The following table compares the binding workflow for for user provided services.

| Feature                    | Tanzu Application Service                                                      | Tanzu Application Platform                                                                                         |
| -------------------------- | ------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------ |
| Create service credentials | `cf cups SERVICE-INSTANCE -p '{"username":"USERNAME", "password":"PASSWORD"}'` | Create a [Kubernetes secret](https://kubernetes.io/docs/concepts/configuration/secret/) containing key/value pairs |
| Bind a service to app      | `cf bind-service APP-NAME SERVICE-INSTANCE`                                    | `tanzu apps workload update APP-NAME --service-ref SERVICE-INSTANCE`                                               |
| Unbind a service to app    | `cf unbind-service APP-NAME SERVICE-INSTANCE`                                  | `tanzu apps workload update my-app --service-ref=SERVICE-INSTANCE:-`                                               |

## <a id="common-operations"></a> Common operations

This section compares how Tanzu Application Service and Tanzu Application Platform meets the needs
of different roles.

### <a id="service-author"></a> Service author perspective

The following table compares Tanzu Application Service and Tanzu Application Platform for service authors.

| Feature                                       | Tanzu Application Service                                                                                                     | Tanzu Application Platform                                                                                                                                                                 |
| --------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Integrate a backing service with the platform | <ul><li>Develop and maintain an OSBAPI Service Broker</li><li>Develop and maintain a Tanzu Application Service Tile</li></ul> | <ul><li>Develop and maintain a Kubernetes Operator</li><li>Develop and maintain a set of Crossplane and Services Toolkit configurations (XRD, Composition, ClusterInstanceClass)</li></ul> |

### <a id="service-operator"></a>Service operator perspective

The following table compares Tanzu Application Service and Tanzu Application Platform for service operators.

| Feature                                                                                         | Tanzu Application Service                        | Tanzu Application Platform                                                                        |
| ----------------------------------------------------------------------------------------------- | ------------------------------------------------ | ------------------------------------------------------------------------------------------------- |
| Offer a backing service for self-serve consumption to application developers on the platform    | Install the Tanzu Application Service Tile       | Install the Kubernetes operator                                                                   |
| Ensure that all service instances on the platform meet all compliance and security requirements | Configure settings in the Tile using Ops Manager | Configure the Crossplane XRD or Composition and Services Toolkit ClusterInstanceClass accordingly |

### <a id="app-developer"></a>Application developer perspective

The following table compares Tanzu Application Service and Tanzu Application Platform for app developers.

| Feature                                                                                                                                         | Tanzu Application Service                                                                                 | Tanzu Application Platform                                                                                                                      |
| ----------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------- |
| Discover the list of backing services that are available                                                                                        | CLI: `cf marketplace`                                                                                     | CLI: `tanzu service class list`                                                                                                                 |
| See detailed information about a particular backing service                                                                                     | CLI: `cf marketplace`                                                                                     | CLI: `tanzu service class get CLASS-NAME`                                                                                                       |
| Create a new service instance of one of the available backing services                                                                          | CLI: `cf create-service SERVICE-CLASS PLAN SERVICE-INSTANCE`                                              | CLI: `tanzu service class-claim create INSTANCE-NAME --class CLASS-NAME --parameter foo=bar`                                                    |
| Bind a service instance to an application workload                                                                                              | CLI: `cf bind-service APP-NAME SERVICE-INSTANCE`                                                          | CLI: `tanzu apps workload update my-app --service-ref CLASS-CLAIM-REF`                                                                          |
| Bind a User Provided Service to an application workload                                                                                         | CLI: `cf cups SERVICE-INSTANCE -p '{"username":"admin","password":"pa55woRD"}` then run `cf bind-service` | Create a Kubernetes Secret containing the required credentials then run `tanzu apps workload update my-app --service-ref KUBERNETES-SECRET-REF` |
| Bind two application workloads to the same service instance in the same Tanzu Application Service space or Tanzu Application Platform namespace | Run the `cf bind-service` command twice, once for each app                                                | Run the `tanzu apps workload update` command twice, once for each app                                                                           |
| Share a service instance with another Tanzu Application Service space or Tanzu Application Platform namespace                                   | CLI: `cf share-service SERVICE-INSTANCE -s OTHER_SPACE [-o OTHER_ORG]`                                    | Not currently supported                                                                                                                         |

## <a id="differences"></a> Key differences

- Tanzu Application Platform does not use OSBAPI to provide backing service integrations. Tanzu Application Platform
  uses the [Service Binding Specification for Kubernetes](https://github.com/servicebinding/spec) instead.

- Tanzu Application Platform does not have a concept of Service Plans. However, you can configure the
  ClusterInstanceClass in Tanzu Application Platform to expose zero or more properties that enable
  developers to configure parameters for service instances to meet their needs.
  You can also set defaults for those parameters.

  This approach is arguably more flexible because service operators can configure or update these properties
  when needed without requiring code changes and version updates to the corresponding OSBAPI brokers.

- Tanzu Application Platform does not currently have a GUI element for services.

- In Tanzu Application Service when you bind a service instance to an application workload,
  each separate binding is guaranteed to receive a unique set of credentials for access to the service instance.
  This is not guaranteed in Tanzu Application Platform.

  The behavior in Tanzu Application Platform depends on the backing Kubernetes operator.

## <a id="examples"></a> End-to-end example deploying an app

for a step-by-step workflow of deploying an app with a service, see
[Migrate Spring Data Services apps to Tanzu Application Platform](./spring-data-services.hbs.md).