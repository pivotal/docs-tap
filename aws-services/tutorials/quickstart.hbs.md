# Quickstart

A quick introduction to the AWS Services Package to get you up and running with AWS Services on
Tanzu Application Platform.

<!-- probs should be split into roles -->
<!-- could this just be a how to? "Create claim and bind to workload"/"Using AWS Services" -->

## Prerequisites

1. Before starting this tutorial it is recommended to first read through
  [Understanding the AWS Services Package](../concepts/understanding-the-aws-services-package.hbs.md).
  This provides context about the features and goals of the package, as well as some of the considerations
  and compromises that have been made as part of its development.

2. [Install AWS services](../install-aws-services.hbs.md)

## <a id="about"></a> About this tutorial

**Target user roles**:      Service Operator, Application Operator, Application Developer<br />
**Complexity**:             Medium<br />
**Estimated time**:         45 minutes<br />
**Topics covered**:         AWS, RDS, PostgreSQL, Classes, Claims,<br />
**Learning outcomes**:      An understanding of how to configure and provision RDS PostgreSQL instances on Tanzu Application Platform using the AWS Services Package<br />


And with that, we are now ready to switch hats to the role of the Application Operator and Developer and to learn how to discover, claim and bind to RDS PostgreSQL service instances. These steps are almost exactly the same as for any other service (e.g. any of the [Bitnami Services](../../bitnami-services/about.hbs.md)).

## <a id="discover-available-aws-services"></a> Step 5: Discover the list of available AWS Services

To discover the list of available services, run:

```console
tanzu service class list
```

You should see one named `postgresql-managed-aws`.

To learn more about the service, including which claim parameters are provided, run:

```console
tanzu service class get postgresql-managed-aws
```

## <a id="create-a-claim-aws-rds-postgresql"></a> Step 6: Create a claim for an instance of the AWS RDS PostgreSQL service

To create a claim for the class:

```console
tanzu service class-claim create rds-psql-1 --class postgresql-managed-aws
```

It takes about 5-10 minutes for the service instance to be provisioned.
You can watch the claim and wait for it to transition into a `READY: True` state to know when it is ready to use.

## <a id="bind-to-workload"></a> Step 7: Binding the instance to a Workload

After creating the claim, you can bind it to one or more of your application workloads.

> **Important** If binding to more than one application workload then all application workloads must
> exist in the same namespace. This is a known limitation. For more information, see
> [Cannot claim and bind to the same service instance from across multiple namespaces](../../services-toolkit/reference/known-limitations.hbs.md#multi-workloads).

1. Find the reference for the claim by running the following command.

    ```console
    tanzu service class-claim get rds-psql-1
    ```

    The reference is in the output under the heading Claim Reference.

1. Bind the claim to a workload of your choice by pass a reference to the claim to the `--service-ref`
   flag of the `tanzu apps workload create` command. For example:

    ```console
    tanzu apps workload create my-workload --image my-registry/my-app-image --service-ref db=services.apps.tanzu.vmware.com/v1alpha1:ClassClaim:rds-psql-1
    ```

    You must pass the claim reference with a corresponding name that follows the format
    `--service-ref db=services.apps.tanzu.vmware.com/v1alpha1:ClassClaim:rds-psql-1`.
    The `db=` prefix to this example reference is an arbitrary name for the reference.
