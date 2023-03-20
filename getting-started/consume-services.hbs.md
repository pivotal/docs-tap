# Consume services on Tanzu Application Platform

This tutorial walks the application developer through deploying two application workloads and configuring them to communicate via a service instance. It uses RabbitMQ as an example, but the process is the same regardless of the service you want to set up. You will use the `tanzu service` CLI plug-in and will learn about classes, claims and bindings.

## <a id="you-will"></a>What you will do

- Discover the range of services available to you
- Create a claim for an instance of one of the services
- Create two application workloads and bind them to the claim so that the workloads utilize the service instance

## <a id="overview"></a>Overview

The following diagram depicts a summary of what this tutorial covers.

![Diagram shows the default namespace and a glimpse at what is happening behind the scenes. The default namespace has two application workloads, each connected to a service binding. The service bindings refer to a single claim, which refers to a service instance.](../images/getting-started-stk-1.png)

Bear the following observations in mind as you work through this guide:

1. There are a set of four classes preinstalled on the cluster.
2. There is no configuration or setup required by Service Operators for these four out-of-the-box services.
3. The life cycle of a service binding is implicitly tied to the life cycle of a workload, and hence managed by the Application Developer.
4. The life cycles of claims are explicitly managed by the Application Operator.
5. This diagram and tutorial are predominantly focussed on the Application Operator and Developer user roles, as such the inner workings of how service instances are provisioned are not pictured and have been labelled as "behind the scenes".

## <a id="stk-prereqs"></a> Prerequisites

Before following this walkthrough, as app developer you must:

1. Have access to a cluster with Tanzu Application Platform installed.
1. Have downloaded and installed the Tanzu CLI and the corresponding plug-ins.
1. Have set up the `default` namespace to use installed packages and use it as your developer namespace.
For more information, see [Set up developer namespaces to use installed packages](../set-up-namespaces.md).
1. Ensure that your Tanzu Application Platform cluster can pull source code from GitHub.

## <a id="stk-discover"></a> Discover available services

This section covers:

* Using `tanzu service class list` and `tanzu service class get` to find information about the classes of services.

The range of available services can be discovered using the `tanzu service class list` command.

    ```console
    tanzu service class list
    ```

    Expected output:

    ```console
      NAME                  DESCRIPTION
      mysql-unmanaged       MySQL by Bitnami
      postgresql-unmanaged  PostgreSQL by Bitnami
      rabbitmq-unmanaged    RabbitMQ by Bitnami
      redis-unmanaged       Redis by Bitnami
    ```

You can see that four classes are listed covering a range of services - MySQL, PostgreSQL, RabbitMQ and Redis. This is the default set of services that come preconfigured with Tanzu Application Platform. They are backed by Bitnami Helm charts which run on the Tanzu Application Platform cluster itself. As such they can be considered "unmanaged" services.

You can see more detailed information for a given class by using the `tanzu service class get` command.

    ```console
    tanzu service class get rabbitmq-unmanaged
    ```

    Expected output:

    ```console
      NAME:           rabbitmq-unmanaged
      DESCRIPTION:    RabbitMQ by Bitnami
      READY:          true

      PARAMETERS:
        KEY        DESCRIPTION                                                      TYPE     DEFAULT  REQUIRED
        replicas   The desired number of replicas forming the cluster               integer  1        false
        storageGB  The desired storage capacity of a single replica, in Gigabytes.  integer  1        false
    ```

The `PARAMETERS` section is of particular interest as it lists the range of configuration options available to you when it comes to creating a claim for the given class.

## <a id="stk-create-claim"></a> Create a claim for a service instance

This section covers:

* Using `tanzu service class-claim create` to create a claim for an instance of a class.
* Using `tanzu service class-claim get` to get detailed information on the status of the claim.

You can create a claim for an instance of a class using the `tanzu service class-claim create` command. Let's create a claim for the `rabbitmq-unmanaged` class. We'll pass a parameter to the command to set the storage capacity of the resulting instance to 3 Gigabytes, rather than using the default 1 Gigabyte.

    ```console
    tanzu service class-claim create rabbitmq-1 --class rabbitmq-unmanaged --parameter storageGB=3
    ```

    Expected output:

    ```console
      Creating claim 'rabbitmq-1' in namespace 'default'.
    ```

You can get detailed information about the claim using the `tanzu service class-claim get` command.

    ```console
    tanzu service class-claim get rabbitmq-1
    ```

    Expected output:

    ```console
      Name: rabbitmq-1
      Namespace: default
      Claim Reference: services.apps.tanzu.vmware.com/v1alpha1:ClassClaim:rabbitmq-1
      Class Reference:
        Name: rabbitmq-unmanaged
      Parameters:
        storageGB: 3
      Status:
        Ready: True
        Claimed Resource:
          Name: b5982046-a1e9-40cf-8282-00fe67a2f868
          Namespace: default
          Group:
          Version: v1
          Kind: Secret
    ```

It may take a moment or two for the claim to report `Ready: True`. Behind the scenes, the creation of the claim has triggered the on-demand creation of a Helm release of the Bitnami RabbitMQ Helm chart. Credentials and connectivity information required to connect to the RabbitMQ cluster have been formatted according to the [Service Binding Specification for Kubernetes](https://github.com/servicebinding/spec) and stored in a `Secret` in your namespace.

However, as an Application Developer you don't need to worry about what's going on behind the scenes. Tanzu Application Platform promotes a strong separation of concerns between Service Operators, who are responsible for managing service instances for the platform, and Application Developers, who just want to use those service instances with their application workloads. The class and claims abstractions work in service of that separation of concerns. Application Operators/Developers create claims and Service Operators do whatever work is necessary to fulfil them.

Now that you have a claim for a RabbitMQ service instance, you can bind it to your application workloads.

## <a id="stk-bind"></a> Binding application workloads to the service instance

This section covers:

* Using `tanzu apps workload create` with the `--service-ref` flag to create workloads and to bind them to the service instance via the claim.

In Tanzu Application Platform, service bindings are created when you create application workloads using the `--service-ref` flag of the `tanzu apps workload create` command.

To create an application workload:

1. Review the output of the `tanzu service class-claim get` command above and note the value of the `Claim Reference`.
This is the value to pass to `--service-ref` when creating the application workloads.

1. Create the application workload by running:

    ```console
    tanzu apps workload create spring-sensors-consumer-web \
      --git-repo https://github.com/tanzu-end-to-end/spring-sensors \
      --git-branch rabbit \
      --type web \
      --label app.kubernetes.io/part-of=spring-sensors \
      --annotation autoscaling.knative.dev/minScale=1 \
      --service-ref="rmq=services.apps.tanzu.vmware.com/v1alpha1:ClassClaim:rabbitmq-1"

    tanzu apps workload create \
      spring-sensors-producer \
      --git-repo https://github.com/tanzu-end-to-end/spring-sensors-sensor \
      --git-branch main \
      --type web \
      --label app.kubernetes.io/part-of=spring-sensors \
      --annotation autoscaling.knative.dev/minScale=1 \
      --service-ref="rmq=services.apps.tanzu.vmware.com/v1alpha1:ClassClaim:rabbitmq-1"
    ```

1. After the workloads are ready, visit the URL of the `spring-sensors-consumer-web` app.
Confirm that sensor data is passing from the `spring-sensors-producer` workload to
the `spring-sensors-consumer-web` workload using the `RabbitmqCluster` service instance.

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
