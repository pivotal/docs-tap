# Catalog of Tanzu Supply Chain Components

{{> 'partials/supply-chain/beta-banner' }}


This section introduces the catalog of components shipped with TAP. You will find all of these components in the "authoring" profile.

## App Config Server

- Name: app-config-server
- Version: 1.0.0


### Description:
Generates configuration for a Server application from a Conventions PodIntent.
Server applications contain a K8s Deployment and Service and can be configured with Ingress.


### Inputs

- conventions[[conventions](./output-types.hbs.md#conventions)]

### Outputs

- oci-yaml-files[[oci-yaml-files](./output-types.hbs.md#oci-yaml-files)]
- oci-ytt-files[[oci-ytt-files](./output-types.hbs.md#oci-ytt-files)]

### Config

```yaml
spec:
  # Configuration for the registry to use
  registry:
    # The name of the repository
    # +required
    repository:
    # The name of the registry server, e.g. docker.io
    # +required
    server:
```


---
## App Config Web

- Name: app-config-web
- Version: 1.0.0
### Description:
Generates configuration for a Web application from a Conventions PodIntent.
Web applications contain a Knative Service.



### Inputs

- conventions[[conventions](./output-types.hbs.md#conventions)]

### Outputs

- oci-yaml-files[[oci-yaml-files](./output-types.hbs.md#oci-yaml-files)]
- oci-ytt-files[[oci-ytt-files](./output-types.hbs.md#oci-ytt-files)]

### Config

```yaml
spec:
  # Configuration for the registry to use
  registry:
    # The name of the repository
    # +required
    repository:
    # The name of the registry server, e.g. docker.io
    # +required
    server:
```


---
## App Config Worker

- Name: app-config-worker
- Version: 1.0.0
### Description:
Generates configuration for a Worker application from a Conventions PodIntent.
Worker applications contain a K8s Deployment.



### Inputs

- conventions[[conventions](./output-types.hbs.md#conventions)]

### Outputs

- oci-yaml-files[[oci-yaml-files](./output-types.hbs.md#oci-yaml-files)]
- oci-ytt-files[[oci-ytt-files](./output-types.hbs.md#oci-ytt-files)]

### Config

```yaml
spec:
  # Configuration for the registry to use
  registry:
    # The name of the repository
    # +required
    repository:
    # The name of the registry server, e.g. docker.io
    # +required
    server:
```


---
## Buildpack Build

- Name: buildpack-build
- Version: 1.0.0
### Description:
Builds an app with buildpacks using kpack


### Inputs

- source[[source](./output-types.hbs.md#source)]
- git[[git](./output-types.hbs.md#git)]

### Outputs

- image[[image](./output-types.hbs.md#image)]

### Config

```yaml
spec:
  source:
    # path inside the source to build from (build has no access to paths above the subPath)
    subPath:
  # Registry to use
  registry:
    # The repository to use
    # +required
    repository:
    # The registry address
    # +required
    server:
  # Kpack build specification
  build:
    # Configure workload to use a non-default builder or clusterbuilder
    builder:
      # builder name
      name:
      # builder kind
      kind:
    # cache options
    cache:
      # cache image to use
      image:
    # Service account to use
    serviceAccountName:
    env:
```


---
## Carvel Package

- Name: carvel-package
- Version: 1.0.0
### Description:
Generates a carvel package from OCI images containing raw YAML files and YTT files.



### Inputs

- oci-yaml-files[[oci-yaml-files](./output-types.hbs.md#oci-yaml-files)]
- oci-ytt-files[[oci-ytt-files](./output-types.hbs.md#oci-ytt-files)]

### Outputs

- package[[package](./output-types.hbs.md#package)]

### Config

```yaml
spec:
  # Configuration for the registry to use
  registry:
    # The name of the repository
    # +required
    repository:
    # The name of the registry server, e.g. docker.io
    # +required
    server:
  # Configuration for the generated Carvel Package
  carvel:
    # Enable the use of IAAS based authentication for imgpkg.
    iaasAuthEnabled:
    # The domain of the Carvel Package. Combines with spec.carvel.packageName to create the Package refName. If set to "", will use "default.tap".
    packageDomain:
    # The name of the Carvel Package. Combines with spec.carvel.packageDomain to create the Package refName. If set to "", will use the workload name.
    packageName:
    # Service account that gives kapp-controller privileges to create resources in the namespace.
    serviceAccountName:
    # Name of the values Secret that provides customized values to the package installation's templating steps.
    valuesSecretName:
    # PEM encoded certificate data for the image registry where the files will be pushed to.
    caCertData:
  gitOps:
    # the branch to commit changes to
    branch:
    # the relative path within the gitops repository to add the package configuration to.
    subPath:
    # the repository to push the pull request to
    url:
```


---
## Conventions

- Name: conventions
- Version: 1.0.0
### Description:
#### Description

The Conventions component is a way to invoke the Convention Controller in a Tanzu Supply Chain.

The Conventions Controller is a sub component of Cartographer Conventions.

**Note** Conventions Controller is bundled with the Cartographer Conventions package for Tanzu Application Platform v1.8
but it will be in a dedicated package for Tanzu Application Platform v1.9.

#### API

Component Input: `image`

Configuration Input: `spec.env` may contain an optional array of objects. Each object is a pair of keys: `name`
and either `value` or `valueFrom`. The Conventions component will translate these values into environment variables
in the output object. See below for more details.

Example:

```console
spec:
  source: TEST
  env:
  - name: TEST_KEY_1
    value: TEST_VALUE_1
  - name: TEST_KEY_2
    value: TEST_VALUE_2
  - name: TEST_KEY_3
    valueFrom:
      configMapKeyRef:
        name: "my_kubernetes_secret"
        key: "a_key_in_that_secret"
```

Component Output: `conventions`

OCI Output: An artifact in the OCI store. This artifact contains one file, `app-config.yaml`, with
a pod template spec.

#### Dependencies

- Supply Chain
- Supply Chain Catalog
- Managed Resource Controller
- Tekton
- Conventions Controller

#### Input Description

The Conventions component takes an `image` input from an earlier component in the supply chain. The component expects
the image to be provided as a reference to a runnable artifact in an OCI registry (i.e.: some image intended to be run
as a container in a pod), e.g.: `my.registry/my.project/my.image@sha256:digest`. The Conventions component passes this
image reference to the conventions controller to analyze.

#### Output Description

The Conventions component produces a `conventions` output stored in an OCI registry referenced by the shared `oci-store`
`Secret`.  A reference to this image will be passed to subsequent components in the supply chain.

The output image contains a single file, `app-config.yaml`.  This file contains a Kubernetes Pod
Template Spec under a `template` field in YAML.  For example:

```yaml
template:
  spec:
    containers:
    - env:
      - name: TEST_KEY_1
        value: TEST_VALUE_1
      - name: TEST_KEY_2
        value: TEST_VALUE_2
      - name: TEST_KEY_3
        valueFrom:
          configMapKeyRef:
            name: "my_kubernetes_secret"
            key: "a_key_in_that_secret"
      image: my-image@sha256:digest
      name: workload
      resources: {}
      securityContext:
        allowPrivilegeEscalation: false
        capabilities:
          drop:
          - ALL
        runAsNonRoot: true
        runAsUser: 1001
        seccompProfile:
          type: RuntimeDefault
    serviceAccountName: default
```

The `image` from the component input is echoed in the `template.spec.containers[0].image` field.

The Conventions controller passes the image reference to any conventions servers installed on the
cluster. Each server has the opportunity to further decorate the Pod template spec.

__Optional:__ In addition to the image field, the Conventions component can also copy the settings in the
configuration's `spec.env` into the Pod template's `env` field.  The `spec.env` field, if present, is expected to
contain an array of `name` and either `value` or `valueFrom` pairs.  You can use this feature to set environment
variables in any pods produced by the supply chain.

The format of the `value` and `valueFrom` matches that of the [Kubernetes Pod Template
Specification](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-v1/#environment-variables-1).

Here is an example supply chain instance with three environment variables.  Two variables are set literally with `value`
fields and the third comes from a `ConfigMap`:

```yaml
apiVersion: widget.com/v1alpha1
kind: conventiontest
metadata:
  name: my-app
  namespace: conventions-component
spec:
  source: TEST
  env:
  - name: TEST_KEY_1
    value: TEST_VALUE_1
  - name: TEST_KEY_2
    value: TEST_VALUE_2
  - name: TEST_KEY_3
    valueFrom:
      configMapKeyRef:
        name: "my_kubernetes_configuration"
        key: "a_key_in_that_configmap"
```

The Conventions component also provides a default security context and service account.



### Inputs

- image[[image](./output-types.hbs.md#image)]

### Outputs

- conventions[[conventions](./output-types.hbs.md#conventions)]

### Config

```yaml
spec:
  env:
```


---
## Deployer

- Name: deployer
- Version: 1.0.0
### Description:
Deploys K8s resources to the cluster.


### Inputs

- package[[package](./output-types.hbs.md#package)]

### Outputs

* _none_

### Config

```yaml
spec:
  # The path to the yaml to be applied to the cluster.
  subPath:
    # The path to the yaml to be applied to the cluster
    # +required
    path:
```


---
## Git Writer

- Name: git-writer
- Version: 1.0.0
### Description:
Writes carvel package config directly to a gitops repository


### Inputs

- package[[package](./output-types.hbs.md#package)]

### Outputs

* _none_

### Config

```yaml
spec:
  gitOps:
    # the branch to commit changes to
    branch:
    # the relative path within the gitops repository to add the package configuration to.
    subPath:
    # the repository to push the pull request to
    # +required
    url:
```


---
## Git Writer Pr

- Name: git-writer-pr
- Version: 1.0.0
### Description:
Writes carvel package config to a gitops repository and opens a PR


### Inputs

- package[[package](./output-types.hbs.md#package)]

### Outputs

- git-pr[[git-pr](./output-types.hbs.md#git-pr)]

### Config

```yaml
spec:
  gitOps:
    # the base branch to create PRs against
    baseBranch:
    # the relative path within the gitops repository to add the package configuration to.
    subPath:
    # the repository to push the pull request to
    # +required
    url:
```


---
## Source Git Provider

- Name: source-git-provider
- Version: 1.0.0
### Description:
Monitors a git repository


### Inputs

* _none_

### Outputs

- source[[source](./output-types.hbs.md#source)]
- git[[git](./output-types.hbs.md#git)]

### Config

```yaml
spec:
  source:
    # Use this object to retrieve source from a git repository.
    # The tag, commit and branch fields are mutually exclusive, use only one.
    # +required
    git:
      # A git branch ref to watch for new source
      branch:
      # A git commit sha to use
      commit:
      # A git tag ref to watch for new source
      tag:
      # The url to the git source repository
      # +required
      url:
    # The sub path in the bundle to locate source code
    subPath:
```


---
## Source Package Translator

- Name: source-package-translator
- Version: 1.0.0
### Description:
Takes the type source and immediately outputs it as type package.



### Inputs

- source[[source](./output-types.hbs.md#source)]

### Outputs

- package[[package](./output-types.hbs.md#package)]

### Config

_none_


---
## Trivy Image Scan

- Name: trivy-image-scan
- Version: 1.0.0
### Description:
Performs a trivy image scan using the scan 2.0 components


### Inputs

- image[[image](./output-types.hbs.md#image)]
- git[[git](./output-types.hbs.md#git)]

### Outputs

* _none_

### Config

```yaml
spec:
  source:
    # Fill this object in if you want your source to come from git.
    # The tag, commit and branch fields are mutually exclusive, use only one.
    # +required
    git:
      # A git branch ref to watch for new source
      branch:
      # A git commit sha to use
      commit:
      # A git tag ref to watch for new source
      tag:
      # The url to the git source repository
      # +required
      url:
    # The sub path in the bundle to locate source code
    subPath:
  # Image Scanning configuration
  scanning:
    service-account-publisher:
    service-account-scanner:
    workspace:
      bindings:
      size:
    active-keychains:
  # Configuration for the registry to use
  registry:
    # The name of the repository
    # +required
    repository:
    # The name of the registry server, e.g. docker.io
    # +required
    server:
```


