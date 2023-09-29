# Quickstart

A quick introduction to the AWS Services Package to get you up and running with AWS Services on
Tanzu Application Platform.

<!-- probs should be split into roles -->

## Prerequisites

1. Before starting this tutorial it is recommended to first read through [Understanding the AWS Services Package](../concepts/understanding-the-aws-services-package.hbs.md). This will provide you with useful background context about the features and goals of the Package, as well as some of the considerations and compromises that have been made as part of its development.

2. [Install AWS services](../install-aws-services.hbs.md)

## <a id="about"></a> About this tutorial

**Target user roles**:      Service Operator, Application Operator, Application Developer<br />
**Complexity**:             Medium<br />
**Estimated time**:         45 minutes<br />
**Topics covered**:         AWS, RDS, PostgreSQL, Classes, Claims,<br />
**Learning outcomes**:      An understanding of how to configure and provision RDS PostgreSQL instances on Tanzu Application Platform using the AWS Services Package<br />

## <a id="create-a-providerconfig"></a> Step 4: Create a ProviderConfig
<!-- is this an install step? Or could this be a how to on its own with a title eg "Configure credentials and access information for your AWS account" -->
The `ProviderConfig` resource is the mechanism through which you configure credentials and access information for your AWS account. For sake of simplicity, in this tutorial we will create a `ProviderConfig` using the `Secret` source, in which your AWS account credentials will be stored in a `Secret` on the cluster. However there are alternative methods available, including an option to assume an IAM Role. Refer to the [official ProviderConfig documentation](https://marketplace.upbound.io/providers/upbound/provider-family-aws/latest/resources/aws.upbound.io/ProviderConfig/v1beta1) to learn about the full range of configuration options available.

First, let's create the `Secret` to hold the AWS credentials.

```console
export AWS_ACCESS_KEY_ID="foo"
export AWS_SECRET_ACCESS_KEY="bar"

echo -e "[default]\naws_access_key_id = $AWS_ACCESS_KEY_ID\naws_secret_access_key = $AWS_SECRET_ACCESS_KEY" > creds.conf

# (optional) if you are required to use a session token to access your AWS account, you must also set AWS_SESSION_TOKEN
# export AWS_SESSION_TOKEN=""
# echo -e "aws_session_token = $AWS_SESSION_TOKEN" >> creds.conf

kubectl create secret generic aws-creds -n crossplane-system --from-file=creds=./creds.conf
rm -f creds.conf
```

Now create a `ProviderConfig` and configure it with the `Secret` source. Note that the `metadata.name` of your `ProviderConifg` must match the `postgresql.provider_config_ref.name` value you have configured in your `aws-services-values.yaml` file (`default` by default).

```console
kubectl apply -f -<<EOF
---
apiVersion: aws.upbound.io/v1beta1
kind: ProviderConfig
metadata:
  name: default
spec:
  credentials:
    source: Secret
    secretRef:
      namespace: crossplane-system
      name: aws-creds
      key: creds
EOF
```

You can confirm that everything has been setup correctly by inspecting the resources created as part of the installation of the Package - the `SubnetGroup` and `SecurityGroups`.

```console
kubectl get securitygroup
kubectl get subnetgroup
```

Both resources should report `SYNCED: True`, meaning that the AWS Providers have been able to successfully connect to your AWS account and to pull down information about each of the resources. And with that, we are now ready to switch hats to the role of the Application Operator and Developer and to learn how to discover, claim and bind to RDS PostgreSQL service instances. These steps are almost exactly the same as for any other service (e.g. any of the [Bitnami Services](../../bitnami-services/about.hbs.md)).

## <a id="discover-available-aws-services"></a> Step 5: Discover the list of available AWS Services

Discover the list of available services by running:

```console
tanzu service class list
```

You should see one named `postgresql-managed-aws`. You can learn more about the service (including which claim paramaters are provided) by running:

```console
tanzu service class get postgresql-managed-aws
```

## <a id="create-a-claim-aws-rds-postgresql"></a> Step 6: Create a claim for an instance of the AWS RDS PostgreSQL service

Now, let's create a claim for the class.

```console
tanzu service class-claim create rds-psql-1 --class postgresql-managed-aws
```

It will take in the region of 5-10 minutes for the service instance to actually be provisioned. You can watch the claim and wait for it to transition into a `READY: True` state to know when it is ready to use.

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
