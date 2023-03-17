# Workload Reference

This topic describes available fields for Supply Chain Choreographer workloads.

## Standard Fields

Cartographer workloads have standard fields leveraged by supply chains.
See [Cartographer's Reference
Documentation](https://cartographer.sh/docs/v0.6.0/reference/workload/#workload) in the Cartographer documentation.

## Labels

Workload labels affect which supply chain is selected. For information about which template is defined for a particular reference, see [Selectors](https://cartographer.sh/docs/v0.6.0/architecture/#selectors) in the Cartographer documentation.
Individual templates can also use workload labels.

OOTB Supply Chains use the following workload labels:

- `apps.tanzu.vmware.com/has-tests` by
  [Source-Test-to-URL](ootb-supply-chain-reference.hbs.md#source-test-to-url) and
  [Source-Test-Scan-to-URL](ootb-supply-chain-reference.hbs.md#source-test-scan-to-url).
- `apps.tanzu.vmware.com/workload-type` by [all supply chains](ootb-supply-chain-reference.hbs.md).
- `apis.apps.tanzu.vmware.com/register-api` by the [Api-Descriptors Template](ootb-template-reference.hbs.md#api-descriptors).
- `apps.tanzu.vmware.com/carvel-package-workflow` by [source-to-url-package (experimental)](ootb-supply-chain-reference.hbs.md#source-to-url-package-experimental) and [basic-image-to-url-package (experimental)](ootb-supply-chain-reference.hbs.md#basic-image-to-url-experimental).

## Parameters

The OOTB templates are configured with parameters from the supply chain or workload.
For information about Cartographer parameters, including precedence rules, see [Parameters](https://cartographer.sh/docs/v0.6.0/templating/#parameters) in the Cartographer documentation.

What parameters are relevant depends on the supply chain selecting the workload, for two reasons:

1. The OOTB supply chains refer to overlapping sets of templates.
A workload selected by the Source-to-URL supply chain can provide a `scanning_image_template` parameter,
but the supply chain does not refer to a template that leverages that parameter.
1. Supply Chains can be written to provide a parameter value to a template
  and prevent the workload from overriding the value. See [Further Information](https://cartographer.sh/docs/v0.6.0/tutorials/using-params/#further-information) in the Cartographer documentation.

The following list of parameters are respected by some OOTB supply chains.
Each provides the templates that respect the parameter.
The reference for the template details which supply chains include the template.

- gitImplementation: [source-template](ootb-template-reference.hbs.md#source-template)
- gitops_ssh_secret: [source-template](ootb-template-reference.hbs.md#source-template),
  [deliverable-template](ootb-template-reference.hbs.md#deliverable-template),
  [external-deliverable-template](ootb-template-reference.hbs.md#external-deliverable-template)
- serviceAccount: [source-template](ootb-template-reference.hbs.md#source-template),
  [image-provider-template](ootb-template-reference.hbs.md#image-provider-template),
  [kpack-template](ootb-template-reference.hbs.md#kpack-template),
  [kaniko-template](ootb-template-reference.hbs.md#kaniko-template),
  [convention-template](ootb-template-reference.hbs.md#convention-template),
  [config-writer-template](ootb-template-reference.hbs.md#config-writer-template),
  [config-writer-and-pull-requester-template](ootb-template-reference.hbs.md#config-writer-and-pull-requester-template),
  [deliverable-template](ootb-template-reference.hbs.md#deliverable-template),
  [external-deliverable-template](ootb-template-reference.hbs.md#external-deliverable-template)
- maven: [source-template](ootb-template-reference.hbs.md#source-template)
- testing_pipeline_matching_labels: [testing-pipeline](ootb-template-reference.hbs.md#testing-pipeline)
- testing_pipeline_params: [testing-pipeline](ootb-template-reference.hbs.md#testing-pipeline)
- scanning_source_template: [source-scanner-template](ootb-template-reference.hbs.md#source-scanner-template)
- scanning_source_policy: [source-scanner-template](ootb-template-reference.hbs.md#source-scanner-template)
- clusterBuilder: [kpack-template](ootb-template-reference.hbs.md#kpack-template)
- buildServiceBindings: [kpack-template](ootb-template-reference.hbs.md#kpack-template)
- live-update: [kpack-template](ootb-template-reference.hbs.md#kpack-template),
  [convention-template](ootb-template-reference.hbs.md#convention-template)
- dockerfile: [kaniko-template](ootb-template-reference.hbs.md#kaniko-template)
- docker_build_context: [kaniko-template](ootb-template-reference.hbs.md#kaniko-template)
- docker_build_extra_args: [kaniko-template](ootb-template-reference.hbs.md#kaniko-template)
- scanning_image_template: [image-scanner-template](ootb-template-reference.hbs.md#image-scanner-template)
- scanning_image_policy: [image-scanner-template](ootb-template-reference.hbs.md#image-scanner-template)
- annotations: [convention-template](ootb-template-reference.hbs.md#convention-template),
  [service-bindings](ootb-template-reference.hbs.md#service-bindings),
  [api-descriptors](ootb-template-reference.hbs.md#api-descriptors)
- debug: [convention-template](ootb-template-reference.hbs.md#convention-template)
- ports: [server-template](ootb-template-reference.hbs.md#server-template)
- api-descriptors: [api-descriptors](ootb-template-reference.hbs.md#api-descriptors)
- gitops_branch: [config-writer-template](ootb-template-reference.hbs.md#config-writer-template),
  [config-writer-and-pull-requester-template](ootb-template-reference.hbs.md#config-writer-and-pull-requester-template),
  [deliverable-template](ootb-template-reference.hbs.md#deliverable-template),
  [external-deliverable-template](ootb-template-reference.hbs.md#external-deliverable-template)
- gitops_user_name: [config-writer-template](ootb-template-reference.hbs.md#config-writer-template),
  [config-writer-and-pull-requester-template](ootb-template-reference.hbs.md#config-writer-and-pull-requester-template)
- gitops_user_email: [config-writer-template](ootb-template-reference.hbs.md#config-writer-template),
  [config-writer-and-pull-requester-template](ootb-template-reference.hbs.md#config-writer-and-pull-requester-template)
- gitops_commit_message: [config-writer-template](ootb-template-reference.hbs.md#config-writer-template),
  [config-writer-and-pull-requester-template](ootb-template-reference.hbs.md#config-writer-and-pull-requester-template)
- gitops_repository: [config-writer-template](ootb-template-reference.hbs.md#config-writer-template),
  [deliverable-template](ootb-template-reference.hbs.md#deliverable-template),
  [external-deliverable-template](ootb-template-reference.hbs.md#external-deliverable-template)
- gitops_repository_prefix: [config-writer-template](ootb-template-reference.hbs.md#config-writer-template),
  [deliverable-template](ootb-template-reference.hbs.md#deliverable-template),
  [external-deliverable-template](ootb-template-reference.hbs.md#external-deliverable-template)
- gitops_server_address: [config-writer-template](ootb-template-reference.hbs.md#config-writer-template),
  [config-writer-and-pull-requester-template](ootb-template-reference.hbs.md#config-writer-and-pull-requester-template),
  [deliverable-template](ootb-template-reference.hbs.md#deliverable-template),
  [external-deliverable-template](ootb-template-reference.hbs.md#external-deliverable-template)
- gitops_repository_owner: [config-writer-template](ootb-template-reference.hbs.md#config-writer-template),
  [config-writer-and-pull-requester-template](ootb-template-reference.hbs.md#config-writer-and-pull-requester-template),
  [deliverable-template](ootb-template-reference.hbs.md#deliverable-template),
  [external-deliverable-template](ootb-template-reference.hbs.md#external-deliverable-template)
- gitops_repository_name: [config-writer-template](ootb-template-reference.hbs.md#config-writer-template),
  [config-writer-and-pull-requester-template](ootb-template-reference.hbs.md#config-writer-and-pull-requester-template),
  [deliverable-template](ootb-template-reference.hbs.md#deliverable-template),
  [external-deliverable-template](ootb-template-reference.hbs.md#external-deliverable-template)
- gitops_commit_branch: [config-writer-and-pull-requester-template](ootb-template-reference.hbs.md#config-writer-and-pull-requester-template)
- gitops_pull_request_title: [config-writer-and-pull-requester-template](ootb-template-reference.hbs.md#config-writer-and-pull-requester-template)
- gitops_pull_request_body: [config-writer-and-pull-requester-template](ootb-template-reference.hbs.md#config-writer-and-pull-requester-template)
- gitops_server_kind: [config-writer-and-pull-requester-template](ootb-template-reference.hbs.md#config-writer-and-pull-requester-template)
- carvel_package_gitops_subpath (experimental): [carvel-package](ootb-template-reference.hbs.md#carvel-package-experimental),
  [package-config-writer-template](ootb-template-reference.hbs.md#package-config-writer-template-experimental),
  [package-config-writer-and-pull-requester-template](ootb-template-reference.hbs.md#package-config-writer-and-pull-requester-template-experimental)
- carvel_package_name_suffix (experimental): [carvel-package](ootb-template-reference.hbs.md#carvel-package-experimental),
  [package-config-writer-template](ootb-template-reference.hbs.md#package-config-writer-template-experimental),
  [package-config-writer-and-pull-requester-template](ootb-template-reference.hbs.md#package-config-writer-and-pull-requester-template-experimental)

## Service Account

In order to create the templated objects, Cartographer needs a reference to a service account with permissions
to manage resources.
This service account may be provided in the workload's `.spec.serviceAccountName` field
or in the supply chain's `spec.serviceAccountRef` field.
See [Service Account](https://cartographer.sh/docs/v0.6.0/tutorials/first-supply-chain/#service-account)
and [Workload and Supply Chain Custom Resources](https://cartographer.sh/docs/v0.6.0/reference/workload/) in the Cartographer documentation.
When using the Tanzu CLI to create a workload,
specify this service account's name with the `--service-account` flag.

After the templated objects are created,
they often need a service account with permissions to do work.
In the OOTB Templates and Supply Chains, the _param_ `serviceAccount` must reference
the service account for these objects.
When using the Tanzu CLI to create a workload,
specify this service account's name with `--param serviceAccount=...`.