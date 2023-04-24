# Configure dynamic provisioning of AWS RDS service instances

This topic describes how [service operators](../reference/terminology-and-user-roles.hbs.md#so) can
set up dynamic provisioning to enable app development teams to create self-serve AWS RDS service
instances that are customized as required.

If you are not already familiar with dynamic provisioning in Tanzu Application Platform,
following the tutorial
[Set up dynamic provisioning of service instances](../tutorials/setup-dynamic-provisioning.hbs.md).
might be help you understand the steps presented in this topic.

## <a id="prereqs"></a> Prerequisites

Before you configure dynamic provisioning, you must have:

- Access to a Tanzu Application Platform cluster v1.5.0 or later.
- The Tanzu services CLI plug-in v0.6.0 or later.
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

There are two variants of the `Provider`:

- [crossplane-contrib/provider-aws](https://marketplace.upbound.io/providers/crossplane-contrib/provider-aws/)
- [upbound/provider-aws](https://marketplace.upbound.io/providers/upbound/provider-aws/)

VMware recommends that you install the official Upbound variant.
To install the `Provider` and to create a corresponding `ProviderConfig`, see the
[Upbound documentation](https://marketplace.upbound.io/providers/upbound/provider-aws/latest/docs/quickstart).

> **Important** The official documentation for the `Provider` includes a step to "Install Universal Crossplane".
> You can skip this step because Crossplane is already installed as part of Tanzu Application Platform.
>
> The documentation also assumes Crossplane is installed in the `upbound-system` namespace.
> However, when working with Crossplane on Tanzu Application Platform, it is installed to the
> `crossplane-system` namespace by default.
> Ensure that you use the correct namespace when you create the `Secret` and the `ProviderConfig`
> with credentials for the `Provider`.

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

2. Apply the file to the Tanzu Application Platform cluster by running:

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
        apiVersion: database.aws.crossplane.io/v1beta1
        kind: RDSInstance
        spec:
          forProvider:
            # NOTE: configure this section to your specific requirements
            dbInstanceClass: db.t2.micro
            engine: postgres
            dbName: postgres
            engineVersion: "12"
            masterUsername: masteruser
            publiclyAccessible: true                # <---- DANGER
            region: us-east-1
            skipFinalSnapshotBeforeDeletion: true
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
      name: rdsinstance
      patches:
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

1. Configure the Composition you just copied to your specific requirements.

   In particular, you can deactivate the `publiclyAccessible: true` setting.
   When set to `true`, this setting opens up public access to all dynamically provisioned RDS databases.
   When set to `false`, only internal connectivity is allowed.

   To help you configure the Composition, see this example in the
   [Upbound documentation](https://marketplace.upbound.io/configurations/xp/getting-started-with-aws-with-vpc/latest/compositions/vpcpostgresqlinstances.aws.database.example.org/database.example.org/XPostgreSQLInstance).
   The example defines a composition that creates a separate VPC for each RDS PostgreSQL instance and
   automatically configures inbound rules.

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

2. Apply the file to the Tanzu Application Platform cluster by running:

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
