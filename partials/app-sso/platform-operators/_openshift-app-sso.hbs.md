On OpenShift clusters, AppSSO must run with a custom SecurityContextConstraint (SCC) to enable compliance with
restricted Kubernetes Pod Security Standards. Tanzu Application Platform configures the following SCC for AppSSO controller
and its `AuthServer` managed resources when you configure the `kubernetes_distribution: openshift` key in the `tap-values.yaml` file.

Specification follows:

```yaml
---
kind: SecurityContextConstraints
apiVersion: security.openshift.io/v1
metadata:
  name: appsso-scc
allowHostDirVolumePlugin: false
allowHostIPC: false
allowHostNetwork: false
allowHostPID: false
allowHostPorts: false
allowPrivilegeEscalation: false
allowPrivilegedContainer: false
allowedCapabilities: null
defaultAddCapabilities: null
fsGroup:
  type: MustRunAs
priority: null
readOnlyRootFilesystem: false
requiredDropCapabilities:
  - KILL
  - MKNOD
  - SETUID
  - SETGID
runAsUser:
  type: MustRunAsNonRoot
seLinuxContext:
  type: MustRunAs
volumes:
  - configMap
  - downwardAPI
  - emptyDir
  - persistentVolumeClaim
  - projected
  - secret
seccompProfiles:
  - 'runtime/default'

```

AppSSO controller's `ServiceAccount` is given the following additional permissions, including a `use` permission for AppSSO SCC, so `AuthServer` can use the custom SCC:

```yaml
- apiGroups:
    - security.openshift.io
  resources:
    - securitycontextconstraints
  verbs:
    - "get"
    - "list"
    - "watch"
```

```yaml
- apiGroups:
    - security.openshift.io
  resourceNames:
    - appsso-scc
  resources:
    - securitycontextconstraints
  verbs:
    - "use"
```
