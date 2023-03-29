# Set up services for consumption by developers

This how-to guide walks service operators and application operators through setting up services for consumption by application developers. In this example, you set up the RabbitMQ Cluster Kubernetes operator, but the process is the same for any other services you want to set up. You will learn about the `tanzu services` CLI plug-in and the most important APIs for working with services on Tanzu Application Platform.

## <a id="you-will"></a>What you will do

- Set up a service.
- Create a service instance.
- Claim a service instance.

This enables the application developer to bind an application workload to the service instance, as described in [Consume services on Tanzu Application Platform](consume-services.md).

Before you begin, for important background, see [Consume services on Tanzu Application Platform](about-consuming-services.md).

## <a id="overview"></a>Overview

The following diagram depicts a summary of what this walkthrough covers, including binding an application workload to the service instance by the application developer.

![Diagram showing the default namespace and service instances namespace. The default namespace has two application workloads, each connected to a service binding. The service bindings connect to the service instance in the service instances namespace through a claim.](../images/getting-started-stk-1.png)

Bear the following observations in mind as you work through this guide:

1. There is a clear separation of concerns across the various user roles.

    * Application developers set the life cycle of workloads.
    * Application operators set the life cycle of claims.
    * Service operators set the life cycle of service instances.
    * The life cycle of service bindings is implicitly tied to the life cycle of workloads.
