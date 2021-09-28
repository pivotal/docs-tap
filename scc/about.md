---
title: Supply Chain Choreographer for VMware Tanzu
subtitle: Supply Chain Choreography
weight: 1
---

# Supply Chain Choreographer for VMware Tanzu

## Overview

Supply Chain Choreographer (SCC) enables app operators to create pre-approved paths to production by
integrating Kubernetes resources with the elements of their existing toolchains, such as Tekton,
Jenkins, and others.

Each pre-approved supply chain creates a paved road to production. This orchestration of supply chain
components -- test, build, scan, and deploy -- enables developers to focus on delivering value to
their users while also providing operators with the peace of mind that all code in production has
passed through all the steps of an approved workflow.

## Design and Philosophy

The following sections describe the design and philosophy of SCC.

### Structure

SCC enables users to define all of the steps that an application must go through to run in a given
environment.

You can view SCC as three separate functional pieces:

* On-cluster resources
* Interfaces
* YAML definitions

### Supply Chain and Delivery

For on-cluster resources, users can codify their paths to production using two abstractions:

* Supply Chain ([Spec Reference](reference#clustersupplychain))
* Deliverable ([Spec Reference](reference#deliverable))

The Supply Chain enables users to define the steps that an application must pass through to create
container images and embed them into Kubernetes configuration. The Delivery portion of an SCC
workflow enables the user to define the steps that promote, test, and validate Kubernetes
configuration.
By combining Supply Chains and Deliveries, you can use SCC to specify and therefore choreograph the
entire path to production.

The Supply Chain and Delivery are not bound to a single cluster. SCC embraces a GitOps approach for
image promotion across clusters: a Git repository is used to track the Kubernetes configuration that
corresponds to a given application. The delivery portion watches that same Git repository and
initiates the second half of the path to production whenever a new configuration is pushed to the
repository.

### Templates

Both the Supply Chain and Delivery consist of resources that are specified through templates and
defined on the cluster through their YAML definitions. Unlike many other Kubernetes-native workflow
tools that already exist in the market, SCC does not create Pods or execute commands. Instead, it
monitors the status of each resource and updates subsequent resources in the Supply Chain or Delivery
when outputs change.

* Source Template ([Spec Reference](reference#clustersoucetemplate))
* Build Template ([Spec Reference](reference#clusterbuildtemplate))
* Opinion Template ([Spec Reference](reference#clusteropiniontemplate))
* Cluster Config Template ([Spec Reference](reference#clusterconfigtemplate))

Each template acts as a wrapper for existing Kubernetes resources and enables them to be used with SCC.
The templates are where integrations with third-party tooling can be added to the Supply Chain.
For example, you can create an integration with ServiceNow that is included in the Supply Chain
through a Config template.
You can create both open and closed integrations for each of the three different template types.

### Workloads

Although the Supply Chain and Delivery are both operator-facing, SCC also provides an abstraction for
developers called a Workload. Workloads enable developers to choose application specifications such
as the location of their repository, environment variables, and service claims.

By design, Supply Chains can be responsible for many Workloads. This enables an operator to specify
the steps in the path to production just once, and developers to specify their applications
independently but for each to use the same path to production. This enables developers to focus on
providing value for their users and to reach production quickly and easily, while providing peace of
mind for app operators, who are assured that each application has passed through the steps of the
path to production that they have defined.

![SCC high-level diagram. The Supply Chain consists of components. Operators own and apply the Supply Chain. Developers own and apply Workloads that target the Supply Chain. The Supply Chain stamps out running apps.](images/ownership-flow.png)
