# Services Toolkit Terminology and User roles

## Terminology

### Service

* A broad, high-level term used to describe something used in either the development of, or running of Application Workloads
* Often, but not exclusively, synonymous with the concept of a Backing Service as defined by The Twelve Factor App
  * _... any service the app consumes over the network as part of its normal operation_

#### Examples

* A PostgreSQL service (implemented as a Kubernetes Operator provided by Tanzu Data Services)
* A PostgreSQL service (implemented as a process running on an Application Developer’s laptop)
* Object storage (implemented as SaaS running on AWS)
* AppSSO

### Service Resource

* Any Kubernetes resource which provides (partial) functionality related to a Service

#### Examples

* A Kubernetes resource with API Kind `PostgreSQL`
* A Kubernetes resource with API Kind `FirewallRule`
* A Kubernetes resource with API Kind `RabbitmqUser`
* A Kubernetes resource with API Kind `ClientRegistration` providing access to an App SSO service
* A Kubernetes resource with API Kind `Secret` containing credentials and connectivity information for a Service (which may or may not be running on the cluster itself)

### Provisioned Service

* This term is defined in the Service Binding Specification for Kubernetes.
  * Essentially, any Service Resource which defines a `.status.binding.name` which points to a Secret in the same namespace containing credentials and connectivity information for the resource
