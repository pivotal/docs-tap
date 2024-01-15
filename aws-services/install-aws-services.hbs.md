# Install AWS Services

This topic tells you how to install the AWS Services package from the Tanzu Application Platform
(commonly known as TAP) package repository.

> **Note** The AWS Services package is not in any of the Tanzu Application Platform profiles.
> To use this package, you must follow the instructions in this topic.

## <a id="prerequisites"></a> Prerequisites

Before you install the AWS Services package:

- [Install Tanzu Application Platform](../install-intro.hbs.md)
- VMware recommends that you read [About the AWS Services package](concepts/about-package.hbs.md).
  The topic provides context about the features and goals of the package, and some of the
  considerations and compromises that were made as part of its development.

## <a id="config-infra"></a> Step 1: Plan and configure your infrastructure

There are a wide range of infrastructure and networking setups available when integrating services on
AWS into Tanzu Application Platform.
Therefore, the first step is to decide which of these setups you want and to configure the AWS Services
package for this topology.

> **Note** This section provides setup guidance for the most simple setup, which is
> a Tanzu Application Platform cluster running on AWS EKS in a virtual private cloud (VPC) connecting
> to RDS PostgreSQL service instances running in the same VPC.

To plan and configure your infrastructure:

1. Decide which topology you want to use. For more information about the topologies supported by the
   AWS Services package, see [Supported Topologies](reference/supported-topologies.hbs.md).

