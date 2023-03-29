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

![Diagram shows the default namespace and service instances namespace. The default namespace has two application workloads, each connected to a service binding. The service bindings connect to the service instance in the service instances namespace through a resource claim.](../images/getting-started-stk-1.png)

Bear the following observations in mind as you work through this guide:

1. There is a clear separation of concerns across the various user roles.

    * Application developers set the life cycle of workloads.
    * Application operators set the life cycle of resource claims.
    * Service operators set the life cycle of service instances.
    * The life cycle of service bindings is implicitly tied to the life cycle of workloads.
2. Resource claims and resource claim policies are the mechanism to enable cross-namespace binding.
3. ProvisionedService is the contract allowing credentials and connectivity information to flow from the service instance, to the resource claim, to the service binding, and ultimately to the application workload. For more information, see [ProvisionedService](https://github.com/servicebinding/spec#provisioned-service) on GitHub.
4. Exclusivity of resource claims: Resource claims are considered to be mutually exclusive, meaning that only one resource claim can claim a service instance.

## <a id="stk-prereqs"></a> Prerequisites

Before following this walkthrough, you must:

1. Have access to a cluster with Tanzu Application Platform installed.
1. Have downloaded and installed the Tanzu CLI and the corresponding plug-ins.
1. Ensure that your Tanzu Application Platform cluster can pull the container images required by the Kubernetes operator providing the service. For more information, see:
   * [VMware RabbitMQ for Kubernetes](https://docs.vmware.com/en/VMware-RabbitMQ-for-Kubernetes/index.html).
   * [VMware Tanzu SQL with Postgres for Kubernetes](https://docs.vmware.com/en/VMware-Tanzu-SQL-with-Postgres-for-Kubernetes/index.html).
   * [VMware Tanzu SQL with MySQL for Kubernetes](https://docs.vmware.com/en/VMware-Tanzu-SQL-with-MySQL-for-Kubernetes/index.html).

## <a id="stk-set-up"></a> Set up a service

This section covers the following:

* Installing the selected service Kubernetes operator.
* Creating the role-based access control (RBAC) rules to grant Tanzu Application Platform permission to interact with the APIs provided by the newly installed Kubernetes operator.
* Creating the additional supporting resources to aid with discovery of services.

For this part of the walkthrough, you assume the role of the **service operator**.

>**Note** Although this walkthrough uses the example of RabbitMQ Cluster Kubernetes operator, the setup steps remain largely the same for any compatible operator. Also, this walkthrough uses the open source RabbitMQ Cluster operator for Kubernetes. For most real-world deployments, VMware recommends using the official, supported version provided by VMware. For more information, see [VMware RabbitMQ for Kubernetes](https://docs.vmware.com/en/VMware-RabbitMQ-for-Kubernetes/index.html).

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

    1. In a file named `resource-claims-rmq.yaml`, create a `ClusterRole` that defines the rules and label it so that the rules are aggregated to the appropriate controller:

        ```yaml
        # resource-claims-rmq.yaml
        ---
        apiVersion: rbac.authorization.k8s.io/v1
        kind: ClusterRole
        metadata:
          name: resource-claims-rmq
          labels:
            servicebinding.io/controller: "true"
        rules:
        - apiGroups: ["rabbitmq.com"]
          resources: ["rabbitmqclusters"]
          verbs: ["get", "list", "watch"]
        ```

    2. Apply `resource-claims-rmq.yaml` by running:

        ```console
        kubectl apply -f resource-claims-rmq.yaml
        ```

        PostgreSQL: [Creating Service Bindings](https://docs.vmware.com/en/VMware-Tanzu-SQL-with-Postgres-for-Kubernetes/1.8/tanzu-postgres-k8s/GUID-creating-service-bindings.html)

        MySQL: [Connecting an Application to a MySQL Instance](https://docs.vmware.com/en/VMware-Tanzu-SQL-with-MySQL-for-Kubernetes/1.5/tanzu-mysql-k8s/GUID-creating-service-bindings.html)

3. Make the new API discoverable to application operators.

    1. In a file named `rabbitmqcluster-clusterinstanceclass.yaml`, create a `ClusterInstanceClass`
    that refers to the new service, and set any additional metadata. For example:

        ```yaml
        # rabbitmqcluster-clusterinstanceclass.yaml
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

    2. Apply `rabbitmqcluster-clusterinstanceclass.yaml` by running:

        ```console
        kubectl apply -f rabbitmqcluster-clusterinstanceclass.yaml
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

    > **Note** By default, you can only claim and bind to service instances that
    > are running in the _same_ namespace as the application workloads.
    > To claim service instances running in a different namespace, you must
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

* Using `tanzu service claimable list --class` to view details about service instances claimable from a namespace.
* Using `tanzu service claim create` to create a claim for the service instance.

For this part of the walkthrough, you assume the role of the **application operator**.

Resource claims in Tanzu Application Platform are a powerful concept that serve many purposes.
Arguably their most important role is to enable application operators to request
services that they can use with their application workloads without having
to create and manage the services themselves. For more information, see [Resource Claims](https://docs.vmware.com/en/Services-Toolkit-for-VMware-Tanzu-Application-Platform/0.8/svc-tlk/GUID-resource_claims-api_docs.html).

In cases where service instances are running in the same namespace as
application workloads, you do not have to create a claim. You can bind to the service instance directly.

In this section you use the `tanzu service claim create` command to create
a claim that the `RabbitmqCluster` service instance you created earlier can fulfill.
This command requires the following information to create a claim:

- `--resource-name`
- `--resource-kind`
- `--resource-api-version`
- `--resource-namespace`

To claim a service instance:

1. Find the claimable instance and the necessary claim information by running:

    ```console
    tanzu service claimable list --class rabbitmq
    ```

    Expected output:

    ```console
      tanzu service claimable list --class rabbitmq

      NAME    NAMESPACE            API KIND         API GROUP/VERSION
      rmq-1   service-instances    RabbitmqCluster  rabbitmq.com/v1beta1
    ```

2. Using the information from the previous command, create a claim for the service instance by running:

    ```console
    tanzu service claim create rmq-1 \
      --resource-name rmq-1 \
      --resource-namespace service-instances \
      --resource-kind RabbitmqCluster \
      --resource-api-version rabbitmq.com/v1beta1
    ```

You have set the scene for the application developer to inspect the claim and to use it to bind to application workloads, as described in [Consume services on Tanzu Application Platform](consume-services.md).

## <a id="stk-use-cases"></a> Further use cases and reading

There are more service use cases not covered in this getting started guide. See the following:

<table class="nice">
  <th><strong>Use Case</strong></th>
  <th><strong>Short Description</strong></th>
  <tr>
    <td>
      <a href="https://docs.vmware.com/en/Services-Toolkit-for-VMware-Tanzu-Application-Platform/0.8/svc-tlk/GUID-usecases-consuming_aws_rds_with_ack.html">Consuming AWS RDS on Tanzu Application Platform</a>
    </td>
    <td>
      Using the Controllers for Kubernetes (ACK) to provision an RDS instance and consume it from a Tanzu Application Platform workload.<br>
      Involves making a third-party API consumable from Tanzu Application Platform.
    </td>
  </tr><tr>
    <td>
      <a href="https://docs.vmware.com/en/Services-Toolkit-for-VMware-Tanzu-Application-Platform/0.8/svc-tlk/GUID-usecases-consuming_aws_rds_with_crossplane.html">Consuming AWS RDS on Tanzu Application Platform with Crossplane</a>
    </td>
    <td>
      Using <a href="https://crossplane.io/">Crossplane</a> to provision an RDS instance and consume it from a Tanzu Application Platform workload.<br>
      Involves making a third-party API consumable from Tanzu Application Platform.
    </td>
  </tr><tr>
    <td>
      <a href="https://docs.vmware.com/en/Services-Toolkit-for-VMware-Tanzu-Application-Platform/0.8/svc-tlk/GUID-usecases-consuming_gcp_sql_with_config_connector.html">Consuming Google Cloud SQL on Tanzu Application Platform with Config Connector</a>
    </td>
    <td>
      Using GCP Config Connector to provision a Cloud SQL instance and consume it from a Tanzu Application Platform workload.<br>
      Involves making a third-party API consumable from Tanzu Application Platform.
    </td>
  </tr><tr>
    <td>
      <a href="https://docs.vmware.com/en/Services-Toolkit-for-VMware-Tanzu-Application-Platform/0.8/svc-tlk/GUID-usecases-consuming_gcp_sql_with_crossplane.html">Consuming Google Cloud SQL on Tanzu Application Platform with Crossplane</a>
    </td>
    <td>
      Using <a href="https://crossplane.io/">Crossplane</a> to provision a Cloud SQL instance and consume it from a Tanzu Application Platform workload.<br>
      Involves making a third-party API consumable from Tanzu Application Platform.
    </td>
  </tr><tr>
    <td>
      <a href="https://docs.vmware.com/en/Services-Toolkit-for-VMware-Tanzu-Application-Platform/0.8/svc-tlk/GUID-usecases-direct_secret_references.html">Direct Secret References</a>
    </td>
    <td>
      Binding to services running external to the cluster, for example, an in-house oracle database.<br>
      Binding to services that do not conform with the binding specification.
    </td>
  </tr>
  <tr>
    <td>
      <a href="https://docs.vmware.com/en/Services-Toolkit-for-VMware-Tanzu-Application-Platform/0.8/svc-tlk/GUID-usecases-dedicated_service_clusters.html">Dedicated Service Clusters</a> (Experimental)
    </td>
    <td>Separates application workloads from service instances across dedicated clusters.</td>
  </tr>
</table>

For more information about the APIs and concepts underpinning Services on Tanzu Application Platform, see the
[Services Toolkit Component documentation](https://docs.vmware.com/en/Services-Toolkit-for-VMware-Tanzu-Application-Platform/0.8/svc-tlk/GUID-overview.html)

## Next steps

Now that you completed the Getting started guides, learn about:

- [Multicluster Tanzu Application Platform](../multicluster/about.md)
