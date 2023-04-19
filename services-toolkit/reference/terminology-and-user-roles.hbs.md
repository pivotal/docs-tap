# Services Toolkit Terminology and User roles

This topic provides descriptions of the terms and user roles used in the Services Toolkit documentation.

## <a id="terms"></a>Terminology

The following terms are used in the Services Toolkit documentation.

### <a id="service"></a>Service

Service is broad, high-level term that describes something used in either the development of,
or running of application workloads.
Often, but not exclusively, synonymous with the concept of a backing service as defined by
the Twelve Factor App:

_"... any service the app consumes over the network as part of its normal operation"_

For example:

- A PostgreSQL service (implemented as a Kubernetes Operator provided by Tanzu Data Services)
- A PostgreSQL service (implemented as a process running on an Application Developer’s laptop)
- Object storage (implemented as SaaS running on AWS)
- AppSSO

### <a id="service-resource"></a> Service resource

A service resource is a Kubernetes resource that provides partial functionality<!--฿ |function|, |features|, or |capability| is preferred. ฿--> related to a Service.

For example:

- A Kubernetes resource with API Kind `PostgreSQL`
- A Kubernetes resource with API Kind `FirewallRule`
- A Kubernetes resource with API Kind `RabbitmqUser`
- A Kubernetes resource with API Kind `ClientRegistration` providing access to an App SSO service
- A Kubernetes resource with API Kind `Secret` containing credentials and connectivity information
  for a Service (which may or may not be running on the cluster itself)

### <a id="provisioned-service"></a>Provisioned Service

A Provisioned Service is any Service Resource that defines a `.status.binding.name` which points
to a secret in the same namespace that contains credentials and connectivity information for the resource.

