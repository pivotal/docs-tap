---
title: Developer Conventions for VMware Tanzu
subtitle: Developer Conventions
weight: 1
---

## Overview

Developer Conventions for VMware Tanzu configures the following modifications to workloads for live updates
and debugging:

- Scales the workload to one Pod
- Extends HTTP-based timeouts
- Enables live-update by using JAVA_TOOL_OPTIONS and spring-boot-devtools
- Enables debugging by using the Java debug buildpack

## Features

Key features of Developer Conventions include:

- **Live updates:** Changes made to your source code appear live in your running app on your cluster.

- **Debugging:** Set breakpoints to help you debug your running app on your cluster.

## About Installing

Developer Conventions is released as a Tanzu Package. For information on installing Developer Conventions, see [Installing Tanzu Application Platform](../install-intro.md).