1. Create a DBSubnetGroup and SecurityGroups:

    1. To learn how to create a DBSubnetGroup, see the [AWS documentation](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_VPC.WorkingWithRDSInstanceinaVPC.html#USER_VPC.CreateDBSubnetGroup).
    1. To learn how to create SecurityGroups, see the [AWS documentation](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Overview.RDSSecurityGroups.html#Overview.RDSSecurityGroups.Create).

    > **Note** The current version of the AWS Services package does not create these resources for you.
    > You must create them manually using the AWS console.
    > This is a one-time manual setup step that you must complete before installing the package.

1. Record the name of the DBSubnetGroup and the IDs of the SecurityGroups you created.
   These are required when installing the package.

1. Complete any remaining configuration tasks listed in [Supported Topologies](reference/supported-topologies.hbs.md).

## <a id="install-package"></a> Step 2: Install the AWS Services package

The AWS Services package is not installed as part of any profile so you must explicitly install it.
To install the AWS Services package:

1. Confirm that you have the AWS Services package available by running:

    ```console
    tanzu package available get aws.services.tanzu.vmware.com -n tap-install
    ```

1. Prepare an `aws-services-values.yaml` file to configure the installation:

    ```yaml
    # aws-services-values.yaml
    ---
    # Optional, add any custom CA certificate data required by your Tanzu Application Platform installation
    ca_cert_data: |
        -----BEGIN CERTIFICATE-----
        MIIFXzCCA0egAwIBAgIJAJYm37SFocjlMA0GCSqGSIb3DQEBDQUAMEY...
        -----END CERTIFICATE-----

    # Configuration specific to the RDS PostgreSQL service
    postgresql:
      # Enable the RDS PostgreSQL service. The default is set to false.
      enabled: true
      region: "REGION"
      provider_config_ref:
        name: "PROVIDER-CONFIG-NAME"
      # Infrastructure configuration for the RDS PostgreSQL service
      infrastructure:
        subnet_group:
          name: "SUBNET-GROUP-NAME"
        security_groups:
          - id: "SECURITY-GROUP-ID"
      # Instance-level configuration for the RDS PostgreSQL service applied to all service instances
      # All instance_configuration is optional. See below for default values.
      instance_configuration:
        instance_class: "INSTANCE-CLASS"
        engine_version: "ENGINE-VERSION"
        skip_final_snapshot: SKIP-FINAL-SNAPSHOT
        publicly_accessible: PUBLICLY-ACCESSIBLE
        maintenance_window: "MAINTENANCE-WINDOW"

    # Configuration specific to the RDS MySQL service
    mysql:
      # Enable the RDS MySQL service. The default is set to false.
      enabled: true
      region: "REGION"
      provider_config_ref:
        name: "PROVIDER-CONFIG-NAME"
      # Infrastructure configuration for the RDS MySQL service
      infrastructure:
        subnet_group:
          name: "SUBNET-GROUP-NAME"
        security_groups:
          - id: "SECURITY-GROUP-ID"
      # Instance-level configuration for the RDS MySQL service applied to all service instances
      # All instance_configuration is optional. See below for default values.
      instance_configuration:
        instance_class: "INSTANCE-CLASS"
        engine_version: "ENGINE-VERSION"
        skip_final_snapshot: SKIP-FINAL-SNAPSHOT
        publicly_accessible: PUBLICLY-ACCESSIBLE
        maintenance_window: "MAINTENANCE-WINDOW"
    ```

    Where:

    - `REGION` is the AWS region you want, for example, `us-east-1`.
    - `PROVIDER-CONFIG-NAME` is the name of the ProviderConfig for this service.
      Choose a name, or enter `default`.
      Choosing a name allows you to use a different ProviderConfig per service type offered by the
      AWS Services package.
    - `SUBNET-GROUP-NAME` is the name of the DBSubnetGroup you created in
      [Plan and configure your infrastructure](#config-infra) earlier.
    - `SECURITY-GROUP-ID` are the IDs of any security groups you created in
      [Plan and configure your infrastructure](#config-infra) earlier.
    - `INSTANCE-CLASS` is the instance type of the RDS instance. The default is `db.t3.micro`.
    - `ENGINE-VERSION` is the engine version. For PostgreSQL the default is `13.7`.
      For MySQL the default is `8.0`. You can find the list of available versions in the
      [AWS documentation](https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_CreateDBInstance.html).
    - `SKIP-FINAL-SNAPSHOT` is whether a final snapshot is created before the instance is deleted.
       If you specify `true`, no snapshot is created. If you specify `false`, a snapshot called
       `final-snapshot-INSTANCE-NAME` is created before the instance is deleted. The default is `false`.
    - `PUBLICLY-ACCESSIBLE` is whether or not PostgreSQL service instances are publicly accessible
       over the Internet. The value can be `true` or `false` depending on the topology you chose.
       See [Supported Topologies](./reference/supported-topologies.hbs.md). The default is `false`.
    - `MAINTENANCE-WINDOW` is the window to perform maintenance in. The syntax is `ddd:hh24:mi-ddd:hh24:mi`.
       The default is `Mon:00:00-Mon:03:00`.

    For the full list of values you can configure, see [Package values for AWS Services](reference/package-values.hbs.md).

1. Review which versions of AWS Services are available to install by running:

    ```console
    tanzu package available list -n tap-install aws.services.tanzu.vmware.com
    ```

    For example:

    ```console
    $ tanzu package available list -n tap-install aws.services.tanzu.vmware.com
      NAME                               VERSION           RELEASED-AT
      aws.services.tanzu.vmware.com  0.1.0             2023-11-07 14:35:15 +0000 UTC
    ```

1. Install the AWS Services package by running:

    ```console
    tanzu package install aws-services -p aws.services.tanzu.vmware.com --version VERSION-NUMBER -n tap-install --values-file aws-services-values.yaml
    ```

    Where `VERSION-NUMBER` is the AWS Services version you want to install. For example, `0.1.0`.

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

## <a id="create-a-providerconfig"></a> Step 3: Configure credentials for access to your AWS account

You configure credentials and access information for your AWS account through the `ProviderConfig` resource.

This section shows you how to create a `ProviderConfig` using the `Secret` source in which
your AWS account credentials are stored in a `Secret` on the cluster.
However, there are alternative methods, for example, an option to assume an IAM Role.
To learn about the full range of configuration options available, see the
[Upbound documentation](https://marketplace.upbound.io/providers/upbound/provider-family-aws/latest/resources/aws.upbound.io/ProviderConfig/v1beta1).

To create a `ProviderConfig` using the `Secret` source:

1. Create the `Secret` to hold the AWS credentials by running:

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

1. Create a `ProviderConfig` and configure it with the `Secret` source by running:

    ```console
    kubectl apply -f -<<EOF
    ---
    apiVersion: aws.upbound.io/v1beta1
    kind: ProviderConfig
    metadata:
      name: PROVIDER-CONFIG-NAME
    spec:
      credentials:
        source: Secret
        secretRef:
          namespace: crossplane-system
          name: aws-creds
          key: creds
    EOF
    ```

    Where `PROVIDER-CONFIG-NAME` is the `postgresql.provider_config_ref.name` value you configured
    in your `aws-services-values.yaml` file. The default is `default`.

1. Verify your setup by inspecting the `SubnetGroup` and `SecurityGroups` resources created as part
   of the installation of the package by running:

    ```console
    kubectl get securitygroup
    kubectl get subnetgroup
    ```

    When both resources report `SYNCED: True`, the AWS providers have connected to your AWS account
    and pulled down the information about each of the resources.
