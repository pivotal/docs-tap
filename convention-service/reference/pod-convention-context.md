# PodConventionContext

The pod convention context is the main object that is passed to the server by the controller and is the one returned as well

The context is a wrapper of the individual object description in an API (TypeMeta), the persistent metadata of a resource ([ObjectMeta](https://kubernetes.io/docs/reference/kubernetes-api/common-definitions/object-meta/#ObjectMeta)), the [`PodConventionContextSpec`](pod-convention-context-spec.md) and the [`PodConventionContextStatus`](pod-convention-context-status.md).

In the `PodConventionContext` API resource:
* Object path `.spec.template` field defines the [PodTemplateSpec](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-template-v1/#PodTemplateSpec) to be enriched by conventions.
* Object path `.spec.imageConfig` field defines [ImageConfig](image-config.md). Each entry of [`imageConfig`](image-config.md) is populated with the name of the image(`.spec.imageConfig[].image`) and its OCI metadata (`.spec.imageConfig[].config`). These entries are generated for each image referenced in [PodTemplateSpec](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-template-v1/#PodTemplateSpec) (`.spec.template`).


```json
{
  "apiVersion": "podconvention.k8s.io/v1alpha1",
  "kind": "PodConventionContext",
  "metadata": {
    "name": "pod-convention-context-name",
    "namespace": "pod-convention-context-namespace",
    "creationTimestamp": "2020-05-06T12:00:00Z",
    "labels": {
      "app": "pod-convention-context-name"
    }
    ...
  },
  "spec": {
    "type": "pod-convention-context-type",
    "metadata": {
      "name": "pod-convention-context-name",
      "namespace": "pod-convention-context-namespace",
      "creationTimestamp": "2020-05-06T12:00:00Z",
      "labels": {
        "app": "pod-convention-context-name"
      }
    },
    "spec": { // see POD_CONVENTION_CONTEXT_SPEC.md
        "template": {
            ...
        },
        "imageConfig": {
            ...
        }
    },
    "status": { // see POD_CONVENTION_CONTEXT_STATUS.md
        "template": {
            ...
        },
        "appliedConventions": [...]
    }
}
```
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

## PodConventionContext Structure

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
