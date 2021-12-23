# Convention Service

## Overview

The Convention Service provides a means for people in operational roles to express
their hard-won knowledge and opinions about how apps should run on Kubernetes as a convention.
The Convention Service applies these opinions to fleets of developer workloads as they are deployed to the platform,
saving operator and developer time.

The service is comprised of two components:

* **The convention controller:**
  The convention controller provides the metadata to the convention server and executes the updates Pod Template Spec as per the convention server's requests.

* **The convention server:**
  The convention server receives and evaluates metadata associated with a workload and
  requests updates to the Pod Template Spec associated with that workload.
  You can have one or more convention servers for a single convention controller instance.
  The Convention Service currently supports defining and applying conventions for Pods.

## About applying conventions

The convention server uses criteria defined in the convention to determine
whether the configuration of a workload should be changed.
The server receives the OCI metadata from the convention controller.
If the metadata meets the criteria defined by the convention server,
the conventions are applied.
It is also possible for a convention to apply to all workloads regardless of metadata.

### Applying conventions by using image metadata

You can define conventions to target workloads by using properties of their OCI metadata.

Conventions can use this information to only apply changes to the configuration of workloads
when they match specific criteria (for example, Spring Boot or .Net apps, or Spring Boot v2.3+).
Targeted conventions can ensure uniformity across specific workload types deployed on the cluster.

You can use all the metadata details of an image when evaluating workloads. To see the metadata details, use the docker CLI command `docker image inspect IMAGE`.

> **Note:** Depending on how the image was built, metadata might not be available to reliably identify
the image type and match the criteria for a given convention server.
Images built with Cloud Native Buildpacks reliably include rich descriptive metadata.
Images built by some other process may not include the same metadata.

### Applying conventions without using image metadata

Conventions can also be defined to apply to workloads without targeting build service metadata.
Examples of possible uses of this type of convention include appending a logging/metrics sidecar,
adding environment variables, or adding cached volumes.
Such conventions are a great way for you to ensure infrastructure uniformity
across workloads deployed on the cluster while reducing developer toil.

> **Note:** Adding a sidecar alone does not magically make the log/metrics collection work.
  This requires collector agents to be already deployed and accessible from the Kubernetes cluster,
and also configuring required access through RBAC policy.

## Convention service resources

There are several [resources](./reference/convention-resources.md) involved in the application of conventions to workloads

### How it works

#### API structure

The [`PodConventionContext`](./reference/pod-convention-context.md) API object in the `webhooks.conventions.apps.tanzu.vmware.com` API group is the structure used for both request and response from the convention server.

#### Template status

The enriched [PodTemplateSpec](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-template-v1/#PodTemplateSpec) is reflected at [`.status.template`](./reference/pod-convention-context-status.md).

## Chaining multiple conventions

You can define multiple `ClusterPodConventions` and apply them to different types of workloads.
You can also apply multiple conventions to a single workload.

The `PodIntent` reconciler lists all `ClusterPodConvention` resources and applies them serially.
To ensure the consistency of enriched [`PodTemplateSpec`](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-template-v1/#PodTemplateSpec),
the list of `ClusterPodConventions`is sorted alphabetically by name before applying conventions.
You can use strategic naming to control the order in which the conventions are applied.

After the conventions are applied, the `Ready` status condition on the `PodIntent` resource is used to indicate
whether it is applied successfully.
A list of all applied conventions is stored under the annotation `conventions.apps.tanzu.vmware.com/applied-conventions`.

## Collecting logs from the controller

Convention controller is a Kubernetes operator and can be deployed in a cluster with other components. If you have trouble, you can retrieve and examine the logs from the controller to help identify issues.

To retrieve pod logs from the `conventions-controller-manager` running in the `conventions-system` namespace:

  ```
  kubectl -n conventions-system logs -l control-plane=controller-manager
  ```

For example:

  ```
  ...
  {"level":"info","ts":1637073467.3334172,"logger":"controllers.PodIntent.PodIntent.ApplyConventions","msg":"applied convention","diff":"  interface{}(\n- \ts\"&PodTemplateSpec{ObjectMeta:{      0 0001-01-01 00:00:00 +0000 UTC <nil> <nil> map[app.kubernetes.io/component:run app.kubernetes.io/part-of:spring-petclinic-app-db carto.run/workload-name:spring-petclinic-app-db] map[developer.conventions/target-container\"...,\n+ \tv1.PodTemplateSpec{\n+ \t\tObjectMeta: v1.ObjectMeta{\n+ \t\t\tLabels: map[string]string{\n+ \t\t\t\t\"app.kubernetes.io/component\": \"run\",\n+ \t\t\t\t\"app.kubernetes.io/part-of\":   \"spring-petclinic-app-db\",\n+ \t\t\t\t\"carto.run/workload-name\":     \"spring-petclinic-app-db\",\n+ \t\t\t\t\"tanzu.app.live.view\":         \"true\",\n+ \t\t\t\t...\n+ \t\t\t},\n+ \t\t\tAnnotations: map[string]string{\"developer.conventions/target-containers\": \"workload\"},\n+ \t\t},\n+ \t\tSpec: v1.PodSpec{Containers: []v1.Container{{...}}, ServiceAccountName: \"default\"},\n+ \t},\n  )\n","convention":"appliveview-sample"}
  ...
  ```

  ## Troubleshooting

For basic troubleshooting Convention Controller, please see the troubleshooting guide [here](troubleshooting.md).
