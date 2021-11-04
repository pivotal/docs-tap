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

There are two Kubernetes resources involved in the application of conventions to workloads.

### PodIntent

```yaml
apiVersion: conventions.apps.tanzu.vmware.com/v1alpha1
kind: PodIntent
```

`PodIntent` applies conventions to a workload.
The `.spec.template`'s PodTemplateSpec is enriched by the conventions and is exposed as the `.status.template`'s PodTemplateSpec.
When a convention is applied, the name of the convention is added
as a `conventions.apps.tanzu.vmware.com/applied-conventions` annotation on the PodTemplateSpec.

### ClusterPodConvention

```yaml
apiVersion: conventions.apps.tanzu.vmware.com/v1alpha1
kind: ClusterPodConvention
```

`ClusterPodConvention` defines a way to connect to convention servers,
and it provides a way to apply a set of conventions to a PodTemplateSpec and the artifact metadata.
A convention typically focuses on a particular application framework, but can be cross cutting.
Applied conventions must be pure functions.

### How It Works

#### API Structure

The `PodConventionContext` API object in the `webhooks.conventions.apps.tanzu.vmware.com` API group is the structure used for both request and response from the convention server.

In the `PodConventionContext` API resource:
* Object path `.spec.template` field defines the PodTemplateSpec to be enriched by conventions.
* Object path `.spec.imageConfig` field defines [ggcrv1.ConfigFile](https://github.com/google/go-containerregistry/blob/main/pkg/v1/config.go) in GitHub. Each entry of `imageConfig` is populated with the name of the image(`.spec.imageConfig[].image`) and its OCI metadata (`.spec.imageConfig[].config`). These entries are generated for each image referenced in PodTemplateSpec (`.spec.template`).

The following is an example of a `PodConventionContext` resource request received by the convention server. This object is generated for [Go language based image](https://github.com/paketo-buildpacks/samples/tree/main/go/mod) (in GitHub) built with Cloud Native Paketo Buildpacks that uses Go mod for dependency management.

```yaml
---
apiVersion: webhooks.conventions.apps.tanzu.vmware.com/v1alpha1
kind: PodConventionContext
metadata:
  name: sample # the name of the ClusterPodConvention
spec: # the request
  imageConfig: # one entry per image referenced by the PodTemplateSpec
  - image: sample/go-based-image
    config:
      entrypoint:
      - "/cnb/process/web"
      domainname: ""
      architecture: "amd64"
      image: "sha256:05b698a4949db54fdb36ea431477867abf51054abd0cbfcfd1bb81cda1842288"
      labels:
        "io.buildpacks.stack.distro.version": "18.04"
        "io.buildpacks.stack.homepage": "https://github.com/paketo-buildpacks/stacks"
        "io.buildpacks.stack.id": "io.buildpacks.stacks.bionic"
        "io.buildpacks.stack.maintainer": "Paketo Buildpacks"
        "io.buildpacks.stack.distro.name": "Ubuntu"
        "io.buildpacks.stack.metadata": `{"app":[{"sha":"sha256:ea4ec23266a3af1204fd643de0f3572dd8dbb5697a5ef15bdae844777c19bf8f"}], 
        "buildpacks":[{"key":"paketo-buildpac`...,
        "io.buildpacks.build.metadata": `{"bom":[{"name":"go","metadata":{"licenses":[],"name":"Go","sha256":"7fef8ba6a0786143efcce66b0bbfbfbab02afeef522b4e09833c5b550d7`...
  template:
    spec:
      containers:
      - name : workload
        image: helloworld-go-mod
```

#### PodConventionContext Structure 

Let's expand more on the [OCI Image metadata](https://github.com/opencontainers/image-spec/blob/master/config.md)
structure present in `PodConventionContext`.
A convention server can use this bill of materials (BOM) information to enrich podTemplateSpec (`.spec.template`).

* `io.buildpacks.stack.metadata`: This label contains information about Buildpack's lifecycle metadata for every layer.
  For more information about individual fields,
  see Buildpack's [Platform Interface Specification](https://github.com/buildpacks/spec/blob/main/platform.md#iobuildpackslifecyclemetadata-json) in GitHub.

* `io.buildpacks.stack.*`: This set of labels contains information about Buildpack stack ID, maintainer, distribution details, and so on.
  For more information about stack-related labels,
  see the section on Stacks in Buildpack's [Platform Interface Specification](https://github.com/buildpacks/spec/blob/main/platform.md#stacks) in GitHub.

* `io.buildpacks.build.metadata`: Contents for label with key `io.buildpacks.build.metadata` is expanded
   for the example above. The JSON is converted to YAML for readability.

```yaml
"io.buildpacks.build.metadata": `{
  #  Bill of Materials for the image
  "bom":[{
    "name":"go",
    "metadata":{
      "licenses":[]
      # Name of the buildpacks used
      "name":"Go"
      "sha256":"7fef8ba6a0786143efcce66b0bbfbfbab02afeef522b4e09833c5b550d7741ad"
      # list of Buildpack stacks
      "stacks":["io.buildpacks.stacks.bionic","io.paketo.stacks.tiny","org.cloudfoundry.stacks.cflinuxfs3"]
      "uri":"https://buildpacks.cloudfoundry.org/dependencies/go/go_1.16.1_linux_x64_cflinuxfs3_c5f8cca1.tgz"
      "version":"1.16.1"
    },
    # Buildpack id and version
    "buildpack": {"id":"paketo-buildpacks/go-dist","version":"0.3.1"}
  }],
  # detected group of buildpacks
  "buildpacks":[
    {"homepage":"https://github.com/paketo-buildpacks/go-dist","id":"paketo-buildpacks/go-dist","version":"0.3.1"},
    {"homepage":"https://github.com/paketo-buildpacks/go-mod-vendor","id":"paketo-buildpacks/go-mod-vendor","version":"0.2.0"},
    {"homepage":"https://github.com/paketo-buildpacks/go-build","id":"paketo-buildpacks/go-build","version":"0.3.0"},
  ],
  # contain the version of the launcher binary included in the app
  # launcher.source.git contains the git repository and commit containing the launcher source code. Refer to https://github.com/buildpacks/spec/blob/main/platform.md#launch for more information on launcher process
  "launcher":{"version":"0.11.1", "source":{"git":{"repository":"github.com/buildpacks/lifecycle","commit":"75df86c"}}},
  # buildpack contributed processes
  "processes":[{
    "type":"mod",
    "command":"/layers/paketo-buildpacks_go-build/targets/bin/mod",
    "args":null,
    "direct":false,
    "buildpackID":"paketo-buildpacks/go-build"
  },{
    "type":"mod",
    "command":"/layers/paketo-buildpacks_go-build/targets/bin/mod",
    "args":null,
    "direct":false,
    "buildpackID":"paketo-buildpacks/go-build"
  }]
}`
```
#### Template Status

The enriched PodTemplateSpec is reflected at `.status.template`, which the owner of the PodIntent resource can watch.
The field `.status.appliedConventions` is populated with the names of any applied conventions.

The following is an example of a `PodConventionContext` response with the `.status` field populated.

```yaml
---
apiVersion: webhooks.conventions.apps.tanzu.vmware.com/v1alpha1
kind: PodConventionContext
metadata:
  name: sample # the name of the ClusterPodConvention
spec: # the request
  imageConfig:
  template:
    <corev1.PodTemplateSpec>
status: # the response
  appliedConventions: # list of names of conventions applied
  - my-convention
  template:
  spec:
      containers:
      - name : workload
        image: helloworld-go-mod
```

## Chaining Multiple Conventions

You can define multiple `ClusterPodConventions` and apply them to different types of workloads.
You can also apply multiple conventions to a single workload.

The `PodIntent` reconciler lists all `ClusterPodConvention` resources and applies them serially.
To ensure the consistency of enriched `podTemplateSpec`,
the list of ClusterPodConventions is sorted alphabetically by name before applying conventions.
You can use strategic naming to control the order in which the conventions are applied.

After the conventions are applied, the `Ready` status condition on the `PodIntent` resource is used to indicate
whether it is applied successfully.
A list of all applied conventions is stored under the annotation `conventions.apps.tanzu.vmware.com/applied-conventions`.
