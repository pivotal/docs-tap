---
title: Supply Chain Choreographer for VMware Tanzu
subtitle: Supply Chain Choreography
weight: 1
---

# Supply Chain Choreographer for VMware Tanzu

This topic introduces Supply Chain Choreographer.

## Overview

Supply Chain Choreographer is based on open source [Cartographer](https://cartographer.sh/docs/).
It allows App Operators to create pre-approved paths to production by integrating Kubernetes 
resources with the elements of their existing toolchains (e.g. Jenkins).

Each pre-approved supply chain creates a paved road to production; orchestrating supply chain 
resources - test, build, scan, and deploy - allowing developers to be able to focus on 
delivering value to their users while also providing App Operators with the peace of mind that 
all code in production has passed through all of the steps of an approved workflow.

## Out of the box Supply Chains

VMware Tanzu ships with [Out-of-the-Box Supply Chains](default-supply-chains.md).

## About Installing

Supply Chain Choreographer is released as a Tanzu Package.

To install Supply Chain Choreographer, see [Install Supply Chain Choreographer](../install-components#install-scc.md).
