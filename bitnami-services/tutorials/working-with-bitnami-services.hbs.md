# Working with Bitnami Services

In this tutorial you learn how [application operators](../../services-toolkit/reference/terminology-and-user-roles.hbs.md#ao)
can discover, claim, and bind services to application workloads.

Tanzu Application Platform has four pre-installed services, which are MySQL, PostgreSQL, RabbitMQ, and Redis.
The corresponding Bitnami Helm Chart backs each of these services.

## <a id="about"></a> About this tutorial

**Target user role**:       Application Operator<br />
**Complexity**:             Basic<br />
**Estimated time**:         15 minutes<br />
**Topics covered**:         Classes, Claims, Bitnami,<br />
**Learning outcomes**:      An understanding of how work with the standard Bitnami services<br />

## <a id="prereqs"></a> Prerequisites

To follow this tutorial, you must have:

- Access to a Tanzu Application Platform cluster v1.5.0 and later
- The Tanzu services CLI plug-in v0.6.0 and later

## <a id="concepts"></a> Concepts

The following diagram provides an overview of the elements you will use during this tutorial and
how they all fit together.

![Diagram shows a high-level overview of the pre-installed Bitnami Services.](../../images/stk-dynamic-provisioning-bitnami-services.png)

In this diagram:

- There are only two elements that require user input, which are creating a `ClassClaim` and
  creating a `Workload`. The workload is configured to refer to the class claim`.

- The life cycles of the `ClassClaim` and the `Workload` are separate.
  This allows you to update one without affecting the other.

- The dynamic provisioning process is simplified.
  This is intentional because Application Operators and Developers do not need to know
  about the inner workings and configurations of service instances.

## <a id="procedure"></a> Procedure

The following steps explain how to work with Bitnami Services.

## <a id="discovery"></a> Step 1: Discover services

Application teams can discover the range of services on offer to them by running:

```console
tanzu service class list
```

The expected output is similar to the following:

```console
  NAME                  DESCRIPTION
  mysql-unmanaged       MySQL by Bitnami
  postgresql-unmanaged  PostgreSQL by Bitnami
  rabbitmq-unmanaged    RabbitMQ by Bitnami
  redis-unmanaged       Redis by Bitnami
```

Here the output shows 4 classes. These are the four pre-installed Bitnami Services.
You can see from the names and descriptions that they are all _unmanaged_ services.
This implies that the resulting service instances run on cluster, that is, they are not a managed
service running in the cloud.
Other classes might be listed here as well.

As an Application Operator, you review the classes on offer and choose one that meets your requirements.

You can learn and discover more about a class by running:

```console
tanzu service class get postgresql-unmanaged
```

The expected output is similar to the following:

```console
NAME:           postgresql-unmanaged
DESCRIPTION:    PostgreSQL by Bitnami
READY:          true

PARAMETERS:
  KEY        DESCRIPTION                                                  TYPE     DEFAULT  REQUIRED
  storageGB  The desired storage capacity of the database, in Gigabytes.  integer  1        false
```

The output shows the name and a short description for the class, its current status, and the parameters.
The parameters represent the set of configuration options that are available to application teams.

The `postgresql-unmanaged` class here has one parameter, which is `storageGB`.
You can also see that it is not required to pass this parameter when creating a claim for the class,
in which case the default value of `1` is used.

## <a id="claiming"></a> Step 2: Claim services

In this example, you have an application workload that requires a PostgreSQL database to function correctly.
You can claim the pre-installed Bitnami PostgreSQL service to obtain such a database.

To create the claim in a namespace named `dev-team-1`, you must first create
the namespace by running:

```console
kubectl create namespace dev-team-1
```

You can use the `tanzu service class-claim create` command to create a claim for the
`postgresql-unmanaged` class, then bind your application workload to the resulting claim.
In this example, you are also choosing to override the default value of `1` for the `storageGB`
parameter, setting it instead to `3`.  You can override any of the options as you see fit.

```console
tanzu service class-claim create psql-1 --class postgresql-unmanaged --parameter storageGB=3 -n dev-team-1
```

The expected output is similar to the following:

```console
Creating claim 'psql-1' in namespace 'dev-team-1'.
Please run `tanzu services class-claims get psql-1 --namespace dev-team-1` to see the progress of create.
```

As the output states, you can then confirm the status of the claim by using the
`tanzu service class-claim get` command as follows:

```console
tanzu services class-claims get psql-1 --namespace dev-team-1
```

The expected output is similar to the following:

```console
Name: psql-1
Namespace: dev-team-1
Claim Reference: services.apps.tanzu.vmware.com/v1alpha1:ClassClaim:psql-1
Class Reference:
  Name: postgresql-unmanaged
Parameters:
  storageGB: 3
Status:
  Ready: True
  Claimed Resource:
    Name: 7974379c-7b4d-41c3-af57-f4f1ae08c65d
    Namespace: dev-team-1
    Group:
    Version: v1
    Kind: Secret
```

It might take a moment or two before the claim reports `Ready: True`.
After the claim is ready, you then have a successful claim for a PostgreSQL database configured to
your needs with 3&nbsp;GB of storage.

## <a id="binding"></a> Step 3: Bind the claim to a workload

After creating the claim, you can bind it to one or more of your application workloads.

> **Important** If binding to more than one application workload then all application workloads must
> exist in the same namespace. This is a known limitation. For more information, see
> [Cannot claim and bind to the same service instance from across multiple namespaces](../../services-toolkit/reference/known-limitations.hbs.md#multi-workloads).

1. Find the reference for the claim by running the following command. The reference is in the output
under the heading "Claim Reference.

   ```console
   tanzu service class-claim get psql-1
   ```

1. Bind the claim to a workload of your choice by pass a reference to the claim to the `--service-ref`
   flag of the `tanzu apps workload create` command. For example:

   ```console
   tanzu apps workload create my-workload --image my-registry/my-app-image --service-ref db=services.apps.tanzu.vmware.com/v1alpha1:ClassClaim:psql-1
   ```

   You must pass the claim reference with a corresponding name that follows the format
   `--service-ref db=services.apps.tanzu.vmware.com/v1alpha1:ClassClaim:psql-1`.
   The `db=` prefix to this example reference is an arbitrary name for the reference.
