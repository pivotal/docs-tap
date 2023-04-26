# External Secrets Operator (alpha)

>**Caution** External Secrets Operator is in alpha and is intended for
>evaluation and test purposes only. Do not use in a production environment.

The [External Secrets Operator](https://external-secrets.io) is a Kubernetes
operator that integrates with external secret management systems, for example,
Google Secrets Manager and Hashicorp Vault. It reads information from external
APIs and automatically injects the values into a Kubernetes secret. Starting
with v1.4.0, Tanzu Application Platform repackages the External Secrets Operator
v0.6.1 into a Carvel bundle.

Tanzu Application Platform's External Secrets package is alpha software and does
not constitute an entire solution. VMware expects later Tanzu Application
Platform releases to have a more comprehensive secret management solution.

## Installing the External Secrets Operator

Tanzu Application Platform packages a version of the External Secrets Operator
that you can install in the `tap-install` namespace.  The External Secrets
Operator is an optional Tanzu Application Platform component. It does not come installed with any of
the default Tanzu Application Platform profiles.

```console
ESO_VERSION=0.6.1+tap.2
TAP_NAMESPACE=tap-install

tanzu package install external-secrets \
  --package-name external-secrets.apps.tanzu.vmware.com \
  --version "$ESO_VERSION" \
  --namespace "$TAP_NAMESPACE"
```

## Using the External Secrets Operator

The following example demonstrates a use case for configuring external
secrets in a Supply Chain.

### Connecting to a secret manager

#### Example : Google Secret Manager

To connect to a Google Secret Manager instance, you need a service account with the appropriate
permissions. The following steps detail how to create a `ClusterStore` resource
that uses this service account to connect to your Secret Manager.

1. Create a secret that holds the service account. Run:

    ```console
    ytt -f google-secrets-manager-secret.yaml  \
      --data-value gcp_secret_name=google-secrets-manager-secret  \
      --data-value secrets_namespace=external-secrets \
      --data-value-file service_account_json=<path_to_service_account_json> | kubectl apply -f-
    ```

    Where:

    ```yaml
    ❯ cat google-secrets-manager-secret.yaml
    #@ load("@ytt:data", "data")
    ---
    apiVersion: v1
    kind: Secret
    metadata:
      labels:
        type: gcpsm
      name: #@ data.values.gcp_secret_name
      namespace: #@ data.values.secrets_namespace
    stringData:
      secret-access-credentials: #@ data.values.service_account_json
    type: Opaque
    ```

2. Create a `ClusterStoreSecret` resource that references the earlier secret. Run:

    ```console
    export GOOGLE_PROJECT_ID="project-id-name"
    ytt -f google-secrets-store.yaml \
    --data-value cluster_store_name=google-secrets-manager-store-secret \
    --data-value secret_name=google-secrets-manager-secret-store \
    --data-value google_project_id="#{GOOGLE_PROJECT_ID}" | kubectl delete -f-
    ```

    Where:

    ```yaml
    ❯ cat google-secrets-store.yaml
    #@ load("@ytt:data", "data")
    ---
    apiVersion: external-secrets.io/v1beta1
    kind: ClusterSecretStore
    metadata:
      name:  #@ data.values.cluster_store_name
    spec:
      provider:
        gcpsm:
          auth:
            secretRef:
              secretAccessKeySecretRef:
                key: secret-access-credentials
                name: #@ data.values.secret_name
                namespace: external-secrets
          projectID: #@ data.values.google_project_id
    ```

3. To verify that you have correctly authenticated to the Secret Manager, run:

    ```sh
      tanzu external-secrets stores list -A
      NAMESPACE  NAME                                  PROVIDER                STATUS
      Cluster    google-secrets-manager-cluster-store  Google Secrets Manager  Valid
    ```

For more information about using the External Secrets Operator,
see the [External Secrets Operator
site](https://external-secrets.io).

### Create a sychronized secret

The secret to be sychronized must exist on your Secret Manager. Alternatively, you
can create one. For example, say you want to access your secret to access a
maven repository stored in a secret `maven-registry-credential` in your Secret
Manager. First, create an external secrets resource with a reference to the
secret to be sychronized and the `Valid` `ClusterStore` configured earlier. Run:

```sh
kubectl apply -f external-secret.yaml
```

Where:

```yaml
---
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: git-secret
  namespace: my-apps
spec:
  data:
  # SecretStoreRef defines which SecretStore to use when fetching the secret data
  - remoteRef:
      conversionStrategy: Default
      key: maven-registry-credentials
    secretKey: apitoken
  refreshInterval: 1m
  secretStoreRef:
    kind: ClusterSecretStore
    name: google-secrets-manager-cluster-store
  # the target describes the secret that shall be created
  # there can only be one target per ExternalSecret
  target:
    creationPolicy: Owner
    deletionPolicy: Retain
    name: maven-registry-credentials
    template:
      metadata:
        annotations:
          tekton.dev/git-0: https://github.com
      type: kubernetes.io/basic-auth
      data:
        password: '\{{ .apitoken | toString }}'
        username: "_json_key"
      engineVersion: v2
```

### Using a sychronized secret

The following example uses the sychronized secret to access a maven artifact:

```console
local readonly workload_name='java-web-app'

tanzu apps wld apply $workload_name \
      --service-account supply-chain-service-account \
      --param-yaml maven='{"artifactId": "spring-petclinic", "version": "3.7.4", "groupId": "org.springframework.samples"}' \
      --param maven_repository_secret_name="maven-registry-credentials"\
      --type web \
      --app spring-petclinic -y -n my-apps
```
