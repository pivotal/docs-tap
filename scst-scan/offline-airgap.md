# Offline and Air Gapped Environments

The `grype` cli will attempt to perform two over the internet calls: one to check for newer versions of the cli and another to automatically update the vulnerability database before scanning.

Both of these external calls will need to be disabled. In addition, for the `grype` cli to function in an offline/air gap environment, the vulnerability database will need to be hosted within the environment. The `grype` cli will need to be configured with the internal url.

The `grype` cli accepts environment variables to satisfy these needs.

Refer to the (Anchore Grype README)[https://github.com/anchore/grype#offline-and-air-gapped-environments] for instructions on how to setup an offline vulnerability database.

To update the existing ScanTemplates that invoke the `grype` cli, the `kapp` installed `PackageInstall` objects will need to be paused before editing and then unpaused after. (Otherwise, Kubernetes will overwrite the edits.)

1. Pause the top-level `PackageInstall/tap` object by running:

    ```bash
    kubectl edit -n tap-install packageinstall tap
    ```

    and make the following edit:

    ```yaml
    apiVersion: packaging.carvel.dev/v1alpha1
    kind: PackageInstall
    metadata:
      name: tap
      namespace: tap-install
    spec:
      paused: true                    # ! set this field to `paused: true`.
      packageRef:
        refName: tap.tanzu.vmware.com
        versionSelection:
    # ...
    ```

1. Pause the `PackageInstall/grypetemplates` object by running:

    ```bash
    kubectl edit -n tap-install packageinstall grype-templates
    ```

1. Set the `packageinstall.spec.paused` field to `true` as it was done above with the `tap` object.

1. There are five installed `ScanTemplates` to edit and each will be edited in the same way. For example, edit the `public-image-scan-template` by running:

    ```bash
    kubectl edit -n MY-DEV-NAMESPACE scantemplate public-image-scan-template
    ```

    Where `MY-DEV-NAMESPACE` is what was specified in the values file during installation.

    Find the container within `spec.initContainers` named `scan-plugin` and append the required grype specific environment variables:

    ```yaml
    spec:
      template:
        # ...
        initContainers:
          - name: scan-plugin
            # ...
            env:
              # ...
              - name: GRYPE_CHECK_FOR_APP_UPDATE
                value: false
              - name: GRYPE_DB_AUTO_UPDATE
                value: false
              - name: GRYPE_DB_UPDATE_URL
                value: <url of internal vulnerability db>
              - name: GRYPE_DB_CA_CERT
                value: |
                  <certificate>
    # ...
    ```

1. Edit the remaining `ScanTemplates` following the above example.

1. Unpause the paused objects by reverting the changes (i.e. remove the `packageinstall.spec.paused` fields).
At this point the scans should function in an offline manner.
