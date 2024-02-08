# Catalog of Tanzu Supply Chain Components
{{> 'partials/supply-chain/beta-banner' }}

This section introduces the catalog of components shipped with TAP. You will find all of these components in the "authoring" profile.


## Aggregator

- Name: aggregator
- Version: 1.0.0
- Description:
  ```
  Constructs configuration from a series of inputs
  ```

### Inputs

- oci-yaml-files[[oci-yaml-files](./output-types.hbs.md#oci-yaml-files)]
- oci-ytt-files[[oci-ytt-files](./output-types.hbs.md#oci-ytt-files)]

### Outputs

- config[[config](./output-types.hbs.md#config)]

### Config

_none_


---
## App Config Server

- Name: app-config-server
- Version: 1.0.0
- Description:
  ```
  Generates a server workload template from a config bundle
  ```

### Inputs

- conventions[[conventions](./output-types.hbs.md#conventions)]

### Outputs

- oci-yaml-files[[oci-yaml-files](./output-types.hbs.md#oci-yaml-files)]
- oci-ytt-files[[oci-ytt-files](./output-types.hbs.md#oci-ytt-files)]

### Config

```yaml
spec:
  # Configuration for the deployment to be generated
  deployment:
    # pod-level security attributes and common container settings
    securityContext:
      runAsUser:
    # DeploymentStrategy describes how to replace existing pods with new ones.
    strategy:
      rollingUpdate:
        maxUnavailable:
        maxSurge:
      type:
    env:
    # If specified, all readiness gates will be evaluated for pod liveness.
    livenessProbe:
      exec:
      periodSeconds:
      successThreshold:
      timeoutSeconds:
      failureThreshold:
      grpc:
        port:
        service:
      httpGet:
        host:
        httpHeaders:
        path:
        port:
        scheme:
      initialDelaySeconds:
      tcpSocket:
        host:
        port:
      terminationGracePeriodSeconds:
    # The name of the deployment resource. defaults to workload if empty
    name:
    # If specified, all readiness gates will be evaluated for pod readiness.
    readinessProbe:
      grpc:
        port:
        service:
      initialDelaySeconds:
      periodSeconds:
      successThreshold:
      terminationGracePeriodSeconds:
      exec:
      failureThreshold:
      httpGet:
        path:
        port:
        scheme:
        host:
        httpHeaders:
      tcpSocket:
        host:
        port:
      timeoutSeconds:
    # Number of desired pods.
    # +required
    replicas:
    # Compute Resources required by the app container.
    resources:
      # max limits for CPU and memory
      limits:
        cpu:
        memory:
      # min limits for CPU and memory
      requests:
        cpu:
        memory:
  # Configuration for the service to be generated
  service:
    # The name of the ksvc resource. defaults to workload if empty
    name:
    # The list of ports that are exposed by this service.
    ports:
  # Configuration for the ingress to be generated
  ingress:
    # hostname is the fully qualified domain name of a network host, as defined by RFC 3986
    hostname:
    # The name of the ingress resource. defaults to workload if empty
    name:
    # provides information about the ports exposed by this LoadBalancer
    port:
    # secretName is the name of the secret used to terminate TLS traffic
    tlsSecretName:
    # the value to used in the annotation cert-manager.io/cluster-issuer
    clusterIssuer:
  # Configuration for the http Route to be generated
  httpRoute:
    # To be used in the httpRoute parentRef
    gatewayName:
    # To be used in the httpRoute parentRef
    gatewayProtocol:
    # The name of the httpRoute resource. defaults to workload if empty
    name:
    # To be used in the httpRoute BackendRef
    port:
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
- Description:
  ```
  Generates a web workload template from a config bundle
  ```

### Inputs

- conventions[[conventions](./output-types.hbs.md#conventions)]

### Outputs

- oci-yaml-files[[oci-yaml-files](./output-types.hbs.md#oci-yaml-files)]
- oci-ytt-files[[oci-ytt-files](./output-types.hbs.md#oci-ytt-files)]

### Config

```yaml
spec:
  # Configuration for the probes to be used with the knaitve service
  pod:
    # If specified, all readiness gates will be evaluated for pod liveness.
    livenessProbe:
      terminationGracePeriodSeconds:
      failureThreshold:
      grpc:
        port:
        service:
      httpGet:
        scheme:
        host:
        httpHeaders:
        path:
        port:
      successThreshold:
      tcpSocket:
        host:
        port:
      exec:
      initialDelaySeconds:
      periodSeconds:
      timeoutSeconds:
    # If specified, all readiness gates will be evaluated for pod readiness.
    readinessProbe:
      tcpSocket:
        host:
        port:
      terminationGracePeriodSeconds:
      failureThreshold:
      successThreshold:
      httpGet:
        host:
        httpHeaders:
        path:
        port:
        scheme:
      initialDelaySeconds:
      periodSeconds:
      timeoutSeconds:
      exec:
      grpc:
        service:
        port:
  # Configuration if kapp-config is needed
  kapp-config:
    include:
  # Configuration for the registry to use
  registry:
    # The name of the repository
    # +required
    repository:
    # The name of the registry server, e.g. docker.io
    # +required
    server:
  # Configuration for the knative service to be generated
  service:
    env:
    # The maximum number of replicas that each revision should have
    maxScale:
    # The initial scale that a Revision is scaled to immediately after creation
    minScale:
    # The name of the ksvc resource. defaults to workload if empty
    # +required
    name:
    # Compute Resources required by the app container.
    resources:
      # max limits for CPU and memory
      limits:
        cpu:
        memory:
      # min limits for CPU and memory
      requests:
        cpu:
        memory:
```


---
## App Config Worker

- Name: app-config-worker
- Version: 1.0.0
- Description:
  ```
  Generates a worker workload template from a config bundle
  ```

### Inputs

- conventions[[conventions](./output-types.hbs.md#conventions)]

### Outputs

- oci-yaml-files[[oci-yaml-files](./output-types.hbs.md#oci-yaml-files)]
- oci-ytt-files[[oci-ytt-files](./output-types.hbs.md#oci-ytt-files)]

### Config

```yaml
spec:
  # Configuration for the deployment to be generated
  deployment:
    # The name of the deployment resource. defaults to workload if empty
    name:
    # If specified, all readiness gates will be evaluated for pod readiness.
    readinessProbe:
      exec:
      failureThreshold:
      httpGet:
        host:
        httpHeaders:
        path:
        port:
        scheme:
      successThreshold:
      tcpSocket:
        host:
        port:
      grpc:
        port:
        service:
      initialDelaySeconds:
      periodSeconds:
      terminationGracePeriodSeconds:
      timeoutSeconds:
    # Number of desired pods.
    # +required
    replicas:
    # Compute Resources required by the app container.
    resources:
      # min limits for CPU and memory
      requests:
        memory:
        cpu:
      # max limits for CPU and memory
      limits:
        cpu:
        memory:
    # pod-level security attributes and common container settings
    securityContext:
      runAsUser:
    # DeploymentStrategy describes how to replace existing pods with new ones.
    strategy:
      rollingUpdate:
        maxUnavailable:
        maxSurge:
      type:
    env:
    # If specified, all readiness gates will be evaluated for pod liveness.
    livenessProbe:
      exec:
      grpc:
        port:
        service:
      periodSeconds:
      terminationGracePeriodSeconds:
      failureThreshold:
      httpGet:
        host:
        httpHeaders:
        path:
        port:
        scheme:
      initialDelaySeconds:
      successThreshold:
      tcpSocket:
        host:
        port:
      timeoutSeconds:
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
- Description:
  ```
  Builds an app with buildpacks using kpack
  ```

### Inputs

- source[[source](./output-types.hbs.md#source)]
- git[[git](./output-types.hbs.md#git)]

### Outputs

- image[[image](./output-types.hbs.md#image)]

### Config

```yaml
spec:
  # Kpack build specification
  build:
    env:
    # Configure workload to use a non-default builder or clusterbuilder
    builder:
      # builder kind
      kind:
      # builder name
      name:
    # cache options
    cache:
      # cache image to use
      image:
    # Service account to use
    serviceAccountName:
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
```


---
## Carvel Package

- Name: carvel-package
- Version: 1.0.0
- Description:
  ```
  Generates a carvel package from a config bundle
  ```

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
  # Configuration for the generated carvel package
  carvel:
    # Service account that gives kapp-controller privileges to create resources in the namespace
    serviceAccountName:
    # PEM encoded certificate data for the image registry where the files will be pushed to.
    caCertData:
    # Enable the use of IAAS based authentication for imgpkg
    iaasAuthEnabled:
    # The name of the carvel package
    # +required
    packageName:
    # Secret that provides customized values to the package installation's templating steps
    secretName:
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
- Description:
  ```
  Use the Cartographer Conventions service to generate decorated pod template specs
  ```

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
- Description:
  ```
  Generates a carvel package from a config bundle
  ```

### Inputs

- package[[package](./output-types.hbs.md#package)]

### Outputs

* _none_

### Config

```yaml
spec:
  # The path to the yaml to be applied to the cluster
  subPath:
    # The path to the yaml to be applied to the cluster
    # +required
    path:
  # If true, the kubectl apply executed by the component will be recursive.
  recursive:
```


---
## Git Writer

- Name: git-writer
- Version: 1.0.0
- Description:
  ```
  Writes carvel package config directly to a gitops repository
  ```

### Inputs

- package[[package](./output-types.hbs.md#package)]

### Outputs

- gitops[[gitops](./output-types.hbs.md#gitops)]

### Config

```yaml
spec:
  gitOps:
    # the repository to push the pull request to
    # +required
    url:
    # the branch to commit changes to
    branch:
    # the relative path within the gitops repository to add the package configuration to.
    subPath:
```


---
## Git Writer Pr

- Name: git-writer-pr
- Version: 1.0.0
- Description:
  ```
  Writes carvel package config to a gitops repository and opens a PR
  ```

### Inputs

- package[[package](./output-types.hbs.md#package)]

### Outputs

- gitops[[gitops](./output-types.hbs.md#gitops)]

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
- Description:
  ```
  Monitors a git repository
  ```

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
      # The url to the git source repository
      # +required
      url:
      # A git branch ref to watch for new source
      branch:
      # A git commit sha to use
      commit:
      # A git tag ref to watch for new source
      tag:
    # The sub path in the bundle to locate source code
    subPath:
```


---
## Source Package Translator

- Name: source-package-translator
- Version: 1.0.0
- Description:
  ```
  Takes the type source and immediately outputs it as type package.
  In the future, will be replaced by input type mapping or some similar feature.
  ```

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
- Description:
  ```
  Performs a trivy image scan using the scan 2.0 components
  ```

### Inputs

- image[[image](./output-types.hbs.md#image)]
- git[[git](./output-types.hbs.md#git)]

### Outputs

* _none_

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
  source:
    # The sub path in the bundle to locate source code
    subPath:
    # Fill this object in if you want your source to come from git.
    # The tag, commit and branch fields are mutually exclusive, use only one.
    # +required
    git:
      # A git commit sha to use
      commit:
      # A git tag ref to watch for new source
      tag:
      # The url to the git source repository
      # +required
      url:
      # A git branch ref to watch for new source
      branch:
  # Image Scanning configuration
  scanning:
    active-keychains:
    service-account-publisher:
    service-account-scanner:
    workspace:
      bindings:
      size:
```


