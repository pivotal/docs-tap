# User-defined kubernetes service account configuration

In order to configure kubernetes service account authentication for AMR, the following requirements must be met for all clients to cloudevent handler or graphql.

## Clients to cloudevent handler

Clients to the cloudevent handler, such as observer, need to have the permission `update`, resource `*`, group `cloudevents.amr.apps.tanzu.vmware.com`. No resourceNames are supported. That translates to “write for all resources” for the CloudEvents API.

An example could look like this:

```
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

If you saved this to a file `observer-rbac.yaml` you can run `kubectl apply -f observer-rbac.yaml` to set everything up. If you prefer short-lived service account tokens, remove the secret from the file beforehand and after creating the resources run `kubectl create token amr-observer-editor-token -n amr-observer-system` to create a token.

Please note that if you want to configure custom service accounts even if autoconfiguration is turned on you will need to adjust the naming of the resources.


## Clients to graphql

Clients to the graphql interface need to have the permission `get`, resource `*`, group `graphql.amr.apps.tanzu.vmware.com`. No resourceNames are supported. That translates to get for all resources” for the GraphQL API.

An example could look like this:

```
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

If you saved this to a file `graphql-client-rbac.yaml` you can run `kubectl apply -f graphql-client-rbac.yaml` to set everything up. If you prefer short lived service account tokens, remove the secret from the file beforehand and after creating the resources run `kubectl create token amr-graphql-view-token -n metadata-store` to create a token.

Please note that if you want to configure custom service accounts even if autoconfiguration is turned on you will need to adjust the naming of the resources.
