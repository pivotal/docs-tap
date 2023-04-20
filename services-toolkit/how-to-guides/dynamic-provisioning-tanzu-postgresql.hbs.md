# Configure dynamic provisioning of VMware Tanzu Postgres service instances

This topic describes how to set up dynamic provisioning to enable the creation of self-serve
VMware Tanzu Postgres service instances that are customized to your needs. <!-- is this correct? which role does the set up and which role creates the services instance? -->

If you are not already familiar with dynamic provisioning in Tanzu Application Platform,
following the tutorial
[Set up dynamic provisioning of service instances](../tutorials/setup-dynamic-provisioning.hbs.md).
might be help you understand the steps presented in this topic.

## <a id="prereqs"></a> Prerequisites

Before you configure dynamic provisioning, you must have:

- Access to a Tanzu Application Platform cluster v1.5.0 or later.

<!-- - The Tanzu services CLI plug-in v0.6.0 or later? -->

## <a id="config-dynamic-provisioning"></a> Configure dynamic provisioning

To configure dynamic provisioning for VMware Tanzu Postgres services instances, you must:

1. [Install the Tanzu VMware Postgres Operator](#install-postgres-operator)
2. [Set up the namespace](#set-up-namespace)
3. [Create a CompositeResourceDefinition](#compositeresourcedef)
4. [Create a Composition](#create-composition)
5. [Make the service discoverable](#make-discoverable)
6. [Configure RBAC](#configure-rbac)

### <a id="install-postgres-operator"></a> Install the Tanzu VMware Postgres Operator

Install the Tanzu VMware Postgres Operator by following the steps in
[Installing a VMware Postgres Operator](https://docs.vmware.com/en/VMware-SQL-with-Postgres-for-Kubernetes/2.0/vmware-postgres-k8s/GUID-install-operator.html).

### <a id="set-up-namespace"></a> Set up the namespace

This topic configures dynamic provisioning to provision all Tanzu Postgres service instances into the
same namespace. This namespace is named `tanzu-psql-service-instances`.

To set up the namespace:

1. Ensure that the namespace exists by running the following:

   ```console
   kubectl create namespace tanzu-psql-service-instances
   ```

2. The Tanzu Postgres Operator also requires that a secret holding registry credentials exists in the
   same namespace that the service instances will be created in.
   Ensure that the secret exists in the namespace by running:

   ```console
   kubectl create secret --namespace=tanzu-psql-service-instances docker-registry regsecret \
     --docker-server=https://registry.tanzu.vmware.com \
     --docker-username=`USERNAME` \
     --docker-password=`PASSWORD`
   ```

   Where:

   - `USERNAME` is your registry user name.
   - `PASSWORD` is your registry password.

   > **Note** You must update the `--docker-server` value if you relocated images as part of the installation
   > of the operator.

### <a id="compositeresourcedef"></a> Create a CompositeResourceDefinition

To create the CompositeResourceDefinition (XRD):

1. Create a file named `xpostgresqlinstances.database.tanzu.example.org.xrd.yaml` and copy in the
   following contents:

   ```yaml
   # xpostgresqlinstances.database.tanzu.example.org.xrd.yaml

   ---
   apiVersion: apiextensions.crossplane.io/v1
   kind: CompositeResourceDefinition
   metadata:
     name: xpostgresqlinstances.database.tanzu.example.org
   spec:
     connectionSecretKeys:
     - provider
     - type
     - database
     - host
     - password
     - port
     - uri
     - username
     group: database.tanzu.example.org
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
   a suitable amount of storage for the Tanzu Postgres service instance when they create a claim.
   You can choose to expose as many or as few parameters to application teams as you like.

2. Apply the file to the Tanzu Application Platform cluster by running:

   ```console
   kubectl apply -f xpostgresqlinstances.database.tanzu.example.org.xrd.yaml
   ```

### <a id="create-composition"></a> Create a Composition

To create the Composition:

1. Create a file named `xpostgresqlinstances.database.tanzu.example.org.composition.yaml` and copy in the
   following contents:

   ```yaml
   # xpostgresqlinstances.database.tanzu.example.org.composition.yaml

   ---
   apiVersion: apiextensions.crossplane.io/v1
   kind: Composition
   metadata:
     name: xpostgresqlinstances.database.tanzu.example.org
   spec:
     compositeTypeRef:
       apiVersion: database.tanzu.example.org/v1alpha1
       kind: XPostgreSQLInstance
     publishConnectionDetailsWithStoreConfigRef:
       name: default
     resources:
     - base:
         apiVersion: kubernetes.crossplane.io/v1alpha1
         kind: Object
         spec:
           forProvider:
             manifest:
               apiVersion: sql.tanzu.vmware.com/v1
               kind: Postgres
               metadata:
                 name: PATCHED
                 namespace: tanzu-psql-service-instances
               spec:
                 storageSize: 2G
           connectionDetails:
           - apiVersion: v1
             kind: Secret
             namespace: tanzu-psql-service-instances
             fieldPath: data.provider
             toConnectionSecretKey: provider
           - apiVersion: v1
             kind: Secret
             namespace: tanzu-psql-service-instances
             fieldPath: data.type
             toConnectionSecretKey: type
           - apiVersion: v1
             kind: Secret
             namespace: tanzu-psql-service-instances
             fieldPath: data.host
             toConnectionSecretKey: host
           - apiVersion: v1
             kind: Secret
             namespace: tanzu-psql-service-instances
             fieldPath: data.port
             toConnectionSecretKey: port
           - apiVersion: v1
             kind: Secret
             namespace: tanzu-psql-service-instances
             fieldPath: data.username
             toConnectionSecretKey: username
           - apiVersion: v1
             kind: Secret
             namespace: tanzu-psql-service-instances
             fieldPath: data.password
             toConnectionSecretKey: password
           - apiVersion: v1
             kind: Secret
             namespace: tanzu-psql-service-instances
             fieldPath: data.database
             toConnectionSecretKey: database
           - apiVersion: v1
             kind: Secret
             namespace: tanzu-psql-service-instances
             fieldPath: data.uri
             toConnectionSecretKey: uri
           writeConnectionSecretToRef:
             namespace: tanzu-psql-service-instances
       connectionDetails:
       - fromConnectionSecretKey: provider
       - fromConnectionSecretKey: type
       - fromConnectionSecretKey: host
       - fromConnectionSecretKey: port
       - fromConnectionSecretKey: username
       - fromConnectionSecretKey: password
       - fromConnectionSecretKey: database
       - fromConnectionSecretKey: uri
       patches:
         - fromFieldPath: metadata.name
           toFieldPath: spec.forProvider.manifest.metadata.name
           type: FromCompositeFieldPath
         - fromFieldPath: spec.storageSize
           toFieldPath: spec.forProvider.manifest.spec.persistence.storage
           transforms:
           - string:
               fmt: '%dG'
               type: Format
             type: string
           type: FromCompositeFieldPath
         - fromFieldPath: metadata.name
           toFieldPath: spec.writeConnectionSecretToRef.name
           transforms:
           - string:
               fmt: '%s-psql'
               type: Format
             type: string
           type: FromCompositeFieldPath
         - fromFieldPath: metadata.name
           toFieldPath: spec.connectionDetails[0].name
           transforms:
           - string:
               fmt: '%s-app-user-db-secret'
               type: Format
             type: string
           type: FromCompositeFieldPath
         - fromFieldPath: metadata.name
           toFieldPath: spec.connectionDetails[1].name
           transforms:
           - string:
               fmt: '%s-app-user-db-secret'
               type: Format
             type: string
           type: FromCompositeFieldPath
         - fromFieldPath: metadata.name
           toFieldPath: spec.connectionDetails[2].name
           transforms:
           - string:
               fmt: '%s-app-user-db-secret'
               type: Format
             type: string
           type: FromCompositeFieldPath
         - fromFieldPath: metadata.name
           toFieldPath: spec.connectionDetails[3].name
           transforms:
           - string:
               fmt: '%s-app-user-db-secret'
               type: Format
             type: string
           type: FromCompositeFieldPath
         - fromFieldPath: metadata.name
           toFieldPath: spec.connectionDetails[4].name
           transforms:
           - string:
               fmt: '%s-app-user-db-secret'
               type: Format
             type: string
           type: FromCompositeFieldPath
         - fromFieldPath: metadata.name
           toFieldPath: spec.connectionDetails[5].name
           transforms:
           - string:
               fmt: '%s-app-user-db-secret'
               type: Format
             type: string
           type: FromCompositeFieldPath
         - fromFieldPath: metadata.name
           toFieldPath: spec.connectionDetails[6].name
           transforms:
           - string:
               fmt: '%s-app-user-db-secret'
               type: Format
             type: string
           type: FromCompositeFieldPath
         - fromFieldPath: metadata.name
           toFieldPath: spec.connectionDetails[7].name
           transforms:
           - string:
               fmt: '%s-app-user-db-secret'
               type: Format
             type: string
           type: FromCompositeFieldPath
       readinessChecks:
         - type: MatchString
           fieldPath: status.atProvider.manifest.status.currentState
           matchString: "Running"
   ```

2. Configure the Composition you just copied to your specific requirements.

3. Apply the file to the Tanzu Application Platform cluster by running:

   ```console
   kubectl apply -f xpostgresqlinstances.database.tanzu.example.org.composition.yaml
   ```

### <a id="make-discoverable"></a> Make the service discoverable

To make the service discoverable to application teams:

1. Create a file named `tanzu-psql.class.yaml` and copy in the following contents:

   ```yaml
   # tanzu-psql.class.yaml

   ---
   apiVersion: services.apps.tanzu.vmware.com/v1alpha1
   kind: ClusterInstanceClass
   metadata:
     name: tanzu-psql
   spec:
     description:
       short: VMware Tanzu Postgres
     provisioner:
       crossplane:
         compositeResourceDefinition: xpostgresqlinstances.database.tanzu.example.org
   ```

1. Apply the file to the Tanzu Application Platform cluster by running:

   ```console
   kubectl apply -f tanzu-psql.class.yaml
   ```

### <a id="configure-rbac"></a> Configure RBAC

To configure access control with RBAC:

1. Create a file named `provider-kubernetes-tanzu-postgres-read-writer.rbac.yaml` and copy in the
   following contents:

   ```yaml
   # provider-kubernetes-tanzu-postgres-read-writer.rbac.yaml

   ---
   apiVersion: rbac.authorization.k8s.io/v1
   kind: ClusterRole
   metadata:
     name: tanzu-postgres-read-writer
     labels:
       services.tanzu.vmware.com/aggregate-to-provider-kubernetes: "true"
   rules:
   - apiGroups:
     - sql.tanzu.vmware.com
     resources:
     - postgres
     verbs:
     - "*"
   ```

1. Apply the file to the Tanzu Application Platform cluster by running:

   ```console
   kubectl apply -f provider-kubernetes-tanzu-postgres-read-writer.rbac.yaml
   ```

1. Create a file named `app-operator-claim-tanzu-psql.rbac.yaml` and copy in the following contents:

   ```yaml
   # app-operator-claim-tanzu-psql.rbac.yaml

   apiVersion: rbac.authorization.k8s.io/v1
   kind: ClusterRole
   metadata:
     name: app-operator-claim-tanzu-psql
     labels:
       apps.tanzu.vmware.com/aggregate-to-app-operator-cluster-access: "true"
   rules:
   - apiGroups:
     - "services.apps.tanzu.vmware.com"
     resources:
     - clusterinstanceclasses
     resourceNames:
     - tanzu-psql
     verbs:
     - claim
   ```

1. Apply the file to the Tanzu Application Platform cluster by running:

   ```console
   kubectl apply -f app-operator-claim-tanzu-psql.rbac.yaml
   ```

## <a id="create-claim"></a> Create a claim

To use dynamic provisioning to create a Tanzu Postgres service instance, run:

```console
tanzu service class-claim create tanzu-psql-1 --class tanzu-psql -p storageGB=5
```
