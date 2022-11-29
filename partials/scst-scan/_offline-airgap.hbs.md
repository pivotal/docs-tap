# Using Grype in offline and air-gapped environments

The `grype` CLI attempts to perform two over the Internet calls: one to verify for newer versions of the CLI and another to update the vulnerability database before scanning.

For the `grype` CLI to function in an offline or air-gapped environment, the vulnerability database must be hosted within the environment. You must configure the `grype` CLI with the internal URL.

The `grype` CLI accepts environment variables to satisfy these needs.

For information about setting up an offline vulnerability database, see the [Anchore Grype README](https://github.com/anchore/grype#offline-and-air-gapped-environments) in GitHub.

## <a id="enable-grype-airgap"></a> To enable Grype in offline air-gapped environments

1. Add the following to your tap-values.yaml:
    ```yaml
    grype:
      db:
        dbUpdateUrl: <INTERNAL-VULN-DB-URL>
    ```
    * `INTERNAL-VULN-DB-URL`: url points to the internal file server

1. Update Tanzu Application Platform
    ```console
    tanzu package installed update tap -f tap-values.yaml -n tap-install
    ```

## <a id="troubleshooting"></a> Troubleshooting

### ERROR failed to fetch latest cli version
```
ERROR failed to fetch latest version: Get "https://toolbox-data.anchore.io/grype/releases/latest/VERSION": dial tcp: lookup toolbox-data.anchore.io on [::1]:53: read udp [::1]:65010->[::1]:53: read: connection refused
```
The grype CLI is checking for newer versions of the CLI by contacting the anchore endpoint over the internet.

#### Solution
To deactivate this check, set the environment variable `GRYPE_CHECK_FOR_APP_UPDATE` to `false` via package overlay with the following steps:

1. Create a Secret that contains the ytt overlay to add the Grype environment variable to the ScanTemplates.
    ```yaml
    apiVersion: v1
    kind: Secret
    metadata:
      name: grype-airgap-deactivate-cli-check-overlay
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
                  - name: GRYPE_CHECK_FOR_APP_UPDATE
                    value: "false"
    ```

2. Configure tap-values.yaml to use `package_overlays`. Add the following to your tap-values.yaml:
    ```yaml
    package_overlays:
      - name: "grype"
        secrets:
            - name: "grype-airgap-deactivate-cli-check-overlay"
    ```

3. Update Tanzu Application Platform
    ```console
    tanzu package installed update tap -f tap-values.yaml -n tap-install
    ```

### Database is too old

```
1 error occurred:
	* db could not be loaded: the vulnerability database was built N days/weeks ago (max allowed age is 5 days)
```
Grype needs up-to-date vulnerability information to provide accurate matches. By default, it will fail to run if the local database was not built in the last 5 days.

#### Solution
The data staleness check is configurable via the environment variable `GRYPE_DB_MAX_ALLOWED_BUILT_AGE` and can be addressed using a package overlay with the following steps:

1. Create a Secret that contains the ytt overlay to add the Grype environment variable to the ScanTemplates.
    ```yaml
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
                    value: "120h"
    ```
    > **Note** The default maximum allowed built age of Grype's vulnerability database is 5 days. This means that scanning with a 6 day old database causes the scan to fail. Stale databases weaken your security posture. VMware recommends updating the database daily. You can use the `GRYPE_DB_MAX_ALLOWED_BUILT_AGE` parameter to override the default in accordance with your security posture.

2. Configure tap-values.yaml to use `package_overlays`. Add the following to your tap-values.yaml:
    ```yaml
    package_overlays:
      - name: "grype"
        secrets:
            - name: "grype-airgap-override-stale-db-overlay"
    ```

3. Update Tanzu Application Platform
    ```console
    tanzu package installed update tap -f tap-values.yaml -n tap-install
    ```