This term is defined in the Service Binding Specification for Kubernetes.
For the full definition, see
[Provisioned Service](https://github.com/servicebinding/spec#provisioned-service) in GitHub.

### <a id="service-binding"></a>Service Binding

A service binding is a mechanism in which service instance credentials<!--฿ |binding credentials| is preferred. ฿--> and other related connectivity
information are automatically communicated to application workloads.

For example:

- The Service Binding concept implemented through the `ServiceBinding` Service Resource provided by
  [servicebinding](https://github.com/vmware-tanzu/servicebinding) in GitHub.

### <a id="service-instance"></a>Service instance

A service instance is an abstraction over one or a group of interrelated service resources that
together provide the functions for a particular service.

One of the service resources that make up an instance must either adhere to provisioned service
or be a secret conforming to the service binding specification for Kubernetes.
This guarantees that you can claim and service and subsequently bind service instances to
application workloads.

You make service instances discoverable through service instance classes.

For example:

- The `RabbitmqCluster` service resource provided by the RabbitMQ Cluster Kubernetes operator.
  This service resource adheres to provisioned service. Therefore, you can consider any
  `RabbitmqCluster` resource on a Kubernetes cluster to be a service instance.

- A logical grouping of the following service resources form a single AWS RDS service instance:
  - An AWS RDS `DBInstance`
  - An AWS RDS `DBSubnetGroup`
  - A Carvel `SecretTemplate` configured to produce a secret conforming to the Service Binding Specification for Kubernetes
  - A `Role`, `RoleBinding`, and `ServiceAccount`

- A Kubernetes `Secret` conforming to the Service Binding Specification for Kubernetes containing
  credentials for a Service running external to the cluster.

### <a id="service-instance-class"></a>Service instance class

A service instance class is more commonly called a "class".
They provide a way to describe classes, that is, categories, of service instances.

A service instance class enable service instances belonging to the class to be discovered.
They come in one of two varieties - pool-based or provisioner-based:

- Claims for pool-based classes are fulfilled by selecting a service instance from a pool.
- Claims for provisioner-based classes are fulfilled by provisioning new service instances.

Different classes might map to different services or to different configurations of the same service.

For example:

- A `ClusterInstanceClass` named “rabbitmq-dev” pointing to all `RabbitmqCluster` service resources
  configured with `.spec.replicas=1` identified by label `class: rmq-dev`.

- A `ClusterInstanceClass` named “rabbitmq-prod” pointing to all `RabbitmqCluster` service resources
  configured with `.spec.replicas=3` identified by label `class: rmq-prod`.

- A `ClusterInstanceClass` named “aws-rds-postgresql” pointing to secrets that conform with the Binding
  Specification and identified by label `class: aws-rds`.

- A `ClusterInstanceClass` named “mysql-on-demand” which provisions MySQL service instances.

### <a id="claim"></a>Claim

A claim is a mechanism in which requests for service instances can be declared and fulfilled without
requiring detailed knowledge of the service instances themselves.

Claims come in one of two varieties - resource claim and class claim:

- Resource claims refer to a specific service instance.
- Class claims refer to a class from which a service instance is then either selected (pool-based) or provisioned (provisioner-based).

For example:

- A resource claim pointing to a `RabbitmqCluster` service instance named `rmq-1` in the namespace `service-instances`.

- A class claim pointing to a class named `on-demand-rabbitmq`.

### <a id="claim-service-instance"></a> Claimable Service Instance

A claimable service instance is any service instance that you are permitted claim using a
resource claim from a namespace, taking into consideration:

- Location (namespace) of the service instance in relation to the location of the resource claim.
- Any matching resource claim policies.
- Exclusivity of resource claims, that is, you can only claim an instance once.

For example:

- A `RabbitmqCluster` service resource located in the same namespace as a resource claim and that
  has not already been claimed by another resource claim is a claimable service instance.

- A `RabbitmqCluster` service resource located in a different namespace to a resource claim,
  for which a matching resource claim policy exists, and has not already been claimed by another resource
  claim is a claimable service instance.

- A `RabbitmqCluster` service resource located in the same namespace as a resource claim that has
  already been claimed is not a claimable service instance due to the exclusive nature of Resource Claims.

### <a id="dynamic-provisioning"></a> Dynamic Provisioning

Dynamic provisioning is a capability of Services Toolkit in which class claims that refer to
provisioner-based classes are fulfilled automatically through the provisioning of new Service instances.

### <a id="lifecycle"></a> Service Resource Life cycle API

A Service Resource Life cycle API is any Kubernetes API that you can use to manage the life cycle (CRUD)
of a Service Resource.

For example:

- `rabbitmqclusters.rabbitmq.com/v1beta1`

### <a id="service-cluster"></a> Service cluster

<!-- add back link [Service API Projection and Service Resource Replication](../api_projection_and_resource_replication/api_docs.md) -->

A service cluster is applicable within the context of Service API Projection and Service Resource
Replication.
It is a Kubernetes cluster that has Service Resource Lifecycle APIs installed and a corresponding controller
managing their life cycle.

### <a id="wrokload-cluster"></a> Workload cluster

<!-- add back link [Service API Projection and Service Resource Replication](../api_projection_and_resource_replication/api_docs.md) -->

A workload cluster is applicable within the context of Service API Projection and Service Resource
Replication.
It is a Kubernetes cluster that has developer-created applications running on it.

## <a id="roles"></a>User roles

Services Toolkit caters to the following user roles.

These user roles are not user personas. It is possible, and even expected, that one person can be
associated with many user roles at any given time.
The user roles align to Tanzu Application Platform's user roles.
Services Toolkit is primarily responsible for defining the service operator role.
For more information about the user roles, see
[Role descriptions](../../authn-authz/role-descriptions.hbs.md).

The user roles listed in this section consist of a short description and the tasks required.
For detailed information about the corresponding Role-Based Access Control (RBAC) associated with each role,
see [Detailed role permissions breakdown](../../authn-authz/permissions-breakdown.hbs.md).

### <a id="ad"></a>Application developer (AD)

The application developer role encompasses both app-editor and app-viewer roles as defined by
Tanzu Application Platform.
For more information about the app-editor and app-viewer roles, see
[Role descriptions](../../authn-authz/role-descriptions.hbs.md).

Application developers do the following:

- Bind and unbind application workloads to and from resource claims.
- Get, list, and watch ResourceClaims.
- get, list, and watch ClusterInstanceClasses associated with ResourceClaims.

### <a id="ao"></a>Application operator (AO)

Encompasses the app-operator role as defined by Tanzu Application Platform.
For more information about the app-operator role, see
[Role descriptions](../../authn-authz/role-descriptions.hbs.md).

Application operators do the following:

- Discover and learn about service instance classes available on a cluster.
- Discover claimable service instances associated with service instance classes.
- Life cycle management (CRUD) of resource claims.

### <a id="so"></a>Service operator (SO)

Service operators do the following:

- Life cycle management (CRUD) of service instances.
- Life cycle management (CRUD) of service instance classes.
- Life cycle management (CRUD) of resource claim policies.
- Identify pending resource claims and, if appropriate, help to fulfil such claims through a
  combination of the previous tasks.
- Setup and configure dynamic provisioning.
