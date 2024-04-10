# Overview of Bitnami Services

Bitnami Services provides a set of backing services for Tanzu Application Platform
(commonly known as TAP).
The services are MySQL, PostgreSQL, RabbitMQ, Redis, MongoDB, and Kafka all of which are backed by the
corresponding Bitnami Helm Chart.

Through integration with [Crossplane](../crossplane/about.hbs.md) and
[Services Toolkit](../services-toolkit/about.hbs.md), these six services are immediately ready
for apps teams to consume, with no additional setup or configuration required from ops teams.
This makes it incredibly quick and easy to get started working with services on Tanzu Application Platform.

> **Note** The Bitnami Services package provides unmanaged services that are not designed to support
> long lived instances. Therefore, there is no supported path to upgrade individual instances.
> Bitnami Services are instantiated using the configuration and version of the package at creation
> time and so upgrading the Bitnami Services package has no effect on existing instances.
> VMware discourages changing the `compositionUpdatePolicy` and `compositionRevisionRef` on the
> individual composite resources (XRs) because this might cause unintended side effects.

## <a id="getting-started"></a> Getting started

If this is your first time working with Bitnami Services on Tanzu Application Platform,
you can start with the tutorial
[Working with Bitnami Services](tutorials/working-with-bitnami-services.hbs.md).
Otherwise, see the [how-to guides](how-to-guides/index.hbs.md) and [reference material](reference/index.hbs.md).
