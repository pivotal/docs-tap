# Supply Chain Choreographer for Tanzu

This topic introduces Supply Chain Choreographer.

## <a id="overview"></a> Overview

Supply Chain Choreographer is based on open source [Cartographer](https://cartographer.sh/docs/).
It allows App Operators to create pre-approved paths to production by integrating Kubernetes
resources with the elements of their existing toolchains, for example, Jenkins.

Each pre-approved supply chain creates a path to production. Orchestrating supply chain
resources including, test, build, scan, and deploy allows developers to focus on
delivering value to their users and provides App Operators the assurance that
all code in production has passed through all the steps of an approved workflow.

## <a id="out-of-the-box-supply-chains"></a> Out of the Box Supply Chains

Out of the box supply chains are provided with Tanzu Application Platform.

The following three supply chains are included:

- [Out of the Box Supply Chain Basic](ootb-supply-chain-basic.html)
- [Out of the Box Supply Chain with Testing](ootb-supply-chain-testing.html)
- [Out of the Box Supply Chain with Testing and Scanning](ootb-supply-chain-testing-scanning.html)

As auxiliary components, Tanzu Application Platform also includes:

- [Out of the Box Templates](ootb-templates.html), for providing templates used by the supply chains
  to perform common tasks such as fetching source code, running tests, and
  building container images.

- [Out of the Box Delivery Basic](ootb-delivery-basic.html), for delivering to a Kubernetes cluster the
  configuration built throughout a supply chain

Both Templates and Delivery Basic are requirements for the Supply Chains.
