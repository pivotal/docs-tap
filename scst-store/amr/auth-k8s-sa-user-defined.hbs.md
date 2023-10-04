# User-defined Kubernetes service account configuration

This topic tells you how to configure a user-defined Kubernetes service account.

## <a id="overview"></a>Overview

To configure a Kubernetes service account authentication for AMR, cloudevent handler or graphql clients must have the required permissions, resources, and groups in the following sections.

## <a id="clients-cloudevent"></a>Clients to cloudevent handler

Clients to the cloudevent handler, such as observer, must have the permission `update`, resource `*`, and group `cloudevents.amr.apps.tanzu.vmware.com`. `resourceNames` are not supported. That translates to write for all resources for the CloudEvents API.

For example:

```console
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: tanzu:amr:observer:editor
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: tanzu:amr:observer:edit
subjects:
  - kind: ServiceAccount
    name: amr-observer-editor
    namespace: amr-observer-system

---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: tanzu:amr:observer:edit
rules:
  - apiGroups: ["cloudevents.amr.apps.tanzu.vmware.com"]
    resources: ["*"]
    verbs: ["update"]

---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: amr-observer-editor
  namespace: amr-observer-system
  annotations:
automountServiceAccountToken: false

---
apiVersion: v1
kind: Secret
type: kubernetes.io/service-account-token
metadata:
  name: amr-observer-editor-token
  namespace: amr-observer-system
  annotations:
    kubernetes.io/service-account.name: amr-observer
```

If you saved this to a `observer-rbac.yaml` file, run `kubectl apply -f observer-rbac.yaml` to set everything up. If you prefer short lived service account tokens, remove the secret from the file beforehand. After creating the resources, run `kubectl create token amr-observer-editor-token -n amr-observer-system` to create a token.

To configure custom service accounts even if automatic configuration is on, you must edit the resource naming.

## <a id="clients-graphql"></a>Clients to graphql

Clients to the graphql interface must have the permission `get`, resource `*`, and group `graphql.amr.apps.tanzu.vmware.com`. `resourceNames` are not supported. That translates to get for all resources for the GraphQL API.

For example:

```console
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: tanzu:amr:graphql:viewer
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: tanzu:amr:graphql:view
subjects:
  - kind: ServiceAccount
    name: amr-graphql-viewer
    namespace: metadata-store
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: tanzu:amr:graphql:view
rules:
  - apiGroups: ["graphql.amr.apps.tanzu.vmware.com"]
    resources: ["*"]
    verbs: ["get"]
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: amr-graphql-viewer
  namespace: metadata-store
  annotations:
    kapp.k14s.io/change-group: amr-graphql-viewer.metadata-store.apps.tanzu.vmware.com/service-account
automountServiceAccountToken: false
---
apiVersion: v1
kind: Secret
type: kubernetes.io/service-account-token
metadata:
  name: amr-graphql-view-token
  namespace: metadata-store
  annotations:
    kubernetes.io/service-account.name: amr-graphql-viewer
```

If you saved this to a `graphql-client-rbac.yaml` file, run `kubectl apply -f graphql-client-rbac.yaml` to set everything up. If you prefer short lived service account tokens, remove the secret from the file beforehand. After creating the resources, run `kubectl create token amr-graphql-view-token -n metadata-store` to create a token.

To configure custom service accounts even if automatic configuration is on, you must edit the resource naming.
