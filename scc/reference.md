---
title: Reference
subtitle: Reference
weight: 3
---

## GVK

### Version

All of the custom resources in development are written under `v1alpha1` to indicate that the first
version of SCC is at the "alpha stability level" and that it is the first iteration.

For versions in CustomResourceDefinitions, see the
[Kubernetes documentation](https://kubernetes.io/docs/tasks/extend-kubernetes/custom-resources/custom-resource-definition-versioning/).


### Group

For instance:

```yaml
apiVersion: kontinue.io/v1alpha1
kind: ClusterSupplyChain
```

If you have written a `SupplyChain` that made use of the `experimental.kontinue.io` group, make sure
to check out the migration guide. <!-- xref missing: /kontinue/docs/page/migrating-from-experimental -->


## Resources

SCC is composed of several custom resources. Some of them are cluster-wide: <!-- Literally just the ones listed below? Or are there others? -->

- `ClusterSupplyChain`
- `ClusterSourceTemplate`
- `ClusterImageTemplate`
- `ClusterConfigTemplate`
- `ClusterTemplate`

Two are namespace-scoped:

- `Workload` <!-- What is the second one? -->


### Workload

`Workload` allows the developer to pass information about the app to be delivered through the supply
chain.


```yaml
apiVersion: kontinue.io/v1alpha1
kind: Workload
metadata:
  name: spring-petclinic
  labels:
    app.tanzu.vmware.com/workload-type: web
```

The label is matched against a `ClusterSupplyChain`s label selector.
Labels serve as a way of indirectly selecting `ClusterSupplyChain`.
Workloads without labels that match the `spec.selector` in a `ClusterSupplyChain` are not reconciled
and stay in an `Errored` state.
`app.tanzu.vmware.com/workload-type: web` -- all of our custom resources under the `kontinue.io` group.

```yaml
spec:
  source:
    git:
      url: https://github.com/scothis/spring-petclinic.git
      ref:
        branch: "main"
        tag: "v0.0.1"
        commit: "b4df00d"
    imgpkgBundle:
      image: harbor-repo.vmware.com/tanzu_desktop/golang-sample-source@sha256:e508a587
```
* `source` is the source code location in a Git repository.
* `imgpkgBundle` contains the source code to be used throughout the supply chain.
* `spec.image` is useful for enabling workflows that are not based on building the container image
from within the Supply Chain, but outside.

```yaml
  services:
    - apiVersion: services.tanzu.vmware.com/v1alpha1
      kind: RabbitMQ
  image: foo/docker-built@sha256:b4df00d
  env:
    - name: SPRING_PROFILES_ACTIVE
      value: mysql
  resources:
    requests:
      memory: 1Gi
      cpu: 100m
    limits:
      memory: 1Gi
      cpu: 4000m
  params:
    - name: my-company.com/defaults/java-version
      value: 11
    - name: debug
      value: true
```
* `services` are bound through service-bindings. Environment variables are passed to the main
container running the application.
* `resources` includes constraints for the main application.
* `parameters` include any that do not fit the ones already typed.


### ClusterSupplyChain

With a `ClusterSupplyChain`, app operators describe which shape of applications they deal with
through `spec.selector`, and which series of components are responsible for creating an artifact
that delivers it through `spec.components`.

Workloads that match `spec.selector` then go through the components specified in `spec.components`.

```yaml
apiVersion: kontinue.io/v1alpha1
kind: ClusterSupplyChain
metadata:
  name: supplychain
spec:
  selector:
    app.tanzu.vmware.com/workload-type: web
  components:
    - name: source-provider
      templateRef:
        kind: ClusterSourceTemplate
        name: git-repository-battery
    - name: built-image-provider
      templateRef:
        kind: ClusterImageTemplate
        name: kpack-battery
```
* `selector` specifies the label key-value pair to select workloads. At least one is required.
* `components` bring the application to a deliverable state. At least one is required.
* `components.name` is the name of the component further components reference in the chain. It is
required and must be unique.
* `templateRef` is an object reference to a template object that instructs how to instantiate and
keep the component up to date. It is required.

```yaml
      sources:
        - component: source-provider
          name: provider
```
* `sources` is a set of components that provide source information: URL and revision.
In a template, these can be consumed as:
    ```bash
    $(sources[<idx>]url)$
    $(sources[<idx>]revision)$
    ```
If there is only one source, it can be consumed as:
    ```bash
    $(source.url)$
    $(sources.revision)$
    ```
* `component` has the name of the component to provide the source information. It is required.
* `name` to be referenced in the template through a query over the list of sources.
For example, `$(sources.$(name=="provider").url)`. It is required and unique in this list.

```yaml
      images: []
      configs: []
```
* `images` include a set of optional components that provide Kubernetes configuration, for example,
* `podTemplateSpecs`. In a template, these can be consumed as `$(configs[<idx>].config)`.
When there is only one config, it can be consumed as `$(config)`.

```yaml
      params:
        - name: java-version
          value: $(workload.spec.params[?(@.name=="nebhale-io/java-version")])$
        - name: jvm
          value: openjdk
```
These are optional parameters to override the defaults from the templates. In a template these can
be consumed as `$(params.<name>)`, and include:
* `params.name` -- the name of the parameter. This is required, unique in this list, and must
match the template's pre-defined set of parameters.
* `params.value` -- the value to be passed down to the template's parameters, supporting interpolation.

For more information, see the [cluster_supply_chain.go](https://gitlab.eng.vmware.com/kontinue/kontinue/-/blob/v0.0.3/pkg/apis/v1alpha1/cluster_supply_chain.go) file.


### ClusterSourceTemplate

`ClusterSourceTemplate` indicates how the supply chain could instantiate a provider of source code
information (URL and revision).

```yaml
apiVersion: kontinue.io/v1alpha1
kind: ClusterSourceTemplate
metadata:
  name: git-repository-battery
spec:
  params:
    - name: git-implementation
      default: libgit2
```
* `params` is the default set of parameters. This is optional.
* `name` is the name of the parameter. This is required and unique to this list.
* `default` is the default value if not specified in the component that references this
`templateClusterSupplyChain`. It is required.

```yaml
  urlPath: .status.artifact.url
  revisionPath: .status.artifact.revision
```
* `urlPath` is the JSONPath expression to instruct where in the object templated-out source code URL
information is. It is required.
* `revisionPath` is the JSONPath expression to instruct where in the object templated-out source code
revision information is. It is required.

```yaml
  template:
    apiVersion: source.toolkit.fluxcd.io/v1beta1
    kind: GitRepository
    metadata:
      name: $(workload.metadata.name)$-source
    spec:
      interval: 3m
      url: $(workload.spec.source.git.url)$
      ref: $(workload.spec.source.git.ref)$
      gitImplementation: $(params.git-implementation.value)$
      ignore: ""
```
`template` is for instantiating the source provider. It is required.
The data available for interpolation (`$(<json_path>)$` is:
    - `workload` for access to the whole workload object)
    - `params`
    - `sources` if specified in the supply chain
    - `images` if specified in the supply chain
    - `configs` if specified in the supply chain

For more information, see the [cluster_source_template.go](https://gitlab.eng.vmware.com/tanzu-delivery-pipeline/kontinue/-/blob/v0.0.3/pkg/apis/v1alpha1/cluster_source_template.go) file.


### ClusterImageTemplate

`ClusterImageTemplate` instructs how the supply chain should instantiate an object responsible for
supplying container images. For example, one that takes source code, builds a container image out
of it, and presents under its `.status` the reference to that produced image.

```yaml
apiVersion: kontinue.io/v1alpha1
kind: ClusterImageTemplate
metadata:
  name: kpack-battery
spec:
  params: []
  imagePath: .status.latestImage
  template:
    apiVersion: kpack.io/v1alpha1
    kind: Image
    metadata:
      name: $(workload.metadata.name)$-image
    spec:
      tag: harbor-repo.vmware.com/kontinuedemo/$(workload.metadata.name)$
      serviceAccount: service-account
      builder:
        kind: ClusterBuilder
        name: java-builder
      source:
        blob:
          url: $(sources.provider.url)$
```
* `spec.params` is the default set of parameters. It is optional. See
[ClusterSourceTemplate](#ClusterSourceTemplate) for more information.
* `imagePath` is the JSONPath expression to instruct where in the object templated-out container
image information is. It is required.
* `template` is for instantiating the image provider. It is required. The same data is available for
interpolation as any other `*Template`.

For more information, see the [cluster_image_template.go](https://gitlab.eng.vmware.com/tanzu-delivery-pipeline/kontinue/-/blob/v0.0.3/pkg/apis/v1alpha1/cluster_image_template.go) file.


### ClusterConfigTemplate

Instructs the supply chain how to instantiate a Kubernetes object that can make Kubernetes
configurations available to further components in the chain.

For instance, a resource that is given an image exposes a complete `podTemplateSpec` to embed in a
Knative service.

```yaml
apiVersion: kontinue.io/v1alpha1
kind: ClusterConfigTemplate
metadata:
  name: convention-service-battery
spec:
  params: []
  configPath: .status.template
  template:
    apiVersion: opinions.local/v1alpha1
    kind: WorkloadDecorator
    metadata:
      name: $(workload.metadata.name)$-workload-template
    spec:
      template:
        metadata:
          labels:
            app.kubernetes.io/part-of: $(workload.metadata.name)$
          annotations:
            autoscaling.knative.dev/minScale: "1"
            autoscaling.knative.dev/maxScale: "1"
        spec:
          containers:
            - name: workload
              image: $(images.solo-image-provider.image)$
              env: $(workload.spec.env)$
              resources: $(workload.spec.resources)$
              securityContext:
                runAsUser: 1000
          imagePullSecrets:
            - name: registry-credentials
```
* `spec.params` is for default parameters. It is optional. For more information, see
[ClusterSourceTemplate](#ClusterSourceTemplate) above.
* `configPath` is the JSONPath expression to instruct where in the object a templated-out Kubernetes
configuration is. It is required.
* `template` details how to template out the Kubernetes object. It is required.

For more information, see the [cluster_config_template.go](https://gitlab.eng.vmware.com/tanzu-delivery-pipeline/kontinue/-/blob/v0.0.3/pkg/apis/v1alpha1/cluster_config_template.go) file.


### ClusterTemplate

A ClusterTemplate instructs the supply chain to instantiate a Kubernetes object that has no outputs
to be supplied to other objects in the chain. For example, a resource that deploys a container image
that other ancestor components built.

```yaml
apiVersion: kontinue.io/v1alpha1
kind: ConfigTemplate
metadata:
  name: deployer
spec:
  params: []
  template:
    apiVersion: kappctrl.k14s.io/v1alpha1
    kind: App
    metadata:
      name: $(workload.metadata.name)
    spec:
      serviceAccountName: service-account
      fetch:
        - inline:
            paths:
              manifest.yml: |
                ---
                apiVersion: kapp.k14s.io/v1alpha1
                kind: Config
                rebaseRules:
                  - path: [metadata, annotations, serving.knative.dev/creator]
                    type: copy
                    sources: [new, existing]
                    resourceMatchers: &matchers
                      - apiVersionKindMatcher: {apiVersion: serving.knative.dev/v1, kind: Service}
                  - path: [metadata, annotations, serving.knative.dev/lastModifier]
                    type: copy
                    sources: [new, existing]
                    resourceMatchers: *matchers
                ---
                apiVersion: serving.knative.dev/v1
                kind: Service
                metadata:
                  name: links
                  labels:
                    app.kubernetes.io/part-of: $(workload.metadata.labels['app\.kubernetes\.io/part-of'])$
                spec:
                  template:
                    spec:
                      containers:
                        - image: $(images.<name-of-image-provider>.image)$
                          securityContext:
                            runAsUser: 1000
      template:
        - ytt: {}
      deploy:
        - kapp: {}
```
* `spec.params` are default parameters. This is optional. For more information, see
[ClusterSourceTemplate](#ClusterSourceTemplate) above.
* `template` details how to template out the Kubernetes object. It is required.

For more information, see the [cluster_template.go](https://gitlab.eng.vmware.com/tanzu-delivery-pipeline/kontinue/-/blob/v0.0.3/pkg/apis/v1alpha1/cluster_template.go) file.
