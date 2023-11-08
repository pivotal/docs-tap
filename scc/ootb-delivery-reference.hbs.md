# Delivery reference for Supply Chain Choreographer

This topic describes the delivery parameters and templates you can use with Supply Chain Choreographer.

Tanzu Application Platform delivery package installs a single [ClusterDelivery](https://cartographer.sh/docs/v0.6.0/reference/deliverable/#clusterdelivery).

The delivery provides some parameters to the templates. The parameters provided by the deliverable might
override some of the delivery parameters in this topic.
See [parameters](https://cartographer.sh/docs/v0.6.0/templating/#parameters) in
the Cartographer documentation.

## <a id='delivery-basic'></a> delivery-basic

### <a id='delivery-basic-purpose'></a> Purpose

- Fetches Kubernetes configuration created by a supply chain.
- Deploys the configuration on the cluster.

### <a id='delivery-basic-resources'></a> Resources

The following resources describe the templates.

#### <a id='source-provider'></a> source-provider

Refers to [delivery-source-template](ootb-template-reference.hbs.md#delivery-source).

Parameters provided:

- `serviceAccount` from tap-value `service_account`. Overridable by deliverable.
- `gitImplementation` from tap-value `git_implementation`. Not overridable by deliverable.

#### <a id='deployer'></a> Deployer

Refers to [app-deploy template](ootb-template-reference.hbs.md#app-deploy).

Parameter provided:

- `serviceAccount` from tap-value `service_account`. Overridable by deliverable.

### <a id='package'></a> Package

Refers to [Out of the Box Delivery Basic](ootb-delivery-basic.hbs.md).

### <a id='more-info'></a> More information

For information about setting `tap-values.yaml` at installation time, see [Install Out of the Box Delivery Basic](install-ootb-delivery-basic.hbs.md).
