# Install multicluster Tanzu Application Platform profiles


## <a id='prerequisites'></a> Prerequisites

1. The [same prerequisites](../prerequisites.md) must be satisfied for Build, Run, and View clusters and these must be observed.
2. Tanzu CLI and Tanzu Cluster Essentials must be [installed on all clusters](../install-tanzu-cli.md).

## <a id='install-view'></a> Install View Cluster

1. Install the [View profile](../overview.md#about-package-profiles) cluster first as you'll need some components to exist (App Live View backend) prior to the installation of the latter Run clusters.
2. Follow the [same installation steps](../install.md) as you would for the Full profile, but you can leverage a reduced [values file for the View profile](./reference/tap-values-view-sample.md).
3. Validate that you can access the Tanzu Application Platform GUI using the ingress that is setup. This address should be `http://tap-gui.INGRESS-DOMAIN` where `INGRESS-DOMAIN` is the DNS domain you've setup to point to the shared Contour installation in the `tanzu-system-ingress` namespace with the service `envoy`. 

## <a id='install-build'></a> Install Build Cluster(s)

1. Install the [Build profile](../overview.md#about-package-profiles) cluster following the [same installation steps](../install.md) as you would for the Full profile, but you can leverage a reduced [values file for the Build profile](./reference/tap-values-build-sample.md).

## <a id='install-run'></a> Install Run Cluster(s)

1. Install the [Run profile](../overview.md#about-package-profiles) cluster following the [same installation steps](../install.md) as you would for the Full profile, but you can leverage a reduced [values file for the Run profile](./reference/tap-values-run-sample.md).
2. If you want to leverage App Live View, you'll need to make sure that in the above values file you specify the `INGRESS-DOMAIN` for `appliveview_connector` that corresponds to the value you setup on the View profile for the `appliveview`.

## <a id='add-view'></a> Add Build and Run clusters to Tanzu Application Platform GUI

1. Now that you have the Build and Run clusters installed, you can create the appropriate `Service Accounts` that will be leveraged by the Tanzu Application Platform GUI to read objects from the clusters. 
2. Follow the steps in the [Tanzu Application Platform GUI documentation regarding adding a remote cluster](../tap-gui/cluster-view-setup.md). You'll need to add both the Build and Run clusters to the View cluster for all the plugins to function as expected.

## Getting Started with Multicluster

1. Now that you've completed the setup of the 3 profiles, you're ready to run a Workload through the Supply Chain. [Continue to the Getting Started with Multicluster](./getting-started.md) documentation.
