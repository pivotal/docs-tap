# Using Grype in offline and air gapped environments

The `grype` CLI attempts to perform two over the Internet calls: one to verify for newer versions of the CLI and another to automatically update the vulnerability database before scanning.

You must deactivate both of these external calls. For the `grype` CLI to function in an offline or air gapped environment, the vulnerability database must be hosted within the environment. You must configure the `grype` CLI with the internal URL.

The `grype` URL accepts environment variables to satisfy these needs.

For information about setting up an offline vulnerability database, see the [Anchore Grype README](https://github.com/anchore/grype#offline-and-air-gapped-environments) in Github.

To update the existing ScanTemplates that call the `grype` CLI, you must pause the `kapp` installed `PackageInstall` before editing and then unpause after. Otherwise, Kubernetes overwrites the edits.

1. Pause the top-level `PackageInstall/tap` object by running:

    ```bash
    kubectl edit -n tap-install packageinstall tap
    ```

    Make the following edit:

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

1. Set the `packageinstall.spec.paused` field to `true` as done earlier with the `tap` object.

1. There are five installed `ScanTemplates` to edit. Each `ScanTemplates` is edited the same way. For example, edit the `public-image-scan-template` by running:

    ```bash
    kubectl edit -n MY-DEV-NAMESPACE scantemplate public-image-scan-template
    ```

    Where `MY-DEV-NAMESPACE` is what was specified in the values file during installation.

    Find the container in `spec.initContainers` named `scan-plugin` and append the required grype specific environment variables:

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

1. Edit the remaining `ScanTemplates` following the earlier example.

1. Unpause the paused objects by reverting the changes. For example, removing the `packageinstall.spec.paused` fields.
