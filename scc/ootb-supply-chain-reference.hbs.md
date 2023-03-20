# Supply Chains

Tanzu Application Platform includes a number of supply chains packages,
each of which installs two
[ClusterSupplyChains](https://cartographer.sh/docs/v0.6.0/reference/workload/#clustersupplychain).
Only one supply chain package can be installed at one time.

The supply chains provide some [parameters](https://cartographer.sh/docs/v0.6.0/templating/#parameters)
to the referenced templates.
These might be overridden by the parameters provided by the workload.

## Source-to-URL

### Purpose

- Fetches application source code
- Builds it into an image
- Writes the Kubernetes configuration necessary to deploy the application
- Commits that configuration to either a Git repository or a container image registry

### Resources

This section describes the templates and their parameters.

#### source-provider

Refers to [source-template](ootb-template-reference.hbs.md#source-template).

Parameters provided:

- `serviceAccount` from tap-value `service_account`. Overridable by workload.
- `gitImplementation` from tap-value `git_implementation`. NOT overridable by workload.

#### image-provider

Refers to [kaniko-template](ootb-template-reference.hbs.md#kaniko-template)
when the workload provides a parameter `dockerfile`.
Refers to [kpack-template](ootb-template-reference.hbs.md#kpack-template) otherwise.

Parameters provided:

- `serviceAccount` from tap-value `service_account`. Overridable by workload.
- `registry` from tap-value `registry`. NOT overridable by workload.
- `clusterBuilder` from tap-value `cluster_builder`. Overridable by workload.
- `dockerfile` value `./Dockerfile`. Overridable by workload.
- `docker_build_context` value `./`. Overridable by workload.
- `docker_build_extra_args` value `[]`. Overridable by workload.

#### Common Resources

- [Config-Provider](#config-provider)
- [App-Config](#app-config)
- [Service-Bindings](#service-bindings)
- [Api-Descriptors](#api-descriptors)
- [Config-Writer](#config-writer)
- [Deliverable](#deliverable)

### Parameters provided to all resources

- `maven_repository_url` from tap-value `maven.repository.url`. NOT overridable by workload.
- `maven_repository_secret_name` from tap-value `maven.repository.secret_name`. NOT overridable by workload.
- See [Params provided by all Supply Chains to all Resources](#params-provided-by-all-supply-chains-to-all-resources)

### Package

[Out of the Box Supply Chain Basic](ootb-supply-chain-basic.hbs.md)

### More Information

See [Install Out of the Box Supply Chain Basic](install-ootb-sc-basic.hbs.md)
for information about setting tap-values at installation time.

## Source-Test-to-URL

- Fetches application source code
- Runs user defined tests against the code
- Builds the code into an image
- Writes the Kubernetes configuration necessary to deploy the application
- Commits that configuration to either a Git repository or a container image registry

### Resources

#### source-provider

Refers to [source-template](ootb-template-reference.hbs.md#source-template).

Parameters provided:

- `serviceAccount` from tap-value `service_account`. Overridable by workload.
- `gitImplementation` from tap-value `git_implementation`. NOT overridable by workload.

#### source-tester

Refers to [testing-pipeline](ootb-template-reference.hbs.md#testing-pipeline).

No parameters are provided by the supply-chain.

#### image-provider

Refers to [kaniko-template](ootb-template-reference.hbs.md#kaniko-template)
when the workload provides a parameter `dockerfile`.
Refers to [kpack-template](ootb-template-reference.hbs.md#kpack-template) otherwise.

Parameters provided:

- `serviceAccount` from tap-value `service_account`. Overridable by workload.
- `registry` from tap-value `registry`. NOT overridable by workload.
- `clusterBuilder` from tap-value `cluster_builder`. Overridable by workload.
- `dockerfile` value `./Dockerfile`. Overridable by workload.
- `docker_build_context` value `./`. Overridable by workload.
- `docker_build_extra_args` value `[]`. Overridable by workload.

#### Common Resources

- [Config-Provider](#config-provider)
- [App-Config](#app-config)
- [Service-Bindings](#service-bindings)
- [Api-Descriptors](#api-descriptors)
- [Config-Writer](#config-writer)
- [Deliverable](#deliverable)

### Parameters provided to all resources

- `maven_repository_url` from tap-value `maven.repository.url`. NOT overridable by workload.
- `maven_repository_secret_name` from tap-value `maven.repository.secret_name`. NOT overridable by workload.
- See [Params provided by all Supply Chains to all Resources](#params-provided-by-all-supply-chains-to-all-resources).

### Package

[Out of the Box Supply Chain Testing](ootb-supply-chain-testing.hbs.md)

### More Information

See [Install Out of the Box Supply Chain with Testing](install-ootb-sc-wtest.hbs.md)
for information about setting tap-values at installation time.

## Source-Test-Scan-to-URL

- Fetches application source code
- Runs user defined tests against the code
- Scans the code for vulnerabilities
- Builds the code into an image
- Scans the image for vulnerabilities
- Writes the Kubernetes configuration necessary to deploy the application
- Commits that configuration to either a Git repository or an image registry

### Resources

#### source-provider

Refers to [source-template](ootb-template-reference.hbs.md#source-template).

Parameters provided:

- `serviceAccount` from tap-value `service_account`. Overridable by workload.
- `gitImplementation` from tap-value `git_implementation`. NOT overridable by workload.

#### source-tester

Refers to [testing-pipeline](ootb-template-reference.hbs.md#testing-pipeline).

No parameters are provided by the supply-chain.

#### source-scanner

Refers to [source-scanner-template](ootb-template-reference.hbs.md#source-scanner-template).

Parameters provided:

- `scanning_source_policy` from tap-value `scanning.source.policy`. Overridable by workload.
- `scanning_source_template` from tap-value `scanning.source.template`. Overridable by workload.

#### image-provider

Refers to [kaniko-template](ootb-template-reference.hbs.md#kaniko-template)
when the workload provides a parameter `dockerfile`.
Refers to [kpack-template](ootb-template-reference.hbs.md#kpack-template) otherwise.

Parameters provided:

- `serviceAccount` from tap-value `service_account`. Overridable by workload.
- `registry` from tap-value `registry`. NOT overridable by workload.
- `clusterBuilder` from tap-value `cluster_builder`. Overridable by workload.
- `dockerfile` value `./Dockerfile`. Overridable by workload.
- `docker_build_context` value `./`. Overridable by workload.
- `docker_build_extra_args` value `[]`. Overridable by workload.

#### image-scanner

Refers to [image-scanner-template](ootb-template-reference.hbs.md#image-scanner-template).

Parameters provided:

- `scanning_image_policy` from tap-value `scanning.image.policy`. Overridable by workload.
- `scanning_image_template` from tap-value `scanning.image.template`. Overridable by workload.

#### Common Resources

- [Config-Provider](#config-provider)
- [App-Config](#app-config)
- [Service-Bindings](#service-bindings)
- [Api-Descriptors](#api-descriptors)
- [Config-Writer](#config-writer)
- [Deliverable](#deliverable)

### Parameters provided to all resources

- `maven_repository_url` from tap-value `maven.repository.url`. NOT overridable by workload.
- `maven_repository_secret_name` from tap-value `maven.repository.secret_name`. NOT overridable by workload.
- See [Params provided by all Supply Chains to all Resources](#params-provided-by-all-supply-chains-to-all-resources)

### Package

[Out of the Box Supply Chain Testing Scanning](ootb-supply-chain-testing-scanning.hbs.md)

### More Information

See [Install Out of the Box Supply Chain with Testing and Scanning](install-ootb-sc-wtest-scan.hbs.md)
for information about setting tap-values at installation time.

## Basic-Image-to-URL

- Fetches a prebuilt image.
- Writes the Kubernetes configuration necessary to deploy the application.
- Commits that configuration to either a Git repository or an image registry.

### Resources

#### image-provider

Refers to [image-provider-template](ootb-template-reference.hbs.md#image-provider-template).

Parameters provided:

- `serviceAccount` from tap-value `service_account`. Overridable by workload.

#### Common Resources

- [Config-Provider](#config-provider)
- [App-Config](#app-config)
- [Service-Bindings](#service-bindings)
- [Api-Descriptors](#api-descriptors)
- [Config-Writer](#config-writer)
- [Deliverable](#deliverable)

### Parameters provided to all resources

- See [Params provided by all Supply Chains to all Resources](#params-provided-by-all-supply-chains-to-all-resources)

### Package

[Out of the Box Supply Chain Basic](ootb-supply-chain-basic.hbs.md)

### More Information

See [Install Out of the Box Supply Chain Basic](install-ootb-sc-basic.hbs.md)
for information about setting tap-values at installation time.

## Testing-Image-to-URL

- Fetches a prebuilt image.
- Writes the Kubernetes configuration necessary to deploy the application.
- Commits that configuration to either a Git repository or an image registry.

### Resources

#### image-provider

Refers to [image-provider-template](ootb-template-reference.hbs.md#image-provider-template).

Parameters provided:

- `serviceAccount` from tap-value `service_account`. Overridable by workload.

#### Common Resources

- [Config-Provider](#config-provider)
- [App-Config](#app-config)
- [Service-Bindings](#service-bindings)
- [Api-Descriptors](#api-descriptors)
- [Config-Writer](#config-writer)
- [Deliverable](#deliverable)

### Parameters provided to all resources

- See [Params provided by all Supply Chains to all Resources](#params-provided-by-all-supply-chains-to-all-resources)

### Package

[Out of the Box Supply Chain Testing](ootb-supply-chain-testing.hbs.md)

### More Information

See [Install Out of the Box Supply Chain with Testing](install-ootb-sc-wtest.hbs.md)
for information about setting tap-values at installation time.

## Scanning-Image-Scan-to-URL

- Fetches a prebuilt image,
- scans the image for vulnerabilities,
- writes the Kubernetes configuration necessary to deploy the application,
- and commits that configuration to either a Git repository or an image registry.

### Resources

#### image-provider

Refers to [image-provider-template](ootb-template-reference.hbs.md#image-provider-template).

Parameters provided:

- `serviceAccount` from tap-value `service_account`. Overridable by workload.

#### image-scanner

Refers to [image-scanner-template](ootb-template-reference.hbs.md#image-scanner-template).

Parameters provided:
- `scanning_image_policy` from tap-value `scanning.image.policy`. Overridable by workload.
- `scanning_image_template` from tap-value `scanning.image.template`. Overridable by workload.

#### Common Resources
- [Config-Provider](#config-provider)
- [App-Config](#app-config)
- [Service-Bindings](#service-bindings)
- [Api-Descriptors](#api-descriptors)
- [Config-Writer](#config-writer)
- [Deliverable](#deliverable)

### Parameters provided to all resources

- See [Params provided by all Supply Chains to all Resources](#params-provided-by-all-supply-chains-to-all-resources)

### Package

[Out of the Box Supply Chain Testing Scanning](ootb-supply-chain-testing-scanning.hbs.md)

### More Information

See [Install Out of the Box Supply Chain with Testing and Scanning](install-ootb-sc-wtest-scan.hbs.md)
for information about setting tap-values at installation time.

## Source-to-URL-Package (experimental)

### Purpose

- Fetches application source code,
- builds it into an image,
- bundles the Kubernetes configuration necessary to deploy the application into a Carvel Package,
- and commits that Package to a Git Repository.

### Resources

This section describes the templates and their parameters.

#### source-provider

Refers to [source-template](ootb-template-reference.hbs.md#source-template).

Parameters provided:

- `serviceAccount` from tap-value `service_account`. Overridable by workload.
- `gitImplementation` from tap-value `git_implementation`. NOT overridable by workload.

#### image-provider

Refers to [kaniko-template](ootb-template-reference.hbs.md#kaniko-template)
when the workload provides a parameter `dockerfile`.
Refers to [kpack-template](ootb-template-reference.hbs.md#kpack-template) otherwise.

Parameters provided:

- `serviceAccount` from tap-value `service_account`. Overridable by workload.
- `registry` from tap-value `registry`. NOT overridable by workload.
- `clusterBuilder` from tap-value `cluster_builder`. Overridable by workload.
- `dockerfile` value `./Dockerfile`. Overridable by workload.
- `docker_build_context` value `./`. Overridable by workload.
- `docker_build_extra_args` value `[]`. Overridable by workload.

#### carvel-package

Refers to [carvel-package](ootb-template-reference.hbs.md#carvel-package-experimental).

Parameters provided:

- `serviceAccount` from tap-value `service_account`. Overridable by workload.
- `registry` from tap-value `registry`. NOT overridable by workload.

#### package-config-writer

Refers to the
[package-config-writer-and-pull-requester-template](ootb-template-reference.hbs.md#package-config-writer-and-pull-requester-template-experimental)
when the tap-value `gitops.commit_strategy` is `pull_request`.
Otherwise, this resource refers to the [package-config-writer-template](ootb-template-reference.hbs.md#package-config-writer-template-experimental)

Parameters provided:

- `serviceAccount` from tap-value `service_account`. Overridable by workload.
- `registry` from tap-value `registry`. NOT overridable by workload.

#### Common Resources

- [Config-Provider](#config-provider)
- [App-Config](#app-config)
- [Service-Bindings](#service-bindings)
- [Api-Descriptors](#api-descriptors)

### Parameters provided to all resources

- `maven_repository_url` from tap-value `maven.repository.url`. NOT overridable by workload.
- `maven_repository_secret_name` from tap-value `maven.repository.secret_name`. NOT overridable by workload.
- `carvel_package_gitops_subpath` from tap-value `carvel_package.gitops_subpath`. Overridable by workload.
- `carvel_package_name_suffix` from tap-value `carvel_package.name_suffix`. Overridable by workload.
- See [Params provided by all Supply Chains to all Resources](#params-provided-by-all-supply-chains-to-all-resources)

### Package

[Out of the Box Supply Chain Basic](ootb-supply-chain-basic.hbs.md)

### More Information

See [Install Out of the Box Supply Chain Basic](install-ootb-sc-basic.hbs.md)
for information about setting tap-values at installation time.

## Basic-Image-to-URL-Package (experimental)

- Fetches a prebuilt image,
- bundles the Kubernetes configuration necessary to deploy the application into a Carvel Package,
- and commits that Package to a Git Repository.

### Resources

#### image-provider

Refers to [image-provider-template](ootb-template-reference.hbs.md#image-provider-template).

Parameters provided:

- `serviceAccount` from tap-value `service_account`. Overridable by workload.

#### carvel-package

Refers to [carvel-package](ootb-template-reference.hbs.md#carvel-package-experimental).

Parameters provided:

- `serviceAccount` from tap-value `service_account`. Overridable by workload.
- `registry` from tap-value `registry`. NOT overridable by workload.

#### package-config-writer

Refers to the
[package-config-writer-and-pull-requester-template](ootb-template-reference.hbs.md#package-config-writer-and-pull-requester-template-experimental)
when the tap-value `gitops.commit_strategy` is `pull_request`.
Otherwise, this resource refers to the [package-config-writer-template](ootb-template-reference.hbs.md#package-config-writer-template-experimental)

Parameters provided:

- `serviceAccount` from tap-value `service_account`. Overridable by workload.
- `registry` from tap-value `registry`. NOT overridable by workload.

#### Common Resources

- [Config-Provider](#config-provider)
- [App-Config](#app-config)
- [Service-Bindings](#service-bindings)
- [Api-Descriptors](#api-descriptors)
- [Config-Writer](#config-writer)
- [Deliverable](#deliverable)

### Parameters provided to all resources

- `carvel_package_gitops_subpath` from tap-value `carvel_package.gitops_subpath`. Overridable by workload.
- `carvel_package_name_suffix` from tap-value `carvel_package.name_suffix`. Overridable by workload.
- See [Params provided by all Supply Chains to all Resources](#params-provided-by-all-supply-chains-to-all-resources)

### Package

[Out of the Box Supply Chain Basic](ootb-supply-chain-basic.hbs.md)

### More Information

See [Install Out of the Box Supply Chain Basic](install-ootb-sc-basic.hbs.md)
for information about setting tap-values at installation time.

## Resources Common to All OOTB Supply Chains

### config-provider

Refers to [convention-template](ootb-template-reference.hbs.md#convention-template).

Parameters provided:

- `serviceAccount` from tap-value `service_account`. Overridable by workload.

### app-config

The tap-values field `supported_workloads` defines which templates are referred to by this resource.
Default configuration is:

```yaml
supported_workloads:
- type: web
  cluster_config_template_name: config-template
- type: server
  cluster_config_template_name: server-template
- type: worker
  cluster_config_template_name: worker-template
```

The workload's `apps.tanzu.vmware.com/workload-type` label determines which template is used at this step.
For example, when the workload has a label `apps.tanzu.vmware.com/workload-type:web`, the supply chain references
`config-template`.

No parameters are provided by the supply-chain.

### service-bindings

Refers to the [service-binding template](ootb-template-reference.hbs.md#service-bindings).

No parameters are provided by the supply-chain.

### api-descriptors

Refers to the [api-descriptors template](ootb-template-reference.hbs.md#api-descriptors).

No parameters are provided by the supply-chain.

### config-writer

Refers to the
[config-writer-and-pull-requester-template](ootb-template-reference.hbs.md#config-writer-and-pull-requester-template)
when the tap-value `gitops.commit_strategy` is `pull_request`.
Otherwise, this resource refers to the [config-writer-template](ootb-template-reference.hbs.md#config-writer-template)

Parameters provided:

- `serviceAccount` from tap-value `service_account`. Overridable by workload.
- `registry` from tap-value `registry`. NOT overridable by workload.

### deliverable

Refers to the [external-deliverable-template](ootb-template-reference.hbs.md#external-deliverable-template)
when the tap-value `external_delivery` evaluates to `true`.
Otherwise the resource refers to the [deliverable-template](ootb-template-reference.hbs.md#deliverable-template).

Parameters provided:

- `registry` from tap-value `registry`. NOT overridable by workload.

## Parameters provided by all Supply Chains to all Resources

All of the following parameters are overridable by the workload.

- `gitops_branch` from tap-value `gitops.branch`
- `gitops_user_name` from tap-value `gitops.username`
- `gitops_user_email` from tap-value `gitops.email`
- `gitops_commit_message` from tap-value `gitops.commit_message`
- `gitops_ssh_secret` from tap-value `gitops.ssh_secret`
- `gitops_repository_prefix` from tap-value `gitops.repository_prefix` when present.
- `gitops_server_address` from tap-value `gitops.server_address` when present.
- `gitops_repository_owner` from tap-value `gitops.repository_owner` when present.
- `gitops_repository_name` from tap-value `gitops.repository_name` when present.
- `gitops_server_kind` from tap-value `gitops.pull_request.server_kind` when present.
- `gitops_commit_branch` from tap-value `gitops.pull_request.commit_branch` when present.
- `gitops_pull_request_title` from tap-value `gitops.pull_request.pull_request_title` when present.
- `gitops_pull_request_body` from tap-value `gitops.pull_request.pull_request_body` when present.
