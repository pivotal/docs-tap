On OpenShift clusters, Developer Conventions must run with a custom SecurityContextConstraint (SCC)
to enable compliance with restricted Kubernetes pod security standards. Tanzu Application Platform
configures the following SCC for the Developer Convention's webhook when you configure the
`kubernetes_distribution: openshift` key in the `tap-values.yaml` file.

Specification follows:

```yaml
---
apiVersion: security.openshift.io/v1
kind: SecurityContextConstraints
metadata:
  name: developer-conventions-scc
allowHostDirVolumePlugin: false
allowHostIPC: false
allowHostNetwork: false
allowHostPID: false
allowHostPorts: false
allowPrivilegeEscalation: false
allowPrivilegedContainer: false
defaultAddCapabilities: null
fsGroup:
  type: RunAsAny
priority: null
readOnlyRootFilesystem: false
requiredDropCapabilities: null
runAsUser:
  type: MustRunAsNonRoot
seLinuxContext:
  type: MustRunAs
supplementalGroups:
  type: RunAsAny
volumes:
  - secret
seccompProfiles: []
groups:
  - system:serviceaccounts:developer-conventions
```
