# Overview of Resumptions

This topic explains the concept of resumptions in Tanzu Supply Chain.
For reference information about resumptions, see [Component API](../../reference/api/component.hbs.md).

{{> 'partials/supply-chain/beta-banner' }}

![core-concepts-resumptions.jpg](./images/core-concepts-resumptions.jpg)

Resumptions are an important part of the Tanzu Supply Chain `Component` resource.

The `Component` resource deals with the configuration to pass to resumptions and pipelines, or
the pipeline to run when the `Component` stage is reached in the supply chain.
Resumptions are focused on the reasons to run again.

Resumptions are executed on a timer that is specified in the `resumptions` array of the component.
When they trigger, they execute a Tekton `TaskRun` to discover new values.
These are common for discovering changes to source repositories, image repositories, and new versions
of binaries.

If a run reaches a stage with a resumption, the system generates a `resumptionKey` based on the value
of the parameters that are passed to the resumption.
If a resumption has already been executed with the same parameters, the result of that resumption is used.
This allows hundreds or thousands of workloads to reuse the same common inputs from resumptions without
needing to run another resumption.

Resumptions wait for the period of time specified in `resumptions[].trigger.runAfter`, after the last
completion of a resumption `TaskRun`, before running it again.

When a result for a resumption changes, all the `WorkloadRuns` with the same `resumptionKey` are cloned,
truncated back to the stage of the resumption, and progress starts from there.
This is the mechanism for resumptions triggering a new `WorkloadRun`.

<!--
[SupplyChain]: ./supply-chains.hbs.md
[SupplyChains]: ./supply-chains.hbs.md
[Component]: ./components.hbs.md
[Components]: ./components.hbs.md
[Workload]: ./workloads.hbs.md
[Workloads]: ./workloads.hbs.md
[WorkloadRuns]: ./workload-runs.hbs.md
[WorkloadRun]: ./workload-runs.hbs.md
[Resumptions]: ./resumptions.hbs.md
[Resumption]: ./resumptions.hbs.md
-->