* See [Provisioned Service](https://github.com/servicebinding/spec#provisioned-service) for the full definition.

### Service Binding

* A mechanism in which Service Instance credentials and other related connectivity information are communicated to Application Workloads in an automated way

#### Examples

* The Service Binding concept implemented through the `ServiceBinding` Service Resource provided by https://github.com/vmware-tanzu/servicebinding

### Service Instance

* An abstraction over one or a group of interrelated Service Resources that together provide the expected functionality for a particular service
* One of the Service Resource that make up an Instance must either adhere to Provisioned Service or be a Secret conforming to the Service Binding Specification for Kubernetes
  * This guarantees that Service Instances can be Claimed and subsequently bound to Application Workloads
* Service Instances are made discoverable through Service Instance Classes

#### Examples

* The `RabbitmqCluster` Service Resource provided by the RabbitMQ Cluster Operator
  * This Service Resource adheres to Provisioned Service, as such any `RabbitmqCluster` resource on a Kubernetes cluster could be considered a Service Instance
* A logical grouping of the following Service Resources could be said to form a single “AWS RDS” Service Instance:
  * An AWS RDS `DBInstance`
  * An AWS RDS `DBSubnetGroup`
  * A Carvel `SecretTemplate` configured to produce a Secret conforming to the Service Binding Specification for Kubernetes
  * A `Role`, `RoleBinding` and `ServiceAccount`
* A Kubernetes `Secret` conforming to the Service Binding Specification for Kubernetes containing credentials for a Service running external to the cluster

### Service Instance Class

* Commonly referred to as simply "class"
* Provides a way to describe "classes" (i.e. categories) of Service Instances
* Allows for discovery of Service Instances belonging to the class
* Comes in one of two varieties - pool-based or provisioner-based
  * Claims for pool-based classes are fulfilled by selecting a service instance from a pool
  * Claims for provisioner-based classes are fulfilled by provisioning new service instances
* Different classes might map to different Services or to different configurations of the same Service

#### Examples

* A `ClusterInstanceClass` named “rabbitmq-dev” pointing to all `RabbitmqCluster` Service Resources configured with `.spec.replicas=1` identified by label `class: rmq-dev`
* A `ClusterInstanceClass` named “rabbitmq-prod” pointing to all `RabbitmqCluster` Service Resources configured with `.spec.replicas=3` identified by label `class: rmq-prod`
* A `ClusterInstanceClass` named “aws-rds-postgresql” pointing to Secrets conformant with the Binding Specification and identified by label `class: aws-rds`
* A `ClusterInstanceClass` named “mysql-on-demand” which provisions MySQL service instances

### Claim

* A mechanism in which requests for Service Instances can be declared and fulfilled without requiring detailed knowledge of the Service Instances themselves
* Comes in one of two varieties - Resource Claim and Class Claim
  * Resource Claims refer to a specific Service Instance
  * Class Claims refer to a class, from which a Service Instance is then either selected (pool-based) or provisioned (provisioner-based)

#### Examples

* A Resource Claim pointing to a `RabbitmqCluster` Service Instance named `rmq-1` in the namespace `service-instances`
* A Class Claim pointing to a class named `on-demand-rabbitmq`

### Claimable Service Instance

* Any Service Instance which is permitted to be claimed via a Resource Claim from a namespace, taking into consideration:
  * Location (namespace) of the Service Instance in relation to the location (namespace) of the Resource Claim
  * Any matching Resource Claim Policies
  * Exclusivity of Resource Claims (i.e. a given instance can only be claimed once at a time)

#### Examples

* A `RabbitmqCluster` Service Resource residing in the same namespace as a Resource Claim and which has not already been claimed by another Resource Claim could be said to be a “Claimable Service Instance”
* A `RabbitmqCluster` Service Resource residing in a different namespace to a Resource Claim, for which a matching Resource Claim Policy exists, and for which has not already been claimed by another Resource Claim could be said to be a “Claimable Service Instance”
* A `RabbitmqCluster` Service Resource residing in the same namespace as a Resource Claim which has already been claimed could not be said to be a “Claimable Service Instance” due to the exclusive nature of Resource Claims

### Dynamic Provisioning

* A capability of Services Toolkit in which Class Claims that refer to provisioner-based classes are fulfilled automatically through the provisioning of new Service Instances

### Service Resource Lifecycle API

* Any Kubernetes API that can be used to manage the life cycle (CRUD) of a Service Resource

#### Examples

* `rabbitmqclusters.rabbitmq.com/v1beta1`

### Service Cluster

* Applicable within the context of [Service API Projection and Service Resource Replication](../api_projection_and_resource_replication/api_docs.md)
* A Kubernetes cluster that has Service Resource Lifecycle APIs installed and a corresponding controller managing their life cycle

### Workload Cluster

* Applicable within the context of [Service API Projection and Service Resource Replication](../api_projection_and_resource_replication/api_docs.md)
* A Kubernetes cluster that has developer-created applications running on it

## User Roles

Services Toolkit caters to the following user roles.

It is important to note that these User Roles are not User Personas - it is perfectly possible (and even expected) that one human being could be associated with many User Roles at any given time. The User Roles align to Tanzu Application Platform's [User Roles](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.4/tap/authn-authz-role-descriptions.html), and the Services Toolkit team is primarily responsible for defining the Service Operator role.

The User Roles listed here consist of a short description as well as the Jobs To Be Done for the role. For detailed information on corresponding RBAC associated with each role, please refer to [Detailed role permissions breakdown](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.4/tap/authn-authz-permissions-breakdown.html).

## <a id="ad"></a>Application Developer (AD)

Encompasses both [app-editor](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.4/tap/authn-authz-role-descriptions.html#appeditor-0) and [app-viewer](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.4/tap/authn-authz-role-descriptions.html#appviewer-1) roles as defined by Tanzu Application Platform

### Jobs To Be Done

* Bind and unbind Application Workloads to/from Resource Claims
* Get, List, Watch ResourceClaims
* Get, List, Watch ClusterInstanceClasses associated with ResourceClaims

## <a id="ao"></a>Application Operator (AO)

Encompasses the [app-operator](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.4/tap/authn-authz-role-descriptions.html#appoperator-2) role as defined by Tanzu Application Platform

### Jobs To Be Done

* Discover and learn about Service Instance Classes available on a cluster
* Discover Claimable Service Instances associated with Service Instance Classes
* Lifecycle management (CRUD) of Resource Claims

## <a id="so"></a>Service Operator (SO)

### Jobs To Be Done

* Lifecycle management (CRUD) of Service Instances
* Lifecycle management (CRUD) of Service Instance Classes
* Lifecycle management (CRUD) of Resource Claim Policies
* Identify pending Resource Claims and, if deemed appropriate, help to fulfil such claims through a combination of the above Jobs To Be Done 
* Setup and configuration of Dynamic Provisioning
