# Git

## Overview

The out of the box supply chains/delivery leverage git in 3 ways:

- To fetch the developers source code. [template](ootb-template-reference.hbs.md#source-template)
- To store complete kubernetes configuration (the "write" side of gitops). 
  [template 1](ootb-template-reference.hbs.md#config-writer-template) and [template 2](ootb-template-reference.hbs.md#config-writer-and-pull-requester-template)
- To fetch stored kubernetes configuration (the "read" side of gitops)
  from either the same or a different kubernetes cluster.
  [template](ootb-template-reference.hbs.md#delivery-source-template)

## Supported Git Repositories

TAP supports three git providers:

- Github
- Gitlab
- [Azure DevOps](azure.hbs.md)

## Related Articles

[Git Authentication](git-auth.hbs.md): walks through the objects (secrets and service accounts)
to create on cluster to allow supply chain git operations to succeed.

[GitOps versus RegistryOps](gitops-vs-regops.hbs.md): discusses the two methods of storing built kubernetes
configuration (either in a git repository or an image registry) and walks through the parameters that must
be provided for each.

[Configuration for Azure DevOps](azure.hbs.md): discusses configuration necessary for working with this git
provider.
