# Install multicluster Tanzu Application Platform profiles


## <a id='prerequisites'></a> Prerequisites

1. Build, Run, and View clusters must satisfy and observe these [prerequisites](../prerequisites.md).
2. Install Tanzu CLI and Tanzu Cluster Essentials on all clusters. See [Installed Tanzu CLI](../install-tanzu-cli.md) for more information.

## <a id='install-view'></a> Install View Cluster

1. Install the [View profile](../overview.md#about-package-profiles) cluster first because some components must exist (App Live View backend) before the installation of the Run clusters.
2. Follow these [installation steps](../install.md) for the Full profile. Alternatively, you can also use a reduced [values file for the View profile](reference/tap-values-view-sample.md).
3. Verify that you can access Tanzu Application Platform GUI by using the ingress that you have setup. The address must follow this format: `http://tap-gui.INGRESS-DOMAIN`.

    Where `INGRESS-DOMAIN` is the DNS domain you've setup to point to the shared Contour installation in the `tanzu-system-ingress` namespace with the service `envoy`. 

## <a id='install-build'></a> Install Build Cluster(s)

1. Install the [Build profile](../overview.md#about-package-profiles) cluster by following [these installation steps](../install.md) for the Full profile. Alternatively, you can also use a reduced [values file for the Build profile](reference/tap-values-build-sample.md).

## <a id='install-run'></a> Install Run Cluster(s)

1. Install the [Run profile](../overview.md#about-package-profiles) cluster by following [these installation steps](../install.md) for the Full profile. Alternatively, you can also use a reduced [values file for the Run profile](./reference/tap-values-run-sample.md).
2. To use App Live View, set the `INGRESS-DOMAIN` for `appliveview_connector` that matches the value you setup on the View profile for the `appliveview` in the values file. 

## <a id='add-view'></a> Add Build and Run clusters to Tanzu Application Platform GUI

1. After installing the Build and Run clusters, you can create the `Service Accounts` that Tanzu Application Platform GUI uses to read objects from the clusters. 
2. Follow the steps in [Viewing resources on multiple clusters in Tanzu Application Platform GUI](../tap-gui/cluster-view-setup.md) to add a remote cluster. You must add both the Build and Run clusters to the View cluster for all the plugins to function as expected.

## Getting Started with Multicluster

1. After setting up the 3 profiles, you're ready to run a Workload by using the Supply Chain. See [Getting Started with Multicluster](getting-started.md) for next steps.
