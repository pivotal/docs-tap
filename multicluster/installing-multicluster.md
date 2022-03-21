# Install multicluster Tanzu Application Platform profiles

## <a id='prerequisites'></a> Prerequisites

Before installing multicluster Tanzu Application Platform profiles, you must meet the following prerequisites:

- Build, Run, and View clusters must satisfy all the requirements to install Tanzu Application Platform. See [Prerequisites](../prerequisites.md).
- Install Tanzu CLI and Tanzu Cluster Essentials on all clusters. For more information, see [Installing the Tanzu CLI](../install-tanzu-cli.md).

## <a id='install-view'></a> Install View cluster

Install the View profile cluster first, because some components must exist before installing the Run clusters. For example, the Application Live View back end must be present before installing the Run clusters. For more information about profiles, see [About Tanzu Application Platform package profiles](../overview.md#about-package-profiles).

To install the View cluster:

1. Follow the steps for installing the Full profile in [Installing the Tanzu Application Platform package and profiles](../install.md). Alternatively, you can use a reduced values file for the View profile, as shown in [View profile](reference/tap-values-view-sample.md).
1. Verify that you can access Tanzu Application Platform GUI by using the ingress that you have set up. The address must follow this format: `http://tap-gui.INGRESS-DOMAIN`, where `INGRESS-DOMAIN` is the DNS domain you've set to point to the shared Contour installation in the `tanzu-system-ingress` namespace with the service `envoy`. 

## <a id='install-build'></a> Install Build clusters

To install the Build profile cluster:

-  Follow the steps for installing the Full profile in [Installing the Tanzu Application Platform package and profiles](../install.md). Alternatively, you can use a reduced values file for the Build profile, as shown in [Build profile](reference/tap-values-build-sample.md).

## <a id='install-run'></a> Install Run clusters

To install the Run profile cluster:

1. Follow the steps for installing the Full profile in [Installing the Tanzu Application Platform package and profiles](../install.md). Alternatively, you can use a reduced values file for the Run profile, as shown in [Run profile](./reference/tap-values-run-sample.md).
1. To use Application Live View, set the `INGRESS-DOMAIN` for `appliveview_connector` to match the value you set on the View profile for the `appliveview` in the values file. 

## <a id='add-view'></a> Add Build and Run clusters to Tanzu Application Platform GUI

1. After installing the Build and Run clusters, create the `Service Accounts` that Tanzu Application Platform GUI uses to read objects from the clusters. 
1. Follow the steps in [Viewing resources on multiple clusters in Tanzu Application Platform GUI](../tap-gui/cluster-view-setup.md) to add a remote cluster. You must add both the Build and Run clusters to the View cluster for all plug-ins to function as expected.

## Next steps

After setting up the 3 profiles, you're ready to run a workload by using the supply chain. See [Getting started with multicluster Tanzu Application Platform](getting-started.md).
