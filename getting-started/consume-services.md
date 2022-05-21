# Consuming services on Tanzu Application Platform

In this guide, you will learn about working with backing services such as
RabbitMQ, PostgreSQL and MySQL as part of Tanzu Application Platform.

Particular focus is given to binding application workloads to service instances,
which is the most common use case for services.

## <a id="stk-concepts"></a> Key concepts

When working with services on Tanzu Application Platform you must be familiar
with service instances, service bindings and resource claims.
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

## <a id="stk-walkthrough"></a> Walkthrough

This section guides you through deploying two application workloads and learning
how to configure them to communicate over RabbitMQ.
You will learn about the `tanzu services` CLI plug-in and the most
important APIs for working with services on Tanzu Application Platform.
The following diagram depicts a summary of what this section covers.

![Diagram shows the default namespace and service instances namespace. The default namespace has two application workloads, each connected to a service binding. The service bindings connect to the service instance in the service instances namespace through a resource claim.](../images/getting-started-stk-1.png)

Bear the following observations in mind as you work through this section.

1. There is a clear separation of concerns across the various user roles:
    * The life cycle of workloads is determined by application developers.
    * The life cycle of resource claims is determined by application operators.
    * The life cycle of service instances is determined by service operators.
    * The life cycle of service bindings is implicitly tied to lifecycle of workloads.
