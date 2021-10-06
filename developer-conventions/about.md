---
title: Developer Conventions for VMware Tanzu
subtitle: Developer Conventions
weight: 1
---

# Developer Conventions

This topic introduces Developer Conventions.

## Overview

Developer Conventions configures the following modifications to workloads for live updates
and debugging:

- Scaling the workload to one pod
- Extending HTTP-based timeouts
- Enabling live-update using JAVA_TOOL_OPTIONS and spring-boot-devtools
- Enabling debugging using the Java debug buildpack


## Features

Key features of Developer Conventions are:

- **Live updates:** See live changes made to your source code appear in your running app on your cluster.

- **Debugging:** Set breakpoints to help you debug your running app on your cluster.


## About Installing

Developer Conventions is released as a Tanzu Package.

To install Developer Conventions, see [Installing Tanzu Application Platform](../install-intro.md).
