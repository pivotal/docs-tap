# Configure dynamic provisioning of VMware Tanzu Postgres service instances

This topic details the steps required to setup dynamic provisioning of VMware Tanzu Postgres service instances.
If you are not already familiar with dynamic provisioning in Tanzu Application Platform, following
the tutorial [Setup Dynamic Provisioning of Service Instances](../tutorials/setup-dynamic-provisioning.hbs.md)
might be beneficial to understanding the steps presented here.

## <a id="prereqs"></a> Prerequisites

Before you configure dynamic provisioning, you must have:

- Access to a Tanzu Application Platform cluster v1.5.0 or later.

## <a id="stk-dynamic-provisioning-tanzu-psql-step-1"></a> Step 1: Install the Tanzu VMware Postgres Operator

The first step is to install the Tanzu VMware Postgres Operator. Follow the steps in [Installing a VMware Postgres Operator](https://docs.vmware.com/en/VMware-SQL-with-Postgres-for-Kubernetes/2.0/vmware-postgres-k8s/GUID-install-operator.html), then return here once you are done.

## <a id="stk-dynamic-provisioning-tanzu-psql-step-2"></a> Step 2: Namespace setup

This guide configures dynamic provisioning to provision all Tanzu Postgres service instances into the same namespace - a namespaced named `tanzu-psql-service-instances`. Ensure that that namespace exists by running the following.

```console
$ kubectl create namespace tanzu-psql-service-instances
```

The Tanzu Postgres Operator also requires that a `Secret` holding registry credentials exists in the same namespace as where the service instances will be created. Therefore you must ensure that that `Secret` exists in the namespace. Run the following, replacing values as necessary:

```console
kubectl create secret --namespace=tanzu-psql-service-instances docker-registry regsecret \
  --docker-server=https://registry.tanzu.vmware.com \
  --docker-username=`USERNAME` \
  --docker-password=`PASSWD`
```

    > **NOTE** You will need to update the `--docker-server` value if you reloacted images as part of the installation
    > of the operator.

## <a id="stk-dynamic-provisioning-tanzu-psql-step-3"></a> Step 3: Create CompositeResourceDefinition

Create a file named `xpostgresqlinstances.database.tanzu.example.org.xrd.yml` and copy in the following contents.

```yaml
# xpostgresqlinstances.database.tanzu.example.org.xrd.yml

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

This particular XRD configures one parameter - `storageGB`. This gives application teams the option to choose a suitable amount of storage for the Tanzu Postgres service instance when they create a claim. You can can choose to expose as many or as few parameters to application teams as you like.

Now use `kubectl` to apply the file to the TAP cluster.

```console
$ kubectl apply -f xpostgresqlinstances.database.tanzu.example.org.xrd.yml
```

## <a id="stk-dynamic-provisioning-tanzu-psql-step-4"></a> Step 4: Create Composition

Create a file named `xpostgresqlinstances.database.tanzu.example.org.composition.yml` and copy in the following contents.

```yaml
# xpostgresqlinstances.database.tanzu.example.org.composition.yml

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

This `Composition` is intended to be used as a starting point only.

Once you are happy with the configuration, use `kubectl` to apply the file to the TAP cluster.

```console
$ kubectl apply -f xpostgresqlinstances.database.tanzu.example.org.composition.yml
```

## <a id="stk-dynamic-provisioning-tanzu-psql-step-5"></a> Step 5: Make the service discoverable to application teams

Create a file named `tanzu-psql.class.yml` and copy in the following contents.

```yaml
# tanzu-psql.class.yml

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

Then use `kubectl` to apply the file to the TAP cluster.

```console
$ kubectl apply -f tanzu-psql.class.yml
```

## <a id="stk-dynamic-provisioning-tanzu-psql-step-6"></a> Step 6: Configure RBAC

Create a file named `provider-kubernetes-tanzu-postgres-read-writer.rbac.yml` and copy in the following contents.

```yaml
# provider-kubernetes-tanzu-postgres-read-writer.rbac.yml

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

Then use `kubectl` to apply the file to the TAP cluster.

```console
kubectl apply -f provider-kubernetes-tanzu-postgres-read-writer.rbac.yml
```

Create a file named `app-operator-claim-tanzu-psql.rbac.yml` and copy in the following contents.

```yaml
# app-operator-claim-tanzu-psql.rbac.yml

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

Then use `kubectl` to apply the file to the TAP cluster.

```console
$ kubectl apply -f app-operator-claim-tanzu-psql.rbac.yml
```

## <a id="stk-dynamic-provisioning-tanzu-psql-step-7"></a> Step 7: Take it for a spin

```console
$ tanzu service class-claim create tanzu-psql-1 --class tanzu-psql -p storageGB=5
```
