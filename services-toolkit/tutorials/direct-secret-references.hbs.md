# Direct Secret References

**Target user role**:       Service Operator and Application Operator<br />
**Complexity**:             Easy<br />
**Estimated time**:         10 minutes<br />
**Topics covered**:         Service Binding, Direct Secret References<br />
**Learning outcomes**:      Ability to bind workloads to almost any backing service via direct secret references<br />

## About

This tutorial leverages direct references to Kubernetes `Secret` resources to enable developers to
connect their application workloads to almost any backing service, including backing services that:

- are running external to Tanzu Application Platform
- do not adhere to the [ProvisionedService](https://github.com/servicebinding/spec#provisioned-service)
of the Service Binding Specification for Kubernetes in GitHub.

For readers who are familiar with Cloud Foundry and Tanzu Application Service, this capability is very similar to the concept of
[User-Provided Service Instances](https://docs.cloudfoundry.org/devguide/services/user-provided.html).

This particular tutorial demonstrates a procedure to bind a new application on Tanzu Application Platform
to an existing PostgreSQL database that exists in Azure. However, the steps and learnings are applicable to any backing service
that you may wish to connect to.

## Pre-requisites

* Access to a TAP cluster (version >= 1.5.0)
* An Azure PostgreSQL database to which you wish to connect

Depending on your Kubernetes distribution and the backing Service you are hoping to connect
to your Tanzu Application Platform workloads, there could be extra work to set up networking between
the workload and the service endpoint and to obtain the credentials for the backing service.
This example assumes the credentials are available and networking has been set up.

## Creating a binding-compatible Secret

1. Create a Kubernetes secret resource similar to the following example:

```yaml
# external-azure-db-binding-compatible.yaml
---
apiVersion: v1
kind: Secret
metadata:
  name: external-azure-db-binding-compatible
type: Opaque
stringData:
  type: postgresql
  provider: azure
  host: EXAMPLE.DATABASE.AZURE.COM
  port: "5432"
  database: "EXAMPLE-DB-NAME"
  username: "USER@EXAMPLE"
  password: "PASSWORD"
```

Substitute in the values as required.

When using direct secret references, the `Secret` values must abide by the [Well-known Secret Entries specifications](https://github.com/servicebinding/spec#well-known-secret-entries) as defined by the Service Binding Specification for Kubernetes.
If you are planning to bind this secret to a Spring-based application workload and want to take
advantage of the auto-wiring feature, this secret must also contain the properties required by
[Spring Cloud Bindings](https://github.com/spring-cloud/spring-cloud-bindings).

2. Apply the YAML file by running:

```console
kubectl apply -f external-azure-db-binding-compatible.yaml
```

3. Grant sufficient RBAC permissions to Services Toolkit to be able to read the secrets specified by
the class:

```yaml
# stk-secret-reader.yaml
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: stk-secret-reader
  labels:
    servicebinding.io/controller: "true"
rules:
- apiGroups:
  - ""
  resources:
  - secrets
  verbs:
  - get
  - list
  - watch
```

1. Apply your changes by running:

```console
kubectl apply -f stk-secret-reader.yaml
```

1. Create a claim for the newly created secret by running:

```console
tanzu service resource-claim create external-azure-db-claim \
  --resource-name external-azure-db-binding-compatible \
  --resource-kind Secret \
  --resource-api-version v1
```

1. Obtain the claim reference of the claim by running:

```console
tanzu service resource-claim list -o wide
```

Expect to see the following output:

```console
NAME                     READY  REASON  CLAIM REF
external-azure-db-claim  True           services.apps.tanzu.vmware.com/v1alpha1:ResourceClaim:external-azure-db-claim
```

1. Create an application workload by running a command similar to the following example:

Example:

```console
tanzu apps workload create WORKLOAD-NAME \
  --git-repo https://github.com/sample-accelerators/spring-petclinic \
  --git-branch main \
  --git-tag tap-1.2 \
  --type web \
  --label app.kubernetes.io/part-of=spring-petclinic \
  --annotation autoscaling.knative.dev/minScale=1 \
  --env SPRING_PROFILES_ACTIVE=postgres \
  --service-ref db=REFERENCE
```

Where:

  - `WORKLOAD-NAME` is the name of the Application Workload. For example, `pet-clinic`.
  - `REFERENCE` is the value of the `CLAIM REF` for the newly created claim in the output of the
  last step.
