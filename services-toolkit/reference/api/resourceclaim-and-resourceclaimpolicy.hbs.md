# ResourceClaim and ResourceClaimPolicy

This topic provides Services Toolkit API documentation for `ResourceClaim` and `ResourceClaimPolicy`.

## <a id="resourceclaim"></a> ResourceClaim

`ResourceClaim` is used to claim a specific Kubernetes resource by using a reference.
`ResourceClaim` adheres to [Provisioned Service](https://github.com/servicebinding/spec#provisioned-service)
as defined by the Service Binding Specification for Kubernetes.
you can bind a `ResourceClaim` to an application workload by using a reference in the workload's
`.spec.serviceClaims` configuration.

A `ResourceClaim` is exclusive by nature. This means that after a `ResourceClaim` has
claimed a resource, no other `ResourceClaim` can claim that same resource.

```yaml
apiVersion: services.apps.tanzu.vmware.com/v1alpha1
kind: ResourceClaim

metadata:
  # The name for the claim.
  name: claim-1
  # The namespace in which to create the claim.
  namespace: my-apps
  # Internal finalizers applied by the resource claim controller to ensure
  # resources are cleaned up.
  finalizers:
  - resourceclaims.services.apps.tanzu.vmware.com/finalizer
  - resourceclaims.services.apps.tanzu.vmware.com/lease-finalizer

spec:
  # ref is a reference to the resource to be claimed.
  ref:
    # The API Group/Version of the resource to claim in the GROUP/VERSION format.
    apiVersion: v1
    # The API Kind of the resource to claim.
    kind: Secret
    # The name of the resource to claim.
    name: 770845b6-02f0-4c1b-8d0c-3dae81bad35c
    # (Optional) The namespace of the resource to claim. If the resource exists
    # in a different namespace to the namespace of the claim, then you must configure
    # a corresponding ResourceClaimPolicy to permit claiming of the resource.
    namespace: service-instances

status:
  # Conditions for the claim.
  conditions:
    # The condition type. Can be one of 'Ready', 'ResourceMatched' or 'ResourceMatched'.
    # All condition types are initialized for all claims.
    # The Ready condition reports status: "True" once all other condition types are healthy.
    - type: Ready
      # status can be either 'True' or 'False'.
      status: "True"
      # reason provides a reason for status: "False" for additional context.
      # One of 'ResourceNotFound', 'BindingNotCopyable', 'UnableToSetExclusiveClaim',
      # 'ResourceNonBindable', 'NoMatchingResourceClaimPolicy',
      # 'UnableToTrackReferencedResource', 'ResourceAlreadyClaimed',
      # 'UpdatedResourceReference', or 'ClaimMarkedForDeletion'.
      # Not set if status: "True".
      reason:

  # binding holds a reference to a secret in the same namespace which contains
  # credentials for accessing the claimed service instance.
  binding:
    # The name of the secret. The presence of the .status.binding.name field marks
    # this resource as a Provisioned Service.
    name: 770845b6-02f0-4c1b-8d0c-3dae81bad35c

  # claimedResourceRef holds a reference to the claimed resource.
  claimedResourceRef:
    # The API Group/Version of the claimed resource in the GROUP/VERSION format.
    apiVersion: v1
    # The API kind of the claimed resource.
    kind: Secret
    # The name of the claimed resource.
    name: 770845b6-02f0-4c1b-8d0c-3dae81bad35c
    # The namespace of the claimed resource.
    namespace: service-instances

  # Populated based on metadata.generation when controller observes a change to
  # the resource. If this value is out of date, other status fields do not
  # reflect latest state.
  observedGeneration: 1
```

## <a id="resourceclaimpolicy"></a> ResourceClaimPolicy

`ResourceClaimPolicy` provides a mechanism to either permit or deny the claiming
of resources across namespaces.

```yaml
apiVersion: services.apps.tanzu.vmware.com/v1alpha1
kind: ResourceClaimPolicy

metadata:
  # The name for the policy.
  name: default-ns-can-claim-secret-1
  # The namespace for the policy.
  # ResourceClaimPolicy resources must exist in the same namespace as the resources
  # they are permitting to be claimed.
  namespace: x-namespace-1

spec:
  # consumingNamespaces specifies the source namespace(s) to permit the claiming
  # of the resources from.
  # Use '*' to configure all namespaces.
  consumingNamespaces:
  - default

  # The API group of the resource to permit the claiming of.
  group: rabbitmq.com
  # The API kind of the resource to permit the claiming of.
  kind: RabbitmqCluster
  # (Optional) selector is a labelSelector to match resources to permit the claiming of.
  selector:
    matchLabels:
      "key": "value"
```
