# RBAC for AppSSO

<!--- TODO(mbrauer) --->

The Application Single Sign-On (commonly called AppSSO) package aggregates the 
following permissions into Tanzu Application Platform's well-known roles. 
For more information, see 
[Role descriptions for Tanzu Application Platform](../../authn-authz/role-descriptions.hbs.md).

## <a id="rules"></a> User aggregated rules

### <a id="app-operator"></a> app-operator

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

### <a id="app-editor"></a> app-editor

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

### <a id="app-viewer"></a> app-viewer

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

### <a id="service-operator"></a> service-operator

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

## <a id="controller"></a> Controller

To manage the life cycle of AppSSO's [APIs](index.hbs.md), the AppSSO controller's 
`ServiceAccount` has a `ClusterRole` with the following permissions:

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

AppSSO also installs OpenShift specific RBAC and resources. For more information, 
see [Application Single Sign-On for OpenShift clusters](./openshift.hbs.md).
