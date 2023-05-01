# Consume services on Tanzu Application Platform

This how-to guide walks the application developer through deploying two application workloads and configuring them to communicate with a service. It uses RabbitMQ as an example, but the process is the same regardless of the service you want to set up. You will learn about the `tanzu services` CLI plug-in and the most important APIs for working with services on Tanzu Application Platform.

## <a id="prereqs"></a>Prerequisites

Before starting this procedure, ensure that the service operator and application operator have already:

- Set up a service.
- Created a service instance.
- Claimed the service instance.

For more information about these prerequisites, see [Set up services for consumption by developers](set-up-services.md). Also, for important background, see [Consume services on Tanzu Application Platform](about-consuming-services.md).

## <a id="you-will"></a>What you will do

- Inspect the claim created for the service instance by the application operator.
- Bind the application workload to the claim so the workload utilizes the service instance.

## <a id="overview"></a>Overview

The following diagram depicts a summary of what this walkthrough covers, including the work of the service and application operators described in [Set up services for consumption by developers](set-up-services.md).

![Diagram shows the default namespace and service instances namespace. The default namespace has two application workloads, each connected to a service binding. The service bindings connect to the service instance in the service instances namespace through a claim.](../images/getting-started-stk-1.png)

Bear the following observations in mind as you work through this guide:

1. There is a clear separation of concerns across the various user roles.

    * Application developers set the life cycle of workloads.
    * Application operators set the life cycle of claims.
    * Service operators set the life cycle of service instances.
    * The life cycle of service bindings is implicitly tied to the life cycle of workloads.

