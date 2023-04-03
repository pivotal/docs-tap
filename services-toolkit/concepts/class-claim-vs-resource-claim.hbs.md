# Class Claims compared to Resource Claims

There are two types of claim to choose from when working with services on Tanzu Application Platform.
These are `ClassClaim` and `ResourceClaim`.
This section explains the similarities and differences between the two and when use of one is
preferable over the other.

In short, it is usually advisable to work with `ClassClaim`s where possible as they are easier to
create and are more portable across multiple clusters.
They are also used as the trigger mechanism for dynamic provisioning of service instances.

## <a id="similarities"></a>Similarities

- Both APIs express that you want to access to a service instance.
- Both APIs adhere to the `ProvisionedService` duck type.  They both have the field `.status.binding.name` in their API.
This means that they both can be targeted using a `ServiceBinding` and therefore both can be
fed into Cartographer's `Workload` API.
- Both APIs ensure mutual exclusivity of claims on service instances.
After using either a `ClassClaim` or a `ResourceClaim` to claim a service instance,
no other `ClassClaim` or a `ResourceClaim` can claim that same service instance.

## <a id="resourceclaim"></a> `ResourceClaim`

A `ResourceClaim` targets a specific resource in the Kubernetes cluster.  To
target that resource, the `ResourceClaim` needs the name, namespace, kind, and
API version of the resource.

The specificity of the `ResourceClaim` means it is most useful when you must guarantee which service
instance the application workload will use.
For example, if the application must connect to the exact same database instance while it advances
through development, test, and production environments.
If if you do not need this guarantee, VMware recommends that you use the `ClassClaim` API instead.

## <a id="classclaim"></a> `ClassClaim`

A `ClassClaim` targets a `ClusterInstanceClass` in the Kubernetes cluster.
To target this class, the `ClassClaim` only requires the name of the `ClusterInstanceClass`.

The `ClusterInstanceClass` can represent any set of service instances and therefore
each time you create a new `ClassClaim`, you can claim any of the service
instances represented by that `ClusterInstanceClass`.
After a `ClassClaim` has claimed a service instance, then it never looks for another.
This is true even if the `ClassClaim`'s `spec` is updated or the `ClusterInstanceClass` is
updated.
Therefore, the `ClassClaim` is performing a **point-in-time** lookup at
its creation, using the `ClusterInstanceClass` for that lookup.

The loose coupling between the `ClassClaim` and the service instances means that
`ClassClaim`s are great in situations where:

- You need to inject different service instances into the application workload
at different points in its advancement from development to production
environments. For more information, see
[Abstracting Service Implementations Behind A Class Across Clusters](../tutorials/abstracting-service-implementation-behind-class-across-clusters.hbs.md).
- The `ClassClaim`, and also any workload referencing it, must be
promoted from one environment to the next without changing their specification.

`ClassClaim`s are the only type of claim that you can use to dynamically provision service instances.
