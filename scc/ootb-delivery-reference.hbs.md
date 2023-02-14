# Deliveries

TAP ships with one delivery package,
which installs a single delivery.

## Delivery-Basic

### Purpose

- Fetches kubernetes configuration created by a supply chain,
- deploys the configuration on the cluster.

### Resources (steps)

#### source-provider

Refers to [delivery-source-template](ootb-template-reference.hbs.md#delivery-source-template).

Params provided:
 - `serviceAccount` from tap-value `service_account`. Overridable by workload param.
 - `gitImplementation` from tap-value `git_implementation`. NOT overridable by workload param.

#### deployer

Refers to [app-deploy template](ootb-template-reference.hbs.md#app-deploy).

Params provided:
- `serviceAccount` from tap-value `service_account`. Overridable by workload param.

### Package

[Out of the Box Delivery Basic](ootb-delivery-basic.hbs.md)

### More Information

See [Install Out of the Box Delivery Basic](install-ootb-delivery-basic.hbs.md)
for information on setting tap-values at installation time.
