# Out of the Box Delivery Basic

This package provides a reusable ClusterDelivery object that is responsible for
delivering to an environment the Kubernetes configuration that has been
produced by the Out of the Box Supply Chains, including [Basic](ootb-supply-chain-basic.html),
[Testing](ootb-supply-chain-testing.html), and
[Testing With Scanning](ootb-supply-chain-testing-scanning.html).

## <a id="prerequisites"></a> Prerequisites

To make use of this package you must have installed:

- [Supply Chain Cartographer](../install-components.html#install-scc)
- [Out of the Box Templates](ootb-templates.html)

## <a id="prerequisites"></a> Usage

Out of the Box Delivery Basic support both GitOps and local development workflows:

```text
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

As a prerequisite to the [Basic](ootb-supply-chain-basic.html),
[Testing](ootb-supply-chain-testing.html), and
[Testing With Scanning](ootb-supply-chain-testing-scanning.html) Out of the Box
Supply Chains, you must install this package to have Workloads delivered properly.

Consumers do not interact directly with this package. Instead, this package is used
once a [carto.run/Deliverable](https://github.com/vmware-tanzu/cartographer) object is created by the supply
chains to express the intention of having the Workloads that go through them
delivered to an environment. At this time, the environment is the same Kubernetes cluster as the
Supply Chains.
