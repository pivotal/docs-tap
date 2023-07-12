# Tanzu Apps Cluster Supply Chain

This topic tells you about the `cluster-supply-chain` command.

## tanzu apps clustersupplychain list

The `cluster-supply-chain` command provides details about the cluster supply chain installed in the
target cluster.

The following aliases are supported:

- `csc`
- `cluster-supply-chains`
- `clustersupplychains`

Run the following command to view more detailed information about the selectors and conditions that
must be met for a workload to be selected by a certain supply chain:

```console
tanzu apps cluster-supply-chain get SUPPLYCHAIN-NAME
```

## Default view

The default view displays the name of the supply chain, whether it is ready or not,
and its age.

For example:

```console
tanzu apps clustersupplychain list
NAME                 READY   AGE
basic-image-to-url   Ready   11d
source-to-url        Ready   11d

To view details: "tanzu apps cluster-supply-chain get <name>"

```

## tanzu apps cluster-supply-chain get

The `tanzu apps cluster-supply-chain get` command gets detailed information of the cluster supply chain.

### Default view

The default view displays the status of the supply
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

This output indicates the attributes a workload needs to be selected by the `source-to-url` supply
chain on the target cluster. For example:

- The workload must have the `--type` flag value of `web`, `server`, or `worker`.
- Or, if expressed through `workload.yaml`, the `Workload.metadata.labels` label
  `apps.tanzu.vmware.com/workload-type` must exist and have a value of `web`, `server` , or `worker`.

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
