# Working with AWS Services

In this tutorial you learn how [application operators](../../services-toolkit/reference/terminology-and-user-roles.hbs.md#ao)
and [application developers](../../services-toolkit/reference/terminology-and-user-roles.hbs.md#ad)
can use AWS Services on Tanzu Application Platform.
You will learn how to discover, claim, and bind services to application workloads.

## <a id="prerequisites"></a>Prerequisites

Before starting this tutorial:

- VMware recommends that you read [About the AWS Services package](../concepts/about-aws-services.hbs.md).
  The topic provides context about the goals of the package, and some of the
  considerations and compromises that were made as part of its development.

- [Install AWS services](../install-aws-services.hbs.md)

## <a id="about"></a> About this tutorial

**Target user roles**:      Application Operator, Application Developer<br />
**Complexity**:             Basic<br />
**Estimated time**:         15 minutes<br />
**Topics covered**:         AWS, RDS, PostgreSQL, Classes, Claims<br />
**Learning outcomes**:      An understanding of how to work with RDS PostgreSQL instances on Tanzu Application Platform using the AWS Services package<br />

## <a id="discover-services"></a> Step 1: Discover the list of available AWS services

To find out about available AWS services:

1. To discover the list of available services, run:

    ```console
    tanzu service class list
    ```

    The expected output has one service named `postgresql-managed-aws`.

1. To learn more about the service, including which claim parameters are provided, run:

    ```console
    tanzu service class get postgresql-managed-aws
    ```

## <a id="create-a-claim"></a> Step 2: Claim an instance of the AWS RDS PostgreSQL service

To claim an instance of the AWS RDS PostgreSQL service:

```console
tanzu service class-claim create rds-psql-1 --class postgresql-managed-aws
```

It takes about 5 to 10 minutes for the service instance to be provisioned.
You can watch the claim and wait for it to transition into a `READY: True` state to know when it is
ready to use.

## <a id="bind-to-workload"></a> Step 3: Bind the service to a workload

After creating the claim, you can bind it to one or more of your application workloads.

> **Important** If you want to bind to more than one application workload, all application workloads
> must be in the same namespace. This is a known limitation. For more information, see
> [Cannot claim and bind to the same service instance from across multiple namespaces](../../services-toolkit/reference/known-limitations.hbs.md#multi-workloads).

1. Find the reference for the claim by running:

    ```console
    tanzu service class-claim get rds-psql-1
    ```

    The reference is in the output under the heading Claim Reference.

1. Bind the claim to a workload of your choice by passing a reference to the claim to the `--service-ref`
   flag of the `tanzu apps workload create` command. For example:

    ```console
    tanzu apps workload create my-workload --image my-registry/my-app-image --service-ref db=services.apps.tanzu.vmware.com/v1alpha1:ClassClaim:rds-psql-1
    ```

    You must pass the claim reference with a corresponding name that follows the format
    `--service-ref db=services.apps.tanzu.vmware.com/v1alpha1:ClassClaim:rds-psql-1`.
    The `db=` prefix to this example reference is an arbitrary name for the reference.
