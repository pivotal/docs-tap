# Customizing Package Installation

You can customize package configuration which is not exposed through data values by using annotations and ytt overlays.

## <a id="package-install"></a>Customizing manually installed packages

To customize a manually installed package, follow these steps:

1. Create a `secret.yml` file with a `Secret` containing your ytt overlay. See [Carvel documentation](https://carvel.dev/ytt/docs/v0.43.0/ytt-overlays/) for more information about ytt overlays. For example:

    ```yaml
    apiVersion: v1
    kind: Secret
    metadata:
      name: tap-overlay
      namespace: tap-install
    stringData:
      custom-package-overlay.yml: |
        <custom-overlay>
    ```
    
1. Apply the `Secret` to your cluster:

    ```console
    kubectl apply -f secret.yml
    ```

1. Update your `PackageInstall` to include the `ext.packaging.carvel.dev/ytt-paths-from-secret-name.x` annotation to reference your new overlay `Secret`. For example:

    ```yaml
    apiVersion: packaging.carvel.dev/v1alpha1
    kind: PackageInstall
    metadata:
      name: <package-name>
      namespace: tap-install
      annotations:
        ext.packaging.carvel.dev/ytt-paths-from-secret-name: tap-overlay
    ...
    ```

    >**Note:** You can suffix the extension annotation with a `.x`, where `x` is a number, to apply multiple overlays. See [Carvel documentation](https://carvel.dev/kapp-controller/docs/v0.40.0/package-install-extensions/) for more information.

## <a id="profile-install"></a>Customizing packages installed by using a profile

Follow these steps to add an overlay to a package installed by using a [Tanzu Application Platform profile](install.html):

1. Create a `Secret` with your ytt overlay. See [Carvel documentation](https://carvel.dev/ytt/docs/v0.41.0/ytt-overlays/) for more information about ytt overlays.

1. Update your values file to include a `package_overlays` field:

    ```yaml
    package_overlays:
    - name: <package-name>
      secrets:
      - name: <secret-name>
    ```

1. Update Tanzu Application Platform by running:

    ```console
    tanzu package installed update tap -p tap.tanzu.vmware.com -v $TAP_VERSION  --values-file tap-values.yaml -n tap-install
    ```
