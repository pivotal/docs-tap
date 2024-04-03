# Security Model

This topic discusses the security model for Tanzu Supply Chain. Prior to TAP 1.9.0, Supply Chain beta
required Workloads associated work resources be created in the same namespace as a Supply Chain. This
was inflexible, and creates security concerns over platform configuration and secrets.

{{> 'partials/supply-chain/beta-banner' }}

TAP 1.9.0 introduces a security model for executing stages of a supply chain, which now assumes Workloads
will exist in their own namespaces, separate from the Supply Chain.

![Security Model Diagram](./images/security-model.png)

Following from this, Runs for the associated Workloads are also created in the Workload's namespace.

Stages, will however, be created by default in the Supply Chain namespace, and that includes its
subordinate Resumptions, TaskRuns and PipelineRuns. This gives the components in these stages visibility
over platform secrets in the Supply Chain namespace.

The platform engineer may deem it appropriate for a stage of a pipeline to instead execute in the Workload
namespace. For example to allow a source component to retrieve source from a developer controlled repository
using secrets provided by the developer in the Workload namespace. This can be achieved with the 
`securityContext.runAs` setting on a [Supply Chain's stages](../../reference/api/supplychain.hbs.md).
