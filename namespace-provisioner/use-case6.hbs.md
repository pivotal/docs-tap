# Apply scanner ScanTemplate overlays in air-gapped environments

This topic tells you how to customize the ScanTemplates create by the `grype-scanner` PackageInstall in Namespace Provisioner. Use annotations to apply an overlay to the ScanTemplates.

Namespace Provisioner includes a pre-configured `grype-scanner` PackageInstall for each developer
namespace. For more information about default resources, see
[Default resources](default-resources.hbs.md).

If you require customization of the ScanTemplate created by the PackageInstall, you must apply
overlays to the ScanTemplate through package customization as Namespace Provisioner does not
directly create the ScanTemplate. For more information on how to customize a package installation, see [Customize a package](../customize-package-installation.hbs.md).

For information about potential customizations of the `grype-scanner` and troubleshooting
tips, see [Use Grype in offline and air-gapped environments](../install-offline/grype-offline-airgap.hbs.md).

1. To enable updates to the ScanTemplates, create an overlay specifically designed for this
purpose. When the package is processed, the overlay is applied to the ScanTemplate. It is done
by the reference to this overlay in the annotation `ext.packaging.carvel.dev/ytt-paths-from-secret-name`:

    ```yaml
    cat << EOF | kubectl apply -f -
    apiVersion: v1
    kind: Secret
    metadata:
      name: grype-airgap-override-stale-db-overlay
      namespace: tap-install #! namespace where tap is installed
    stringData:
      patch.yaml: |
        #@ load("@ytt:overlay", "overlay")

        #@overlay/match by=overlay.subset({"kind":"ScanTemplate"}),expects="1+"
        ---
        spec:
          template:
            initContainers:                                             
              #@overlay/match by=overlay.subset({"name": "scan-plugin"}), expects="1+"
              - name: scan-plugin
                #@overlay/match missing_ok=True
                env:
                  #@overlay/append
                  - name: GRYPE_DB_MAX_ALLOWED_BUILT_AGE #! see note on best practices
                    value: "240h"
    EOF
    ```

2. To enhance the functionality of the `grype-scanner` PackageInstall created by the Namespace Provisioner, create an overlay that adds the `ext.packaging.carvel.dev/ytt-paths-from-secret-name` annotation. This annotation enables the PackageInstall to retrieve information from the created secret with the overlay and apply it to the ScanTemplate.

    ```yaml
    cat << EOF | kubectl apply -f -
    apiVersion: v1
    kind: Secret
    metadata:
      name: grype-airgap-override-stale-db-overlay-for-nsp
      namespace: tap-install # or any other namespaces from where nsp will import the secret
    stringData:
      patch-grype-install-in-nsp.yaml: |
        #@ load("@ytt:overlay", "overlay")
        #@ def matchGrypeScanners(index, left, right):
          #@ if left["apiVersion"] != "packaging.carvel.dev/v1alpha1" or left["kind"] != "PackageInstall":
            #@ return False
          #@ end      #@ return left["metadata"]["name"].startswith("grype-scanner")
        #@ end
        #@overlay/match by=matchGrypeScanners, expects="0+"
        ---
        metadata:
          annotations:
            #@overlay/match missing_ok=True
            ext.packaging.carvel.dev/ytt-paths-from-secret-name.0: grype-airgap-override-stale-db-overlay
            #! The value of the above annotation is the name of the secret that contains the grype overlay
    EOF
    ```

3. Update the `tap-values.yaml` file as follows so the overlay is applied to the PackageInstall. For
more information, see [Import overlay secrets](customize-installation.hbs.md#import-overlay-secrets).

    ```yaml
    namespace_provisioner:
      overlay_secrets:
      - create_export: true
        name: grype-airgap-override-stale-db-overlay-for-nsp
        namespace: tap-install # or any other namespaces from where nsp will import the secret
    ```
