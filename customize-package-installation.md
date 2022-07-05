# Customizing Package Installation

It is possible to customize package configuration which is not exposed through data values by using annotations and ytt overlays.

## Customizing manually installed packages

To customize a manually installed package, follow the steps below. Further documentation and an example can be found [here](https://carvel.dev/kapp-controller/docs/v0.38.0/package-install-extensions/).

1. Create a `Secret` with your ytt overlay. Read more about [ytt overlays](https://carvel.dev/ytt/docs/v0.41.0/ytt-overlays/).
2. Update your `PackageInstall` to include the `ext.packaging.carvel.dev/ytt-paths-from-secret-name.x` annotation to reference your new overlay `Secret`.

## Customizing packages installed using a profile
To add an overlay to a package installed using a [TAP profile](install.md.hbs), follow the steps:

1. Create a `Secret` with your ytt overlay. Read more about [ytt overlays](https://carvel.dev/ytt/docs/v0.41.0/ytt-overlays/).
1. Update your values file to include a `package_overlays` field.
    ```yaml
    package_overlays:
    - name: <package-name>
        secrets:
        - name: <secret-name>
    ```