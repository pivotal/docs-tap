---
title: Developer Conventions for VMware Tanzu
subtitle: Developer Conventions
weight: 1
---

# Developer Conventions

## Overview

Configures the following modifications to workloads for Live Update and Debug:
- Scaling the workload to 1 pod
- Extending http-based timeouts
- Enabling live-update via JAVA_TOOL_OPTIONS and spring-boot-devtools
- Enabling debugging via the Java debug buildpack

---

### Features

- Live Update

  - See live changes made to your source code appear in your running application on your cluster.

- Debug

  - Set breakpoints to help you debug your running application on your cluster.