# Security for Supply Chain Security Tools - Store

## Application Security:

### TLS Encryption

The Store requires TLS connection. If certificates are not provided the store will not start. The Store supports TLS v1.2 and TLS v1.3. The Store does not support TLS 1.0, so a downgrade attack cannot happen. TLS 1.0 is prohibited under Payment Card Industry Data Security Standard (PCI DSS).

##### Cryptographic Algorithms:

Elliptic Curve:
```
CurveP521
CurveP384
CurveP256
```

Cipher Suites:
```
TLS_AES_128_GCM_SHA256
TLS_AES_256_GCM_SHA384
TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256
TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384
TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
```

### Access Controls

The Store uses [kube-rbac-proxy](https://github.com/brancz/kube-rbac-proxy) as the only entry point to the Store's API. Authentication and Authorization must be completed successfully via the `kube-rbac-proxy` before the Store's API is accessible.

##### Authorization

The `kube-rbac-proxy` uses [Token Review](https://kubernetes.io/docs/reference/access-authn-authz/authentication/) to verify if the token is valid. `Token Review` is a Kubernetes API to ensure the access token provided by the user was issued by a trusted vendor. To issue an access token using Kubernetes, the user can create a Kubernetes Service Account and retrieve the corresponding generated Secret for the access token.

To create an access token, please refer to the [Create Service Account Access Token Docs](create_service_account_access_token.md)

##### Authentication

The `kube-rbac-proxy` uses [Subject Access Review](https://kubernetes.io/docs/reference/access-authn-authz/authorization/) to ensure the user has access to certain operations. `Subject Access Review` is a Kubernetes API that uses [Kubernetes RBAC](https://kubernetes.io/docs/reference/access-authn-authz/rbac/) to deternmine if the user can perform the current action.

Please refer to the [Create Service Account Access Token Docs](create_service_account_access_token.md)

There are only two roles that are supported: `Read Only User` and `Read and Write User`. 
The `Read and Write User` is installed by default. This can be turned off by setting `add_default_rw_service_account` property to `"false"` in the `scst-store-values.yaml` file.

*** Note: There is no support for roles with access to only specific types of resources (ie. images, packages, vulnerabilities, etc)

## Container Security

### Non-root User
All containers shipped do not use root. Using Kubernetes Security Context to ensure that the start up user is not root.

Security Context for the Store:
```
    allowPrivilegeEscalation: false
    runAsUser: 65532
    fsGroup: 65532
```
Security Context for the Postgres DB POD:
```
    allowPrivilegeEscalation: false
    runAsUser: 999
    fsGroup: 999
```

*** Note: 65532 is the uuid for the "nobody" user. 999 is the uuid for the "postgres" user.

## Security Scanning

There are two types of security scans that are performed before every release.

### Static Application Security Testing (SAST)

A Coverity Scan is run on the source code of the Store, CLI, and all their dependencies. There are no high or critical items outstanding at the time of release.

### Software Composition Analysis (SCA)

A Black Duck scan is run on the compiled binary to check for vulnerabilities and licence data. There are no high or critical items outstanding at the time of release.

A Grype scan is run against the source code and the compiled container for dependencies vulnerabilities. There are no high or critical items outstanding at the time of release.

