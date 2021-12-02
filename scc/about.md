---
title: Supply Chain Choreographer for Tanzu
subtitle: Supply Chain Choreography
weight: 1
---

# Supply Chain Choreographer for Tanzu

This topic introduces Supply Chain Choreographer.

## Overview

Supply Chain Choreographer is based on open source [Cartographer](https://cartographer.sh/docs/).
It allows App Operators to create pre-approved paths to production by integrating Kubernetes 
resources with the elements of their existing toolchains (e.g. Jenkins).

Each pre-approved supply chain creates a paved road to production; orchestrating supply chain 
resources - test, build, scan, and deploy - allowing developers to be able to focus on 
delivering value to their users while also providing App Operators with the peace of mind that 
all code in production has passed through all of the steps of an approved workflow.

# Out of The Box supply chains

Out of the box supply chains are provided with Tanzu Application Platform.

The following three supply chains are included:

- Out of The Box Supply Chain Basic
- Out of The Box Supply Chain with Testing
- Out of The Box Supply Chain with Testing and Scanning

As auxiliary components, Tanzu Application Platform also includes:

- Out of The Box Templates, for providing templates used by the supply chains
  to perform common tasks like fetching source code, running tests, and
  building container images.

- Out of The Box Delivery Basic, for deliverying to a Kubernetes cluster the
  configuration built throughout a supply chain

Note that both Templates and Delivery Basic are requirements for the Supply
Chains. 

## Installing

Supply Chain Choreographer is released as a Tanzu Package.

To install Supply Chain Choreographer, see [Install Supply Chain Choreographer](../install-components.md#install-scc).
