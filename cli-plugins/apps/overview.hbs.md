# Apps CLI plug-in overview

This Tanzu CLI plug-in provides the ability to create, view, update, and delete application workloads on any Kubernetes cluster that has the Tanzu Application Platform components installed.

## <a id='about'></a>About workloads

Tanzu Application Platform enables developers to quickly build and test applications regardless of their familiarity with Kubernetes.
Developers can turn source code into a workload that runs in a container with a URL.

A workload enables developers to choose application specifications, such as repository location, environment variables, service binding, and more.

Tanzu Application Platform can support a range of workloads, including a serverless process that starts on demand, a constellation of microservices that functions as a logical application, or a small hello-world test app.

## <a id='envvars'> Environment variables with default values

There are some environment variables that can be specified to have default values so users can execute their commands with the minimum required flags. These flags and naming convention are as follows:

`--type`: `TANZU_APPS_TYPE`
`--registry-ca-cert`: `TANZU_APPS_REGISTRY_CA_CERT`
`--registry-password`: `TANZU_APPS_REGISTRY_PASSWORD`
`--registry-username`: `TANZU_APPS_REGISTRY_USERNAME`
`--registry-token`: `TANZU_APPS_REGISTRY_TOKEN`

## <a id='tutorials'></a>Tutorials

To get started with apps plugin and workload management, see [Tutorials](tutorials.hbs.md)

## <a id='how-to-guides'></a>How-to-guides

For more complex examples regarding apps cli plugin usage, check [How-to-guides](how-to-guides.hbs.md)

## <a id='reference'></a>Reference

While the [How-to-guides](how-to-guides.hbs.md) section provides examples regarding complex scenarios where the Tanzu CLI Apps plug-in is useful, the [reference section](./command-reference/commands-details.hbs.md) explains each flag in detail and gives examples for their usage.

<!-- describe each component and how they work together -->