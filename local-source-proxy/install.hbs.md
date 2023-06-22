# Install Local Source Proxy

This topic tells you how to install and customize Local Source Proxy.

## Prerequisites

Meet the [prerequisites](prereqs.hbs.md) before attempting to install Local Source Proxy.

## Install

To install Local Source Proxy:

Update your TAP installation values file with the following details:

```yaml
local_source_proxy:
  # (Required) This is the repository where all your source code will be uploaded
  repository: gcr.io/tap-dev-framework/lsp

  # (Required) Push secret reference which has the permission to push artifacts to the repository mentioned in local_source_proxy.repository
  push_secret:
   name: lsp-push-credentials
   namespace: tap-install
   # NOTE: create_export is false by default. Setting it to true tells Local source proxy to create a SecretExport for the referred secret and own it. If you are reusing the secret that already existed in your cluster, you should make sure it's not exported by any other process, or set this flag to false and make sure it is exportable to the tap-local-source-system namespace via a SecretExport resource.
   create_export: true

  # (Optional) Highly recommended for Production use
  pull_secret:
   # Use the credential that has pull permissions. You can re-use the lsp-push-credentials that have pull access if you chose not to create a separate request for pull.
   name: lsp-pull-credentials
   namespace: tap-install
   # NOTE: create_export is false by default. Setting it to true tells Local source proxy to create a SecretExport for the referred secret and own it. If you are reusing the secret that already existed in your cluster, you should make sure it's not exported by any other process, or set this flag to false and make sure it is exportable to developer namespaces via a SecretExport resource.
   create_export: true
```

[Optional] If you see the `create_export` to false in the above `tap-values.yaml`, apply below YAML
to create the `SecretExport` resource.

push-secret
: Use this YAML for `push-secret`

    ```yaml
    ---
    apiVersion: secretgen.carvel.dev/v1alpha1
    kind: SecretExport
    metadata:
      name: lsp-push-credentials
      namespace: tap-install
    spec:
      toNamespace: tap-local-source-system
    ```

pull-secret
: Use this YAML for `pull-secret`

    ```yaml
    ---
    apiVersion: secretgen.carvel.dev/v1alpha1
    kind: SecretExport
    metadata:
      name: lsp-pull-credentials
      namespace: tap-install
    spec:
      toNamespace: *
    ```

Additional details:

- repository: REGISTRY-SERVER/BASE-PATH `Example: gcr.io/my-project/source`
  Take caution to avoid conflicts with other registry credentials used elsewhere in TAP when
  specifying the push_secret and pull_secret.

- push_secret:
  - Docker registry credentials secret referenced by name and namespace
  - create_export: Set this value to true if a SecretExport resource needs to be created in its
    namespace, allowing the secret to be imported into the Local Source Proxy's
    tap-local-source-system namespace.

In a production installation of TAP, the registry secret with write access should not be shared
across developer namespaces. Instead, it is preferred to distribute a separate registry secret with
only read access. In such cases, the `pull_secret`   can be specified, which is used by the
source-controller to pull source artifacts for deployment.

- pull_secret:
  - Docker registry credentials secret referenced by `name` and `namespace`
  - create_export: Set this value to true if a SecretExport resource needs to be created in its
    namespace, allowing the secret to be imported into developer namespaces using the Namespace
    provisioner or other means.

## Customize the installation

You can configure specific Local Source Proxy resources using the following properties in
`tap-values.yaml`:

### <a id="override-dflt-rbac"></a> Override default RBAC permissions to access the proxy service

When this section is not provided, the default behavior is to employ the system:authenticated group
as the chosen option.

```yaml
local_source_proxy:
  rbac_subjects_for_proxy_access:
  - kind: "Group"
    name: "system:authenticated"
    apiGroup: "rbac.authorization.k8s.io"
```

To grant access for a specific user or group to push images through Local Source Proxy, use the
`rbac_subjects_for_proxy_access` property in the `local_source_proxy` configuration:

- Set `rbac_subjects_for_proxy_access.kind` to either `"User"` or `"Group"`.
- Set `rbac_subjects_for_proxy_access.name` to the username or group name that requires authorization.
- Set `rbac_subjects_for_proxy_access.apiGroup` to either `rbac.authorization.k8s.io` or the custom
  `apiGroup` associated with the specified kind.

For more information about RoleBinding, see the [Kubernetes documentation](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#role-binding-examples).
These settings enable you to customize RBAC permissions for accessing the proxy service according to
your specific user or group requirements.

> **Important** If you define the `rbac_subjects_for_proxy_access` configuration in the
> `tap-values.yaml` file, it supersedes the default `system:authenticated` role binding with the
> one specified in `tap-values.yaml`. This allows platform operators to restrict access to the proxy
> server exclusively to a predefined set of groups, users, or service accounts.

```yaml
local_source_proxy:
  rbac_subjects_for_proxy_access:
  - kind: "Group"
    name: "alpha-group"
    apiGroup: "rbac.authorization.k8s.io"
```

### Override default CPU and memory limits for controller pods

To configure the compute resource limits for the Local Source Proxy server, you can utilize the
`proxy_configuration` section within the `local_source_proxy` configuration in `tap-values.yaml`.

Specify the following properties to set the resource limits:

- `proxy_configuration.limits.cpu`: Set the maximum CPU limit for the Local Source Proxy server.
- `proxy_configuration.limits.memory`: Configure the maximum memory limit available for the Local
  Source Proxy server.

```yaml
local_source_proxy:
  proxy_configuration:
    limits:
      cpu: 500m
      memory: 100Mi
```

### Use AWS IAM roles for ECR

In the case of TAP installation on AWS with Amazon EKS that is utilizing the AWS Elastic Container
Registry (ECR) for storing local source code, you can specify the IAM Role that has push and pull
permissions in aws_iam_role_arn to assign it to the Kubernetes Service Account used by the Local
Source Proxy server. This allows the Local Source Proxy server to handle incoming image push
requests with the appropriate IAM Role-based permissions.

```yaml
local_source_proxy:
  push_secret:
    aws_iam_role_arn: "arn:aws:iam::123456789012:role/EKSIAMRole"
```

### Increase number of replicas

By default, the Local Source Proxy instance is configured with 1 replica in the deployment. However,
you can modify this behavior by adjusting the proxy_configuration.replicas setting to increase or
decrease the number of replicas according to your requirements.

```yaml
local_source_proxy:
  proxy_configuration:
    Replicas: 3
```

### Specifying CA Cert data for Registries using self-signed certificates

If your registry server is signed with a custom TLS certificate or a self-signed certificate using a
private certificate authority, you can configure the public CA certificate data by specifying it
under `local_source_proxy.ca_cert_data` in the `tap.values.yaml` file. This allows you to provide the
necessary certificate information for secure communication with the registry server.

```yaml
local_source_proxy:
  ca_cert_data: |
    -----BEGIN CERTIFICATE-----
    ...
    -----END CERTIFICATE-----
```

> **Note** If `shared.ca_cert_data` is provided in `tap-values.yaml`, Local Source Proxy respects
> that and imports the CA certificate data from that key.