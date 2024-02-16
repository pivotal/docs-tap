# Supply Chain Security Tools - Scan 2.0 with Tanzu Supply Chain

This topic uses the same overview of Supply Chain Security Tools (SCST) - Scan 2.0 provided in the previous [section](../scan-2-0.hbs.md#overview) and covers how to create a Tanzu Supply Chain with SCST - Scan 2.0.

## <a id="supply-chain-usage"></a>Integrating into a Tanzu Supply Chain

The SCST - Scan 2.0 component defines how to scan a container image with a scan
solution using the generic Kubernetes custom resource `ImageVulnerabilityScan`.
This provides a generic interface that allows you to declare how the Tanzu
Application Platform executes a scan on a container image for a container
image scan solution.

To run an `ImageVulnerabilityScan` in a [Tanzu Supply Chain](../../supply-chain/about.hbs.md):
* [Author Supply Chains and Components](../../supply-chain/platform-engineering/how-to/about.hbs.md)
* [Create a Workload](../../supply-chain/development/how-to/about.hbs.md)

## <a id="getting-started"></a>Getting started with SCST - Scan 2.0 with Tanzu Supply Chain

To use SCST - Scan 2.0 in a Tanzu Supply Chain, see [Create Tanzu Supply Chain with SCST - Scan 2.0](./create-tanzu-supply-chain.hbs.md)
