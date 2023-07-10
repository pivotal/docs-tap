# Configure dynamic provisioning of AWS RDS service instances

This Services Toolkit topic for [service operators](../reference/terminology-and-user-roles.hbs.md#so)
explains how you set up dynamic provisioning.
This enables app development teams to self-serve AWS RDS service instances that are customized.

If you are not already familiar with dynamic provisioning in Tanzu Application Platform,
following the tutorial
[Set up dynamic provisioning of service instances](../tutorials/setup-dynamic-provisioning.hbs.md)
might help you to understand the steps presented in this topic.

## <a id="prereqs"></a> Prerequisites

Before you configure dynamic provisioning, you must have:

- Access to a Tanzu Application Platform cluster v1.6.1 or later.
- The Tanzu services CLI plug-in v0.7.0 or later.
- Access to AWS.

## <a id="config-dynamic-provisioning"></a> Configure dynamic provisioning

To configure dynamic provisioning for AWS RDS service instances, you must:

1. [Install the AWS Provider for Crossplane](#install-aws-provider)
2. [Create a CompositeResourceDefinition](#compositeresourcedef)
3. [Create a Composition](#create-composition)
4. [Make the service discoverable](#make-discoverable)
5. [Configure RBAC](#configure-rbac)
6. [Verify your configuration](#verify)

### <a id="install-aws-provider"></a> Install the AWS Provider for Crossplane

The first step is to install the AWS `Provider` for Crossplane.

The following variants of AWS `Provider` are available:

- [crossplane-contrib/provider-aws](https://marketplace.upbound.io/providers/crossplane-contrib/provider-aws/)
- [upbound/provider-aws](https://marketplace.upbound.io/providers/upbound/provider-aws/)
- [upbound/provider-family-aws](https://marketplace.upbound.io/providers/upbound/provider-family-aws/)

VMware recommends that you use the [upbound/provider-family-aws](https://marketplace.upbound.io/providers/upbound/provider-family-aws/).
This variant is both fully supported by Upbound and also gives you more control when installing APIs.
This helps to improve performance issues often associated with the more monolithic
[upbound/provider-aws](https://marketplace.upbound.io/providers/upbound/provider-aws/).
For more information about how Crossplane is resolving the Provider CRD scaling problem, see the
[Crossplane Blog](https://blog.crossplane.io/crd-scaling-provider-families/).

You must install both the top-level family Provider and the `provider-aws-rds` Provider. To do so:

1. Create a file named `provider-family-aws.yaml` and copy in the following contents, which configures
   both Providers:

    ```yaml
    # provider-family-aws.yaml

    ---
    # The AWS "family" Provider - manages the ProviderConfig for all other Providers in the same family.
    # Does not have to be created explicitly, if not created explicitly it will be installed by the first Provider created
    # in the family.
    apiVersion: pkg.crossplane.io/v1
    kind: Provider
    metadata:
      name: upbound-provider-family-aws
    spec:
      package: xpkg.upbound.io/upbound/provider-family-aws:v0.36.0
      controllerConfigRef:
        name: upbound-provider-family-aws
    ---
    # The AWS RDS Provider - just one of the many Providers in the AWS family.
    # You can add as few or as many additional Providers in the same family as you wish.
    apiVersion: pkg.crossplane.io/v1
    kind: Provider
    metadata:
      name: upbound-provider-aws-rds
    spec:
      package: xpkg.upbound.io/upbound/provider-aws-rds:v0.36.0
      controllerConfigRef:
        name: upbound-provider-family-aws
    ---
    # The ControllerConfig applies settings to a Provider Pod.
    # With family Providers each Provider is a unique Pod running in the cluster.
    apiVersion: pkg.crossplane.io/v1alpha1
    kind: ControllerConfig
    metadata:
      name: upbound-provider-family-aws
    ```

1. Apply the file to the Tanzu Application Platform cluster by running:

    ```console
    kubectl apply -f provider-family-aws.yaml
    ```

1. Verify that both Providers are installed by running:

    ```console
    kubectl get providers
    ```

    From the output, confirm that `INSTALLED=True` and `HEALTHY=TRUE`.

1. Create a `ProviderConfig` for the Providers. For instructions, see the sections
   _Create a Kubernetes secret for AWS_ and _Create a ProviderConfig_ in the
   [Upbound documentation](https://marketplace.upbound.io/providers/upbound/provider-aws/v0.36.0/docs/quickstart).

    > **Important** The Upbound documentation assumes Crossplane is installed in the `upbound-system` namespace.
    > However, when working with Crossplane on Tanzu Application Platform, it is installed to the `crossplane-system` namespace.
    > Ensure that you use the correct namespace when you create the `Secret` with credentials for the `Provider`.
    > **Note** Depending on the setup of your AWS account, you might also need to include `aws_session_token` in the `Secret`.

### <a id="compositeresourcedef"></a> Create a CompositeResourceDefinition

To create the CompositeResourceDefinition (XRD):

1. Create a file named `xpostgresqlinstances.database.rds.example.org.xrd.yaml` and copy in the
   following contents:

    ```yaml
    # xpostgresqlinstances.database.rds.example.org.xrd.yaml

    ---
    apiVersion: apiextensions.crossplane.io/v1
    kind: CompositeResourceDefinition
    metadata:
      name: xpostgresqlinstances.database.rds.example.org
    spec:
      claimNames:
        kind: PostgreSQLInstance
        plural: postgresqlinstances
      connectionSecretKeys:
      - type
      - provider
      - host
      - port
      - database
      - username
      - password
      group: database.rds.example.org
      names:
        kind: XPostgreSQLInstance
        plural: xpostgresqlinstances
      versions:
      - name: v1alpha1
        referenceable: true
        schema:
          openAPIV3Schema:
            properties:
              spec:
                properties:
                  storageGB:
                    type: integer
                    default: 20
                type: object
            type: object
        served: true
    ```

    This XRD configures the parameter `storageGB`. This gives application teams the option to choose
    a suitable amount of storage for the AWS RDS service instance when they create a claim.
    You can choose to expose as many or as few parameters to application teams as you like.

1. Apply the file to the Tanzu Application Platform cluster by running:

    ```console
    kubectl apply -f xpostgresqlinstances.database.rds.example.org.xrd.yaml
    ```

### <a id="create-composition"></a> Create a Composition

To create the composition:

1. Create a file named `xpostgresqlinstances.database.rds.example.org.composition.yaml` and copy in the
   following contents:

    ```yaml
    # xpostgresqlinstances.database.rds.example.org.composition.yaml

    ---
    apiVersion: apiextensions.crossplane.io/v1
    kind: Composition
    metadata:
      labels:
        provider: "aws"
        vpc: "default"
      name: xpostgresqlinstances.database.rds.example.org
    spec:
      compositeTypeRef:
        apiVersion: database.rds.example.org/v1alpha1
        kind: XPostgreSQLInstance
      publishConnectionDetailsWithStoreConfigRef:
        name: default
      resources:
      - base:
          apiVersion: rds.aws.upbound.io/v1beta1
          kind: Instance
          spec:
            forProvider:
              # NOTE: configure this section to your specific requirements
              instanceClass: db.t3.micro
              autoGeneratePassword: true
              passwordSecretRef:
                key: password
                namespace: crossplane-system
              engine: postgres
              engineVersion: "13.7"
              name: postgres
              username: masteruser
              publiclyAccessible: true                # <---- DANGER
              region: us-east-1
              skipFinalSnapshot: true
            writeConnectionSecretToRef:
              namespace: crossplane-system
        connectionDetails:
        - name: type
          value: postgresql
        - name: provider
          value: aws
        - name: database
          value: postgres
        - fromConnectionSecretKey: username
        - fromConnectionSecretKey: password
        - name: host
          fromConnectionSecretKey: endpoint
        - fromConnectionSecretKey: port
        name: instance
        patches:
        - fromFieldPath: metadata.uid
          toFieldPath: spec.forProvider.passwordSecretRef.name
          transforms:
          - string:
              fmt: '%s-postgresql-pw'
              type: Format
            type: string
          type: FromCompositeFieldPath
        - fromFieldPath: metadata.uid
          toFieldPath: spec.writeConnectionSecretToRef.name
          transforms:
          - string:
              fmt: '%s-postgresql'
              type: Format
            type: string
          type: FromCompositeFieldPath
        - fromFieldPath: spec.storageGB
          toFieldPath: spec.forProvider.allocatedStorage
          type: FromCompositeFieldPath
    ```

    This Composition configures all RDS PostgreSQL instances as follows:

    - All instances are placed in the `us-east-1` region.
    - All instances use the default Virtual Private Cloud (VPC) for the respective AWS account.
    - All instances are publicly accessible over the Internet.

    > **Note** If you want to keep the instances publicly accessible over the Internet and use the
    > default VPC, you must add an inbound rule for TCP on port 5432 to the security group of the
    > default VPC to allow connection to the instances.

1. Configure the Composition you just copied to your specific requirements.

    If you do not want the RDS PostgreSQL instances to be publicly accessible over the Internet,
    edit the Composition as required.
    Specific requirements vary, but this might include composing a combination of VPCs,
    Subnets, SubnetGroups, Routes, SecurityGroups, and SecurityGroupRules.
    Refer to Compositions that are available online for inspiration and guidance.
    For example, see `getting-started-with-aws-with-vpc` in the [Upbound documentation](https://marketplace.upbound.io/configurations/xp/getting-started-with-aws-with-vpc/v1.12.2/compositions/vpcpostgresqlinstances.aws.database.example.org/database.example.org/XPostgreSQLInstance).
    This example defines a Composition that creates a separate VPC for each RDS PostgreSQL instance
    and automatically configures inbound rules.
    If you want to follow this example, you might need to install additional Providers from the
    AWS Provider Family, such as
    [upbound/provider-aws-ec2](https://marketplace.upbound.io/providers/upbound/provider-aws-ec2/v0.36.0).

1. Apply the file to the Tanzu Application Platform cluster by running:

    ```console
    kubectl apply -f xpostgresqlinstances.database.rds.example.org.composition.yaml
    ```

### <a id="make-discoverable"></a> Make the service discoverable

To make the service discoverable to application teams:

1. Create a file named `rds.class.yaml` and copy in the following contents:

    ```yaml
    # rds.class.yaml

    ---
    apiVersion: services.apps.tanzu.vmware.com/v1alpha1
    kind: ClusterInstanceClass
    metadata:
      name: aws-rds-psql
    spec:
      description:
        short: Amazon AWS RDS PostgreSQL
      provisioner:
        crossplane:
          compositeResourceDefinition: xpostgresqlinstances.database.rds.example.org
    ```

1. Apply the file to the Tanzu Application Platform cluster by running:

    ```console
    kubectl apply -f rds.class.yaml
    ```

### <a id="configure-rbac"></a> Configure RBAC

To configure Role-Based Access Control (RBAC) to authorize users with the app-operator role to claim
from the class:

1. Create a file named `app-operator-claim-aws-rds-psql.rbac.yaml` and copy in the following contents:

    ```yaml
    # app-operator-claim-aws-rds-psql.rbac.yaml

    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRole
    metadata:
      name: app-operator-claim-aws-rds-psql
      labels:
        apps.tanzu.vmware.com/aggregate-to-app-operator-cluster-access: "true"
    rules:
    - apiGroups:
      - "services.apps.tanzu.vmware.com"
      resources:
      - clusterinstanceclasses
      resourceNames:
      - aws-rds-psql
      verbs:
      - claim
    ```

1. Apply the file to the Tanzu Application Platform cluster by running:

    ```console
    kubectl apply -f app-operator-claim-aws-rds-psql.rbac.yaml
    ```

### <a id="verify"></a> Verify your configuration

To verify your configuration, create a claim for an AWS RDS service instance by running:

```console
tanzu service class-claim create rds-psql-1 --class aws-rds-psql -p storageGB=30
```

> **Note** Whether application workloads can establish network connectivity to the
> resulting RDS database depends on a number of factors. This includes specifics about the environment you're
> working in and the configuration in the `Composition` file. At a minimum, you can
> configure a `securityGroup` to permit inbound traffic. There might be other requirements as well.