1. Resource claims and resource claim policies are the mechanism to enable cross-namespace binding.
1. [ProvisionedService](https://github.com/servicebinding/spec#provisioned-service) is the contract allowing credentials and connectivity information to flow from the service instance, to the resource claim, to the service binding, and ultimately to the application workload.
1. Exclusivity of resource claims:
    * Resource claims are considered to be mutually exclusive, meaning that service instances can be claimed by at most one resource claim.

### <a id="stk-prereqs>"></a> Prerequisites

Before following this walkthrough, you must:

1. Have access to a cluster with Tanzu Application Platform installed.
1. Have downloaded and installed the `tanzu` CLI and the corresponding plug-ins.
1. Have setup the `default` namespace to use installed packages and use it as your developer namespace.
For more information, see [Set up developer namespaces to use installed packages](https://docs.vmware.com/en/Tanzu-Application-Platform/1.1/tap/GUID-install-components.html#setup)).
1. Ensure your Tanzu Application Platform cluster can pull source code from GitHub.
1. Ensure your Tanzu Application Platform cluster can pull the images required by the [RabbitMQ Cluster Kubernetes Operator](https://www.rabbitmq.com/kubernetes/operator/using-operator.html).

### <a id="stk-set-up"></a> Set up a service

This section covers the following:

* Installing the [RabbitMQ Cluster Kubernetes Operator](https://www.rabbitmq.com/kubernetes/operator/using-operator.html)
* Creating the RBAC rules to grant Tanzu Application Platform permission to interact
with the newly-installed APIs provided by the RabbitMQ Cluster Kubernetes Operator.
* Creating the additional supporting resources to aid with discovery of services

For this part of the walkthrough, you assume the role of the **service operator**.

> **Note:** Although this walkthrough uses the RabbitMQ Cluster Kubernetes Operator
> as an example, the set up steps remain mostly the same for any compatible Operator.

To set up a service:

1. Use `kapp` to install the RabbitMQ Cluster Kubernetes Operator by running:

    ```console
    kapp -y deploy --app rmq-operator --file https://github.com/rabbitmq/cluster-operator/releases/download/v1.9.0/cluster-operator.yml
    ```
    As a result, a new API Group (`rabbitmq.com`) and Kind (`RabbitmqCluster`) are
    now available in the cluster.

1. Apply RBAC rules to grant Tanzu Application Platform permission to interact with the new API.

    1. In a file named `resource-claims-rmq.yaml`, create a `ClusterRole` that defines the rules and label it
    so that the rules are aggregated to the appropriate controller:

        ```yaml
        # resource-claims-rmq.yaml
        ---
        apiVersion: rbac.authorization.k8s.io/v1
        kind: ClusterRole
        metadata:
          name: resource-claims-rmq
          labels:
            resourceclaims.services.apps.tanzu.vmware.com/controller: "true"
        rules:
        - apiGroups: ["rabbitmq.com"]
          resources: ["rabbitmqclusters"]
          verbs: ["get", "list", "watch", "update"]
        ```

    1. Apply `resource-claims-rmq.yaml` by running:

        ```console
        kubectl apply -f resource-claims-rmq.yaml
        ```

    1. In a file named `rabbitmqcluster-app-operator-reader.yaml`, define RBAC
    rules that permit the users of the cluster to interact with the new APIs.
    For example, to permit application operators to get, list, and watch for `RabbitmqCluster` service instances,
    apply the following RBAC `ClusterRole`, labeled so that the rules are aggregated to the `app-operator` role:

        ```yaml
        # rabbitmqcluster-app-operator-reader.yaml
        ---
        apiVersion: rbac.authorization.k8s.io/v1
        kind: ClusterRole
        metadata:
          name: rabbitmqcluster-app-operator-reader
          labels:
            apps.tanzu.vmware.com/aggregate-to-app-operator-cluster-access: "true"
        rules:
        - apiGroups: ["rabbitmq.com"]
          resources: ["rabbitmqclusters"]
          verbs: ["get", "list", "watch"]
        ```

    1. Apply `rabbitmqcluster-app-operator-reader.yaml` by running:

        ```console
        kubectl apply -f rabbitmqcluster-app-operator-reader.yaml
        ```

1. Make the new API discoverable.

    1. In a file named `rabbitmqcluster-clusterresource.yaml`, create a `ClusterResource`
    that refers to the new service, and set any additional metadata. For example:

        ```yaml
        # rabbitmqcluster-clusterresource.yaml
        apiVersion: services.apps.tanzu.vmware.com/v1alpha1
        kind: ClusterResource
        metadata:
          name: rabbitmq
        spec:
          shortDescription: It's a RabbitMQ cluster!
          longDescription: A consistent and easy way to deploy RabbitMQ clusters to Kubernetes and run them, including "day two" (continuous) operations.
          resourceRef:
            group: rabbitmq.com
            kind: RabbitmqCluster
        ```

    1. Apply `rabbitmqcluster-clusterresource.yaml` by running:

        ```console
        kubectl apply -f rabbitmqcluster-clusterresource.yaml
        ```
        After applying this resource, it will be listed in the output of the
        `tanzu service types list` command, and is discoverable in the `tanzu` tooling.

### <a id="stk-create-svc-instances"></a> Create a service instance

This section covers the following:

* Using kubectl to create a `RabbitmqCluster` service instance.
* Creating a resource claim policy that permits the service instance to be claimed.

For this part of the walkthrough, you assume the role of the **service operator**.

To create a service instance:

1. Create a dedicated namespace for service instances by running:

    ```console
    kubectl create namespace service-instances
    ```

    > **Note:** Using namespaces to separate service instances from application workloads allows
    > for greater separation of concerns, and means that you can achieve greater control
    > over who has access to what. However, this is not a strict requirement.
    > You can create both service instances and application workloads in the same namespace if desired.

2.  Find the list of services that are available on your cluster by running:

    ```console
    tanzu service types list
    ```

    Expected output:

    ```console
    Warning: This is an ALPHA command and may change without notice.

     NAME      DESCRIPTION               APIVERSION                    KIND
     rabbitmq  It's a RabbitMQ cluster!  rabbitmq.com/v1beta1          RabbitmqCluster
    ```

    > **Note**: If you see `No service types found.`, ensure you have completed the
    > steps in [Set up a service](#stk-set-up) earlier in this walkthrough.

1. Create a `RabbitmqCluster` service instance.

    1. Create a file named `rmq-1-service-instance.yaml` using the `APIVERSION` and
    `KIND` from the output of the `tanzu service types list` command:

        ```yaml
        # rmq-1-service-instance.yaml
        ---
        apiVersion: rabbitmq.com/v1beta1
        kind: RabbitmqCluster
        metadata:
          name: rmq-1
          namespace: service-instances
        ```

    1. Apply `rmq-1-service-instance.yaml` by running:

        ```console
        kubectl apply -f rmq-1-service-instance.yaml
        ```

3. Create a resource claim policy to define the namespaces the instance can be claimed and bound from:

    > **Note:** By default, you can only claim and bind to service instances that
    > are running in the _same_ namespace as the application workloads.
    > To claim service instances that are running in a different namespace, you must
    > create a resource claim policy.

    1. Create a file named `rmq-claim-policy.yaml` as follows:

        ```yaml
        # rmq-claim-policy.yaml
        ---
        apiVersion: services.apps.tanzu.vmware.com/v1alpha1
        kind: ResourceClaimPolicy
        metadata:
          name: rabbitmqcluster-cross-namespace
          namespace: service-instances
        spec:
          consumingNamespaces:
          - '*'
          subject:
            group: rabbitmq.com
            kind: RabbitmqCluster
        ```

    1. Apply `rmq-claim-policy.yaml` by running:

        ```console
        kubectl apply -f rmq-claim-policy.yaml
        ```

    This policy states that any resource of kind `RabbitmqCluster` on the `rabbitmq.com`
    API group in the `service-instances` namespace can be consumed from any namespace.

### <a id="stk-claim"></a> Claim a service instance

This section covers the following:

* Using `tanzu service instance list` to view details about service instances.
* Using `tanzu service claim create` to create a claim for the service instance.

For this part of the walkthrough you assume the role of the **application operator**.

Resource claims in Tanzu Application Platform are a powerful concept that serve many purposes.
Arguably their most important role is to enable application operators to request
services that they can use with their application workloads without them having
to create and manage the services themselves.
Resource claims provide a mechanism for application operators to say what
they want, without having to worry about anything that goes into providing what they want.
For more information, see [Resource Claims](https://docs.vmware.com/en/Services-Toolkit-for-VMware-Tanzu-Application-Platform/0.6/svc-tlk/GUID-service_resource_claims-terminology_and_apis.html).

In cases where service instances are running in the same namespace as
application workloads, you do not have to create a claim. You can bind to the service instance directly.

In this section you will use the `tanzu service claims create` command to create
claim that the `RabbitmqCluster` service instance you created earlier can fulfill.
This command requires the following information to create a claim successfully:

- `--resource-name`
- `--resource-kind`
- `--resource-api-version`
- `--resource-namespace`

To claim a service instance:

1. Find the information needed to make a resource claim by running:

    ```console
    tanzu service instance list -A
    ```

    Expected output:

    ```console
      Warning: This is an ALPHA command and may change without notice.

      NAMESPACE          NAME   KIND             SERVICE TYPE  AGE
      service-instances  rmq-1  RabbitmqCluster  rabbitmq      24h
    ```

1. Using the information from the previous command, create a claim for the service instance by running:

    ```console
    tanzu service claim create rmq-1 \
      --resource-name rmq-1 \
      --resource-namespace service-instances \
      --resource-kind RabbitmqCluster \
      --resource-api-version rabbitmq.com/v1beta1
    ```

In the next section you will see how to inspect the claim and to then use it to bind to application workloads.

### <a id="stk-bind"></a> Bind an application workload to the service instance

This section covers the following:

* Using `tanzu service claim list` and `tanzu service claim get` to find information about the claim to use for binding
* Using `tanzu apps workload create` with the `--service-ref` flag to create a Workload and bind it to the Service Instance

For this part of the walkthrough you assume the role of the **application developer**.

As a final step, you must create application workloads and to bind them to the service instance using the claim.

In Tanzu Application Platform Service bindings are created when application workloads
that specify `.spec.serviceClaims` are created.
In this section, you will see how to create such workloads using the `--service-ref`
flag of the `tanzu apps workload create` command.

To create an application workload:

1. Inspect the claims in the developer namespace to find the value to pass to
`--service-ref` command by running:

    ```console
    tanzu services claims list
    ```

    Expected output:

    ```console
      Warning: This is an ALPHA command and may change without notice.

      NAME   READY  REASON
      rmq-1  True
    ```

1. Retrieve detailed information about the claim by running:

    ```console
    tanzu services claims get rmq-1
    ```

    Expected output:

    ```console
      Warning: This is an ALPHA command and may change without notice.

    Name: rmq-1
    Status:
      Ready: True
    Namespace: default
    Claim Reference: services.apps.tanzu.vmware.com/v1alpha1:ResourceClaim:rmq-1
    Resource to Claim:
      Name: rmq-1
      Namespace: service-instances
      Group: rabbitmq.com
      Version: v1beta1
      Kind: RabbitmqCluster
    ```

1. Record the value of `Claim Reference` from the previous command.
This is the value to pass to `--service-ref` to create the application workload.

1. Create the application workload by running:

    ```console
    tanzu apps workload create spring-sensors-consumer-web \
      --git-repo https://github.com/sample-accelerators/spring-sensors-rabbit \
      --git-branch main \
      --type web \
      --service-ref="rmq=services.apps.tanzu.vmware.com/v1alpha1:ResourceClaim:rmq-1"

    tanzu apps workload create \
      spring-sensors-producer \
      --git-repo https://github.com/tanzu-end-to-end/spring-sensors-sensor \
      --git-branch main \
      --type web \
      --service-ref="rmq=services.apps.tanzu.vmware.com/v1alpha1:ResourceClaim:rmq-1" \
      --annotation=autoscaling.knative.dev/minScale="1"
    ```

    Using the `--service-ref` flag instructs Tanzu Application Platform to bind the application workload to the service provided in the `ref`.

    > **Note:** You are not passing a service ref to the `RabbitmqCluster` service instance directly,
    > but rather to the resource claim that has claimed the `RabbitmqCluster` service instance.
    > See the [consuming services diagram](#stk-walkthrough) at the beginning of this walkthrough.

1. After the workloads are ready, visit the URL of the `spring-sensors-consumer-web` app.
Confirm that sensor data, passing from the `spring-sensors-producer` workload to
the `create spring-sensors-consumer-web` workload using our `RabbitmqCluster` service instance, is displayed.

## <a id="stk-advanced-use-cases"></a> Advanced use cases and further reading

There are a couple more advanced service use cases that not covered in the
procedures in this topic, such as Direct Secret References and Dedicated Service Clusters.

<table class="nice">
  <th><strong>Advanced Use Case</strong></th>
  <th><strong>Short Description</strong></th>
  <tr>
    <td>
      <a href="https://docs.vmware.com/en/Services-Toolkit-for-VMware-Tanzu-Application-Platform/0.6/svc-tlk/GUID-reference-use_cases.html#direct-secret-references">Direct Secret References</a>
    </td>
    <td>
      Binding to services running external to the cluster, for example, and in-house oracle database.<br>
      Binding to services that are not conformant with the binding specification.
    </td>
  </tr>
  <tr>
    <td>
      <a href="https://docs.vmware.com/en/Services-Toolkit-for-VMware-Tanzu-Application-Platform/0.6/svc-tlk/GUID-reference-use_cases.html#dedicated-service-clusters-using-experimental-projection-and-replication-apis">Dedicated Service Clusters</a>
    </td>
    <td>Separates application workloads from service instances across dedicated clusters.</td>
  </tr>
</table>

For more information about the APIs and concepts underpinning Services on Tanzu Application Platform, see the
[Services Toolkit Component documentation](https://docs.vmware.com/en/Services-Toolkit-for-VMware-Tanzu-Application-Platform/0.6/svc-tlk/GUID-overview.html)

## Next step

Now that you've completed the Getting started guides, you might want to learn about:

- [Multicluster Tanzu Application Platform](../multicluster/about.md)
