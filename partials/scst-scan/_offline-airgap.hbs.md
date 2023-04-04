The `grype` CLI attempts to perform two over the Internet calls: 

- One to verify for later versions of the CLI.
- One to update the vulnerability database before scanning.

For the `grype` CLI to function in an offline or air-gapped environment, the
vulnerability database must be hosted within the environment. You must configure
the `grype` CLI with the internal URL.

The `grype` CLI accepts environment variables to satisfy these needs.

For information about setting up an offline vulnerability database, see the [Anchore Grype README](https://github.com/anchore/grype#offline-and-air-gapped-environments) in GitHub.

## <a id="enable-grype-airgap"></a> To enable Grype in offline air-gapped environments

1. Add the following to your tap-values.yaml:

    ```yaml
    grype:
      db:
        dbUpdateUrl: INTERNAL-VULN-DB-URL
    ```

    - `INTERNAL-VULN-DB-URL`: URL that points to the internal file server.

2. Update Tanzu Application Platform:

    ```console
    tanzu package installed update tap -f tap-values.yaml -n tap-install
    ```

## <a id="troubleshooting"></a> Troubleshooting

### ERROR failed to fetch latest cli version

**Note**: This message is a warning and the grype scan still runs with this message.

The Grype CLI checks for later versions of the CLI by contacting the anchore endpoint over the Internet.

```console
ERROR failed to fetch latest version: Get "https://toolbox-data.anchore.io/grype/releases/latest/VERSION": dial tcp: lookup toolbox-data.anchore.io on [::1]:53: read udp [::1]:65010->[::1]:53: read: connection refused
```

#### Solution

To deactivate this check, set the environment variable `GRYPE_CHECK_FOR_APP_UPDATE` to `false` by using a package overlay with the following steps:

1. Create a secret that contains the ytt overlay to add the Grype environment variable to the ScanTemplates.

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

3. Update Tanzu Application Platform:

    ```console
    tanzu package installed update tap -f tap-values.yaml -n tap-install
    ```

### Database is too old

```console
1 error occurred:
  * db could not be loaded: the vulnerability database was built N days/weeks ago (max allowed age is 5 days)
```

Grype needs up-to-date vulnerability information to provide accurate matches. By
default, it fails to run if the local database was not built in the last 5 days.

#### Solution

Two options to resolve this:

1. Stale databases weaken your security posture. VMware recommends updating the database daily as the first recommended solution.

2. If updating the database daily is not an option, the data staleness check is configurable by using the environment variable
`GRYPE_DB_MAX_ALLOWED_BUILT_AGE` and is addressed using a package overlay with
the following steps:

   1. Create a secret that contains the ytt overlay to add the Grype environment variable to the ScanTemplates.

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

    > **Note** The default maximum allowed built age of Grype's vulnerability
    > database is 5 days. This means that scanning with a 6 day old database
    > causes the scan to fail. You can use the
    > `GRYPE_DB_MAX_ALLOWED_BUILT_AGE` parameter to override the default in
    > accordance with your security posture.

   2. Configure tap-values.yaml to use `package_overlays`. Add the following to your tap-values.yaml:

       ```yaml
       package_overlays:
         - name: "grype"
           secrets:
               - name: "grype-airgap-override-stale-db-overlay"
       ```

   3. Update Tanzu Application Platform:

       ```console
       tanzu package installed update tap -f tap-values.yaml -n tap-install
       ```

### Vulnerability database is invalid

```
scan-pod[scan-plugin]  1 error occurred:
scan-pod[scan-plugin]	* failed to load vulnerability db: vulnerability database is invalid (run db update to correct): database metadata not found: /.cache/grype/db/5
```

#### Solution

Here is an example of a proper listing.json format:

```
{
  "available": {
    "5": [
      {
        "built": "2023-03-28T01:29:38Z",
        "version": 5,
        "url": "https://toolbox-data.anchore.io/grype/databases/vulnerability-db_v5_2023-03-28T01:29:38Z_e49d318c32a6113eed07.tar.gz",
        "checksum": "sha256:408ce2932f04dee929a5df524e92494f2d635c6b19e30ff9f0a50425b1fc29a1"
      },
      .....
    ]
  }
}
```

Options:

1. Make sure that the built parameters in the listing.json has timestamps in this proper format `yyyy-MM-ddTHH:mm:ssZ`. See above []()
