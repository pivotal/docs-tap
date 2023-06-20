# About consuming services on Tanzu Application Platform

This topic describes the key concepts and terms you need to know about consuming services on
Tanzu Application Platform (commonly known as TAP).

As part of Tanzu Application Platform, you can work with backing services such
as RabbitMQ, PostgreSQL, and MySQL among others.
The most common use of services is binding an application workload to a service instance.

## <a id="stk-concepts"></a> Key concepts

When working with services on Tanzu Application Platform, you must be familiar
with service instances, service bindings, and resource claims. This section
provides a brief overview of each of these key concepts.

### <a id="service-instances"></a>Service instances

A **service instance** is a logical grouping of one or more Kubernetes resources
that together expose a known capability through a well-defined interface. For
example, a theoretical "MySQL" service instance might consist of a
`MySQLDatabase` and a `MySQLUser` resource. When considering compatibility of
service instances for Tanzu Application Platform, one of the resources of a
service instance must adhere to the [Service Binding for
Kubernetes](https://servicebinding.io/) specification.

### <a id="service-bindings"></a>Service bindings

**Service binding** refers to a mechanism in which connectivity information,
such as service instance credentials, and connectivity information, such as host and port,
are automatically communicated to application workloads. Tanzu
Application Platform uses a standard named [Service Binding for
Kubernetes](https://servicebinding.io/) to implement this mechanism. See this
standard to fully understand the services aspect of Tanzu Application Platform.

### <a id="resource-claims"></a>Resource claims

**Resource claims** are inspired in part by Persistent Volume Claims. For more
information, see the [Kubernetes
documentation](https://kubernetes.io/docs/concepts/storage/persistent-volumes/).
Resource claims provide a mechanism for users to claim service instances on a
cluster, while also decoupling the life cycle of application workloads and
service instances.

## <a id="stk-available-services"></a> Services you can use with Tanzu Application Platform

The following list of Kubernetes operators expose APIs that integrate well with
Tanzu Application Platform:

1. [RabbitMQ Cluster Operator for Kubernetes](https://docs.vmware.com/en/VMware-RabbitMQ-for-Kubernetes/index.html).
2. [VMware SQL with Postgres for Kubernetes](https://docs.vmware.com/en/VMware-SQL-with-Postgres-for-Kubernetes/index.html).
3. [VMware SQL with MySQL for Kubernetes](https://docs.vmware.com/en/VMware-SQL-with-MySQL-for-Kubernetes/index.html).

Compatibility of a service with Tanzu Application Platform ranges on a scale
between fully compatible and incompatible. The minimum requirement for
compatibility is that there must be a declarative, Kubernetes-based API on which
at least one API resource type adheres to the [Provisioned
Service](https://github.com/servicebinding/spec#provisioned-service) duck type
defined by the [Service Binding Specification for
Kubernetes](https://github.com/servicebinding/spec) in GitHub. This duck type
includes any resource type with the following schema:

```yaml
status:
  binding:
    name: # string
```

The value of `.status.binding.name` must point to a `Secret` in the same
namespace. The `Secret` contains required credentials and connectivity
information for the resource.

Typically, APIs that include these resource types are installed onto the Tanzu
Application Platform cluster as Kubernetes operators. These Kubernetes operators
provide custom resource definitions (CRDs) and corresponding controllers to
reconcile the resources of the CRDs, as is the case with the three Kubernetes
operators listed earlier.

For services that do not provide a resource adhering to the Service Binding
Specification for Kubernetes, it may still be possible to provide configurations
allowing such services to integrate with Tanzu Application Platform. See the
following for examples of how to do this for Amazon AWS RDS.

* [Consuming AWS RDS on Tanzu Application Platform (TAP) with AWS Controllers
  for Kubernetes
  (ACK)](https://docs.vmware.com/en/Services-Toolkit-for-VMware-Tanzu-Application-Platform/0.9/svc-tlk/usecases-consuming_aws_rds_with_ack.html)
* [Consuming AWS RDS on Tanzu Application Platform (TAP) with
  Crossplane](https://docs.vmware.com/en/Services-Toolkit-for-VMware-Tanzu-Application-Platform/0.9/svc-tlk/usecases-consuming_aws_rds_with_crossplane.html)

## <a id="stk-user-roles"></a> User roles and responsibilities

It is important to understand the user roles for services on Tanzu Application
Platform and the responsibilities assumed by each. The following table describes
each user role.

<table class="nice">
  <th><strong>User role</strong></th>
  <th><strong>Exists as a default role in Tanzu Application Platform?</strong></th>
  <th><strong>Responsibilities</strong></th>
  <tr>
    <td>Service operator</td>
    <td>Yes - <a href="../authn-authz/role-descriptions.md#service-operator">service-operator</a></td>
    <td>
      <ul>
        <li>Life cycle management (CRUD) of service instances</li>
        <li>Life cycle management (CRUD) of service instance classes</li>
        <li>Life cycle management (CRUD) of resource claim policies</li>
        <li>View and query for resource claims across namespaces</li>
      </ul>
    </td>
  </tr>
  <tr>
    <td>Application operator</td>
    <td>
      Yes - <a href="../authn-authz/role-descriptions.md#app-operator">app-operator</a>
    </td>
    <td>Life cycle management (CRUD) of resource claims</td>
  </tr>
  <tr>
    <td>Application developer</td>
    <td>
      Yes - <a href="../authn-authz/role-descriptions.md#app-editor">app-editor</a>
      and <a href="../authn-authz/role-descriptions.md#app-viewer">app-viewer</a>
    </td>
    <td>Binding service instances to application workloads</td>
  </tr>
</table>

## Next steps

Apply what you've learned:

- [Claim services on Tanzu Application Platform](claim-services.md)
- [Consume services on Tanzu Application Platform](consume-services.md)
