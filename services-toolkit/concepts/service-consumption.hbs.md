# The four levels of service consumption in Tanzu Application Platform

As Tanzu Application Platform has evolved, so has the way to offer and consume services on the platform.
This topic charts the progress of this evolution in terms of four levels of service consumption.

The introduction of a higher level does not automatically mean that all lower levels are made obsolete.
In most cases, the higher levels build upon the foundations laid by the lower
levels, and represent an abstraction that is higher-level and more opinionated.

## <a id="direct-bindings"></a> Level 1 - direct bindings

Tanzu Application Platform v1.0 included support for service bindings, which back the level 1
concept of direct bindings.

![Diagram shows level 1 of service consumption in Tanzu Application Platform.](../../images/stk-4-levels-1.png)

For example, if you deploy an application workload to Tanzu Application Platform, this results in a
Knative service in a namespace.
An API resource in the same namespace that represents a service, such as a database
or a cache, is called a service resource.

Using a service binding you can bind that service resource with the Knative service.
This injects the credentials for the service resource into the Knative service, so that the
application workload can consume it.

In this relatively straightforward scenario, there are only a few resources involved and
there is no unnecessary indirection. <!-- what does this mean? -->
In fact, users are not even directly exposed to the service binding.
The service binding is created automatically as part of the Out of the Box Supply Chains whenever an
application workload is configured to refer to a service.

However, there are a number of limitations with this setup.
The first is that the service resource must be bindable and which means it must adhere to
the provisioned services definition in the service binding specification for Kubernetes.
For more information, see [Provisioned Service](https://github.com/servicebinding/spec#provisioned-service).
There are some resources that adhere to this specification, primarily resources
offered by VMware Tanzu's data services, but the overwhelming majority of resources don't.

The second limitation is that all resources have to be in the same namespace.

The third limitation is that the service binding has have detailed and specific information about
the service resource, including its name, namespace, and API group, version, and kind.
This is not a clear separation of concerns as it introduces tight coupling between app teams,
who create the application workloads, and ops teams, who create the service resources.

## <a id="resource-claims"></a> Level 2 - resource claims

Level 2 addresses some of the limitations of direct bindings through the Services Toolkit feature
resource claims. This feature coincided with the release of Tanzu Application Platform v1.0.

![Diagram shows level 2 of service consumption in Tanzu Application Platform.](../../images/stk-4-levels-2.png)

For example, if you have the same setup as in [Level 1 - direct bindings](#direct-bindings),
but you want the service resource to be in a separate namespace from the Knative service
you cannot use direct bindings.
This is because the [schema](https://github.com/servicebinding/spec#resource-type-schema-1)
for ServiceBinding provides no option to configure a `namespace` for the service.

Resource claims allow you to claim a bindable service resource that exists in another namespace,
and to then bind the application workload to the resource claim instead of to the service resource directly.
Because you are now crossing namespace tenancy boundaries, you are only permitted to claim the
service resource if you create a corresponding resource claim policy.

The advantage of level 2 over level 1 is that now the application workload and the service resource
do not have to exist in the same namespace. This helps to promote a better separation of concerns.
It is now possible for apps teams and ops teams to manage the life cycles of apps and services independently.

However, it's still not an ideal solution, and some of the limitations from level 1 still exist in level 2.
The service resource still must be bindable, and apps teams still must know the name,
namespace, and API group, version, and kind of the service resource.
In addition, ops teams must ensure that the service resources exist.
These resources must be manually provisioned and permitted to be claimed through policy, otherwise
resource claims created by the apps teams will remain in a pending state indefinitely.

## <a id="pool-based-classes"></a> Level 3 - class claims and pool-based classes

Level 3 introduces class claims and pool-based classes. Originally released with
Tanzu Application Platform v1.4, class claims and pool-based classes help to alleviate the issue of
apps teams having to know detailed information about service resources.

![Diagram shows level 3 of service consumption in Tanzu Application Platform.](../../images/stk-4-levels-3.png)

Level 3 builds on the example in level 2, which has an application workload in a namespace `foo`
and a service resource in a namespace `bar`.
Rather than relying on resource claim and resource claim policy, level 3 introduces
a class claim and a pool-based class.

The pool-based class can pool service resources using label or field selectors from across all
namespaces on the cluster.
Ops teams create the service resources and then create a class to gather them all together into one
logical group that apps teams can discover and claim from.

Apps teams can discover the available classes using the `tanzu service class list` command.
Rather than creating a resource claim, they instead create a higher-level abstraction - a class claim.
The class claim refers to the name of a class.
You only need to create a class claim referring to a class and then bind your application workload to the class claim.
There is no longer a need to provide detailed information such as the API group, version, and kind
for the service resource behind the class.

Level 3 is much simpler for apps teams to consume services and the separation of concerns is much neater.
A few limitations still remain. Service resources must still be bindable and ops teams still must
manually provision the service resources to fill the pool.

## <a id="provisioner-based-classes"></a> Level 4 - class claims and provisioner-based classes (aka "Dynamic Provisioning")

Level 4 is the current highest level of service consumption in Tanzu Application Platform.
Released in Tanzu Application Platform v1.5, it introduces provisioner-based
classes, which, together with class claims, power Tanzu Application Platform's dynamic provisioning capability.

![Diagram shows level 4 of service consumption in Tanzu Application Platform.](../../images/stk-4-levels-4.png)

Level 4 builds on the example in level 3, but the class now defines a provisioner rather than a pool.
Services Toolkit in Tanzu Application Platform v1.5 supports one provisioner type - [Crossplane](https://www.crossplane.io/).
Support for new provisioners might be added in the future.

When you create a class claim that refers to a provisioner-based class, the Services Toolkit controller
requests the provisioner to provision the resources necessary to create a service instance
that can then be bound to application workloads.
In this example, the provisioner creates a namespace, a service resource, and a secret that conforms
to the binding specification.
Then, that secret is wired all the way back through to the application workload.

Two big advantages are realized at level 4. Firstly, ops teams no longer need to manually provision service resources.
They are now created on-demand as and when needed.
This not only helps to remove unnecessary burden from ops teams, but also helps to provide better
use of resources because service resources no longer need to remain in a pool waiting to be claimed.
The second advantage is that service resources no longer need to be bindable.
The provisioner can act almost like an adapter to bring pretty much any service you can think of into Tanzu Application Platform.
The only requirement is that the provisioner create a binding-conforming secret that holds credentials
for the provisioned service resources. You can configure this once during the dynamic provisioning setup.

While level 4 is very powerful and seemingly solves the problems mentioned so far,
it's not entirely without its drawbacks.
The main one being that all this flexibility comes at the cost of added complexity.
There are many, many more moving parts involved at level 4 when compared to level 1.
However, it might be a price worth paying to benefit from all that is on offer.

## <a id="summary"></a> Summary

By now you have seen how each new level builds and improves upon the last.
All levels are also valid use cases in their own right.

![Diagram shows a summary of the levels of service consumption in Tanzu Application Platform.](../../images/stk-4-levels-summary.png)

Tanzu Application Platform users can choose which level to operate at.
Finding the level that is right for your situation depends on a number of factors, such as, the size
of the organization you work for and the layout of apps teams and ops teams within the org.

If you work at a small startup in which there are no strict divides between apps teams and ops teams,
level 1 might be suitable for your needs.
However, if you work for a large organization with distinct and dedicated apps and ops teams,
choosing one of the higher levels in which that separation is better catered to might make more sense.
If you are not sure, it's probably best to start with level 4.
Level 4 provides the ultimate services experience on Tanzu Application Platform, and as such will
hopefully meet all your services needs.
