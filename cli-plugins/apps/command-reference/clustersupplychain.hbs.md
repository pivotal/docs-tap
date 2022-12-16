# Tanzu Apps Cluster Supply Chain

## tanzu apps cluster supply chain list

`tanzu apps clustersupplychain get` command lists the available supply chains installed in the cluster.

After listing the available supply chains, in order to view more detailed information about the selectors and conditions that must be met for a workload to be selected by certain supply chain, run `tanzu apps clustersupplychain get <supplychain-name>` (check usage and examples in the next section).

## Default view

The default view for this command contains the name of the supply chain, if it's ready or not and its age.

For example:

```bash
tanzu apps clustersupplychain list
NAME                 READY   AGE
basic-image-to-url   Ready   11d
source-to-url        Ready   11d

To view details: "tanzu apps cluster-supply-chain get <name>"

```

## tanzu apps cluster supply chain get

`tanzu apps clustersupplychain get` command is used to get a detailed information of the cluster supply chain.

### Default view

The default view of `tanzu apps clustersupplychain get` command shows the status of the supply chain, and the selectors that a workload must match so it's taken by that supply chain.

For example:

```bash
tanzu apps cluster-supply-chain get source-to-url
---
# source-to-url: Ready
---
Supply Chain Selectors
   TYPE          KEY                                   OPERATOR   VALUE
   expressions   apps.tanzu.vmware.com/workload-type   In         web
   expressions   apps.tanzu.vmware.com/workload-type   In         server
   expressions   apps.tanzu.vmware.com/workload-type   In         worker
```