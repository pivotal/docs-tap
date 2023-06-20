# Consume services on Tanzu Application Platform

This topic for application developers guides you through deploying two application workloads and configuring
them to communicate using a service instance.
The topic uses RabbitMQ as an example, but the process is the same regardless of the service you
want to consume.

You will use the `tanzu service` CLI plug-in and will learn about classes, claims, and bindings.

## <a id="you-will"></a>What you will do

- Discover existing claims on service instances within your namespace
- Create two application workloads and bind them to an existing claim so that
the workloads use the service instance.

## <a id="overview"></a>Overview

The following diagram depicts a summary of what this tutorial covers.

![In the default namespace there are two app workloads, each connected to a service binding.
The service bindings refer to one class claim.](../images/getting-started-stk-1.png)

Bear the following observations in mind as you work through this guide:

1. There is a set of four service classes preinstalled on the cluster.

1. Service operators do not need to configure or setup these four services.

1. The life cycle of a service binding is implicitly tied to the life cycle of a workload,
   and is managed by the application developer.

1. The life cycles of claims are explicitly managed by the application operator.

1. The diagram and tutorial in this guide are predominantly focused on the application operator and
   developer user roles, as such the inner workings of how service instances are provisioned are not
   in the diagram and are labeled as "behind the scenes".

## <a id="stk-prereqs"></a> Prerequisites

Before following this tutorial, an application developer must:

1. Have access to a cluster with Tanzu Application Platform installed.
1. Have the Tanzu CLI and the corresponding plug-ins.
1. Have access to the `default` namespace which has been set up to use installed packages.
For more information, see [Set up developer namespaces to use your installed packages](../install-online/set-up-namespaces.hbs.md).
1. Have a Tanzu Application Platform cluster that can pull source code from GitHub.

## <a id="stk-discover-claims"></a> Discovering existing claims

This section covers using `tanzu service class-claim list` and `tanzu service class-class get`
to discover existing claims within your namespace and obtaining information needed †o bind your
workload to them.

1. To get the list of claims within your namespace, run:

    ```console
    tanzu service class-claim list
    ```

    Expected output:

    ```console
    NAME        CLASS               READY  REASON
    rabbitmq-1  rabbitmq-unmanaged  True   Ready
    ```

1. To get detailed information about the claim, run:

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

## <a id="stk-bind"></a> Binding application workloads to the service instance

This section covers using `tanzu apps workload create` with the `--service-ref` flag to create
workloads and to bind them to the service instance through the claim.

In Tanzu Application Platform, service bindings are created when you create application workloads
using the `--service-ref` flag of the `tanzu apps workload create` command.

To create an application workload:

1. Review the output of the `tanzu service class-claim get` command you ran in
[Discovering existing claims](#stk-discover-claims) earlier, and note the value of the `Claim Reference`.
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

## <a id="stk-use-cases"></a> Learn more

To learn more about working with services on Tanzu Application Platform, see the
[Services Toolkit component documentation](../services-toolkit/about.hbs.md):

- [Tutorials](../services-toolkit/tutorials/index.hbs.md)
- [How-to guides](../services-toolkit/how-to-guides/index.hbs.md)
- [Concepts](../services-toolkit/concepts/index.hbs.md)
- [Reference material](../services-toolkit/reference/index.hbs.md)

## Next steps

Now that you completed the Getting started guides, learn about:

- [Multicluster Tanzu Application Platform](../multicluster/about.md)
