# Duck Typed resources

This topic describes the duck typed resources for Tanzu Supply Chain.

Two of the resources in Tanzu Supply Chains are called "Duck Types".
The two resource types that are "Duck types" are [Workloads](./workload.hbs.md) and [WorkloadRuns](./workloadrun.hbs.md).

In short, a duck type resource is a resource with significant commonality, like a "Class" in Object Oriented Design, but without the inheritance.

![duck-type.png](./images/duck-type.png)

As shown, some sections of a Duck Type API are unchanging (static) and others can and do change (dynamic)

Both Tanzu Supply Chain duck types have dynamic kinds, which means there may be many Kubernetes CRDs that comply with the WorkloadRun Duck Type.