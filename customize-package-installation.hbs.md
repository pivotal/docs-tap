# Customizing Package Installation

You can customize package configuration which is not exposed through data values by using annotations and ytt overlays.

## <a id="package-install"></a>Customizing manually installed packages

To customize a manually installed package, follow these steps:

1. Create a `Secret` with your ytt overlay. See [Carvel documentation](https://carvel.dev/ytt/docs/v0.41.0/ytt-overlays/) for more information about ytt overlays.
2. Update your `PackageInstall` to include the `ext.packaging.carvel.dev/ytt-paths-from-secret-name.x` annotation to reference your new overlay `Secret`.

See [Carvel documentation](https://carvel.dev/kapp-controller/docs/v0.38.0/package-install-extensions/) for more information.

## <a id="profile-install"></a>Customizing packages installed by using a profile

To add an overlay to a package installed by using a [Tanzu Application Platform profile](install..md), follow these steps:

1. Create a `Secret` with your ytt overlay. See [Carvel documentation](https://carvel.dev/ytt/docs/v0.41.0/ytt-overlays/) for more information about ytt overlays.
1. Update your values file to include a `package_overlays` field.

    ```yaml
    package_overlays:
    - name: <package-name>
      secrets:
      - name: <secret-name>
    ```
