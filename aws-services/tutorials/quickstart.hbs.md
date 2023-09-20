# Quickstart

A quick introduction to the AWS Services Package to get you up and running with AWS Services on Tanzu Application Platform.

## <a id="about"></a> About this tutorial

**Target user roles**:      Service Operator, Application Operator, Application Developer<br />
**Complexity**:             Medium<br />
**Estimated time**:         45 minutes<br />
**Topics covered**:         AWS, RDS, PostgreSQL, Classes, Claims,<br />
**Learning outcomes**:      An understanding of how to configure and provision RDS PostgreSQL instances on Tanzu Application Platform using the AWS Services Package<br />

## <a id="understanding-the-aws-services-package"></a> Step 1: Understanding the AWS Services Package

Before starting this tutorial it is recommended to first read through [Understanding the AWS Services Package](../concepts/understanding-the-aws-services-package.hbs.md). This will provide you with useful background context about the features and goals of the Package, as well as some of the considerations and compromises that have been made as part of its development.

## <a id="infra-planning-setup-configuration"></a> Step 2: Infrastructure planning, setup and configuration

There are a wide range of possible infrastructure and networking setups available when it comes to integrating AWS services into Tanzu Application Platform. Therefore the first step is to decide which of these setups you'd like to configure the AWS Services Package for. The full list of topologies currently supported by the AWS Services Package can be found in [Supported Topologies](../reference/supported-topologies.hbs.md), but in order to bring focus to this tutorial, we'll run with arguably the most simple of setups:

* TAP cluster running on AWS EKS in VPC A connecting to RDS PostgreSQL service instances running in VPC A

This setup can be thought of as quite similar to [A DB instance in a VPC accessed by an EC2 instance in the same VPC](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_VPC.Scenarios.html#USER_VPC.Scenario1) as described in the official AWS documentation. Given we will be using this setup for the rest of this tutorial, it is assumed that you already have a TAP cluster running in a VPC in AWS to hand. If you don't, please refer to [Install Tanzu Application Platform (AWS)](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.6/tap/install-aws-intro.html).

Now that we know the sort of infrastructure setup we'd like to configure, the next step is to understand what sort of configuration options are provided and required by the AWS Services Package to help us configure that setup. The full list of values can be found in the reference material [Package values for AWS Services](../reference/package-values.hbs.md), with a few of the most important values picked out and highlighted below.

```yaml
postgresql:
  enabled: true
  region: us-east-1
  infrastructure:
    subnet_group:
      name: "dbsubnetgroup-1"
    security_groups:
      - id: "sg-1"
  instance_configuration:
    instance_class: db.t3.micro
```

Take particular note of the `postgresql.infrastructure` block, which contains a `subnet_group` and a `security_groups` key. This is how you configure the PostgreSQL service for the AWS Services Package with relevant infrastructure information to support the type of setup we've decided upon. It's important to understand that the current version of the AWS Services Package will not create these resources for you, meaning that they must be created manually out-of-band. It's possible (not guaranteed) that future versions of the AWS Services Package may provide options to create required infrastructure resources for you. For now, this is a one-time manual setup step that must be performed before installing the Package.

To learn how to create a DBSubnetGroup, refer to [Create a DB subnet group](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_VPC.WorkingWithRDSInstanceinaVPC.html#USER_VPC.CreateDBSubnetGroup). To learn how to create SecurityGroups, refer to [Creating a VPC security group](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Overview.RDSSecurityGroups.html#Overview.RDSSecurityGroups.Create).

Once created, make sure to note down the name of the DBSubnetGroup and the IDs of the SecurityGroups you create as you will need to refer to them in the next step.

## <a id="install-the-aws-services-package"></a> Step 3: Install the AWS Services Package

The AWS Services Package is not installed by default so you will need to explicitly install it. Check that you have the AWS Services Package available by running `tanzu package available get aws.services.tanzu.vmware.com -n tap-install`. Note that the Package is only available from TAP 1.7 onwards. Next, let's prepare an `aws-services-values.yaml` file to use configure the installation.

```yaml
# aws-services-values.yaml
---
# optional, add any custom CA cert data required by your installation of TAP here
# ca_cert_data:

# configuration specific to the RDS PostgreSQL service
postgresql:
  # enable the RDS PostgreSQL service by configuring enabled: true
  # the default is set to false, allowing you to selectively enable only those services you wish to use
  enabled: true
  # choose an AWS region
  region: us-east-1
  # you can optionally choose to provide a named ProviderConfig for this service rather than using the default
  # this allows you to use a different ProviderConfig per service type offered by the AWS Services Package
  # details on how to create a ProviderConfig are provided in the next step of this tutorial
  provider_config_ref:
    name: default
  # infrastructure configuration for the RDS PostgreSQL service
  infrastructure:
    subnet_group:
      name: "" # add the name of the DBSubnetGroup you created in the previous step
    security_groups:
      - id: "" # add the IDs of any Security Groups you created in the previous step
  # instance-level configuration for the RDS PostgreSQL service (applied to all service instnaces that will be created)
  instance_configuration:
    instance_class: db.t3.micro
    engine_version: "13.7"
    skip_final_snapshot: false
    publicly_accessible: false
    maintenance_window: "Wed:00:00-Wed:03:00"
```

Now install the Package by running `tanzu package install aws-services -p aws.services.tanzu.vmware.com --version 0.1.0 -n tap-install --values-file aws-services-values.yaml`

## <a id="create-a-providerconfig"></a> Step 4: Create a ProviderConfig

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
