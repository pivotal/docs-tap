# Configure Dynamic Provisioning of AWS RDS Service Instances

## <a id="stk-dynamic-provisioning-rds-about"></a> About

This document details the steps required to setup dynamic provisioning of AWS RDS service instances. If you are not already familiar with dynamic provisioning in Tanzu Application Platform, it is recommended to first run through the tutorial [Setup Dynamic Provisioning of Service Instances](../tutorials/setup-dynamic-provisioning.hbs.md). The learnings from that tutorial will be beneficial to understanding the steps presented here.

## <a id="stk-dynamic-provisioning-rds-pre-reqs"></a> Pre-requisites

* Access to a TAP cluster (version >= 1.5.0)
* The `tanzu services` CLI plug-in (version >= 0.6.0)
* Access to AWS

## <a id="stk-dynamic-provisioning-rds-step-1"></a> Step 1: Install the AWS Provider for Crossplane

The first step is to install the AWS `Provider` for Crossplane. There are two variants of the `Provider` - [crossplane-contrib/provider-aws](https://marketplace.upbound.io/providers/crossplane-contrib/provider-aws/) and [upbound/provider-aws](https://marketplace.upbound.io/providers/upbound/provider-aws/). VMware recommends you install the official Upbound variant. Follow the official documentation [here](https://marketplace.upbound.io/providers/upbound/provider-aws/latest/docs/quickstart) to install the `Provider` and to create a corresponding `ProviderConfig`. 

    > **Note** The official documentation for the `Provider` includes a step to "Install Universal Crossplane",
    > which you can safely skip over as Crossplane is already installed as part of TAP.
    > The documentation also assumes Crossplane to be installed in the `upbound-system` namespace,
    > however when working with Crossplane on TAP it is installed to the `crossplane-system` namespace by default.
    > Bear this in mind when it comes to creating the `Secret` and the `ProviderConfig` with credentials for the `Provider`.

## <a id="stk-dynamic-provisioning-rds-step-2"></a> Step 2: Create CompositeResourceDefinition

Create a file named `xpostgresqlinstances.database.rds.example.org.xrd.yml` and copy in the following contents.

```yaml
# xpostgresqlinstances.database.rds.example.org.xrd.yml

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

This particular XRD configures one parameter - `storageGB`. This gives application teams the option to choose a suitable amount of storage for the RDS service instance when they create a claim. You can can choose to expose as many or as few parameters to application teams as you like.

Now use `kubectl` to apply the file to the TAP cluster.

```console
$ kubectl apply -f xpostgresqlinstances.database.rds.example.org.xrd.yml
```

## <a id="stk-dynamic-provisioning-rds-step-3"></a> Step 3: Create Composition

Create a file named `xpostgresqlinstances.database.rds.example.org.composition.yml` and copy in the following contents.

```yaml
# xpostgresqlinstances.database.rds.example.org.composition.yml

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

This `Composition` is intended to be used as a starting point only. You will likely need to update the `forProvider` configuration to your specific requirements. In particular note the `publiclyAccessible: true` setting, which has the effect of opening up public access to all dynamically provisioned RDS databases. You will most likely want to disable this setting and to instead configure internal connectivity. You may wish to seek inspiration from [this example](https://marketplace.upbound.io/configurations/xp/getting-started-with-aws-with-vpc/latest/compositions/vpcpostgresqlinstances.aws.database.example.org/database.example.org/XPostgreSQLInstance), which defines a composition that creates a separate VPC for each RDS PostgreSQL instance and automatically configures inbound rules.

Once you are happy with the configuration, use `kubectl` to apply the file to the TAP cluster.

```console
$ kubectl apply -f xpostgresqlinstances.database.rds.example.org.composition.yml
```

## <a id="stk-dynamic-provisioning-rds-step-4"></a> Step 4: Make the service discoverable to application teams

Create a file named `rds.class.yml` and copy in the following contents.

```yaml
# rds.class.yml

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

Then use `kubectl` to apply the file to the TAP cluster.

```console
$ kubectl apply -f rds.class.yml
```

## <a id="stk-dynamic-provisioning-rds-step-5"></a> Step 5: Authorize users with the app-operator role to claim from the class

Create a file named `app-operator-claim-aws-rds-psql.rbac.yml` and copy in the following contents.

```yaml
# app-operator-claim-aws-rds-psql.rbac.yml

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

Then use `kubectl` to apply the file to the TAP cluster.

```console
$ kubectl apply -f app-operator-claim-aws-rds-psql.rbac.yml
```

## <a id="stk-dynamic-provisioning-rds-step-6"></a> Step 6: Take it for a spin

```console
$ tanzu service class-claim create rds-psql-1 --class aws-rds-psql -p storageGB=30
```

    > **NOTE** Whether or not it is possible for application Workloads to establish network connectivity to the
    > resulting RDS database is dependent on a number of factors, including specifics about the environment you're
    > working in, as well as the configuration used in the `Composition`. At a minimum you will likely need to
    > configure a `securityGroup` to permit inbound traffic, but there may be other requirements as well.
