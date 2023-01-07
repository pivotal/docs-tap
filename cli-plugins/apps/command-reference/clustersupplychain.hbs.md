# Tanzu Apps Cluster Supply Chain

## Tanzu apps cluster supply chain list

The `tanzu apps clustersupplychain list` command lists the available supply chains installed in the
cluster (supported clustersupplychain alias is `csc`).

After listing the available supply chains, to view more detailed information about the selectors and
conditions that must be met for a workload to be selected by a
certain supply chain, run `tanzu apps clustersupplychain get <supplychain-name>` (check usage and
examples in the next section).

## Default view

The default view for this command contains the name of the supply chain, if it's ready or not and
its age.

For example:

```console
tanzu apps clustersupplychain list
NAME                 READY   AGE
basic-image-to-url   Ready   11d
source-to-url        Ready   11d

To view details: "tanzu apps cluster-supply-chain get <name>"

```

## Tanzu apps cluster supply chain get

The `tanzu apps clustersupplychain get` command gets detailed information of the cluster supply chain.

### Default view

The default view of `tanzu apps clustersupplychain get` command shows the status of the supply
chain, and the selectors that a workload must match so it is taken by that supply chain.

For example:

```console
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

The output from the earlier command reveals the attributes a workload must have to
be selected by the `source-to-url` supply chain on the target cluster:

- The workload must have the `--type` flag value of `web`, `server`, or `worker`
- Or, if expressed through `workload.yaml`, the `Workload.metadata.labels` label
  `apps.tanzu.vmware.com/workload-type` must exist and have a value of `web`, `server` ,or `worker`.

Another example is the `testing/scanning` pipeline, which has the `tekton` steps for testing and
the scanning steps.

```console
---
# source-test-scan-to-url: Ready
---
Supply Chain Selectors
   TYPE          KEY                                   OPERATOR   VALUE
   labels        apps.tanzu.vmware.com/has-tests                  true
   expressions   apps.tanzu.vmware.com/workload-type   In         web
   expressions   apps.tanzu.vmware.com/workload-type   In         server
   expressions   apps.tanzu.vmware.com/workload-type   In         worker
```

In this case, the workload must have both labels `apps.tanzu.vmware.com/has-tests: true` and
`apps.tanzu.vmware.com/workload-type` set up as `web`, `server`, or `worker` to be selected for
the supply chain.
