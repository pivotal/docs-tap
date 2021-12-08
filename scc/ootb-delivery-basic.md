---
title: Out of The Box Delivery Basic (ootb-delivery-basic)
weight: 2
---

This package provides a reusable ClusterDelivery object that is responsible for
delivering to an environment the Kubernetes configuration that has been
produced by the Out of The Box Supply Chains, including Basic, Testing, and Testing With
Scanning.

It support both GitOps and local development workflows:


```
GITOPS

    Deliverable:
      points at a git repository where source code is found and
      kubernetes configuration is pushed to


LOCAL DEVELOPMENT

    Deliverable:

      points at a container image registry where the supplychain
      pushes source code and configuration to


---

DELIVERY

    takes a Deliverable (local or gitops) and passes is through
    a series of resources:

    
           config-provider  <---[config]--- deployer
                 .                             .
                 .                             .
    GitRepository/ImageRepository         kapp-ctrl/App
                                                - knative/Service
                                                - ResourceClaim
                                                - ServiceBinding
                                                ...
```

As a prerequisite of the Out of The Box Supply Chains (the three of them), it
must be installed in order to have Workloads being properly delivered.

ps.: from the perspective of a consumer of the Out of The Box Supply Chains,
this package is not something to be interacted with directly - it's used behind
the scenes once a [carto.run/Deliverable] object is created by the supply
chains to express the intention of having the Workloads that go through them
delivered to an environment (at the moment, the same Kubernetes cluster as the
Supply Chains).


### Prerequisites

To make use of this package, it's required that:

- Cartographer is installed
- Out of The Box Templates is installed
