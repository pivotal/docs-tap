# Supply chains

Tanzu Application Platform includes a number of supply chains packages,
each of which installs two
[ClusterSupplyChains](https://cartographer.sh/docs/v0.6.0/reference/workload/#clustersupplychain).
Only one supply chain package can be installed at a time.

The supply chains provide some [parameters](https://cartographer.sh/docs/v0.6.0/templating/#parameters)
to the referenced templates.
These might be overridden by the parameters provided by the workload.

## <a id='source-url'></a> Source-to-URL

### <a id='source-url-purpose'></a> Purpose

- Fetches application source code
- Builds it into an image
- Writes the Kubernetes configuration necessary to deploy the application
- Commits that configuration to either a Git repository or a container image registry

### <a id='source-url-resources'></a> Resources

This section describes the templates and their parameters.

#### <a id='source-url-source-provider'></a> source-provider

Refers to [source-template](ootb-template-reference.hbs.md#source-template).

Parameters provided:

- `serviceAccount` from tap-value `service_account`. Overridable by workload.
- `gitImplementation` from tap-value `git_implementation`. NOT overridable by workload.

#### <a id='source-url-image-provider'></a> image-provider

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

#### <a id='common-resources-source-url'></a> Common resources

- [Config-Provider](#config-provider)
- [App-Config](#app-config)
- [Service-Bindings](#service-bindings)
- [Api-Descriptors](#api-descriptors)
- [Config-Writer](#config-writer)
- [Deliverable](#deliverable)

### <a id='parameters-source-url'></a> Parameters provided to all resources

- `maven_repository_url` from tap-value `maven.repository.url`. NOT overridable by workload.
- `maven_repository_secret_name` from tap-value `maven.repository.secret_name`. NOT overridable by workload.
- See [Params provided by all Supply Chains to all Resources](#params-provided-by-all-supply-chains-to-all-resources)

### <a id='package-source-url'></a> Package

[Out of the Box Supply Chain Basic](ootb-supply-chain-basic.hbs.md)

### <a id='more-info-source-url'></a> More information

For information about setting tap-values at installation time, see [Install Out of the Box Supply Chain Basic](install-ootb-sc-basic.hbs.md).

## <a id='source-test'></a> Source-Test-to-URL

- Fetches application source code
- Runs user defined tests against the code
- Builds the code into an image
- Writes the Kubernetes configuration necessary to deploy the application
- Commits that configuration to either a Git repository or a container image registry

### <a id='source-test-resources'></a> Resources

#### <a id='source-test-source-provider'></a> source-provider

Refers to [source-template](ootb-template-reference.hbs.md#source-template).

Parameters provided:

- `serviceAccount` from tap-value `service_account`. Overridable by workload.
- `gitImplementation` from tap-value `git_implementation`. NOT overridable by workload.

#### <a id='source-test-source-tester'></a> source-tester

Refers to [testing-pipeline](ootb-template-reference.hbs.md#testing-pipeline).

No parameters are provided by the supply-chain.

#### <a id='source-test-image-provider'></a> image-provider

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

#### <a id='source-test-common-resources'></a> Common resources

- [Config-Provider](#config-provider)
- [App-Config](#app-config)
- [Service-Bindings](#service-bindings)
- [Api-Descriptors](#api-descriptors)
- [Config-Writer](#config-writer)
- [Deliverable](#deliverable)

### <a id='source-test-params'></a> Parameters provided to all resources

- `maven_repository_url` from tap-value `maven.repository.url`. NOT overridable by workload.
- `maven_repository_secret_name` from tap-value `maven.repository.secret_name`. NOT overridable by workload.
- See [Params provided by all Supply Chains to all Resources](#params-provided-by-all-supply-chains-to-all-resources).

### <a id='source-test-package'></a> Package

[Out of the Box Supply Chain Testing](ootb-supply-chain-testing.hbs.md)

### <a id='source-test-more-info'></a> More information

For information about setting tap-values at installation time, see [Install Out of the Box Supply Chain with Testing](install-ootb-sc-wtest.hbs.md).

## <a id='source-test-scan'></a> Source-Test-Scan-to-URL

- Fetches application source code
- Runs user defined tests against the code
- Scans the code for vulnerabilities
- Builds the code into an image
- Scans the image for vulnerabilities
- Writes the Kubernetes configuration necessary to deploy the application
- Commits that configuration to either a Git repository or an image registry

### <a id='source-test-scan-resources'></a> Resources

#### <a id='source-test-scan-source-provider'></a> source-provider

Refers to [source-template](ootb-template-reference.hbs.md#source-template).

Parameters provided:

- `serviceAccount` from tap-value `service_account`. Overridable by workload.
- `gitImplementation` from tap-value `git_implementation`. NOT overridable by workload.

#### <a id='source-test-scan-source-tester'></a> source-tester

Refers to [testing-pipeline](ootb-template-reference.hbs.md#testing-pipeline).

No parameters are provided by the supply-chain.

#### <a id='source-test-scan-source-scanner'></a> source-scanner

Refers to [source-scanner-template](ootb-template-reference.hbs.md#source-scanner-template).

Parameters provided:

- `scanning_source_policy` from tap-value `scanning.source.policy`. Overridable by workload.
- `scanning_source_template` from tap-value `scanning.source.template`. Overridable by workload.

#### <a id='source-test-scan-image-provider'></a> image-provider

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

#### <a id='source-test-scan-image-scanner'></a> image-scanner

Refers to [image-scanner-template](ootb-template-reference.hbs.md#image-scanner-template).

Parameters provided:
- `scanning_image_policy` from tap-value `scanning.image.policy`. Overridable by workload.
- `scanning_image_template` from tap-value `scanning.image.template`. Overridable by workload.

#### <a id='source-test-scan-common-resources'></a> Common resources

- [Config-Provider](#config-provider)
- [App-Config](#app-config)
- [Service-Bindings](#service-bindings)
- [Api-Descriptors](#api-descriptors)
- [Config-Writer](#config-writer)
- [Deliverable](#deliverable)

### <a id='source-test-scan-params'></a> Parameters provided to all resources

- `maven_repository_url` from tap-value `maven.repository.url`. NOT overridable by workload.
- `maven_repository_secret_name` from tap-value `maven.repository.secret_name`. NOT overridable by workload.
- See [Params provided by all Supply Chains to all Resources](#params-provided-by-all-supply-chains-to-all-resources)

### <a id='source-test-scan-package'></a> Package

[Out of the Box Supply Chain Testing Scanning](ootb-supply-chain-testing-scanning.hbs.md)

### <a id='source-test-scan-more-info'></a> More information

For information about setting tap-values at installation time, see [Install Out of the Box Supply Chain with Testing and Scanning](install-ootb-sc-wtest-scan.hbs.md).

## <a id='basic-image'></a> Basic-Image-to-URL

- Fetches a prebuilt image.
- Writes the Kubernetes configuration necessary to deploy the application.
- Commits that configuration to either a Git repository or an image registry.

### <a id='basic-image-resources'></a> Resources

#### <a id='basic-image-image-provider'></a> image-provider

Refers to [image-provider-template](ootb-template-reference.hbs.md#image-provider-template).

Parameters provided:

- `serviceAccount` from tap-value `service_account`. Overridable by workload.

#### <a id='basic-image-common-resources'></a> Common resources

- [Config-Provider](#config-provider)
- [App-Config](#app-config)
- [Service-Bindings](#service-bindings)
- [Api-Descriptors](#api-descriptors)
- [Config-Writer](#config-writer)
- [Deliverable](#deliverable)

### <a id='basic-image-params'></a> Parameters provided to all resources

- See [Params provided by all Supply Chains to all Resources](#params-provided-by-all-supply-chains-to-all-resources)

### <a id='basic-image-package'></a> Package

[Out of the Box Supply Chain Basic](ootb-supply-chain-basic.hbs.md)

### <a id='basic-image-more-info'></a> More information

For information about setting tap-values at installation time, see [Install Out of the Box Supply Chain Basic](install-ootb-sc-basic.hbs.md).

## <a id='testing-image'></a> Testing-Image-to-URL

- Fetches a prebuilt image.
- Writes the Kubernetes configuration necessary to deploy the application.
- Commits that configuration to either a Git repository or an image registry.

### <a id='testing-image-resources'></a> Resources

#### <a id='testing-image-provider'></a> image-provider

Refers to [image-provider-template](ootb-template-reference.hbs.md#image-provider-template).

Parameters provided:

- `serviceAccount` from tap-value `service_account`. Overridable by workload.

#### <a id='testing-image-common-resources'></a> Common resources

- [Config-Provider](#config-provider)
- [App-Config](#app-config)
- [Service-Bindings](#service-bindings)
- [Api-Descriptors](#api-descriptors)
- [Config-Writer](#config-writer)
- [Deliverable](#deliverable)

### <a id='testing-image-params'></a> Parameters provided to all resources

- See [Params provided by all Supply Chains to all Resources](#params-provided-by-all-supply-chains-to-all-resources)

### <a id='testing-image-package'></a> Package

[Out of the Box Supply Chain Testing](ootb-supply-chain-testing.hbs.md)

### <a id='testing-image-more-info'></a> More information

For information about setting tap-values at installation time, see [Install Out of the Box Supply Chain with Testing](install-ootb-sc-wtest.hbs.md).

## <a id='scanning-image'></a> Scanning-image-scan-to-URL

- Fetches a prebuilt image.
- Scans the image for vulnerabilities.
- Writes the Kubernetes configuration necessary to deploy the application.
- Commits the configuration to either a Git repository or an image registry.

### <a id='scanning-image-resources'></a> Resources

#### <a id='scanning-image-provider'></a> image-provider

Refers to [image-provider-template](ootb-template-reference.hbs.md#image-provider-template).

Parameters provided:

- `serviceAccount` from tap-value `service_account`. Overridable by workload.

#### <a id='scanning-image-scanner'></a> image-scanner

Refers to [image-scanner-template](ootb-template-reference.hbs.md#image-scanner-template).

Parameters provided:

- `scanning_image_policy` from tap-value `scanning.image.policy`. Overridable by workload.
- `scanning_image_template` from tap-value `scanning.image.template`. Overridable by workload.

#### <a id='scanning-image-common-resources'></a> Common resources
- [Config-Provider](#config-provider)
- [App-Config](#app-config)
- [Service-Bindings](#service-bindings)
- [Api-Descriptors](#api-descriptors)
- [Config-Writer](#config-writer)
- [Deliverable](#deliverable)

### <a id='scanning-image-params'></a> Parameters provided to all resources

- See [Params provided by all Supply Chains to all Resources](#params-provided-by-all-supply-chains-to-all-resources)

### <a id='scanning-image-package'></a> Package

[Out of the Box Supply Chain Testing Scanning](ootb-supply-chain-testing-scanning.hbs.md)

### <a id='scanning-image-more-info'></a> More information

For information about setting tap-values at installation time, see [Install Out of the Box Supply Chain with Testing and Scanning](install-ootb-sc-wtest-scan.hbs.md).

## <a id='source-package'></a> Source-to-URL-Package (experimental)

### <a id='source-package-purpose'></a> Purpose

- Fetches the application source code.
- Builds the source code into an image.
- Bundles the Kubernetes configuration necessary to deploy the application into a Carvel Package.
- Commits the Package to a Git Repository.

### <a id='source-package-resources'></a> Resources

This section describes the templates and their parameters.

#### <a id='source-package-source-provider'></a> source-provider

Refers to [source-template](ootb-template-reference.hbs.md#source-template).

Parameters provided:

- `serviceAccount` from tap-value `service_account`. Overridable by workload.
- `gitImplementation` from tap-value `git_implementation`. NOT overridable by workload.

#### <a id='source-package-image-provider'></a> image-provider

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

#### <a id='source-package-carvel'></a>carvel-package

Refers to [carvel-package](ootb-template-reference.hbs.md#carvel-package-experimental).

Parameters provided:

- `serviceAccount` from tap-value `service_account`. Overridable by workload.
- `registry` from tap-value `registry`. NOT overridable by workload.

#### <a id='source-package-config-writer'></a> package-config-writer

Refers to the
[package-config-writer-and-pull-requester-template](ootb-template-reference.hbs.md#package-config-writer-and-pull-requester-template-experimental)
when the tap-value `gitops.commit_strategy` is `pull_request`.
Otherwise, this resource refers to the [package-config-writer-template](ootb-template-reference.hbs.md#package-config-writer-template-experimental).

Parameters provided:

- `serviceAccount` from tap-value `service_account`. Overridable by workload.
- `registry` from tap-value `registry`. NOT overridable by workload.

#### <a id='source-package-common-resources'></a> Common resources

- [Config-Provider](#config-provider)
- [App-Config](#app-config)
- [Service-Bindings](#service-bindings)
- [Api-Descriptors](#api-descriptors)

### <a id='source-package-params'></a> Parameters provided to all resources

- `maven_repository_url` from tap-value `maven.repository.url`. NOT overridable by workload.
- `maven_repository_secret_name` from tap-value `maven.repository.secret_name`. NOT overridable by workload.
- `carvel_package_gitops_subpath` from tap-value `carvel_package.gitops_subpath`. Overridable by workload.
- `carvel_package_name_suffix` from tap-value `carvel_package.name_suffix`. Overridable by workload.
- See [Params provided by all Supply Chains to all Resources](#params-provided-by-all-supply-chains-to-all-resources)

### <a id='source-package-package'></a>Package

[Out of the Box Supply Chain Basic](ootb-supply-chain-basic.hbs.md)

### <a id='source-package-more-info'></a> More information

See [Install Out of the Box Supply Chain Basic](install-ootb-sc-basic.hbs.md)
for information about setting tap-values at installation time.

## <a id='basic-package'></a> Basic-Image-to-URL-Package (experimental)

- Fetches a prebuilt image.
- Bundles the Kubernetes configuration necessary to deploy the application into a Carvel Package.
- Commits the Package to a Git Repository.

### <a id='basic-package-resources'></a> Resources

#### <a id='basic-image-provider'></a> image-provider

Refers to [image-provider-template](ootb-template-reference.hbs.md#image-provider-template).

Parameters provided:

- `serviceAccount` from tap-value `service_account`. Overridable by workload.

#### <a id='basic-carvel'></a> carvel-package

Refers to [carvel-package](ootb-template-reference.hbs.md#carvel-package-experimental).

Parameters provided:

- `serviceAccount` from tap-value `service_account`. Overridable by workload.
- `registry` from tap-value `registry`. NOT overridable by workload.

#### <a id='basic-config-writer'></a> package-config-writer

Refers to the
[package-config-writer-and-pull-requester-template](ootb-template-reference.hbs.md#package-config-writer-and-pull-requester-template-experimental)
when the tap-value `gitops.commit_strategy` is `pull_request`.
Otherwise, this resource refers to the [package-config-writer-template](ootb-template-reference.hbs.md#package-config-writer-template-experimental)

Parameters provided:

- `serviceAccount` from tap-value `service_account`. Overridable by workload.
- `registry` from tap-value `registry`. NOT overridable by workload.

#### <a id='basic-common-resources'></a> Common resources

- [Config-Provider](#config-provider)
- [App-Config](#app-config)
- [Service-Bindings](#service-bindings)
- [Api-Descriptors](#api-descriptors)
- [Config-Writer](#config-writer)
- [Deliverable](#deliverable)

### <a id='basic-params'></a> Parameters provided to all resources

- `carvel_package_gitops_subpath` from tap-value `carvel_package.gitops_subpath`. Overridable by workload.
- `carvel_package_name_suffix` from tap-value `carvel_package.name_suffix`. Overridable by workload.
- See [Params provided by all Supply Chains to all Resources](#params-provided-by-all-supply-chains-to-all-resources)

### <a id='basic-package-package'></a>Package

[Out of the Box Supply Chain Basic](ootb-supply-chain-basic.hbs.md)

### <a id='basic-package-more-info'></a> More information

See [Install Out of the Box Supply Chain Basic](install-ootb-sc-basic.hbs.md)
for information about setting tap-values at installation time.

## <a id='ootb-resources'></a> Resources common to all OOTB supply chains

### <a id='config-provider'></a> config-provider

Refers to [convention-template](ootb-template-reference.hbs.md#convention-template).

Parameters provided:

- `serviceAccount` from tap-value `service_account`. Overridable by workload.

### <a id='app-config'></a> app-config

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

### <a id='service-bindings'></a> service-bindings

Refers to the [service-binding template](ootb-template-reference.hbs.md#service-bindings).

No parameters are provided by the supply-chain.

### <a id='api-descriptors'></a> api-descriptors

Refers to the [api-descriptors template](ootb-template-reference.hbs.md#api-descriptors).

No parameters are provided by the supply-chain.

### <a id='config-writer'></a> config-writer

Refers to the
[config-writer-and-pull-requester-template](ootb-template-reference.hbs.md#config-writer-and-pull-requester-template)
when the tap-value `gitops.commit_strategy` is `pull_request`.
Otherwise, this resource refers to the [config-writer-template](ootb-template-reference.hbs.md#config-writer-template)

Parameters provided:

- `serviceAccount` from tap-value `service_account`. Overridable by workload.
- `registry` from tap-value `registry`. NOT overridable by workload.

### <a id='deliverable'></a> deliverable

Refers to the [external-deliverable-template](ootb-template-reference.hbs.md#external-deliverable-template)
when the tap-value `external_delivery` evaluates to `true`.
Otherwise the resource refers to the [deliverable-template](ootb-template-reference.hbs.md#deliverable-template).

Parameters provided:

- `registry` from tap-value `registry`. NOT overridable by workload.

## <a id='all-params'></a> Parameters provided by all supply chains to all resources

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
