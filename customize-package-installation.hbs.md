# Customize package installation

You can customize a package configuration that is not exposed through data values by using
annotations and ytt overlays.

You can customize a package that was [installed manually](#manual-package) or that was
[installed by using a Tanzu Application Platform profile](#profile-package).

## <a id="manual-package"></a>Customize a package that was manually installed

To customize a package that was installed manually:

1. Create a `secret.yml` file with a `Secret` that contains your ytt overlay. For example:

   ```yaml
   apiVersion: v1
   kind: Secret
   metadata:
   name: tap-overlay
   namespace: tap-install
   stringData:
   custom-package-overlay.yml: |
     CUSTOM-OVERLAY
   ```

   For more information about ytt overlays, see the
   [Carvel documentation](https://carvel.dev/ytt/docs/v0.43.0/ytt-overlays/).

2. Apply the `Secret` to your cluster by running:

   ```console
   kubectl apply -f secret.yml
   ```

3. Update your `PackageInstall` to include the
   `ext.packaging.carvel.dev/ytt-paths-from-secret-name.x` annotation to reference your new
   overlay `Secret`. For example:

   ```yaml
   apiVersion: packaging.carvel.dev/v1alpha1
   kind: PackageInstall
   metadata:
   name: PACKAGE-NAME
   namespace: tap-install
   annotations:
     ext.packaging.carvel.dev/ytt-paths-from-secret-name: tap-overlay
   ...
   ```

   > **Note** You can suffix the extension annotation with `.x`, where `x` is a number, to
   > apply multiple overlays.
   > For more information, see the
   > [Carvel documentation](https://carvel.dev/kapp-controller/docs/v0.40.0/package-install-extensions/).

## <a id="profile-package"></a>Customize a package that was installed by using a profile

To add an overlay to a package that was installed by using a Tanzu Application Platform profile:

1. Create a `Secret` with your ytt overlay. For more information about ytt overlays, see the
   [Carvel documentation](https://carvel.dev/ytt/docs/v0.43.0/ytt-overlays/).

2. Update your values file to include a `package_overlays` field:

    ```yaml
    package_overlays:
    - name: PACKAGE-NAME
      secrets:
      - name: SECRET-NAME
    ```

    Where `PACKAGE-NAME` is the target package for the overlay. For example, `tap-gui`.

3. Update Tanzu Application Platform by running:

    ```console
    tanzu package installed update tap -p tap.tanzu.vmware.com -v {{ vars.tap_version }}  --values-file tap-values.yaml -n tap-install
    ```

For information about Tanzu Application Platform profiles, see
[Installing Tanzu Application Platform package and profiles](install-online/profile.hbs.md).
