# Supply Chain Choreographer in Tanzu Application Platform GUI

This topic describes Supply Chain Choreographer in Tanzu Application Platform GUI.


## <a id="overview"></a> Overview

The Supply Chain Choreographer (SCC) plug-in enables you to visualize the execution of a workload
through any of the installed Out-Of-The-Box supply chains.
For more information about the Out-Of-The-Box Supply Chains that are available in
Tanzu Application Platform, and their installation guides, see [Supply Chain Choreographer for Tanzu](../../scc/about.md).


## <a id="prerequisites"></a> Prerequisites

You must have the Full profile or View profile installed on your cluster, which includes
Tanzu Application Platform GUI, or have installed the Tanzu Application Platform GUI package, to visualize the supply chain.

You must have the Run or Full profile installed on the target cluster where you want to deploy your workload to so that you can see your workload being deployed to that cluster. For more information, see [Overview of multicluster Tanzu Application Platform]https://docs-staging.vmware.com/en/draft/VMware-Tanzu-Application-Platform/1.2/tap/GUID-multicluster-about.html

**If you are using the test-scan OOTB supply chain to visualize CVE results, you must 
- First follow the steps outlined here to configure the access token to the Store: https://docs-staging.vmware.com/en/draft/VMware-Tanzu-Application-Platform/1.2/tap/GUID-scst-store-create-service-account-access-token.html
- then config:

  /tap_gui:
  
  app_config:
  
  proxy:
  
  /metadata-store:
  
        target: https://metadata-store-app.metadata-store:8443/api/v1
        
        changeOrigin: true
        
        secure: false
        
        headers:
        
        Authorization: "Bearer <Access Token>"
        
        X-Custom-Source: project-star 
        


## <a id="sc-visibility"></a> Supply Chain Visibility

To visualize your workload through the SCC plug-in, you must first create a workload.

The workload must have the `app.kubernetes.io/part-of` label specified, whether you manually create
the workload or use those supplied with the OOTB supply chains.

Use the left sidebar navigation to access your workload and visualize it in the supply chain that is
installed on your cluster.

For this example, we are looking at the `tanzu-java-web-app`.

![Screen Shot of Workloads](images/workloads.png)

Click **tanzu-java-web-app** in the **WORKLOADS** table to navigate to the visualization of the
supply chain.

![Screen Shot of Supply Chain Visualization](images/visual-sc.png)

There are two sections within this view:

- the graph view at the top, which shows all the configured CRDs used by this supply chain and any artifacts that are outputs of the supply chain's execution
- the stage details view at the bottom, which shows source data for each part of the supply chain that you select in the graph view

Here is a sample result of the Build stage for the `tanzu-java-web-app` by using Tanzu Build Service:

![Screen Shot of Build Stage](images/build-stage-sample.png)

Here is a sample result of the Image Scan stage, using Grype - only available in the **test-scan** OOTB supply chain

![Supply Chain CVEs](https://user-images.githubusercontent.com/94395371/172258186-4d2c741c-1dc4-43a2-a5b3-681df0725d0a.png)


When a workload is deployed to a cluster that has the `deliverable` package installed, you will observe a new section in the supply chain that will show the **Pull Config** as well as the **Delivery**. A box will surround this section, showing the name of the cluster at the top, indicating which clusters the config has been deployed to.

<img width="751" alt="Pull Config" src="https://user-images.githubusercontent.com/94395371/172258376-697f539b-faa0-4c55-af0e-3b4bdce6c4b3.png">

