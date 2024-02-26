# Tanzu Supply Chains Known Issues

{{> 'partials/supply-chain/beta-banner' }}

## Workload Creation

* The Beta version of the Tanzu Supply Chains only supports creating `Workloads` in the same namespace where the `SupplyChain` is installed. This will be fixed in the future versions before Tanzu Supply Chains becomes GA and `SupplyChain` will be installed in a single protected namespace in the cluster, and the developers will be able to create `Workloads` in any namespace as long as they have permissions to do so in that namespace.

## Workload Visibility

* Tekton failures in Tasks are not propagated properly in the status of the `WorkloadRuns` and thereby not visible in the `tanzu workload run get` outputs.
* Errors in the `Component` pipelines and exposed as a message is not properly propagated in the status of the `WorkloadRun` and thereby not visible in the `tanzu workload run get` outputs.

## Component Authoring

* Component authors cannot have more than one resumption defined. When there are multiple resumptions, the `WorkloadRuns` are not being correctly created upon changes triggered by these resumptions.

## Security

* The Tekton `Pipelines` and `Tasks` are currently running in the Developer namespace where the `Workload` is. In future release, `SupplyChain` namespaces will run these resources for the `Component` unless its specifically chosen by the component author to run in the Developer namespace. There are use cases for components such as `source-git-provider` where a Developer can provide a secret to pull the source for their repository without the Platform Engineer being the bottleneck.