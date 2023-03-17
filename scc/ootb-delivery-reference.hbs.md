# Deliveries

Tanzu Application Platform delivery package installs a single [ClusterDelivery](https://cartographer.sh/docs/v0.6.0/reference/deliverable/#clusterdelivery).

The delivery provides some parameters to the templates. Some of these might be
overridden by the parameters provided by the deliverable.
See [parameters](https://cartographer.sh/docs/v0.6.0/templating/#parameters) in
the Cartographer documentation.

## Delivery-Basic

### Purpose

- Fetches Kubernetes configuration created by a supply chain.
- Deploys the configuration on the cluster.

### Resources

The following resources describe the templates.

#### source-provider

Refers to [delivery-source-template](ootb-template-reference.hbs.md#delivery-source-template).

Parameters provided:

 - `serviceAccount` from tap-value `service_account`. Overridable by deliverable.
 - `gitImplementation` from tap-value `git_implementation`. Not overridable by deliverable.

#### Deployer

Refers to [app-deploy template](ootb-template-reference.hbs.md#app-deploy).

Parameter provided:

- `serviceAccount` from tap-value `service_account`. Overridable by deliverable.

### Package

Refers to [Out of the Box Delivery Basic](ootb-delivery-basic.hbs.md).

### More Information

For information about setting tap-values at installation time, see [Install Out of the Box Delivery Basic](install-ootb-delivery-basic.hbs.md).