2. Claims and resource claim policies are the mechanism to enable cross-namespace binding.
3. ProvisionedService is the contract allowing credentials and connectivity information to flow from the service instance to the class claim, to the resource claim, to the service binding, and ultimately to the application workload. For more information, see [ProvisionedService](https://github.com/servicebinding/spec#provisioned-service) on GitHub.
4. Exclusivity of claims: claims are considered to be mutually exclusive, meaning that claims for a service instance can only be fulfilled by at most one claim at a time.

## <a id="stk-prereqs"></a> Prerequisites

Before following this walkthrough, you must:

1. Have access to a cluster with Tanzu Application Platform installed.
1. Have downloaded and installed the Tanzu CLI and the corresponding plug-ins.
1. Ensure that your Tanzu Application Platform cluster can pull the container images required by the Kubernetes operator providing the service. For more information, see:
   * [VMware RabbitMQ for Kubernetes](https://docs.vmware.com/en/VMware-RabbitMQ-for-Kubernetes/index.html).
   * [VMware SQL with Postgres for Kubernetes](https://docs.vmware.com/en/VMware-SQL-with-Postgres-for-Kubernetes/index.html).
   * [VMware SQL with MySQL for Kubernetes](https://docs.vmware.com/en/VMware-SQL-with-MySQL-for-Kubernetes/index.html).

## <a id="stk-set-up"></a> Set up a service

This section covers the following:

* Installing the selected service Kubernetes operator.
* Creating the role-based access control (RBAC) rules to grant Tanzu Application Platform permission to interact with the APIs provided by the newly installed Kubernetes operator.
* Creating the additional supporting resources to aid with discovery of services.

For this part of the walkthrough, you assume the role of the **service operator**.

Although this walkthrough uses the example of RabbitMQ Cluster Kubernetes operator, the setup
steps remain largely the same for any compatible operator. Also, this walkthrough uses the
open source RabbitMQ Cluster operator for Kubernetes. For most real-world deployments, VMware
recommends using the official, supported version provided by VMware. For more information,
see [VMware RabbitMQ for Kubernetes](https://docs.vmware.com/en/VMware-RabbitMQ-for-Kubernetes/index.html).

To set up a service:

1. Use `kapp` to install the open source RabbitMQ Cluster Kubernetes operator by running:

    ```console
    kapp -y deploy --app rmq-operator --file https://github.com/rabbitmq/cluster-operator/releases/latest/download/cluster-operator.yml
    ```

    As a result, a new API Group (`rabbitmq.com`) and Kind (`RabbitmqCluster`) are
    now available in the cluster.

    PostgreSQL: [Installing a Tanzu Postgres Operator](https://docs.vmware.com/en/VMware-Tanzu-SQL-with-Postgres-for-Kubernetes/1.8/tanzu-postgres-k8s/GUID-install-operator.html)

    MySQL: [Installing the Tanzu SQL for Kubernetes Operator](https://docs.vmware.com/en/VMware-Tanzu-SQL-with-MySQL-for-Kubernetes/1.5/tanzu-mysql-k8s/GUID-install-operator.html)

2. Apply RBAC rules to grant Tanzu Application Platform permission to interact with the new API.

    1. In a file named `rmq-reader-for-binding-and-claims.yaml`, create a `ClusterRole` that defines the rules and label it so that the rules are aggregated to the appropriate controller:

        ```yaml
        # rmq-reader-for-binding-and-claims.yaml
        ---
        apiVersion: rbac.authorization.k8s.io/v1
        kind: ClusterRole
        metadata:
          name: rmq-reader-for-binding-and-claims
          labels:
            servicebinding.io/controller: "true"
        rules:
        - apiGroups: ["rabbitmq.com"]
          resources: ["rabbitmqclusters"]
          verbs: ["get", "list", "watch"]
        ```

    2. Apply `rmq-reader-for-binding-and-claims.yaml` by running:

        ```console
        kubectl apply -f rmq-reader-for-binding-and-claims.yaml
        ```

        PostgreSQL: [Creating Service Bindings](https://docs.vmware.com/en/VMware-Tanzu-SQL-with-Postgres-for-Kubernetes/1.8/tanzu-postgres-k8s/GUID-creating-service-bindings.html#setup-postgres-with-services-toolkit)

        MySQL: [Connecting an Application to a MySQL Instance](https://docs.vmware.com/en/VMware-Tanzu-SQL-with-MySQL-for-Kubernetes/1.5/tanzu-mysql-k8s/GUID-creating-service-bindings.html#setup-mysql-with-services-toolkit)

3. Make the new API discoverable to application operators.

    1. In a file named `rmq-class.yaml`, create a `ClusterInstanceClass`
    that refers to the new service, and set any additional metadata. For example:

        ```yaml
        # rmq-class.yaml
        ---
        apiVersion: services.apps.tanzu.vmware.com/v1alpha1
        kind: ClusterInstanceClass
        metadata:
          name: rabbitmq
        spec:
          description:
            short: It's a RabbitMQ cluster!
          pool:
            group: rabbitmq.com
            kind: RabbitmqCluster
        # for Postgres
        #   group: sql.tanzu.vmware.com
        #   kind: Postgres
        # for MySql
        #   group: with.sql.tanzu.vmware.com
        #   kind: MySQL
        ```

    2. Apply `rmq-class.yaml` by running:

        ```console
        kubectl apply -f rmq-class.yaml
        ```

        After applying this resource, it is listed in the output of the
        `tanzu service classes list` command, and is discoverable in the `tanzu` tooling.

## <a id="create-svc-instances"></a> Create a service instance

This section covers:

* Using kubectl to create a `RabbitmqCluster` service instance.
* Creating a resource claim policy that permits the service instance to be claimed.

For this part of the walkthrough, you assume the role of the **service operator**.

To create a service instance:

1. Create a dedicated namespace for service instances by running:

    ```console
    kubectl create namespace service-instances
    ```

    > **Note** Using namespaces to separate service instances from application workloads allows
    > for greater separation of concerns, and means that you can achieve greater control
    > over who has access to what. However, this is not a strict requirement.
    > You can create both service instances and application workloads in the same namespace.
    > There is no need to create a resource claim policy if the service instance resides in the
    > same namespace as the application workload.

2. Create a `RabbitmqCluster` service instance.

    1. Create a file named `rmq-1-service-instance.yaml`:

        ```yaml
        # rmq-1-service-instance.yaml
        ---
        apiVersion: rabbitmq.com/v1beta1
        kind: RabbitmqCluster
        metadata:
          name: rmq-1
          namespace: service-instances
        ```

        >**Note** If using Openshift, you might have to provide additional configuration for the `RabbitmqCluster`. For more details, see Using the RabbitMQ Kubernetes Operators on Openshift in the [RabbitMQ documentation](https://www.rabbitmq.com/kubernetes/operator/using-on-openshift.html).

    2. Apply `rmq-1-service-instance.yaml` by running:

        ```console
        kubectl apply -f rmq-1-service-instance.yaml
        ```

        PostgreSQL: [Deploying a Postgres Instance](https://docs.vmware.com/en/VMware-Tanzu-SQL-with-Postgres-for-Kubernetes/1.8/tanzu-postgres-k8s/GUID-create-delete-postgres.html#deploying-a-postgres-instance)

        MySQL: [Creating a MySQL Instance](https://docs.vmware.com/en/VMware-Tanzu-SQL-with-MySQL-for-Kubernetes/1.5/tanzu-mysql-k8s/GUID-create-delete-mysql.html#create-a-mysql-instance)

3. Create a resource claim policy to define the namespaces the instance can be claimed and bound from.

    By default, you can only claim and bind to service instances that
    are running in the _same_ namespace as the application workloads.
    To claim service instances running in a different namespace, you must
    create a resource claim policy.

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
        # for Postgres
        #   group: sql.tanzu.vmware.com
        #   kind: Postgres
        # for MySql
        #   group: with.sql.tanzu.vmware.com
        #   kind: MySQL
        ```

    2. Apply `rmq-claim-policy.yaml` by running:

        ```console
        kubectl apply -f rmq-claim-policy.yaml
        ```

    This policy states that any resource of kind `RabbitmqCluster` on the `rabbitmq.com`
    API group in the `service-instances` namespace can be consumed from any namespace.

## <a id="stk-claim"></a> Claim a service instance

This section covers:

* Using `tanzu service class list` to view details about available classes from which instances can be claimed.
* Using `tanzu service class-claim create` to create a claim for the service instance.

For this part of the walkthrough, you assume the role of the **application operator**.

Claims in Tanzu Application Platform are a powerful concept that serve many purposes.
Arguably their most important role is to enable application operators to request
services to use with their application workloads without having
to create and manage the services themselves. For more information, see [Resource Claims](https://docs.vmware.com/en/Services-Toolkit-for-VMware-Tanzu-Application-Platform/0.9/svc-tlk/resource_claims-api_docs.html).

In cases where service instances are running in the same namespace as
application workloads, you do not have to create a claim. You can bind to the service instance directly.

In this section you use the `tanzu service class-claim create` command to create
a claim that the `RabbitmqCluster` service instance you created earlier can fulfill.
This command requires the following information to create a claim:

- `--class`

To claim a service instance:

1. Find the claimable instance and the necessary claim information by running:

    ```console
    tanzu service class list
    ```

    Expected output:

    ```console
      tanzu service class list

      NAME      DESCRIPTION
      rabbitmq  It's a RabbitMQ cluster!
    ```

2. Using the information from the previous command, create a claim for the service instance by running:

    ```console
    tanzu service class-claim create rmq-1 \
      --class rabbitmq
    ```

You have set the scene for the application developer to inspect the claim and to use it to bind to application workloads, as described in [Consume services on Tanzu Application Platform](consume-services.md).

## <a id="stk-use-cases"></a> Further use cases and reading

There are more service use cases not covered in this Getting started guide. See the following:

<table class="nice">
  <th><strong>Use Case</strong></th>
  <th><strong>Short Description</strong></th>
  <tr>
    <td>
      <a href="https://docs.vmware.com/en/Services-Toolkit-for-VMware-Tanzu-Application-Platform/0.9/svc-tlk/usecases-introducing_different_service_implementations_in_different_environments.html">Introducing Different Service Implementatations in Different Environments</a>
    </td>
    <td>
      Using classes to have a claim resolve to a different backing service resource depending on which environment it is in.<br>
      This removes the need for application operators to change `ClassClaim`s and `Workload`s as they are promoted through environments.
    </td>
  </tr><tr>
    <td>
      <a href="https://docs.vmware.com/en/Services-Toolkit-for-VMware-Tanzu-Application-Platform/0.9/svc-tlk/usecases-consuming_aws_rds_with_ack.html">Consuming AWS RDS on Tanzu Application Platform</a>
    </td>
    <td>
      Using the Controllers for Kubernetes (ACK) to provision an RDS instance and consume it from a Tanzu Application Platform workload.<br>
      Involves making a third-party API consumable from Tanzu Application Platform.
    </td>
  </tr><tr>
    <td>
      <a href="https://docs.vmware.com/en/Services-Toolkit-for-VMware-Tanzu-Application-Platform/0.9/svc-tlk/usecases-consuming_aws_rds_with_crossplane.html">Consuming AWS RDS on Tanzu Application Platform with Crossplane</a>
    </td>
    <td>
      Using <a href="https://crossplane.io/">Crossplane</a> to provision an RDS instance and consume it from a Tanzu Application Platform workload.<br>
      Involves making a third-party API consumable from Tanzu Application Platform.
    </td>
  </tr><tr>
    <td>
      <a href="https://docs.vmware.com/en/Services-Toolkit-for-VMware-Tanzu-Application-Platform/0.9/svc-tlk/usecases-consuming_gcp_sql_with_config_connector.html">Consuming Google Cloud SQL on Tanzu Application Platform with Config Connector</a>
    </td>
    <td>
      Using GCP Config Connector to provision a Cloud SQL instance and consume it from a Tanzu Application Platform workload.<br>
      Involves making a third-party API consumable from Tanzu Application Platform.
    </td>
  </tr><tr>
    <td>
      <a href="https://docs.vmware.com/en/Services-Toolkit-for-VMware-Tanzu-Application-Platform/0.9/svc-tlk/usecases-consuming_gcp_sql_with_crossplane.html">Consuming Google Cloud SQL on Tanzu Application Platform with Crossplane</a>
    </td>
    <td>
      Using <a href="https://crossplane.io/">Crossplane</a> to provision a Cloud SQL instance and consume it from a Tanzu Application Platform workload.<br>
      Involves making a third-party API consumable from Tanzu Application Platform.
    </td>
  </tr><tr>
    <td>
      <a href="https://docs.vmware.com/en/Services-Toolkit-for-VMware-Tanzu-Application-Platform/0.9/svc-tlk/usecases-direct_secret_references.html">Direct Secret References</a>
    </td>
    <td>
      Binding to services running external to the cluster, for example, an in-house oracle database.<br>
      Binding to services that do not conform with the binding specification.
    </td>
  </tr>
  <tr>
    <td>
      <a href="https://docs.vmware.com/en/Services-Toolkit-for-VMware-Tanzu-Application-Platform/0.9/svc-tlk/usecases-dedicated_service_clusters.html">Dedicated Service Clusters</a> (Experimental)
    </td>
    <td>Separates application workloads from service instances across dedicated clusters.</td>
  </tr>
</table>

For more information about the APIs and concepts underpinning Services on Tanzu Application Platform, see the
[Services Toolkit Component documentation](https://docs.vmware.com/en/Services-Toolkit-for-VMware-Tanzu-Application-Platform/0.9/svc-tlk/overview.html)

## Next steps

Now that you completed the Getting started guides, learn about:

- [Multicluster Tanzu Application Platform](../multicluster/about.md)
