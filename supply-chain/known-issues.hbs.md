# Tanzu Supply Chains Known Issues

{{> 'partials/supply-chain/beta-banner' }}

## Workload Creation
* The Beta version of the Tanzu Supply Chains only supports creating `Workloads` in the same namespace where the `SupplyChain` is installed. This will be fixed in the future versions before Tanzu Supply Chains becomes GA.

## Workload Visibility
* Tekton failures in Tasks are not propogated properly in the status of the `WorkloadRuns` and thereby not visible in the `tanzu workload run get` outputs.
* Errors in the `Component` pipelines and exposed as a message is not properly propogated in the status of the `WorkloadRun` and thereby not visible in the `tanzu workload run get` outputs.

## Component Authoring
* Component authors cannot have more than one resumption defined. When there are multiple resumptions, the `WorkloadRuns` are not being correctly created upon changes trigger by these resumptions.