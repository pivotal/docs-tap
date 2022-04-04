# Supply Chain Choreographer in Tanzu Application Platform GUI

## <a id="overview"></a> Overview

The Supply Chain Choreographer (SCC) plug-in enables you to visualize the execution of a workload through any of the installed Out-Of-The-Box supply chains. See [Supply Chain Choreographer for Tanzu](../../scc/about.md) for more information about the Out-Of-The-Box Supply Chains that are available in Tanzu Application Platform, and their installation guides.

## <a id="prerequisites"></a> Prerequisites

You must have either of the Full or View profiles installed on your cluster, which includes Tanzu Application Platform GUI, or having installed Tanzu Application Platform GUI package.

## <a id="sc-visibility"></a> Supply Chain Visibility

To visualize your workload through the SCC plug-in, you must first create a workload.

Use the left sidebar navigation to access your workload and visualize it in the supply chain that is installed on your cluster.

For this example, we will look at the `tanzu-java-web-app`.

![Screen Shot of Workloads](images/workloads.png)

Click **tanzu-java-web-app** in the **WORKLOADS** table to navigate to the visualization of the supply chain.

![Screen Shot of Supply Chain Visualization](images/visual-sc.png)

There are two sections within this view:

- the graph view at the top, which shows all the configured CRDs used by this supply chain and any artifacts that are outputs of the supply chain's execution
- the stage details view at the bottom, which shows source data for each part of the supply chain that you select in the graph view

Here is a sample result of the Build stage for the `tanzu-java-web-app` by using Tanzu Build Service:

![Screen Shot of Build Stage](images/build-stage-sample.png)
