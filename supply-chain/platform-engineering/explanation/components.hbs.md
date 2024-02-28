# Overview of Components

{{> 'partials/supply-chain/beta-banner' }}

This topic introduces the Component resource in Tanzu Supply Chain.

![core-concepts-component.jpg](./images/core-concepts-component.jpg)

For more information, see [Component API](../../reference/api/component.hbs.md).

Components encapsulate "work to be done" in composable and reusable pieces.
Components are analogous to steps, stages, jobs, and, tasks in other CI/CD offerings.
Components are unique from other CI/CD offerings in three distinct ways:

1. Component configuration requirements are declared, static, and enforced. The configuration is used to build a Workload Resource that is strongly typed and well-documented.
2. Components are observed by end-users through a strict error-reporting API.
3. Components can exhibit re-entrant behavior. If a Resumption is defined for a component, that can trigger new WorkloadRuns. This keeps the knowledge of component transient dependencies within the component. For more information, see [Resumptions](resumptions.hbs.md).

These design constraints exist to:

1. Simplify the end-user experience, offering a single well-defined API and a way of mitigating errors if they arise.
2. Simplify the authoring experience, requiring minimal Kubernetes experience to construct supply chains that meet your organization's needs.

<!--
[SupplyChain]: ./supply-chains.hbs.md
[SupplyChains]: ./supply-chains.hbs.md
[Workload]: ./workloads.hbs.md
[Workloads]: ./workloads.hbs.md
[WorkloadRuns]: ./workload-runs.hbs.md
[WorkloadRun]: ./workload-runs.hbs.md
[Resumptions]: ./resumptions.hbs.md
[Resumption]: ./resumptions.hbs.md
-->