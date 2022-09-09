# OpenShift

On _OpenShift_ clusters AppSSO must run with a custom SecurityContextConstraint (SCC) to enable compliance with
restricted Kubernetes Pod Security Standards. The following SCC will be configured for AppSSO's controller
and its `AuthServer`-managed resources when the `kubernetes_distribution: openshift` key is configured in tap-values.yaml.
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

Its controller's `ServiceAccount` is given these additional permissions so that it may provision AuthServers allowed
to use our custom SCC:

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

as well as a `use` permission specifically for AppSSO SCC:

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
