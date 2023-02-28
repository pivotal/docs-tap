# Deliveries

TAP ships with one delivery package,
which installs a single [ClusterDelivery](https://cartographer.sh/docs/v0.6.0/reference/deliverable/#clusterdelivery).

The delivery provides some [parameters](https://cartographer.sh/docs/v0.6.0/templating/#parameters)
to the templates.
Some of these may be overridden by the parameters provided by the deliverable.

## Delivery-Basic

### Purpose

- Fetches kubernetes configuration created by a supply chain,
- deploys the configuration on the cluster.

### Resources (steps)

#### source-provider

Refers to [delivery-source-template](ootb-template-reference.hbs.md#delivery-source-template).

Params provided:
 - `serviceAccount` from tap-value `service_account`. Overridable by deliverable.
 - `gitImplementation` from tap-value `git_implementation`. NOT overridable by deliverable.

#### deployer

Refers to [app-deploy template](ootb-template-reference.hbs.md#app-deploy).

Params provided:
- `serviceAccount` from tap-value `service_account`. Overridable by deliverable.

### Package

[Out of the Box Delivery Basic](ootb-delivery-basic.hbs.md)

### More Information

See [Install Out of the Box Delivery Basic](install-ootb-delivery-basic.hbs.md)
for information on setting tap-values at installation time.
