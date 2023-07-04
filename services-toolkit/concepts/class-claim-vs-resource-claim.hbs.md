# Class claims compared to resource claims

There are two types of claim you can choose from when working with services on Tanzu Application Platform
(commonly known as TAP). These are `ClassClaim` and `ResourceClaim`.
This Services Toolkit topic explains the similarities and differences between the two and when using
one is preferable over the other.

It is usually advisable to work with a `ClassClaim` where possible as they are easier to
create and are more portable across multiple clusters.
They are also used as the trigger mechanism for dynamic provisioning of service instances.

## <a id="similarities"></a>Similarities

- Both APIs express that you want to access to a service instance.
- Both APIs adhere to the `ProvisionedService` duck type. They both have the field `.status.binding.name`
  in their API.
  This means that you can target them using a `ServiceBinding` and, therefore, you can feed them into
  Cartographer's `Workload` API.
- Both APIs ensure that mutual exclusivity of claims on service instances.
  After using either a `ClassClaim` or a `ResourceClaim` to claim a service instance,
  no other `ClassClaim` or a `ResourceClaim` can claim that same service instance.

## <a id="resourceclaim"></a> Using a `ResourceClaim`

A `ResourceClaim` targets a specific resource in the Kubernetes cluster.  To
target that resource, the `ResourceClaim` needs the name, namespace, kind, and
API version of the resource.

The specificity of the `ResourceClaim` means it is most useful when you must guarantee which service
instance the application workload uses.
For example, if the application must connect to the exact same database instance while it advances
through development, test, and production environments.
If if you do not need this guarantee VMware recommends that you use the `ClassClaim` API instead.

## <a id="classclaim"></a> Using a `ClassClaim`

A `ClassClaim` targets a `ClusterInstanceClass` in the Kubernetes cluster.
To target this class, the `ClassClaim` only requires the name of the `ClusterInstanceClass`.

The `ClusterInstanceClass` can represent any set of service instances and therefore
each time you create a new `ClassClaim`, you can claim any of the service
instances represented by that `ClusterInstanceClass`.
After a `ClassClaim` has claimed a service instance, it never looks for another.
This is true even if the `ClassClaim`'s `spec` is updated or the `ClusterInstanceClass` is
updated.
Therefore, the `ClassClaim` is performing a **point-in-time** lookup at
its creation, using the `ClusterInstanceClass` for that lookup.

The loose coupling between the `ClassClaim` and the service instances means that a
`ClassClaim` is best in situations where:

- You must inject different service instances into the application workload
at different points in its advancement from development to production
environments. For more information, see
[Abstracting Service Implementations Behind A Class Across Clusters](../tutorials/abstracting-service-implementation.hbs.md).
- The `ClassClaim`, and also any workload referencing it, must be
promoted from one environment to the next without changing their specification.

The `ClassClaim` is the only type of claim that you can use to dynamically provision service instances.
