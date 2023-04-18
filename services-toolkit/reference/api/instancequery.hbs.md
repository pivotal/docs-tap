# InstanceQuery

Detailed API documentation for `InstanceQuery`.

## <a id="instancequery"></a> InstanceQuery

`InstanceQuery` is a create-only API that, given a pool-based `ClusterInstanceClass`, returns the
intersection of the set of service instances represented by that class and the claimable service instances
for the namespace of the `InstanceQuery`.

```yaml
apiVersion: claimable.services.apps.tanzu.vmware.com/v1alpha1
kind: InstanceQuery

metadata:
  # An arbitrary name for the query.
  name: test
  # The namespace from which query. The resulting list of instances will be specific to the namespace of the query
  # itself.
  namespace: my-apps

spec:
  # The name of the class to query for claimable instances. Must refer to a pool-based class and not a
  # provisioner-based class.
  class: pooled-class-1
  # A limit on the maximum number of instances to return.
  # (optional; default=50).
  limit: 1

status:
  # A list of service instances which can be successfully claimed by ResourceClaims creted in the same namespace as the
  # query.
  instances:
    # The API group/version of the claimable instance in the format GROUP/VERSION.
  - apiVersion: v1
    # The API kind of the claimable instance.
    kind: Secret
    # The name of the claimable instance.
    name: my-secret-two
    # The namespace of the claimable instance.
    namespace: default
```
