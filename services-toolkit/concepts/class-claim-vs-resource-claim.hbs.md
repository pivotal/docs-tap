# Class Claims compared to Resource Claims

There are two types of claim to choose from when working with services on Tanzu Application Platform. These are `ClassClaim` and `ResourceClaim`.
This section explains the similarities and differences between the two and when usage of one is preferable over the other.

In short, it is usually advisable to work with `ClassClaim`s where possible as they are easier to create and are more portable across multiple clusters.
They are also used as the trigger mechanism for dynamic provisioning of service instances.

## Similarities

- Both APIs express the desire for access to a Service Instance.
- Both APIs adhere to the `ProvisionedService` duck type.  In order words,
they both have the field `.status.binding.name` in their API.  This means that
they both can be targeted via a `ServiceBinding` and therefore both can be
fed into Cartographer's `Workload` API.
- Both APIs ensure mutual exclusivity of claims on Service Instances.  That is to
say that that once a Service Instance has been claimed (by either a `ClassClaim` or a `ResourceClaim`),
then no other `ClassClaim` or a `ResourceClaim` can successfully claim that same Service Instance.

## `ResourceClaim`

A `ResourceClaim` targets a specific resource in the Kubernetes cluster.  To
target that resource, the `ResourceClaim` needs the name, namespace, kind, and
API version of the resource.

The specificity of the `ResourceClaim` means it is most useful when:

- There's a strong need to guarantee which Service Instance the application
workload will be utilising.  For example, if the application needs to connect
to exact same database instance as it promotes through development, test, and
production environments.

If the above is not true, then it is recommended to look at the `ClassClaim` API instead.

## `ClassClaim`

A `ClassClaim` targets a `ClusterInstanceClass` in the Kubernetes cluster.  To
target that class, the `ClassClaim` just needs its name.  The
`ClusterInstanceClass` can represent any set of service instances and therefore
each time you create a new `ClassClaim`, you could claim any of the service
instances represented by that `ClusterInstanceClass`.  Once a `ClassClaim` has
claimed a service instance, then it will never look for another.  This is true
even if the `ClassClaim`'s spec is updated or the `ClusterInstanceClass` is
updated.  Therefore the `ClassClaim` is performing a **point-in-time** lookup at
its creation, utilising the `ClusterInstanceClass` for that lookup.

The loose coupling between the `ClassClaim` and the Service Instances means that
`ClassClaim`s are great in situations where:

- Different Service Instances need to be injected into the application workload
at different points in its promotion from development to production
environments (see [Abstracting Service Implementations Behind A Class Across Clusters](../tutorials/abstracting-service-implementation-behind-class-across-clusters.hbs.md) for more info).
- The `ClassClaim` (perhaps along with a `Workload` referencing it) need to be
promoted from one environment to the next without changing their specification.

`ClassClaim`s are the only type of claim that can be used for dynamic provisioning of service instances.
