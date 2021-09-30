# Creating Service Accounts and Access Tokens

## Creating Service

You can create two types of service accounts:
1. Read-only service account
1. Read-write service account

### Read-Only Service Account
To create a read-only service account run the following command. The command creates a service account named `metadata-store-read-client`:

```sh
$ kubectl apply -f - -o yaml << EOF
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: metadata-store-read-only
  namespace: metadata-store
rules:
- resources: ["all"]
  verbs: ["get"]
  apiGroups: [ "metadata-store/v1" ]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: metadata-store-read-only
  namespace: metadata-store
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
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
automountServiceAccountToken: false
EOF
```

### Read-Write Service Account

To create a read-write service account run the following command. The command create a service account called `metadata-store-read-write-client`:

```sh
$ kubectl apply -f - -o yaml << EOF
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
automountServiceAccountToken: false
EOF
```

## Getting the Access Token
To retrieve the read-only access token run the following command:

```sh
$ kubectl get secret $(kubectl get sa -n metadata-store metadata-store-read-client -o json | jq -r '.secrets[0].name') -n metadata-store -o json | jq -r '.data.token' | base64 -d
```

To retrieve the read-write access token run the following command:

```sh
$ kubectl get secret $(kubectl get sa -n metadata-store metadata-store-read-write-client -o json | jq -r '.secrets[0].name') -n metadata-store -o json | jq -r '.data.token' | base64 -d
```

The access token is a "Bearer" token used in the http request header "Authorization". (ex. `Authorization: Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IjhMV0...`)

## Setting `METADATA_STORE_ACCESS_TOKEN`

When using the CLI, you'll need to either set the `METADATA_STORE_ACCESS_TOKEN` environment variable, or use the `--access-token` flag. It is not recommended to use the `--access-token` flag as the token will appear in your shell history. We recommend using `METADATA_STORE_ACCESS_TOKEN`.

The follow command will retrieve the access token from Kubernetes and store it in `METADATA_STORE_ACCESS_TOKEN`:

```sh
$ export METADATA_STORE_ACCESS_TOKEN=$(kubectl get secrets -n metadata-store -o jsonpath="{.items[?(@.metadata.annotations['kubernetes\.io/service-account\.name']=='metadata-store-read-write-client')].data.token}" | base64 -d)
```

Replace `metadata-store-read-write-client` with name of the service account you plan to use.
