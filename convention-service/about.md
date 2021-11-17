# Convention Service <!-- omit in toc -->

## Overview

The convention service provides a means for people in operational roles to express
their hard-won knowledge and opinions about how apps should run on Kubernetes as a convention.
The convention service applies these opinions to fleets of developer workloads as they are deployed to the platform,
saving operator and developer time.

The service is comprised of two components:

* **The Convention Controller:**
  The Convention Controller provides the metadata to the Convention Server and executes the updates Pod Template Spec as per the Convention Server's requests.

* **The Convention Server:**
  The Convention Server receives and evaluates metadata associated with a workload and
  requests updates to the Pod Template Spec associated with that workload. 
  You can have one or more Convention Servers for a single Convention Controller instance.
  The convention service currently supports defining and applying conventions for Pods.

## About Applying Conventions

The convention server uses criteria defined in the convention to determine
whether the configuration of a workload should be changed.
The server receives the OCI metadata from the convention controller.
If the metadata meets the criteria defined by the convention server,
the conventions are applied.
It is also possible for a convention to apply to all workloads regardless of metadata.

### Applying Conventions by Using Image Metadata

You can define conventions to target workloads by using properties of their OCI metadata.

Conventions can use this information to only apply changes to the configuration of workloads
when they match specific critera (for example, Spring Boot or .Net apps, or Spring Boot v2.3+).
Targeted conventions can ensure uniformity across specific workload types deployed on the cluster.

You can use all the metadata details of an image when evaluating workloads. To see the metadata details, use the docker CLI command `docker image inspect IMAGE`.

> **Note:** Depending on how the image was built, metadata might not be available to reliably identify
the image type and match the criteria for a given convention server.
Images built with Cloud Native Buildpacks reliably include rich descriptive metadata.
Images built by some other process may not include the same metadata.

### Applying Conventions without Using Image Metadata

Conventions can also be defined to apply to workloads without targeting build service metadata.
Examples of possible uses of this type of convention include appending a logging/metrics sidecar,
adding environment variables, or adding cached volumes.
Such conventions are a great way for you to ensure infrastructure uniformity
across workloads deployed on the cluster while reducing developer toil.

> **Note:** Adding a sidecar alone does not magically make the log/metrics collection work.
  This requires collector agents to be already deployed and accessible from the Kuberentes cluster,
and also configuring required access through RBAC policy.

## Convention Service Resources

There are several [resources](./reference/README.md) involved in the application of conventions to workloads

### How It Works

#### API Structure

The [`PodConventionContext`](./reference/pod-convention-context.md) API object in the `webhooks.conventions.apps.tanzu.vmware.com` API group is the structure used for both request and response from the convention server.

#### Template Status

The enriched [PodTemplateSpec](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-template-v1/#PodTemplateSpec) is reflected at [`.status.template`](./reference/pod-convention-context-status.md).

## Chaining Multiple Conventions

You can define multiple `ClusterPodConventions` and apply them to different types of workloads.
You can also apply multiple conventions to a single workload.

The `PodIntent` reconciler lists all `ClusterPodConvention` resources and applies them serially.
To ensure the consistency of enriched [`PodTemplateSpec`](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-template-v1/#PodTemplateSpec),
the list of ClusterPodConventions is sorted alphabetically by name before applying conventions.
You can use strategic naming to control the order in which the conventions are applied.

After the conventions are applied, the `Ready` status condition on the `PodIntent` resource is used to indicate
whether it is applied successfully.
A list of all applied conventions is stored under the annotation `conventions.apps.tanzu.vmware.com/applied-conventions`.

## Troubleshooting

Convention Controller is a Kubernetes operator, and may be deployed in a cluster with other components. If you are having trouble, you can refer to the troubleshooting guide [here](./troubleshooting.md).