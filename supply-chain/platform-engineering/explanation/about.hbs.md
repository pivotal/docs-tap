# Explanations for Platform Engineers

This section describes the core architectural concepts of Tanzu Supply Chain.
It focuses on authoring a platform for application development.

{{> 'partials/supply-chain/beta-banner' }}

The Tanzu Supply Chain enables platform engineers to author a seamless experience for
development work. You do not require an understanding of Kubernetes.

![core-concepts-about.jpg](./images/core-concepts-about.jpg)

## <a id="primatives"></a> About the primitives of Tanzu Supply Chain

Tanzu Supply Chain has the following primitives:

- **SupplyChain:** Defines the `Workload` Kind and the components to use.
- **Workload:** Provides a developer API.
- **WorkloadRun:** Provides a record of each progression through a supply chain.
- **Component:** Provides an abstraction for a piece of work and reasons to trigger new runs.
- **Resumptions:** Provide a process for defining the triggering of new runs.

## <a id="system-overview"></a> Overview of the Tanzu Supply Chain system

Each `SupplyChain` resource combines multiple `Components` in `stages`.
`SupplyChain` resources define a process for converting configuration workloads into final artifacts.
They are very similar to pipelines in other CI/CD systems, with some key differences:

- The `SupplyChain` defines a `Workload` custom resource definition (CRD).
  The `Workload` becomes the interface that users, typically developers, consume to have work done.

- Users are typically unaware of the inner-workings of the `SupplyChain` and `Components`.

- `Components` encapsulate the work of generating a final or intermediate artifact, and importantly,
  the work of discovering new work to be done.

The flow of operations is as follows:

1. Apply a valid `SupplyChain`, `Components`, and accompanying Tekton `Tasks` and `Pipelines`.

2. Tanzu Supply Chain generates a `Workload` CRD as defined by the `SupplyChain`.

3. A developer discovers the `Workload` Kinds available to them using the Tanzu CLI.

4. The developer generates a `Workload` and fills in the required configuration.

5. After applying the `Workload`, Tanzu Supply Chain starts the first `WorkloadRun`.
   Tanzu Supply Chain captures its progress and artifacts.

6. Tanzu Supply Chain monitors `Components` that have resumptions to discover if it needs to generate
   new runs.
   1. New configuration in the `Workload` triggers new runs.
   2. New source code, base images, or other triggers from resumptions trigger new runs.

7. The developer observes the progress of runs using the Tanzu CLI.

## <a id="gitops"></a> Managing SupplyChains with GitOps

`SupplyChains`, especially the authoring resources `SupplyChain`, `Component`, and Tekton `Pipeline`
or `Task` are delivered to clusters through a Git repository and GitOps source promotion style.

For more information, see [Manage SupplyChains with GitOps](./../how-to/deploying-supply-chains/gitops-managed.hbs.md).

<!--
[SupplyChain]: ./supply-chains.hbs.md
[Workload]: ./workloads.hbs.md
[WorkloadRun]: ./workload-runs.hbs.md
[Components]: ./components.hbs.md
[Resumptions]: ./resumptions.hbs.md
-->
