# About consuming services on Tanzu Application Platform

As part of Tanzu Application Platform, you can work with backing services such as
RabbitMQ, PostgreSQL, and MySQL. Particularly, binding application workloads to service instances
is the most common use case for services.

## <a id="stk-concepts"></a> Key concepts

When working with services on Tanzu Application Platform you must be familiar
with service instances, service bindings, and resource claims.
This section provides a brief overview of each of these key concepts.

### Service instances

A **service instance** is any Kubernetes resource which exposes its capability
through a well-defined interface.
For example, you could consider Kubernetes resources that have `MySQL` as the API Kind
to be MySQL service instances. These resources expose their capability over the MySQL protocol.
Other examples include resources that have `PostgreSQL` or `RabbitmqCluster` as the API Kind.

### Service bindings

**Service binding** refers to a mechanism in which connectivity information such
as service instance credentials are automatically communicated to application workloads.
Tanzu Application Platform uses a standard named [Service Binding for Kubernetes](https://servicebinding.io/)
to implement this mechanism. To fully understand the services aspect of Tanzu Application Platform,
you must learn about this standard.

### Resource claims

**Resource claims** are inspired in part by [Persistent Volume Claims](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) in Kubernetes.
Resource Claims provide a mechanism for users to "claim" service instance resources
on a cluster, while also decoupling the life cycle of application workloads and service instances.

## <a id="stk-available-services"></a> Services you can use with Tanzu Application Platform

The following list of Kubernetes Operators expose APIs that integrate well with Tanzu Application Platform:

1. [RabbitMQ Cluster Operator for Kubernetes](https://www.rabbitmq.com/kubernetes/operator/operator-overview.html)
1. [VMware Tanzu SQL with Postgres for Kubernetes](https://docs.vmware.com/en/VMware-Tanzu-SQL-with-Postgres-for-Kubernetes/index.html)
1. [VMware Tanzu SQL with MySQL for Kubernetes](https://docs.vmware.com/en/VMware-Tanzu-SQL-with-MySQL-for-Kubernetes/index.html)

Whether a service is compatible with Tanzu Application Platform is on a scale
between fully compatible and incompatible.

The minimum requirement for compatibility is that there must be a declarative,
Kubernetes-based API on which there is at least one API resource type adhering to the
[Provisioned Service](https://github.com/servicebinding/spec#provisioned-service)
duck type defined by the [Service Binding for Kubernetes](https://servicebinding.io/) standard.
This duck type includes any resource type with the following schema:

```yaml
status:
  binding:
    name: # string
```

The value of `.status.binding.name` must point to a `Secret` in the same namespace.
The `Secret` contains required credentials and connectivity information for the resource.

Typically, APIs that include these resource types are installed onto the Tanzu Application Platform
cluster as Kubernetes Operators.
These Kubernetes Operators provide CRDs and corresponding controllers to reconcile
the resources of the CRDs, as is the case with the three Kubernetes Operators listed above.

## <a id="stk-user-roles"></a> User roles and responsibilities

It is important to understand the user roles for services on Tanzu Application Platform
along with the responsibilities assumed of each. The following table describes
each user role.

<table class="nice">
  <th><strong>User role</strong></th>
  <th><strong>Exists as a default role in Tanzu Application Platform?</strong></th>
  <th><strong>Responsibilities</strong></th>
  <tr>
    <td>Service operator</td>
    <td>No (might be introduced in a future release)</td>
    <td>
      <ul>
        <li>Namespace and cluster topology design</li>
        <li>Life cycle management (CRUD) of Kubernetes Operators</li>
        <li>Life cycle management (CRUD) of Service Instances</li>
        <li>Life cycle management (CRUD) of Resource Claim Policies</li>
      </ul>
    </td>
  </tr>
  <tr>
    <td>Application operator</td>
    <td>
      Yes - <a href="../authn-authz/role-descriptions.md#app-operator">app-operator</a>
    </td>
    <td>Life cycle management (CRUD) of Resource Claims</td>
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

## Next step

Apply what you've learned:

- How to [Consume services on Tanzu Application Platform](consume-services.md)
