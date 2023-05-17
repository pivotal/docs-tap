# RBAC for Application Single Sign-On

TODO(mbrauer)

The AppSSO package aggregates the following permissions into [TAP's well-known roles](../../authn-authz/role-descriptions.hbs.md).

## User aggregated rules

### app-operator

<!---
Generated with:
```shell
kubectl get clusterrole app-operator -oyaml | yq '.rules[] | select(.apiGroups | contains(["sso.apps.tanzu.vmware.com"]))'
```
--->
  
```yaml
apiGroups:
  - sso.apps.tanzu.vmware.com
resources:
  - clientregistrations
  - workloadregistrations
verbs:
  - '*'
```

### app-editor

<!---
Generated with:
```shell
kubectl get clusterrole app-editor -oyaml | yq '.rules[] | select(.apiGroups | contains(["sso.apps.tanzu.vmware.com"]))'
```
--->

```yaml
apiGroups:
  - sso.apps.tanzu.vmware.com
resources:
  - clientregistrations
  - workloadregistrations
verbs:
  - get
  - list
  - watch
```

### app-viewer

<!---
Generated with:
```shell
kubectl get clusterrole app-viewer -oyaml | yq '.rules[] | select(.apiGroups | contains(["sso.apps.tanzu.vmware.com"]))'
```
--->

```yaml
apiGroups:
  - sso.apps.tanzu.vmware.com
resources:
  - clientregistrations
  - workloadregistrations
verbs:
  - get
  - list
  - watch
```

### service-operator

<!---
Generated with:
```shell
kubectl get clusterrole service-operator -oyaml | yq '.rules[] | select(.apiGroups | contains(["sso.apps.tanzu.vmware.com"]))'
```
--->

```yaml
apiGroups:
  - sso.apps.tanzu.vmware.com
resources:
  - authservers
  - clusterunsafetestlogins
  - clusterworkloadregistrationclasses
verbs:
  - '*'
```

## Controller

To manage the life cycle of AppSSO's [APIs](index.hbs.md), the AppSSO controller's `ServiceAccount`
has a `ClusterRole` with the following permissions:

<!---
Generated with:
```shell
kubectl get clusterrolebinding -A -oyaml | yq '.items[] | select(.subjects[] | contains({"kind": "ServiceAccount", "name": "appsso-controller", "namespace": "appsso"})) | .roleRef.name' | xargs -n1 -I% kubectl get clusterrole % -oyaml | yq .rules
```
--->

```yaml
- apiGroups:
    - sso.apps.tanzu.vmware.com
  resources:
    - authservers
    - clientregistrations
    - clusterunsafetestlogins
    - clusterworkloadregistrationclasses
    - workloadregistrations
  verbs:
    - '*'
- apiGroups:
    - sso.apps.tanzu.vmware.com
  resources:
    - authservers/status
    - clientregistrations/status
    - clusterunsafetestlogins/status
    - clusterworkloadregistrationclasses/status
    - workloadregistrations/status
  verbs:
    - patch
    - update
- apiGroups:
    - sso.apps.tanzu.vmware.com
  resources:
    - authservers/finalizers
    - clientregistrations/finalizers
    - clusterunsafetestlogins/finalizers
    - clusterworkloadregistrationclasses/finalizers
    - workloadregistrations/finalizers
  verbs:
    - '*'
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
- apiGroups:
    - ""
  resources:
    - secrets
    - configmaps
    - services
    - serviceaccounts
  verbs:
    - '*'
- apiGroups:
    - apps
  resources:
    - deployments
  verbs:
    - '*'
- apiGroups:
    - rbac.authorization.k8s.io
  resources:
    - roles
    - rolebindings
  verbs:
    - '*'
- apiGroups:
    - cert-manager.io
  resources:
    - certificates
    - issuers
  verbs:
    - '*'
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
    - '*'
- apiGroups:
    - servicebinding.io
  resources:
    - servicebindings
  verbs:
    - '*'
- apiGroups:
    - services.apps.tanzu.vmware.com
  resources:
    - clusterinstanceclasses
  verbs:
    - '*'
- apiGroups:
    - services.apps.tanzu.vmware.com
  resources:
    - clusterinstanceclasses
  verbs:
    - '*'
- apiGroups:
    - apiextensions.crossplane.io
  resources:
    - compositions
  verbs:
    - '*'
```

Furthmore, AppSSO installs [_OpenShift_-specific RBAC and resources](openshift.md).
