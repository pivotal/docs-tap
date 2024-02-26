# Components explained

{{> 'partials/supply-chain/beta-banner' }}

![core-concepts-component.jpg](./images/core-concepts-component.jpg)

[Detailed Specification in the API Section](../../reference/api/component.hbs.md)

Components encapsulate "work to be done" in composable and re-usable pieces.
Components are analogous to steps, stages, jobs, and tasks in other CI/CD offerings.
Components are unique from other CI/CD offerings in three distinct ways:

1. Components' configuration requirements are declared, static, and enforced. The configuration is used to build a [Workload] Resource that is strongly typed and well-documented.
2. Components are observed by end users through a strict error-reporting API.
3. Components can exhibit "re-entrant behaviour". If a [Resumption] is defined for a component, that can trigger new [WorkloadRuns]. This keeps the knowledge of component transient dependencies _within_ the component. 

To understand this last point, take a look at the [Resumptions] section where they are explained in greater detail.

These design constraints exist to:

1. Simplify the end-user experience, offering them a single well-defined API and a way of mitigating errors if they arise.
2. Simplify the authoring experience, requiring minimal Kubernetes experience to construct supply chains that meet your organizations needs. 

[SupplyChain]: ./supply-chains.hbs.md
[SupplyChains]: ./supply-chains.hbs.md
[Workload]: ./workloads.hbs.md
[Workloads]: ./workloads.hbs.md
[WorkloadRuns]: ./workload-runs.hbs.md
[WorkloadRun]: ./workload-runs.hbs.md
[Resumptions]: ./resumptions.hbs.md
[Resumption]: ./resumptions.hbs.md
