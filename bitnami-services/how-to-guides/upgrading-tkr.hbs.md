# Upgrading to Tanzu Kubernetes releases v1.26 or later

This topic describes how to update your existing Bitnami Services instances if you upgraded to
Tanzu Kubernetes releases v1.26 and later.

Tanzu Kubernetes releases v1.26 and later enforces a [`restricted` Pod Security Standard (PSS)](https://kubernetes.io/docs/concepts/security/pod-security-standards/#restricted)
for all pods running on the cluster.
This change affects your running Bitnami services.
Services claimed in Tanzu Application Platform v1.6 will fail to start after you upgrade to
Tanzu Kubernetes releases v1.26 or later.

## <a id="workaround"></a>Workaround

VMware recommends that you apply a workaround based on mutating pods through a mutating webhook.

For example, using [Kyverno](https://kyverno.io/), the following `ClusterPolicy` applies the
necessary changes to every pod created on the cluster:

```yaml
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: set-security-context
spec:
  rules:
    - name: set-security-context
      match:
        any:
        - resources:
            kinds:
            - Pod
            selector:
              matchExpressions:
              - key: app.kubernetes.io/name
                operator: In
                values:
                - kafka
                - mongodb
                - mysql
                - postgresql
                - rabbitmq
                - redis
      mutate:
        patchStrategicMerge:
          spec:
            containers:
              - (name): "*"
                securityContext:
                  allowPrivilegeEscalation: false
                  runAsNonRoot: true
                  seccompProfile:
                    type: RuntimeDefault
                  capabilities:
                    drop: ['ALL']
            initContainers:
              - (name): "*"
                securityContext:
                  allowPrivilegeEscalation: false
                  runAsNonRoot: true
                  seccompProfile:
                    type: RuntimeDefault
                  capabilities:
                    drop: ['ALL']
            ephemeralContainers:
              - (name): "*"
                securityContext:
                  allowPrivilegeEscalation: false
                  runAsNonRoot: true
                  seccompProfile:
                    type: RuntimeDefault
                  capabilities:
                    drop: ['ALL']
```

You might have to trigger the reconciliation of any `ReplicaSet` or `StatefulSet` that have failed
in the past by editing them, for example, adding a label.
