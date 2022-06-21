# Security details

## <a id='app-sec'></a>Application security

### <a id='tls-encrypt'></a>TLS encryption

Supply Chain Security Tools - Store requires TLS connection. If certificates are not provided, the application will not start. It supports TLS v1.2 and TLS v1.3. It does not support TLS 1.0, so a downgrade attack cannot happen. TLS 1.0 is prohibited under Payment Card Industry Data Security Standard (PCI DSS).

##### <a id='crypto-al'></a>Cryptographic algorithms:

Elliptic Curve:

```text
CurveP521
CurveP384
CurveP256
```

Cipher Suites:

```text
TLS_AES_128_GCM_SHA256
TLS_AES_256_GCM_SHA384
TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256
TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384
TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
```

### <a id='acc-control'></a>Access controls

Supply Chain Security Tools - Store uses [kube-rbac-proxy](https://github.com/brancz/kube-rbac-proxy) as the only entry point to its API. Authentication and Authorization must be completed successfully via the `kube-rbac-proxy` before its API is accessible.

##### <a id='auth-token'></a>Authentication

The `kube-rbac-proxy` uses [Token Review](https://kubernetes.io/docs/reference/access-authn-authz/authentication/) to verify if the token is valid. `Token Review` is a Kubernetes API to ensure a trusted vendor issued the access token provided by the user. To issue an access token using Kubernetes, the user can create a Kubernetes Service Account and retrieve the corresponding generated Secret for the access token.

To create an access token, please refer to the [Create Service Account Access Token Docs.](create-service-account-access-token.md)

##### <a id='auth-api'></a>Authorization

The `kube-rbac-proxy` uses [Subject Access Review](https://kubernetes.io/docs/reference/access-authn-authz/authorization/) to ensure users access certain operations. `Subject Access Review` is a Kubernetes API that uses [Kubernetes RBAC](https://kubernetes.io/docs/reference/access-authn-authz/rbac/) to determine if the user can perform specific actions. Please refer to the [Create Service Account Access Token doc](create-service-account-access-token.md).

There are only two supported roles: `Read Only` cluster role and `Read and Write` cluster role. These cluster roles are deployed by default.
Additionally, a service account is created and bound to the `Read and Write` cluster role by default. If you do not want this service account, set `add_default_rw_service_account` property to `"false"` in the `metadata-store-values.yaml` file [during deployment](install-scst-store.md).

There is no default service account bound to the `Read Only` cluster role. You must create your service account and cluster role binding to bind to the `Read Only` role.

>**Note:** There is no support for roles with access to only specific types of resources (i.e., images, packages, vulnerabilities, etc.)

## <a id='contain-sec'></a>Container security

### <a id='non-root'></a>Non-root user
All containers shipped do not use root user accounts or accounts with root access. Using Kubernetes Security Context ensures that applications do not run with root users.

Security Context for the API server:

```text
allowPrivilegeEscalation: false
runAsUser: 65532
fsGroup: 65532
```

Security Context for the Postgres DB pod:

```text
allowPrivilegeEscalation: false
runAsUser: 999
fsGroup: 999
```

>**Note:**  `65532` is the uuid for the "nobody" user. `999` is the uuid for the "postgres" user.

## <a id='sec-scan'></a>Security scanning

There are two types of security scans that are performed before every release.

### <a id='sast'></a>Static Application Security Testing (SAST)

A Coverity Scan is run on the source code of the API server, CLI, and all their dependencies. There are no high or critical items outstanding at the time of release.

### <a id='sca'></a>Software Composition Analysis (SCA)

A Black Duck scan is run on the compiled binary to check for vulnerabilities and license data. There are no high or critical items outstanding at the time of release.

A Grype scan is run against the source code and the compiled container for dependencies vulnerabilities. There are no high or critical items outstanding at the time of release.
