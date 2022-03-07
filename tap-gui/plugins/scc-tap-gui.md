# Supply Chain Choreographer in Tanzu Application Platform GUI
**Overview:**

The Supply Chain Choreographer (SCC) plugin enables you to visualize the execution of a workload through any of the installed Out-Of-The-Box supply chains. More information on the Out-Of-The-Box Supply Chains that are available in Tanzu Application Platform, and their installation guides, can be found here:https://docs.vmware.com/en/Tanzu-Application-Platform/1.1/tap/GUID-scc-about.html.

**Prerequisites:**

You must have either of the Full or View profiles installed, which will include the Tanzu Application Platform GUI.

**Supply Chain Visibility:**

To visualize your workload throught the SCC plugin, you must first create a workload. Guides on how to complete this step can be found here: 

When you create a workload in this manner, you can use the left hand sidebar navigation to access your workload and visualize it in the supply chain that is installed on your cluster.

For this example, we will look at the tanzu-java-web-app

![Screen Shot 2022-03-04 at 2 26 00 PM](https://user-images.githubusercontent.com/94395371/156849927-498524fc-4c92-4bee-8680-5de0c9f9cf84.png)


After clicking on tanzu-java-web-app in the Workload table, you will be taken to the visualization of the supply chain:

![Screen Shot 2022-03-04 at 2 29 32 PM](https://user-images.githubusercontent.com/94395371/156849831-6ab69788-2269-4087-a9e7-b65853e898e7.png)

This is how the Out-Of-The-Box Supply Chain with Test and Scan will be represented in the SCC plugin through Tanzu Application Platform GUI. More information on this Supply Chain can be found here: https://docs.vmware.com/en/Tanzu-Application-Platform/1.1/tap/GUID-scc-ootb-supply-chain-testing-scanning.html

There are two sections within this view:
- the Graph view at the top, which will show all the configured CRDs used by this supply chain as well as any artifacts that were outputs of the supply chain's execution
- the Stage Details view at the bottom, which will populate with source data for each part of the supply chain that you click on in the Graph View above

Here is an example of the results of the Source Scan stage, using Grype, for this workload:

![Screen Shot 2022-03-04 at 2 27 13 PM](https://user-images.githubusercontent.com/94395371/156852212-61ee065d-20a3-43df-8191-f0ca9fedb18e.png)

Here is an example of the results of the Build stage, using Tanzu Build Service, for this workload:

![Screen Shot 2022-03-04 at 2 27 42 PM](https://user-images.githubusercontent.com/94395371/156852521-d0e1582d-4341-472e-8d34-64b9fbaa62a8.png)

