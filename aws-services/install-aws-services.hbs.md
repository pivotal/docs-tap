# Install AWS Services

This topic tells you how to install AWS Services from the Tanzu Application Platform
(commonly known as TAP) package repository.

> **Note** The AWS Service package in not in any of the Tanzu Application Platform profiles.
> To use this package, you must follow the instructions in this topic.

## Prerequisites

1. Before starting this tutorial it is recommended to first read through [Understanding the AWS Services Package](../concepts/understanding-the-aws-services-package.hbs.md). This will provide you with useful background context about the features and goals of the Package, as well as some of the considerations and compromises that have been made as part of its development.

## <a id="infra-planning-setup-configuration"></a> Step 1: Infrastructure planning, setup and configuration

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

## <a id="install-the-aws-services-package"></a> Step 2: Install the AWS Services package

The AWS Services package is not installed as part of any profile so you must explicitly install it.

1. Check that you have the AWS Services package available by running:

    ```console
    tanzu package available get aws.services.tanzu.vmware.com -n tap-install
    ```

1. Prepare an `aws-services-values.yaml` file to configure the installation:

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

    <!-- consider converting comments to placeholders -->

<!-- for future-proofing should we add a step to check which versions of the package are available? -->

1. Install the AWS Services package by running:

    ```console
    tanzu package install aws-services -p aws.services.tanzu.vmware.com --version 0.1.0 -n tap-install --values-file aws-services-values.yaml
    ```

1. Verify that the package installed by running:

    ```console
    tanzu package installed get aws-services -n tap-install
    ```

    In the output, confirm that the `STATUS` value is `Reconcile succeeded`.

    For example:

    ```console
    $ tanzu package installed get aws-services -n tap-install
    NAMESPACE:          tap-install
    NAME:               aws-services
    PACKAGE-NAME:       aws.services.tanzu.vmware.com
    PACKAGE-VERSION:    0.1.0
    STATUS:             Reconcile succeeded
    CONDITIONS:         - type: ReconcileSucceeded
      status: "True"
      reason: ""
      message: ""
    ```

<!-- is this verify step correct? -->
