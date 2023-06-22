# Troubleshoot

## <a id="view-lsp-server-logs"></a> View Local Source Proxy server logs

### Symptom

You encounter an error and need to view the Local Source Proxy server logs to investigate it.

### Solution

Run

```console
kubectl -n tap-local-source-system logs deployments/local-source-proxy
```

Use `-f` to follow the log output.

## <a id="view-apps-cli-health"></a> View Apps CLI health messages

### Symptom

You need to investigate an error by reading the Apps CLI health messages to assess the status of
Local Source Proxy and its connectivity with the upstream repository.

### Solution

Run

```console
tanzu apps lsp health
```

Example:

```console
$ tanzu apps lsp health
user_has_permission: true
reachable: true
upstream_authenticated: true
overall_health: true
message: All health checks passed
```

## <a id="lacks-rbac-to-lst-srvcs"></a> User does not have RBAC permission to list services

### Symptom

You encounter any of these error messages:

```console
$ tanzu apps workload apply
Error: Either Local Source Proxy is not installed on the Cluster or you don't have permissions to access it
Reason: The current user does not have permission to access the local source proxy.
Messages:
- services "http:local-source-proxy:5001" is forbidden: User "adhol@vmware.com" cannot get resource "services/proxy" in API group "" in the namespace "tap-local-source-system": requires one of ["container.services.proxy"] permission(s).
```

```console
$ tanzu apps lsp health
user_has_permission: false
reachable: false
upstream_authenticated: false
overall_health: false
message: |-
  The current user does not have permission to access the local source proxy.
  Messages:
  - services "http:local-source-proxy:5001" is forbidden: User "adhol@vmware.com" cannot get resource "services/proxy" in API group "" in the namespace "tap-local-source-system": requires one of ["container.services.proxy"] permission(s).
```

### Cause

Typically, this situation arises when a custom user/group is specified within the
`rbac_subjects_for_proxy_access` section of `tap-values.yaml`.

### Solution

Ensure that the user/group listed is valid. For more information about overriding default RBAC
permissions to access the proxy service, see
[Override default RBAC permissions to access the proxy service](install.hbs.md#override-dflt-rbac).

## <a id="missing-tap-values"></a> Missing repository in Tanzu Application Platform values

### Symptom

You encounter one of these error messages:

```console
$ tanzu apps workload apply
Error: Local source proxy failed to upload source to the repository
Reason: Local source proxy is not healthy.
Messages:
- registry server configuration in the cluster is invalid
```

```console
$ tanzu apps lsp health
user_has_permission: true
reachable: true
upstream_authenticated: false
overall_health: false
message: |
  Local source proxy is not healthy.
  Messages:
  - registry server configuration in the cluster is invalid
```

### Cause

The cause might be that `tap-values.yaml` lacks a valid value for the repository.

### Solution

Add a valid repository value to `tap-values.yaml`.
<!-- And restart? Needs more detail. -->

## <a id="miscofig-reg-secret"></a> Missing or misconfigured registry secret

### Symptom

You encounter one of these error messages:

```console
$ tanzu apps workload apply
Error: Local source proxy failed to upload source to the repository
Reason: Local source proxy was unable to authenticate against the target registry.
Messages:
- GET https://gcr.io/v2/token?scope=repository:adhol-playground/lsp-source:pull,push&service=gcr.io: UNAUTHORIZED: You don't have the needed permissions to perform this operation, and you may have invalid credentials. To authenticate your request, follow the steps in: https://cloud.google.com/container-registry/docs/advanced-authentication
```

```console
$ tanzu apps lsp health
user_has_permission: true
reachable: true
upstream_authenticated: false
overall_health: false
message: |-
  Local source proxy was unable to authenticate against the target registry.
  Messages:
  - GET https://gcr.io/v2/token?scope=repository:adhol-playground/lsp-source:pull,push&service=gcr.io: UNAUTHORIZED: You don't have the
 needed permissions to perform this operation, and you may have invalid credentials. To authenticate your request, follow the steps in: https:/
/cloud.google.com/container-registry/docs/advanced-authentication
```

### Cause

Potential causes include:

- The secret was not exported to the Local Source Proxy namespace
- Credentials for the `push_registry` do not match the host in the secret
- `push_registry` information is missing in `tap-values.yaml`

### Solution

<!-- Missing -->

## <a id="invalid-creds"></a> Invalid credentials

### Symptom

You encounter one of these error messages:

```console
$ tanzu apps workload apply
Error: Local source proxy failed to upload source to the repository
Reason: Local source proxy was unable to authenticate against the target registry.
Messages:
- GET https://gcr.io/v2/token?scope=repository:adhol-playground/lsp-source:pull,push&service=gcr.io: UNAUTHORIZED: Not Authorized.
```

```console
$ tanzu apps lsp health # when using Harbor
user_has_permission: true
reachable: true
upstream_authenticated: false
overall_health: false
message: |-
  Local source proxy was unable to authenticate against the target registry.
  Messages:
  - 401 Unauthorized
```

```console
$ tanzu apps lsp health # when using GCR
user_has_permission: true
reachable: true
upstream_authenticated: false
overall_health: false
message: |-
  Local source proxy was unable to authenticate against the target registry.
  Messages:
  - GET https://gcr.io/v2/token?scope=repository:adhol-playground/lsp-source:pull,push&service=gcr.io: UNAUTHORIZED: Not Authorized.
```

### Cause

The cause is the use of invalid credentials.

### Solution

<!-- Missing -->