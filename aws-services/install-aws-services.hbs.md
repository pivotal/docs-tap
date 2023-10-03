# Install AWS Services

This topic tells you how to install AWS Services from the Tanzu Application Platform
(commonly known as TAP) package repository.

> **Note** The AWS Service package in not in any of the Tanzu Application Platform profiles.
> To use this package, you must follow the instructions in this topic.

## <a id="prerequisites"></a> Prerequisites

Before you install the AWS Services package:

- [Install Tanzu Application Platform](../install-intro.hbs.md)
- VMware recommends that you read
[Understanding the AWS Services Package](../concepts/understanding-the-aws-services-package.hbs.md).
The topic provides context about the features and goals of the package, and some of the
considerations and compromises that were made as part of its development.

## <a id="config-infra"></a> Step 1: Plan and configure your infrastructure planning

There are a wide range of infrastructure and networking setups available when integrating AWS services
into Tanzu Application Platform.
Therefore, the first step is to decide which of these setups you want and to configure the AWS Services
package for this topology.

> **Note** This section provides setup guidance for the most simple setup, which is
> a Tanzu Application Platform cluster running on AWS EKS in a virtual private cloud (VPC) connecting
> to RDS PostgreSQL service instances running in the same VPC.

To plan and configure your infrastructure:

1. Decide which topology you want to use. For more information about the topologies supported by the
   AWS Services package, see [Supported Topologies](reference/supported-topologies.hbs.md).

1. Create a DBSubnetGroup and SecurityGroups:

    - To learn how to create a DBSubnetGroup, see the [AWS documentation](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_VPC.WorkingWithRDSInstanceinaVPC.html#USER_VPC.CreateDBSubnetGroup).
    - To learn how to create SecurityGroups, see the [AWS documentation](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Overview.RDSSecurityGroups.html#Overview.RDSSecurityGroups.Create).

    > **Note** The current version of the AWS Services package does not create these resources for you.
    > You must create them manually out-of-band. <!-- what does it mean by out-of-band? -->
    > It's possible (not guaranteed) that future versions of the AWS Services package might provide options
    > to create required infrastructure resources for you. For now, this is a one-time manual setup step
    > that you must complete before installing the package.

1. Configure the AWS Services package with the settings required for your topology. For example:

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

    Take particular note of the `postgresql.infrastructure` block, which contains a `subnet_group` and
    a `security_groups` key.
    This is how you configure the PostgreSQL service for the AWS Services package with relevant
    infrastructure information to support the topology you chose. <!-- Use placeholders -->

    For the full list of values you can configure, see [Package values for AWS Services](../reference/package-values.hbs.md).

    <!-- isn't the above step duplication of what to do in step 2 of Install the AWS Services package? -->

1. Record the name of the DBSubnetGroup and the IDs of the SecurityGroups you created.
   These are required when installing the package.

## <a id="install-package"></a> Step 2: Install the AWS Services package

The AWS Services package is not installed as part of any profile so you must explicitly install it.

1. Confirm that you have the AWS Services package available by running:

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

    For the full list of values you can configure, see [Package values for AWS Services](../reference/package-values.hbs.md).

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
