# Create Service Accounts

When you install Tanzu Application Platform, the included Supply Chain Security Tools (SCST) - Store deployment automatically comes with a read-write service account.
This service account is already bound to the `metadata-store-read-write` role.
Skip to the section [Getting the access token](#getting-access-token) to see how to retrive the access token for the default read-write service account.

If you want to create another read-write service account, or if you want to create a read-only servie account, then follow the instructions in this guide.

## Types of services accounts

You can create two types of SCST - Store service accounts:

1. Read-only service account - can only use `GET` API requests
2. Read-write service account - full access to the API requests

## <a id='ro-serv-accts'></a>Read-only service account

### With default cluster role

As a part of the Store installation, the `metadata-store-read-only` cluster role
is created by default. This cluster role allows the bound user to have `get`
access to all resources. To bind to this cluster role, run the following command
depending on the Kubernetes version:

  ```console
  kubectl apply -f - -o yaml << EOF
  ---
  apiVersion: rbac.authorization.k8s.io/v1
  kind: ClusterRoleBinding
  metadata:
    name: metadata-store-read-only
  roleRef:
    apiGroup: rbac.authorization.k8s.io
    kind: ClusterRole
    name: metadata-store-read-only
  subjects:
  - kind: ServiceAccount
    name: metadata-store-read-client
    namespace: metadata-store
  ---
  apiVersion: v1
  kind: ServiceAccount
  metadata:
    name: metadata-store-read-client
    namespace: metadata-store
    annotations:
      kapp.k14s.io/change-group: "metadata-store.apps.tanzu.vmware.com/service-account"
  automountServiceAccountToken: false
  ---
  apiVersion: v1
  kind: Secret
  type: kubernetes.io/service-account-token
  metadata:
    name: metadata-store-read-client
    namespace: metadata-store
    annotations:
      kapp.k14s.io/change-rule: "upsert after upserting metadata-store.apps.tanzu.vmware.com/service-account"
      kubernetes.io/service-account.name: "metadata-store-read-client"
  EOF
  ```

> **Note** For Kubernetes v1.24 and later, services account secrets are no longer automatically created.
> This is why we added a `Secret` resource in the above yaml.

### With a custom cluster role

If using the default role is not sufficient for your use case, follow the instructions in [Create a service account with a custom cluster role](custom-role.hbs.md).

## Read-write service account

When you install Tanzu Application Platform, the included Supply Chain Security Tools (SCST) - Store deployment automatically comes with a read-write service account.
This service account is already bound to the `metadata-store-read-write` role.

To create an *additional* read-write service account, run the following command.
The command creates a service account called `metadata-store-read-write-client`, depending on the Kubernetes version:

```console
kubectl apply -f - -o yaml << EOF
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: metadata-store-read-write
  namespace: metadata-store
rules:
- resources: ["all"]
  verbs: ["get", "create", "update"]
  apiGroups: [ "metadata-store/v1" ]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: metadata-store-read-write
  namespace: metadata-store
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: metadata-store-read-write
subjects:
- kind: ServiceAccount
  name: metadata-store-read-write-client
  namespace: metadata-store
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: metadata-store-read-write-client
  namespace: metadata-store
  annotations:
    kapp.k14s.io/change-group: "metadata-store.apps.tanzu.vmware.com/service-account"
automountServiceAccountToken: false
---
apiVersion: v1
kind: Secret
type: kubernetes.io/service-account-token
metadata:
  name: metadata-store-read-write-client
  namespace: metadata-store
  annotations:
    kapp.k14s.io/change-rule: "upsert after upserting metadata-store.apps.tanzu.vmware.com/service-account"
    kubernetes.io/service-account.name: "metadata-store-read-write-client"
EOF
```

> **Note** For Kubernetes v1.24 and later, services account secrets are no longer automatically created.
> This is why we added a `Secret` resource in the above yaml.
  
## <a id='getting-access-token'></a>Getting the access token

To retrieve the read-only access token, run:

```console
kubectl get secrets metadata-store-read-client -n metadata-store -o jsonpath="{.data.token}" | base64 -d
```

To retrieve the read-write access token, run:

```console
kubectl get secrets metadata-store-read-write-client -n metadata-store -o jsonpath="{.data.token}" | base64 -d
```

The access token is a "Bearer" token used in the http request header "Authorization." (ex. `Authorization: Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IjhMV0...`)

# Additional resources

- [Create a service account with a custom cluster role](custom-role.hbs.md)
