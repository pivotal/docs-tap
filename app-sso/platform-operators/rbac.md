# RBAC

The AppSSO package aggregates the following permissions into TAP's well-known roles:

* app-operator

  ```yaml
  - apiGroups:
      - sso.apps.tanzu.vmware.com
    resources:
      - clientregistrations
    verbs:
      - "*"
  ```

* app-editor

  ```yaml
  - apiGroups:
      - sso.apps.tanzu.vmware.com
    resources:
      - clientregistrations
    verbs:
      - get
      - list
      - watch
  ```

* app-viewer

  ```yaml
  - apiGroups:
      - sso.apps.tanzu.vmware.com
    resources:
      - clientregistrations
    verbs:
      - get
      - list
      - watch
  ```

* service-operator

  ```yaml
  - apiGroups:
      - sso.apps.tanzu.vmware.com
    resources:
      - authserver
    verbs:
      - "*"
  ```

For the purpose of managing the lifecycle of AppSSO's [APIs](../crds/index.md) the AppSSO operator's `ServiceAccount`
has a `ClusterRole` with the following permissions:

```yaml
- apiGroups:
    - sso.apps.tanzu.vmware.com
  resources:
    - authservers
  verbs:
    - get
    - list
    - watch
- apiGroups:
    - sso.apps.tanzu.vmware.com
  resources:
    - authservers/status
  verbs:
    - patch
    - update
- apiGroups:
    - sso.apps.tanzu.vmware.com
  resources:
    - authservers/finalizers
  verbs:
    - "*"
- apiGroups:
    - sso.apps.tanzu.vmware.com
  resources:
    - clientregistrations
  verbs:
    - get
    - list
    - watch
- apiGroups:
    - sso.apps.tanzu.vmware.com
  resources:
    - clientregistrations/status
  verbs:
    - patch
    - update
- apiGroups:
    - sso.apps.tanzu.vmware.com
  resources:
    - clientregistrations/finalizers
  verbs:
    - "*"
- apiGroups:
    - ""
  resources:
    - secrets
    - configmaps
    - services
    - serviceaccounts
  verbs:
    - "*"
- apiGroups:
    - apps
  resources:
    - deployments
  verbs:
    - "*"
- apiGroups:
    - rbac.authorization.k8s.io
  resources:
    - roles
    - rolebindings
  verbs:
    - "*"
- apiGroups:
    - cert-manager.io
  resources:
    - certificates
    - issuers
  verbs:
    - "*"
- apiGroups:
    - cert-manager.io
  resources:
    - clusterissuers
  verbs:
    - get
    - list
    - watch
    - apiGroups:
        - networking.k8s.io
      resources:
        - ingresses
      verbs:
        - "*"
- apiGroups:
    - ""
  resources:
    - events
  verbs:
    - create
    - update
    - patch
- apiGroups:
    - coordination.k8s.io
  resources:
    - leases
  verbs:
    - create
    - get
    - update
```

AppSSO installs [_OpenShift_-specific RBAC and resources](openshift.md).
