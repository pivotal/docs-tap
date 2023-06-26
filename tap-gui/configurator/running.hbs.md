# Running your Customized Tanzu Developer Portal

At this stage, you should have completed the building of your customized Tanzu Developer Portal
image in the [previous](building.hbs.md) section.

After the build has completed successfully you need to retrieve the image reference of the built
portal. You then use that and perform a [`ytt`](https://carvel.dev/ytt/) overlay to substitute that
image name for the one running the pre-built Tanzu Developer Portal on your cluster.

## Identifying the Customized Image Reference

### Option 1: Through the Kubernetes CLI

```bash
kubectl -n DEVELOPER-NAMESPACE get images.kpack.io WORKLOAD-NAME -o jsonpath={.status.latestImage}
```

Where:

- `DEVELOPER-NAMESPACE` is the configured developer namespace on the cluster where you ran the workload.
- `WORKLOAD-NAME` is the name of the workload you used.

For example:

```bash
> kubectl -n default get images.kpack.io tpb-workload -o jsonpath={.status.latestImage}
> kapplegate.azurecr.io/demo/workloads/tpb-workload-default@sha256:bae710386f7d81a725ce5ab15d76a3dd4f6ea79804ae0a475cf98f5e3dd6cf82
```

### Option 2: Through the Tanzu Developer Portal GUI

1. Find your workload in the Supply Chain view.
   ![Supply Chain Plugin](./images/supply-chain-plugin.png)
2. Fine the Artifact Detail for the Image Provider step. You'll see the Image value located there.
   ![Supply Chain Plugin Artufact Detail](./images/supply-chain-artifact.png)