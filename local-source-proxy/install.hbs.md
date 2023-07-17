# Install Local Source Proxy

This topic tells you how to install and customize Local Source Proxy (LSP).

## <a id="prereqs"></a> Prerequisites

Meet the [prerequisites](prereqs.hbs.md) before attempting to install Local Source Proxy.

## <a id="install"></a> Install

Install Local Source Proxy by updating `tap-values.yaml` with the following details:

```yaml
local_source_proxy:
  repository: REGISTRY-SERVER/REPOSITORY-PATH

  push_secret:
   name: lsp-push-credentials
   namespace: tap-install
   create_export: true

  pull_secret:
   name: lsp-pull-credentials
   namespace: tap-install
   create_export: true
```

Where:

- `local_source_proxy.repository` is required. This is the repository where all your source code
  will be uploaded. Examples:

  - Harbor has the form `my-harbor.io/my-project/local-source`.
  - Docker Hub has the form `my-dockerhub-user/local-source` or `index.docker.io/my-user/local-source`.
  - Google Artifact Registry has the form `MY-REGISTRY-REGION-docker.pkg.dev/my-project/local-source/image`.
  - Google Cloud Registry has the form `gcr.io/my-project/local-source`.

- `local_source_proxy.push_secret` is required. This is the push secret reference that has the
  permission to push artifacts to the repository mentioned in `local_source_proxy.repository`.

- `local_source_proxy.push_secret.create_export` is `false` by default. Set it as `true` to tell
  Local Source Proxy to create a `SecretExport` for the referenced secret and own it. Do one of the
  following if you're reusing the secret that already existed in your cluster:

  - Ensure that it's not exported by any other process
  - Set this flag to `false` and ensure that it is exportable to the `tap-local-source-system`
    namespace by using a `SecretExport` resource

- `local_source_proxy.pull_secret` is optional, but recommended for production. Use the credential
  that has pull permissions. You can re-use `lsp-push-credentials` that have pull access if you
  chose not to create a separate request for pulling.

- `local_source_proxy.pull_secret.create_export` is `false` by default. Set it as `true` to tell
  Local Source Proxy to create a SecretExport for the referenced secret and own it.

In a production installation of Tanzu Application Platform, do not share the registry secret that has
write access across developer namespaces. Instead, distribute a separate registry secret that only has
read access.

In such cases, `pull_secret` can be specified, and `source-controller` uses the `pull_secret`
to pull source artifacts for deployment.

The `pull_secret` uses a Docker registry credentials secret referenced by its `name` and `namespace`.

To enable the Tanzu Application Platform installer to automatically create a `SecretExport` resource
in the specified `namespace` for exporting the secret to developer namespaces, set
`pull_secret.create_export` to `true`.

Alternatively, if `create_export` is set to `false`, you must manually create the `SecretExport`
resource in the referenced `namespace`.

Do one of the following if you're reusing the secret that already existed in your cluster:

- Ensure that it's not exported by any other process
- Set this flag to `false` and ensure that it is exportable to developer namespaces by using a
  `SecretExport` resource

### <a id="create-secretexport-rsrc"></a> Create the SecretExport resource

If you left `create_export` as `true` in `tap-values.yaml`, skip this procedure. If you set the
`create_export` to `false`, apply the following YAML in `tap-values.yaml` to create the `SecretExport`
resource:

Use this YAML for `push-secret`:

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

Use this YAML for `pull-secret`:

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

## <a id="customize-install"></a> Customize the installation

You can configure specific Local Source Proxy resources by using the following properties in
`tap-values.yaml`, as described in the following sections.

### <a id="override-dflt-rbac"></a> Override default RBAC permissions to access the proxy service

When this section is not provided, the default behavior is to employ the `system:authenticated` group
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
- Set `rbac_subjects_for_proxy_access.name` to the user name or group name that requires authorization.
- Set `rbac_subjects_for_proxy_access.apiGroup` to either `rbac.authorization.k8s.io` or the custom
  `apiGroup` associated with the specified kind.

For more information about RoleBinding, see the
[Kubernetes documentation](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#role-binding-examples).
These settings enable you to customize RBAC permissions for accessing the proxy service according to
your specific user or group requirements.

> **Important** If you define the `rbac_subjects_for_proxy_access` configuration in the
> `tap-values.yaml` file, it supersedes the default `system:authenticated` role binding with the
> one specified in `tap-values.yaml`. This allows platform operators to restrict access to the proxy
> server exclusively to a predefined set of groups, users, or service accounts.

For example:

```yaml
local_source_proxy:
  rbac_subjects_for_proxy_access:
  - kind: "Group"
    name: "alpha-group"
    apiGroup: "rbac.authorization.k8s.io"
```

### <a id="override-dflt-cpu"></a> Override default CPU and memory limits for controller pods

To configure the compute resource limits for the Local Source Proxy server, you can use the
`proxy_configuration` section within the `local_source_proxy` configuration in `tap-values.yaml`.

Specify the following properties to set the resource limits:

- `proxy_configuration.limits.cpu`: Set the maximum CPU limit for the Local Source Proxy server.
- `proxy_configuration.limits.memory`: Configure the maximum memory limit available for the Local
  Source Proxy server.

For example:

```yaml
local_source_proxy:
  proxy_configuration:
    limits:
      cpu: 500m
      memory: 100Mi
```

### <a id="use-aws-iam-roles"></a> Use AWS Identity and Access Management (IAM) roles for ECR

If your Tanzu Application Platform installation is both

- On AWS with Amazon Elastic Kubernetes Service (EKS)
- Using the AWS Elastic Container Registry (ECR) for storing local source code

then write the IAM role that has push and pull permissions for `aws_iam_role_arn`. For example:

```yaml
local_source_proxy:
  repository: 123456789012.dkr.ecr.us-east-1.amazonaws.com/local-source
  push_secret:
    aws_iam_role_arn: arn:aws:iam::123456789012:role/tap-local-source-proxy
```

You specify this IAM role in `aws_iam_role_arn` to assign it to the Kubernetes service account that
the Local Source Proxy server uses. For the steps to create an IAM role and add the
Amazon Resource Name (ARN) to the Kubernetes service account used by Local Source Proxy, see
[Prerequisites for Local Source Proxy](prereqs.hbs.md).

Doing this allows the Local Source Proxy server to handle incoming image push requests with the
appropriate IAM role-based permissions.

### <a id="increase-replicas"></a> Increase or decrease the number of replicas

By default, the Local Source Proxy instance is configured with one replica in the deployment.
You can increase or decrease the number of replicas by changing the `proxy_configuration.replicas`
value.

For example:

```yaml
local_source_proxy:
  proxy_configuration:
    replicas: 3
```

### <a id="spec-ca-cert"></a> Specify CA certificate data for registries that use self-signed certificates

If you have a custom TLS certificate or a self-signed certificate for your registry server, and it
uses a private certificate authority, you can set up the public CA certificate data by providing the
necessary configuration under `local_source_proxy.ca_cert_data` in the `tap.values.yaml` file.

This allows you to provide the necessary certificate information for secure communication with the
registry server. For example:

```yaml
local_source_proxy:
  ca_cert_data: |
    -----BEGIN CERTIFICATE-----
    ...
    -----END CERTIFICATE-----
```

Local Source Proxy detects when `shared.ca_cert_data` is provided in `tap-values.yaml` and imports
the CA certificate data from that key.