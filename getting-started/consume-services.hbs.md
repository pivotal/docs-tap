# Consume services on Tanzu Application Platform

This topic for application developers guides you through deploying two application workloads and configuring
them to communicate using a service instance.
The topic uses RabbitMQ as an example, but the process is the same regardless of the service you
want to consume.

You will use the `tanzu service` CLI plug-in and will learn about classes, claims, and bindings.

## <a id="you-will"></a>What you will do

- Inspect the resource claim created for the service instance by the application operator.
- Bind the application workload to the ResourceClaim so the workload utilizes the service instance.

## <a id="overview"></a>Overview

The following diagram depicts a summary of what this walkthrough covers, including the work of the service and application operators described in [Set up services for consumption by developers](set-up-services.md).

![Diagram shows the default namespace and service instances namespace. The default namespace has two application workloads, each connected to a service binding. The service bindings connect to the service instance in the service instances namespace through a resource claim.](../images/getting-started-stk-1.png)

Bear the following observations in mind as you work through this guide:

1. There is a clear separation of concerns across the various user roles.

    * Application developers set the life cycle of workloads.
    * Application operators set the life cycle of resource claims.
    * Service operators set the life cycle of service instances.
    * The life cycle of service bindings is implicitly tied to the life cycle of workloads.

2. ProvisionedService is the contract allowing credentials and connectivity information to flow from the service instance, to the resource claim, to the service binding, and ultimately to the application workload. For more information, see [ProvisionedService](https://github.com/servicebinding/spec#provisioned-service) on GitHub.

## <a id="stk-prereqs"></a> Prerequisites

Before following this walkthrough, you must:

1. Have access to a cluster with Tanzu Application Platform installed.
1. Have downloaded and installed the Tanzu CLI and the corresponding plug-ins.
1. Have set up the `default` namespace to use installed packages and use it as your developer namespace.
For more information, see [Set up developer namespaces to use your installed packages](../install-online/set-up-namespaces.hbs.md).
1. Ensure that your Tanzu Application Platform cluster can pull source code from GitHub.
1. Ensure that the service operator and application operator has completed the work of setting up the service, creating the service instance, and claiming the service instance, as described in [Set up services for consumption by developers](set-up-services.md).

As application developer, you are now ready to inspect the resource claim created for the service instance by the application operator in [Set up services for consumption by developers](set-up-services.md) and use it to bind to application workloads.

## <a id="stk-bind"></a> Bind an application workload to the service instance

This section covers:

* Using `tanzu service claim list` and `tanzu service claim get` to find information about the claim to use for binding.
* Using `tanzu apps workload create` with the `--service-ref` flag to create a workload and bind it to the service instance.

You must create application workloads and bind them to the service instance using the claim.

In Tanzu Application Platform, service bindings are created when you create application workloads
that specify `.spec.serviceClaims`.
In this section, you create such workloads by using the `--service-ref`
flag of the `tanzu apps workload create` command.

To create an application workload:

1. Inspect the claims in the developer namespace to find the value to pass to
`--service-ref` command by running:

    ```console
    tanzu service claim list
    ```

    Expected output:

    ```console
      NAME   READY  REASON
      rmq-1  True
    ```

1. Retrieve detailed information about the claim by running:

    ```console
    tanzu service claim get rmq-1
    ```

    Expected output:

    ```console
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
      --git-repo https://github.com/tanzu-end-to-end/spring-sensors \
      --git-branch rabbit \
      --type web \
      --label app.kubernetes.io/part-of=spring-sensors \
      --annotation autoscaling.knative.dev/minScale=1 \
      --service-ref="rmq=services.apps.tanzu.vmware.com/v1alpha1:ResourceClaim:rmq-1"

    tanzu apps workload create \
      spring-sensors-producer \
      --git-repo https://github.com/tanzu-end-to-end/spring-sensors-sensor \
      --git-branch main \
      --type web \
      --label app.kubernetes.io/part-of=spring-sensors \
      --annotation autoscaling.knative.dev/minScale=1 \
      --service-ref="rmq=services.apps.tanzu.vmware.com/v1alpha1:ResourceClaim:rmq-1"
    ```

    Using the `--service-ref` flag instructs Tanzu Application Platform to bind the application workload to the service provided in the `ref`.

    > **Note** You are not passing a service ref to the `RabbitmqCluster` service instance directly,
    > but rather to the resource claim that has claimed the `RabbitmqCluster` service instance.
    > See the [consuming services diagram](#overview) at the beginning of this walkthrough.

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
      <a href="https://docs.vmware.com/en/Services-Toolkit-for-VMware-Tanzu-Application-Platform/0.8/svc-tlk/GUID-usecases-consuming_aws_rds_with_ack.html#dscvr-claim-bind">Consuming AWS RDS on Tanzu Application Platform</a>
    </td>
    <td>
      Using the Controllers for Kubernetes (ACK) to provision an RDS instance and consume it from a Tanzu Application Platform workload.<br>
      Involves making a third-party API consumable from Tanzu Application Platform.
    </td>
  </tr><tr>
    <td>
      <a href="https://docs.vmware.com/en/Services-Toolkit-for-VMware-Tanzu-Application-Platform/0.8/svc-tlk/GUID-usecases-consuming_aws_rds_with_crossplane.html#claim-the-rds-postgresql-instance-and-connect-to-it-from-the-tanzu-application-platform-workload-8">Consuming AWS RDS on Tanzu Application Platform with Crossplane</a>
    </td>
    <td>
      Using <a href="https://crossplane.io/">Crossplane</a> to provision an RDS instance and consume it from a Tanzu Application Platform workload.<br>
      Involves making a third-party API consumable from Tanzu Application Platform.
    </td>
  </tr><tr>
    <td>
      <a href="https://docs.vmware.com/en/Services-Toolkit-for-VMware-Tanzu-Application-Platform/0.8/svc-tlk/GUID-usecases-consuming_gcp_sql_with_config_connector.html#discover-claim-and-bind-to-a-google-cloud-sql-postgresql-instance-3">Consuming Google Cloud SQL on Tanzu Application Platform with Config Connector</a>
    </td>
    <td>
      Using GCP Config Connector to provision a Cloud SQL instance and consume it from a Tanzu Application Platform workload.<br>
      Involves making a third-party API consumable from Tanzu Application Platform.
    </td>
  </tr><tr>
    <td>
      <a href="https://docs.vmware.com/en/Services-Toolkit-for-VMware-Tanzu-Application-Platform/0.8/svc-tlk/GUID-usecases-consuming_gcp_sql_with_crossplane.html#claim-the-cloudsql-postgresql-instance-and-connect-to-it-from-the-tanzu-application-platform-workload-8">Consuming Google Cloud SQL on Tanzu Application Platform with Crossplane</a>
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
[Services Toolkit Component documentation](https://docs.vmware.com/en/Services-Toolkit-for-VMware-Tanzu-Application-Platform/0.8/svc-tlk/GUID-overview.html).

## Next steps

Now that you completed the Getting started guides, learn about:

- [Multicluster Tanzu Application Platform](../multicluster/about.md)
