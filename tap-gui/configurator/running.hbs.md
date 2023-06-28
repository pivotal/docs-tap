# Running your Customized Tanzu Developer Portal

At this stage, you should have completed the building of your customized Tanzu Developer Portal
image in the [previous](building.hbs.md) section.

After the build has completed successfully you need to retrieve the image reference of the built
portal. You then use that and perform a [`ytt`](https://carvel.dev/ytt/) overlay to substitute that
image name for the one running the pre-built Tanzu Developer Portal on your cluster.

## <a id=identify></a>Identifying the Customized Image Reference

You'll need to identify the image that was built by the supply chain. You'll be using this image reference in your [`ytt`](https://carvel.dev/ytt/) overlay in the next step. There are multiple ways to retrieve this image name. Here we show how to retrieve that with either the CLI or the Developer Portal UI.

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

## Preparing to overlay your customized image onto the currently running instance

### Create the [`ytt`](https://carvel.dev/ytt/) overlay secret

Create a file called `tdp-overlay-secret.yaml` with the following contents:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: tdp-app-image-overlay-secret
  namespace: tap-install
stringData:
  tdp-app-image-overlay.yaml: |
    #@ load("@ytt:overlay", "overlay")

    #! makes an assumption that tap-gui is deployed in the namespace: "tap-gui"
    #@overlay/match by=overlay.subset({"kind": "Deployment", "metadata": {"name": "server", "namespace": "tap-gui"}}), expects="1+"
    ---
    spec:
      template:
        spec:
          containers:
            #@overlay/match by=overlay.subset({"name": "backstage"}),expects="1+"
            #@overlay/match-child-defaults missing_ok=True
            - image: IMAGE-REFERENCE 
```
Where:

- `IMAGE-REFERENCE` is the customized image you retrived during the [previous steps](#identify)

### Apply the overal secret to your `tap-values.yaml`

Here you'll need to modify the `tap-values.yaml` file you used to install Tanzu Application Platform. Add the following to the root of the tap-values file:

```yaml
#Top of the tap-values.yaml file
package_overlays:
  - name: tap-gui
    secrets:
      - name: tdp-app-image-overlay-secret
#Your remaining tap-values.yaml file is below
```

Depending on your installation method (GitOps or Online/Offline install) you'll need to then update your installation to use this modified values file. For example, the steps for doing this in an online installation are [here](../../install-online/profile.hbs.md#install-your-tanzu-application-platform-package).
