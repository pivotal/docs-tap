# Getting Started with Multicluster Tanzu Application Platform 

The purpose of the below procedures is to validate the successful implementation of a multicluster topology by taking a small sample Workload and passing it through the Supply Chains that exist on the Build and Run clusters. There are numerous ways that the supply chain can be configured in this topology, but we're going to focus on validating the most basic capbilities. At the end of this documenation you should have a application that was build on the Build profile clusters and delivered to run on the Run profile clusters. This Workload and associated objects should be viewable from the Tanzu Application Platform GUI interface on the View profile cluster.

## <a id='prerequisites'></a> Prerequisites

1. In order to continue, you'll need to make sure you've completed the [installation steps for the 3 profiles](./installing-multicluster.md): Build, Run, and View. 
2. For the sample Workload we'll be using the same Application Accelerator - Tanzu Java Web App that is used in the non-multicluster [Getting Started](../getting-started.md) guide. You can download this accelerator and put it on your own Git infrastructure of choice (additional configuration may be necessary regarding permissions) or you can leverage the [sample-accelerators GitHub repository](https://github.com/sample-accelerators/tanzu-java-web-app).
3. The two Supply Chains that will be used here are on the Build profile: `ootb-supply-chain-basic` and on the Run profile: `ootb-delivery-basic`
4. For both the Build and Run profiled clusters, perform the [Setup Developer Namespace](../install-components.md#setup) steps. For the purposes of this guide, we'll assume that the `default` namespace was used.

## <a id='build-cluster'></a> Start the Workload on the Build Profile Cluster

1. The Build cluster will start things off by taking the Workload and building the necessary bundle that will then be delivered to the Run cluster to start.
2. Use the Tanzu CLI to start the Workload down the first Supply Chain:

```bash
tanzu apps workload create tanzu-java-web-app \
--git-repo https://github.com/sample-accelerators/tanzu-java-web-app \
--git-branch main \
--type web \
--label app.kubernetes.io/part-of=tanzu-java-web-app \
--yes \
--namespace YOUR-DEVELOPER-NAMESPACE
```

Where:

- `YOUR-DEVELOPER-NAMESPACE` is the namespace you [setup prior](../install-components.md#setup). For the purposes of this tutorial, `default` will be used.

3. You can now monitor the progress of this process using the command below. To exit the monitoring session you can use `CTRL+C`


