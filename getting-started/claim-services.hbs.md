# Claim services on Tanzu Application Platform

This tutorial guides application operators claiming a service instance and
therefore making credentials available to workloads within their namespace.
It uses RabbitMQ as an example, but the process is the same regardless of the
service you want to consume.
You will use the `tanzu service` CLI plug-in and will learn about classes,
claims, and bindings.

## <a id="you-will"></a>What you will do

- Discover the range of services available to you
- Create a claim for an instance of one of the services

## <a id="overview"></a>Overview

The following diagram depicts a summary of what this tutorial covers.

![Diagram shows the default namespace and a glimpse at what is happening behind the scenes.
The default namespace has two application workloads, each connected to a service binding.
The service bindings refer to a single claim, which refers to a service instance.](../images/getting-started-stk-1.png)

Bear the following observations in mind as you work through this guide:

1. There are a set of four service classes preinstalled on the cluster.

1. Service operators do not need to configure or setup these four services.

1. The life cycle of a service binding is implicitly tied to the life cycle of a workload,
   and is managed by the application developer.

1. The life cycles of claims are explicitly managed by the application operator.

1. The diagram and tutorial in this guide are predominantly focused on the
application operator, therefore the inner workings of how service instances are
provisioned are not in the diagram and are labeled as "behind the scenes".

## <a id="stk-prereqs"></a> Prerequisites

Before following this tutorial, an application operator must:

1. Have access to a cluster with Tanzu Application Platform installed.
1. Have the Tanzu CLI and the corresponding plug-ins.
1. Have access to the `default` namespace which has been set up to use installed packages.
For more information, see [Set up developer namespaces to use installed packages](../set-up-namespaces.md).

## <a id="stk-discover"></a> Discover available services

This section covers using `tanzu service class list` and `tanzu service class get` to find
information about the classes of services.

- To discover the range of available services, run the `tanzu service class list` command:

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

    The output lists four classes that cover a range of services: MySQL, PostgreSQL, RabbitMQ and Redis.
    This is the default set of services that come preconfigured with Tanzu Application Platform.
    They are backed by Bitnami Helm charts that run on the Tanzu Application Platform cluster.
    You can consider these to be unmanaged services with no guarantees of service provided.

- To see more detailed information for a class, run the `tanzu service class get` command:

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

    The `PARAMETERS` section is of particular interest because it lists the range of configuration
    options available to you when creating a claim for the given class.

## <a id="stk-create-claim"></a> Create a claim for a service instance

This section covers using `tanzu service class-claim create` to create a claim for an instance of a
class and using `tanzu service class-claim get` to get detailed information about the status of the claim.

- To create a claim for an instance of a class, run the `tanzu service class-claim create` command:

    ```console
    tanzu service class-claim create rabbitmq-1 --class rabbitmq-unmanaged --parameter storageGB=3
    ```

    In this example, you create a claim for the `rabbitmq-unmanaged` class and pass a parameter to
    the command to set the storage capacity of the resulting instance to 3 Gigabytes,
    rather than using the default 1 Gigabyte.

    Expected output:

    ```console
      Creating claim 'rabbitmq-1' in namespace 'default'.
    ```

- To get detailed information about the claim, run the `tanzu service class-claim get` command:

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

    It might take a moment or two for the claim to report `Ready: True`.

In the background, the creation of the claim triggers the on-demand creation of a Helm release
of the Bitnami RabbitMQ Helm chart.
Credentials and connectivity information required to connect to the RabbitMQ cluster are
formatted according to the [Service Binding Specification for Kubernetes](https://github.com/servicebinding/spec)
and stored in a `Secret` in your namespace.

As an application operator you don't need to know what's happening in the background.
Tanzu Application Platform promotes a strong separation of concerns between service operators,
who are responsible for managing service instances for the platform, and application operators,
who want to use those service instances with their application workloads.
The class and claims abstractions enable that separation of concerns.
Application operators create claims and service operators help to fulfil them.

Now that you have a claim for a RabbitMQ service instance, you can now follow
instructions to [Consume services on Tanzu Application Platform](./consume-services.hbs.md).

## <a id="stk-use-cases"></a> Learn more

To learn more about working with services on Tanzu Application Platform, see the
[Services Toolkit component documentation](../services-toolkit/about.hbs.md):

- [Tutorials](../services-toolkit/tutorials/index.hbs.md)
- [How-to guides](../services-toolkit/how-to-guides/index.hbs.md)
- [Explanations](../services-toolkit/concepts/index.hbs.md)
- [Reference material](../services-toolkit/reference/index.hbs.md)

## Next steps

Now that you completed the Getting started guides, learn about:

- [Multicluster Tanzu Application Platform](../multicluster/about.md)
