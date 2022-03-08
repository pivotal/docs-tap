# Supply Chain Choreographer in Tanzu Application Platform GUI

## <a id="overview"></a> Overview

The Supply Chain Choreographer (SCC) plugin enables you to visualize the execution of a workload through any of the installed Out-Of-The-Box supply chains. See [Supply Chain Choreographer for Tanzu](../../scc/about.md) for more information about the Out-Of-The-Box Supply Chains that are available in Tanzu Application Platform, and their installation guides.

## <a id="prerequisites"></a> Prerequisites

You must have either of the Full or View profiles installed, which includes the Tanzu Application Platform GUI.

## <a id="sc-visibility"></a> Supply Chain Visibility

To visualize your workload through the SCC plugin, you must first create a workload.

Use the left sidebar navigation to access your workload and visualize it in the supply chain that is installed on your cluster.

For this example, we will look at the `tanzu-java-web-app`.

![Screen Shot 2022-03-04 at 2 26 00 PM](https://user-images.githubusercontent.com/94395371/156849927-498524fc-4c92-4bee-8680-5de0c9f9cf84.png)

Click **tanzu-java-web-app** in the **WORKLOADS** table to navigate to the visualization of the supply chain:

![Screen Shot 2022-03-04 at 2 29 32 PM](https://user-images.githubusercontent.com/94395371/156849831-6ab69788-2269-4087-a9e7-b65853e898e7.png)

This is how the Out-Of-The-Box Supply Chain with Test and Scan is represented in the SCC plugin through Tanzu Application Platform GUI. See [Out of the Box Supply Chain with Testing and Scanning](../../scc/ootb-supply-chain-testing-scanning.md) for more information about the Supply Chain.

There are two sections within this view:

- the graph view at the top, which shows all the configured CRDs used by this supply chain and any artifacts that are outputs of the supply chain's execution
- the stage details view at the bottom, which shows source data for each part of the supply chain that you select in the graph view

Here is a sample result of the Source Scan stage for the `tanzu-java-web-app` by using Grype:

![Screen Shot 2022-03-04 at 2 27 13 PM](https://user-images.githubusercontent.com/94395371/156852212-61ee065d-20a3-43df-8191-f0ca9fedb18e.png)

Here is a sample result of the Build stage for the `tanzu-java-web-app` by using Tanzu Build Service:

![Screen Shot 2022-03-04 at 2 27 42 PM](https://user-images.githubusercontent.com/94395371/156852521-d0e1582d-4341-472e-8d34-64b9fbaa62a8.png)
