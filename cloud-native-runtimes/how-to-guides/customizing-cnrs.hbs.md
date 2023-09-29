# Customizing Cloud Native Runtimes

This topic tells you how to customize your Cloud Native Runtimes installation.

## <a id='overview'></a> Overview

There are many package configuration options exposed through data values that allows you to customize your Cloud Native Runtimes installation.

To yield all the configuration options available in a Cloud Native Runtimes package version:

```sh
export CNR_VERSION=2.4.0
tanzu package available get cnrs.tanzu.vmware.com/${CNR_VERSION} --values-schema -n tap-install
```

## <a id='customize'></a> Customizing Cloud Native Runtimes

Besides using the out-of-the-box options to configure your package, you can use ytt overlays to further customize your installation.
For information about how to customize any Tanzu Application Platform package, see [Customize your package installation](../../customize-package-installation.hbs.md).

The following example shows how to update the Knative ConfigMap `config-logging` to override the logging level
of the Knative Serving controller to `debug`:

1. Create a Kubernetes secret containing the ytt overlay by applying the following configuration to your cluster.

    ```console
    kubectl apply -n tap-install -f - << EOF
    apiVersion: v1
    kind: Secret
    metadata:
     name: cnrs-patch
    stringData:
     patch.yaml: |
       #@ load("@ytt:overlay", "overlay")
       #@overlay/match by=overlay.subset({"kind":"ConfigMap","metadata":{"name":"config-logging","namespace":"knative-serving"}})
       ---
       data:
         #@overlay/match missing_ok=True
         loglevel.controller: "debug"
    EOF
    ```

    To learn more about the Carvel tool `ytt` and how to write overlays, see the [ytt documentation](https://carvel.dev/ytt/).

2. Update your `tap-values.yaml` file to add the YAML below. This YAML informs the Tanzu Application Platform about the secret name where the overlay is stored and applies the overlay to the `cnrs` package.

    ```yaml
    package_overlays:
    - name: cnrs
      secrets:
      - name: cnrs-patch
    ```

   You can retrieve your `tap-values.yaml` file by running:

   ```console
   kubectl get secret tap-tap-install-values -n tap-install -ojsonpath="{.data.tap-values\.yaml}" | base64 -d
   ```

3. Update the Tanzu Application Platform installation.

    ```console
    tanzu package installed update tap -p tap.tanzu.vmware.com -v ${TAP_VERSION} --values-file tap-values.yaml -n tap-install
    ```

4. Confirm your changes were applied to the corresponding ConfigMap.

    To confirm that your changes were applied to the ConfigMap `config-logging`
    by ensuring `loglevel.controller` is set to `debug`.

    ```console
    kubectl get configmap config-logging -n knative-serving -oyaml
    ```
