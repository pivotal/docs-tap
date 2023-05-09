# Use Git with Supply Chain Choreographer

This topic explains how you can use Git with Supply Chain Choreographer.

The out of the box supply chains and delivery use Git in three ways:

- To fetch the developers source code, using the [template](ootb-template-reference.hbs.md#source-template).
- To store complete Kubernetes configuration, the write side of GitOps, using 
  [template 1](ootb-template-reference.hbs.md#config-writer-template), [template 2](ootb-template-reference.hbs.md#config-writer-and-pull-requester-template), [template 3 (experimental)](ootb-template-reference.hbs.md#package-config-writer-template-experimental), and [template 4 (experimental)](ootb-template-reference.hbs.md#package-config-writer-and-pull-requester-template-experimental).
- To fetch stored Kubernetes configuration, the read side of GitOps,
  from either the same or a different Kubernetes cluster, using the
  [template](ootb-template-reference.hbs.md#delivery-source-template).

## Supported Git Repositories

Tanzu Application Platform supports three git providers:

- Github
- Gitlab
- [Azure DevOps](azure.hbs.md)

## Related Articles

[Git Authentication](git-auth.hbs.md) walks through the objects, such as secrets and service accounts,
to create on cluster to allow supply chain Git operations to succeed.

[GitOps versus RegistryOps](gitops-vs-regops.hbs.md) discusses the two methods
of storing built Kubernetes configuration, either in a Git repository or a
container image registry, and walks through the parameters that must be provided
for each.

[Configuration for Azure DevOps](azure.hbs.md): discusses configuration necessary for working with this git
provider.
