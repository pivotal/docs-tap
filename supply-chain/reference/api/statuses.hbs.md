# Resource Statuses

This topic describes the statuses for Tanzu Supply Chain resources.

Every status in Tanzu Supply Chain resources adheres to the same set of rules, starting with those set out by Kubernetes API Conventions.

The `spec.conditions` array is referred to as a Condition Set.

Each Condition Set has a top level condition type selected based on the behavior of the resource, Living and Batch.

## Living resource

This resource is never "finished", instead it modifies it's managed resources or internal services to match the state of the `spec`. Examples include `services` and `pods`.

A living resource's top-level condition type is Ready.

However, some Living resources are resistant to changes in their spec. They are "living and immutable". For example, the [Component Resource](./component.hbs.md).

## Batch resource

Batch resources complete. They're expected to terminate after they have achieved the desired outcome. Typically their `spec` is immutable, or if it is mutable, the mutation has no effect.

A batch resource's top-level condition type is *Succeeded*

For more information, see [Kubernetes](https://github.com/kubernetes/kubernetes/blob/release-1.1/docs/devel/api-conventions.md#typical-status-properties) documentation.