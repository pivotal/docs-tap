# Using direct secret references

In this Services Toolkit tutorial you learn how developers can use direct references to Kubernetes `Secret`
resources to connect their application workloads to almost any backing service.

This includes backing services that:

- Run external to Tanzu Application Platform
- Do not adhere to [ProvisionedService](https://github.com/servicebinding/spec#provisioned-service)
in the Service Binding Specification for Kubernetes in GitHub.

If you are familiar with Cloud Foundry and Tanzu Application Service, this capability is
similar to the concept of user-provided service instances.
For more information about user-provided service instances in Cloud Foundry, see the
[Cloud Foundry documentation](https://docs.cloudfoundry.org/devguide/services/user-provided.html).

This tutorial demonstrates a procedure to bind a new application on Tanzu Application Platform
to an existing PostgreSQL database that exists in Azure.
However, the steps are applicable to any backing service that you want to connect to.

## <a id="about"></a> About this tutorial

**Target user role**:       Service Operator and Application Operator<br />
**Complexity**:             Easy<br />
**Estimated time**:         10 minutes<br />
**Topics covered**:         Service Binding, Direct Secret References<br />
**Learning outcomes**:      Ability to bind workloads to almost any backing service using direct secret references<br />

## <a id="prereqs"></a> Prerequisites

Before you can follow this tutorial, you must have:

- Access to a Tanzu Application Platform cluster v1.5.0 or later.
- An Azure PostgreSQL database to connect to.
- Configured networking between the workload and the service endpoint and you must have the
  credentials for the backing service. Whether this requires extra steps depends on your
  Kubernetes distribution and the backing service you want to connect your
  Tanzu Application Platform workloads to.

## <a id="create-secret"></a> Create a binding-compatible secret

1. Create a file named `external-azure-db-binding-compatible.yaml` and enter a
   Kubernetes secret resource similar to the following example:

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

    When using direct secret references, the `Secret` values must abide by the
    [Well-known Secret Entries specifications](https://github.com/servicebinding/spec#well-known-secret-entries)
    as defined by the Service Binding Specification for Kubernetes.
    If you plan to bind this secret to a Spring-based application workload and want to take
    advantage of the auto-wiring feature, this secret must also contain the properties required by
    [Spring Cloud Bindings](https://github.com/spring-cloud/spring-cloud-bindings).

2. Apply the YAML file by running:

    ```console
    kubectl apply -f external-azure-db-binding-compatible.yaml
    ```

    If you are using a multicluster Tanzu Application Platform topology, apply the YAML file to all
    Run clusters.

3. In a file named `stk-secret-reader.yaml`, grant sufficient Role-Based Access Control (RBAC)
   permissions to permit Services Toolkit to read the secrets specified by the class:

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

4. Apply your changes by running:

    ```console
    kubectl apply -f stk-secret-reader.yaml
    ```

    If you are using a multicluster Tanzu Application Platform topology, apply the YAML file to all
    Run clusters.

5. Create a claim for the newly created secret by running:

    ```console
    tanzu service resource-claim create external-azure-db-claim \
      --resource-name external-azure-db-binding-compatible \
      --resource-kind Secret \
      --resource-api-version v1
    ```

    If you are using a multicluster Tanzu Application Platform topology, create the claim on the
    Build cluster.

6. Obtain the claim reference of the claim by running:

    ```console
    tanzu service resource-claim list -o wide
    ```

    If you are using a multicluster Tanzu Application Platform topology, obtain the claim reference
    on the Build cluster.

    Expected output:

    ```console
    NAME                     READY  REASON  CLAIM REF
    external-azure-db-claim  True           services.apps.tanzu.vmware.com/v1alpha1:ResourceClaim:external-azure-db-claim
    ```

    From the output, record the value of `CLAIM REF`.

7. Create an application workload by running a command similar to the following example:

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

    - `WORKLOAD-NAME` is the name of the application workload. For example, `pet-clinic`.
    - `REFERENCE` is the value of the `CLAIM REF` for the newly created claim in the output of the
    last step.

    If you are using a multicluster Tanzu Application Platform topology, create the application workload
    on the Build cluster.
