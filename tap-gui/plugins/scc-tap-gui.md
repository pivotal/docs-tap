# Supply Chain Choreographer in Tanzu Application Platform GUI

## <a id="overview"></a> Overview

The Supply Chain Choreographer (SCC) plug-in enables you to visualize the execution of a workload through any of the installed Out-Of-The-Box supply chains. See [Supply Chain Choreographer for Tanzu](../../scc/about.md) for more information about the Out-Of-The-Box Supply Chains that are available in Tanzu Application Platform, and their installation guides.

## <a id="prerequisites"></a> Prerequisites

You must have installed: 
- Tanzu Application Platform GUI
- At least one of the OOTB supply chains
- Copied the secret (work with James R on wording) for the metadata store (if using a supply chain that includes scanning) following the instructions here <put link to instructions on how to copy the secret into the tap-values.yaml file. 

## <a id="sc-visibility"></a> Supply Chain Visibility

To visualize your workload through the SCC plug-in, you must first create a workload.

Use the left sidebar navigation to access your workload and visualize it in the supply chain that is installed on your cluster.

For this example, we will look at the `tanzu-java-web-app`.

![Screen Shot 2022-03-04 at 2 26 00 PM](https://user-images.githubusercontent.com/94395371/156849927-498524fc-4c92-4bee-8680-5de0c9f9cf84.png)

Click **tanzu-java-web-app** in the **WORKLOADS** table to navigate to the visualization of the supply chain:

![Screen Shot 2022-03-04 at 2 29 32 PM](https://user-images.githubusercontent.com/94395371/156849831-6ab69788-2269-4087-a9e7-b65853e898e7.png)

Here is a sample result of the Build stage for the `tanzu-java-web-app` by using Tanzu Build Service:

![Screen Shot 2022-03-04 at 2 27 42 PM](https://user-images.githubusercontent.com/94395371/156852521-d0e1582d-4341-472e-8d34-64b9fbaa62a8.png)

There are two sections within this view:

- the graph view at the top, which shows all the configured CRDs used by this supply chain and any artifacts that are outputs of the supply chain's execution
- the stage details view at the bottom, which shows source data for each part of the supply chain that you select in the graph view

## <a id="sc-errors"></a> Supply Chain Errors

When looking at the **WORKLOADS** table, if there was an error encountered during the execution of the workload in the supply chain, a red icon will appear. If the icon is green, the workload executed successfully. 

Here is an example of the **WORKLOADS** table showing errors: 
<img width="1514" alt="scc-workloadlist-errors" src="https://user-images.githubusercontent.com/94395371/160712144-c542c462-4d49-491f-b13e-08fe377516d5.png">

  
When looking at the graph view, after selecting your workload, the top right corner of the graph view will display **Errors** in Red (# of errors) and **Warnings** in Yellow (# of warnings) that have occurred during the workload's execution in the supply chain. 
  
Here is a sample result of the Source Scan stage for the `tanzu-java-web-app` by using Grype, with errors found:

Insert image of errors in the  
<insert image here for errors in execution>
  
Each stage of the supply chain will have the same indicator color to draw attention to the outcome of each stage. This enables effective troubleshooting to ensure your workload has a smooth path to production.  