2. ProvisionedService is the contract allowing credentials and connectivity information to flow from the service instance to the class claim, to the resource claim, to the service binding, and ultimately to the application workload. For more information, see [ProvisionedService](https://github.com/servicebinding/spec#provisioned-service) on GitHub.

## <a id="stk-prereqs"></a> Prerequisites

Before following this walkthrough, as app developer you must:

1. Have access to a cluster with Tanzu Application Platform installed.
1. Have downloaded and installed the Tanzu CLI and the corresponding plug-ins.
1. Have set up the `default` namespace to use installed packages and use it as your developer namespace.
For more information, see [Set up developer namespaces to use installed packages](../install-online/set-up-namespaces.hbs.md).
1. Ensure that your Tanzu Application Platform cluster can pull source code from GitHub.
2. Ensure that the service operator and application operator have completed:

   - Setting up the service.
   - Creating the service instance.
   - Creating a claim for the service instance.

After you've completed these prerequisites, you are ready to inspect the claim created for the service instance by the application operator in [Set up services for consumption by developers](set-up-services.md) and use it to bind to application workloads.

## <a id="stk-bind"></a> Bind an application workload to the service instance

This section covers:

* Using `tanzu service class-claim list` and `tanzu service class-claim get` to find information about the claim to use for binding.
* Using `tanzu apps workload create` with the `--service-ref` flag to create a workload and bind it to the service instance.

In Tanzu Application Platform, service bindings are created when you create application workloads
that specify `.spec.serviceClaims`.
In this section, you create such workloads by using the `--service-ref`
flag of the `tanzu apps workload create` command.

To create an application workload:

1. Inspect the claims in the developer namespace to find the value to pass to
`--service-ref` command by running:

    ```console
    tanzu services class-claims list
    ```

    Expected output:

    ```console
      NAME      CLASS     READY  REASON
      rmq-1     rabbitmq  True   Ready
    ```

1. Retrieve detailed information about the claim by running:

    ```console
    tanzu services class-claims get rmq-1
    ```

    Expected output:

    ```console
    Name: rmq-1
    Namespace: default
    Claim Reference: services.apps.tanzu.vmware.com/v1alpha1:ClassClaim:rmq-1
    Class Reference:
      Name: rabbitmq
    Status:
      Ready: True
      Claimed Resource:
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
      --git-repo https://github.com/tanzu-end-to-end/spring-sensors \
      --git-branch rabbit \
      --type web \
      --label app.kubernetes.io/part-of=spring-sensors \
      --annotation autoscaling.knative.dev/minScale=1 \
      --service-ref="rmq=services.apps.tanzu.vmware.com/v1alpha1:ClassClaim:rmq-1"

    tanzu apps workload create \
      spring-sensors-producer \
      --git-repo https://github.com/tanzu-end-to-end/spring-sensors-sensor \
      --git-branch main \
      --type web \
      --label app.kubernetes.io/part-of=spring-sensors \
      --annotation autoscaling.knative.dev/minScale=1 \
      --service-ref="rmq=services.apps.tanzu.vmware.com/v1alpha1:ClassClaim:rmq-1"
    ```

    Using the `--service-ref` flag instructs Tanzu Application Platform to bind the application workload to the service provided in the `ref`.

    You are not passing a service ref to the `RabbitmqCluster` service instance directly,
    but rather to the claim that has claimed the `RabbitmqCluster` service instance.
    See the [consuming services diagram](#overview) at the beginning of this walkthrough.

    > **Note** The deliverable produced eventually fails if the referenced resource in `--service-ref` consistently does not exist.
    > This behavior is encoded in the OOTB supply chains through the use of the [OOTB templates](../scc/ootb-templates.md).
    > The `service-bindings` OOTB template can be used to replicate the same behavior in bespoke supply chains.

2. After the workloads are ready, visit the URL of the `spring-sensors-consumer-web` app.
Confirm that sensor data, passing from the `spring-sensors-producer` workload to
the `create spring-sensors-consumer-web` workload using the `RabbitmqCluster` service instance, is displayed.

## <a id="stk-use-cases"></a> Further use cases and reading

There are more service use cases not covered in this getting started guide. See the following:

<table class="nice">
  <th><strong>Use Case</strong></th>
  <th><strong>Short Description</strong></th>
  <tr>
    <td>
      <a href="https://docs.vmware.com/en/Services-Toolkit-for-VMware-Tanzu-Application-Platform/0.9/svc-tlk/usecases-consuming_aws_rds_with_ack.html#dscvr-claim-bind">Consuming AWS RDS on Tanzu Application Platform</a>
    </td>
    <td>
      Using the Controllers for Kubernetes (ACK) to provision an RDS instance and consume it from a Tanzu Application Platform workload.<br>
      Involves making a third-party API consumable from Tanzu Application Platform.
    </td>
  </tr><tr>
    <td>
      <a href="https://docs.vmware.com/en/Services-Toolkit-for-VMware-Tanzu-Application-Platform/0.9/svc-tlk/usecases-consuming_aws_rds_with_crossplane.html#claim-the-rds-postgresql-instance-and-connect-to-it-from-the-tanzu-application-platform-workload-8">Consuming AWS RDS on Tanzu Application Platform with Crossplane</a>
    </td>
    <td>
      Using <a href="https://crossplane.io/">Crossplane</a> to provision an RDS instance and consume it from a Tanzu Application Platform workload.<br>
      Involves making a third-party API consumable from Tanzu Application Platform.
    </td>
  </tr><tr>
    <td>
      <a href="https://docs.vmware.com/en/Services-Toolkit-for-VMware-Tanzu-Application-Platform/0.9/svc-tlk/usecases-consuming_gcp_sql_with_config_connector.html#discover-claim-and-bind-to-a-google-cloud-sql-postgresql-instance-3">Consuming Google Cloud SQL on Tanzu Application Platform with Config Connector</a>
    </td>
    <td>
      Using GCP Config Connector to provision a Cloud SQL instance and consume it from a Tanzu Application Platform workload.<br>
      Involves making a third-party API consumable from Tanzu Application Platform.
    </td>
  </tr><tr>
    <td>
      <a href="https://docs.vmware.com/en/Services-Toolkit-for-VMware-Tanzu-Application-Platform/0.9/svc-tlk/usecases-consuming_gcp_sql_with_crossplane.html#claim-the-cloudsql-postgresql-instance-and-connect-to-it-from-the-tanzu-application-platform-workload-8">Consuming Google Cloud SQL on Tanzu Application Platform with Crossplane</a>
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
[Services Toolkit Component documentation](https://docs.vmware.com/en/Services-Toolkit-for-VMware-Tanzu-Application-Platform/0.9/svc-tlk/overview.html).

## Next steps

Now that you completed the Getting started guides, learn about:

- [Multicluster Tanzu Application Platform](../multicluster/about.md)
