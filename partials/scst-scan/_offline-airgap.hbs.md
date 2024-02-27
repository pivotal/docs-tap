## <a id="trivy-with-scan-2-0"></a> Using Trivy with SCST - Scan 2.0

The Aqua Trivy vulnerability scanner uses two databases to perform vulnerability scans:

1. Vulnerability Database: This database contains the vulnerability information used to scan
artifacts. This database is built every six hours on [GitHub](https://github.com/aquasecurity/trivy-db)
and is distributed using [GitHub Container registry (GHCR)](https://ghcr.io/aquasecurity/trivy-db).

2. Java Index Database: This database enables Trivy to identify the `groupId`, `artifactId`, and `version`
of JAR files. It is built once a day on [GitHub](https://github.com/aquasecurity/trivy-java-db) and
distributed using [GitHub Container registry (GHCR)](https://ghcr.io/aquasecurity/trivy-java-db).

In an online installation of Tanzu Application Platform, these databases are automatically downloaded
from GHCR (Github Container Registry) with each scan execution. To enable scanning in an offline environment, these two
databases must be relocated to your private container image registry, and Trivy must be configured
to use your private location instead of downloading from GHCR.

For more information about the Trivy vulnerability databases, see the [Trivy ](https://aquasecurity.github.io/trivy/v0.48/docs/scanner/vulnerability/) documentation.

### <a id="relocate-trivy-databases"></a>Relocate Trivy Images

The databases are stored in an OCI-compliant registry as OCI artifacts. To copy these to
your private registry, Trivy recommends using the [ORAS CLI](https://oras.land/docs/installation/).

To make the Trivy databases available in your private registry:

1. Create a repository within your private registry. This example uses aquasecurity to remain
consistent with the GHCR  repository.

1. Copy the vulnerability database from GHCR to your private registry:

    ```console
    oras cp ghcr.io/aquasecurity/trivy-db:2 CONTAINER-REGISTRY/aquasecurity/trivy-db
    ```

    > **Note**  The Trivy scanner is hardcoded to use the `2` tag for the vulnerability database.

    Where `CONTAINER-REGISTRY` is the URL for your registry. For example, `harbor.example.com`

1. Copy the Java index database from GHCR to your private registry:

    ```console
    oras cp ghcr.io/aquasecurity/trivy-java-db:1 harbor.CONTAINER-REGISTRY/aquasecurity/trivy-java-db
    ```

    Where `CONTAINER-REGISTRY` is the URL for your registry. For example, `harbor.example.com`

    > **Note**  The Trivy scanner is hardcoded to use the `1` tag for the Java index database.

The databases are now available locally in your air-gapped environment. The next step is to
configure the supply chain to use the air-gapped location for Trivy. For more information about using
Trivy in an air-gapped environment, see the [Trivy](https://aquasecurity.github.io/trivy/v0.48/docs/advanced/air-gap/) documentation.

### <a id="Configure-trivy"></a>Configure Trivy in the Supply Chain

Now that you have relocated the images, you must configure the scanning step of the supply chain to
use Trivy with the SCST - Scan 2.0, and provide the location of the database artifacts in
the private registry.

1. To enable SCST - Scan 2.0 with Trivy with private registries, update your `tap-values.yaml` file to
specify the Trivy `ClusterImageTemplate`. For example:

    ```yaml
    ootb_supply_chain_testing_scanning:
      image_scanner_template_name: image-vulnerability-scan-trivy
      scanning:
        steps:
          env_vars:
          - name: TRIVY_DB_REPOSITORY
            value: CONTAINER-REGISTRY/aquasecurity/trivy-db
          - name: TRIVY_JAVA_DB_REPOSITORY
            value: CONTAINER-REGISTRY/aquasecurity/trivy-java-db
          - name: TRIVY_OFFLINE_SCAN
            value: "true"
    ```

    Where `CONTAINER-REGISTRY` is the URL for your registry. For example, `harbor.example.com`

2. Update your Tanzu Application Platform installation by running:

    ```console
    tanzu package installed update tap -p tap.tanzu.vmware.com -v TAP-VERSION  --values-file tap-values.yaml -n tap-install
    ```

    Where `TAP-VERSION` is the version of Tanzu Application Platform installed.

Trivy is now configured to use resources in your air-gapped environment when executed with the
supply chain. For more information about using Trivy in an air-gapped environment, see the [Trivy](https://aquasecurity.github.io/trivy/v0.48/docs/advanced/air-gap/) documentation.

## <a id="grype-with-scan-1-0"></a> Using Grype with Scan 1.0

VMware recommends using [Aqua Trivy](https://www.aquasec.com/products/trivy/) with SCST - Scan 2.0
for offline or air-gapped environments due to the simplified setup and maintenance. However, if you
require policy enablement based on vulnerability scanning, use the following steps to enable
Grype scanning with SCST - Scan 1.0.

The Grype CLI attempts to perform two over-the-Internet calls:

- One to verify for later versions of the CLI.
- One to update the vulnerability database before scanning.

For the Grype CLI to function in an offline or air-gapped environment, the
vulnerability database must be hosted in the environment. You must configure
the Grype CLI with the internal URL.

The Grype CLI accepts environment variables to satisfy these needs.

### <a id="host-grype-db"></a> Host the Grype vulnerability database

To host the Grype vulnerability database in an air-gapped environment:

1. Retrieve the Grype listing file from its public endpoint: [https://toolbox-data.anchore.io/grype/databases/listing.json](https://toolbox-data.anchore.io/grype/databases/listing.json).

2. Create your own `listing.json` file.

  **Note** Different Grype versions require specific database schema versions. To avoid
  compatibility issues between different versions, include a database schema for each version. For example:

  ```json
        {
          "available": {
            "1": [
              {
                "built": "2023-06-16T01:33:30Z",
                "version": 1,
                "url": "https://toolbox-data.anchore.io/grype/databases/vulnerability-db_v1_2023-06-16T01:33:30Z_1621f4169ffd15bea9e5.tar.gz",
                "checksum": "sha256:3f2c1b432945cca9a69b2e604f6fb231fec450fdd27f4946fc5608692b63a9d1"
              }
            ],
            "2": [
              {
                "built": "2023-06-16T01:33:30Z",
                "version": 2,
                "url": "https://toolbox-data.anchore.io/grype/databases/vulnerability-db_v2_2023-06-16T01:33:30Z_d6eee5e78d9b78285e1a.tar.gz",
                "checksum": "sha256:7b7e3a2a7712c72b8c5cc777733c4d8d140d8cfee65e4f04540abbdfe3ef1f65"
              }
            ],
            "3": [
              {
                "built": "2023-06-16T01:33:30Z",
                "version": 3,
                "url": "https://toolbox-data.anchore.io/grype/databases/vulnerability-db_v3_2023-06-16T01:33:30Z_f96ae38a7b05987c3ece.tar.gz",
                "checksum": "sha256:8ea9fae3fda3bf3bf35bd5e5eb656fc127b59cd3c42db4c36795556aab8a9cf0"
              }
            ],
            "4": [
              {
                "built": "2023-06-16T01:33:30Z",
                "version": 4,
                "url": "https://toolbox-data.anchore.io/grype/databases/vulnerability-db_v4_2023-06-16T01:33:30Z_13bba2fa8ff62b7f8b26.tar.gz",
                "checksum": "sha256:3b53d20241b88e5aa45feb817b325c53d6efbe9fa1fc5a67eeddaecafa7687e0"
              }
            ],
            "5": [
              {
                "built": "2023-06-16T01:33:30Z",
                "version": 5,
                "url": "https://toolbox-data.anchore.io/grype/databases/vulnerability-db_v5_2023-06-16T01:33:30Z_e07da3853f6db6eb1104.tar.gz",
                "checksum": "sha256:93d4d9d2f9e39f86570f832cf85b7149a949ca6f1613581b10c12393509d884f"
              }
            ]
          }
        }
  ```

  Where `url` points to a tarball containing Grype's `vulnerability.db` and `metadata.json` files.

1. Download and host the tarballs in your internal file server.

  >**Note** Some storage solutions for internal file servers change the name of TAR files automatically
  because of their limits. Notice these modified names and reflect the changes in the `url`. Ensure
  that the timestamp in the name is correctly formatted because Grype parses the name of TAR artifact
  to get the timestamp.

1. Update the download `url` to point at your internal endpoint.

  For information about setting up an offline vulnerability database, see the [Anchore Grype README](https://github.com/anchore/grype#offline-and-air-gapped-environments) in GitHub.

### <a id="enable-grype-airgap"></a> To enable Grype in offline air-gapped environments

1. Add the following to your `tap-values.yaml` file:

    ```yaml
    grype:
      db:
        dbUpdateUrl: INTERNAL-VULN-DB-URL
    ```

    Where `INTERNAL-VULN-DB-URL` is the URL that points to the internal file server.

2. Update Tanzu Application Platform:

    ```console
    tanzu package installed update tap -f tap-values.yaml -n tap-install
    ```

## <a id="configure-grype-env-var"></a> Configure Grype environmental variables

1. Create a secret that contains the ytt overlay to add the Grype environment variable to the ScanTemplates.

    ```yaml
    apiVersion: v1
    kind: Secret
    metadata:
      name: grype-airgap-environmental-variables
      namespace: tap-install
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

Where `spec.template.initContainers[]` specifies setting one or more environment variables in the `scan-plugin` `initContainer`.

> **Note** If you are using the Namespace Provisioner to provision a new developer namespace and want
to apply a package overlay for Grype, you must import the overlay `Secret`.
See [Import overlay secrets](/docs-tap/namespace-provisioner/customize-installation.hbs.md#import-overlay-secrets).

### <a id="troubleshooting"></a> Troubleshooting


#### ERROR failed to fetch latest cli version

##### Symptom

Error message:

```console
ERROR failed to fetch latest version: Get "https://toolbox-data.anchore.io/grype/releases/latest/VERSION": dial tcp: lookup toolbox-data.anchore.io on [::1]:53: read udp [::1]:65010->[::1]:53: read: connection refused
```

##### Cause

The Grype CLI checks for later versions of the CLI by contacting the anchore endpoint over-the-Internet.

##### Solution

This message is a warning and the Grype scan still runs.

To deactivate this check, set the environment variable `GRYPE_CHECK_FOR_APP_UPDATE` to `false` by
using a package overlay:

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

2. Configure `tap-values.yaml` to use `package_overlays`. Add the following to your `tap-values.yaml` file:

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

#### Database is too old

##### Symptom

Error message:

```console
1 error occurred:
  * db could not be loaded: the vulnerability database was built N days/weeks ago (max allowed age is 5 days)
```

##### Cause

Grype needs up-to-date vulnerability information to provide accurate matches. By
default, it fails to run if the local database was not built in the last 5 days.

##### Solution

There are two options to resolve this:

1. Stale databases weaken your security posture. VMware recommends updating the database daily.

2. If you cannot update the database daily, configure the data staleness check using the environment
variable `GRYPE_DB_MAX_ALLOWED_BUILT_AGE` and apply a package overlay:

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

    2. Configure `tap-values.yaml` to use `package_overlays`. Add the following to your `tap-values.yaml` file:

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

#### Vulnerability database is invalid

##### Symptom

Error message:

```console
scan-pod[scan-plugin]  1 error occurred:
scan-pod[scan-plugin]  * failed to load vulnerability db: vulnerability database is invalid (run db update to correct): database metadata not found: /.cache/grype/db/5
```

##### Solution

Examine the `listing.json` file you created. This matches the format of the listing file. The listing
file is located at Anchore Grype's public endpoint. See the [Grype README.md](https://github.com/anchore/grype#how-database-updates-work) in GitHub.

An example `listing.json`:

```console
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

Where:

- `5` refers to the Grype vulnerability database schema.
- `built` is the build timestamp in the format `yyyy-MM-ddTHH:mm:ssZ`.
- `url` is the download URL for the tarball containing the database. This points at your internal
endpoint. The tarball contains the following files:
  - ` vulnerability.db` is an SQLite file that is Grype's vulnerability database. Each time the data
  shape of the vulnerability database changes, a new schema is created. Different Grype versions require specific database schema versions. For example, Grype `v0.54.0` requires database schema version v5.
  - `metadata.json` file
- `checksum` is the SHA used to verify the database's integrity.

Verify these possible reasons why the vulnerability database is not valid:

1. The database schema is invalid. Confirm that the required database schema for
   the installed Grype version is used. Confirm that the top level version key
   matches the nested `version`. For example, the top level version `1` in the
   following snippet does not match the nested `version: 5`.

    ```json
    {
      "available": {
        "1": [{
               "built": "2023-02-08T08_17_20Z",
               "version": 5,
               "url": "https://INTERNAL-ENDPOINT/PATH-TO-TARBALL/vulnerability-db_v5_2023-02-08T08_17_20Z_6ef73016d160043c630f.tar.gz",
               "checksum": "sha256:aab8d369933c845878ef1b53bb5c26ee49b91ddc5cd87c9eb57ffb203a88a72f"
        }]
      }
    }
    ```

    Where `PATH-TO-TARBALL` is the path to the tarball containing the vulnerability database.

    As stale databases weaken your security posture, VMware recommends using the
    newest entry of the relevant schema version in the `listing.json` file. See
    Anchore’s [grype-db](https://github.com/anchore/grype-db) in GitHub.

2. The `built` parameters in the `listing.json` file are incorrectly formatted. The proper format is `yyyy-MM-ddTHH:mm:ssZ`.

3. The `url` that you modified to point at an internal endpoint is not reachable
   from the cluster. For information about verifying connectivity, see
   [Debug Grype database in a cluster](#debug-grype-database-in-a-cluster).
4. Verify if there are syntax errors in the listing.json:

    ```console
    grype db check
    ```

5. Validate the configured listing.json:

    ```console
    grype db list -o raw
    ```

##### Debug Grype database in a cluster

1. Describe the failed source scan or image scan to verify the name of the ScanTemplate being used.

    - For `sourcescan`, run:

        ```console
        kubectl describe sourcescan SCAN-NAME -n DEV-NAMESPACE
        ```

    - For `imagescan`, run:

        ```console
        kubectl describe imagescan SCAN-NAME -n DEV-NAMESPACE
        ```

    Where `SCAN-NAME` is the name of the source or image scan that failed.

2. Pause reconciliation of the `grype.scanning.apps.tanzu.vmware.com` package:

    ```console
    kctrl package installed pause -i <PACKAGE-INSTALL-NAME> -n tap-install
    ```

    Where `PACKAGE-INSTALL-NAME` is the name of the `grype.scanning.apps.tanzu.vmware.com` package, for example, grype

3. Edit the ScanTemplate's `scan-plugin` container to include a "sleep" entrypoint which allows you
to troubleshoot inside the container:

    ```yaml
    - name: scan-plugin
      volumeMounts:
        ...
      image: #@ data.values.scanner.image
      imagePullPolicy: IfNotPresent
      env:
        ...
      command: ["/bin/bash"]
      args:
      - "sleep 1800" # insert 30 min sleep here
    ```

4. Re-run the scan.

5. Get the name of the `scan-plugin` pod.

    ```console
    kubectl get pods -n DEV-NAMESPACE
    ```

6. Get a shell to the container.

    ```console
    kubectl exec --stdin --tty SCAN-PLUGIN-POD -c step-scan-plugin -- /bin/bash
    ```

    Where `SCAN-PLUGIN-POD` is the name of the `scan-plugin` pod.
    For more information, see the [Kubernetes documentation](https://kubernetes.io/docs/tasks/debug/debug-application/get-shell-running-container/).

7. Inside the container, run Grype CLI commands to report database status and verify connectivity
   from the cluster to the mirror.
   See the [Grype documentation](https://github.com/anchore/grype#cli-commands-for-database-management) in GitHub.

   - Report current status of Grype's database, such as location, build date, and checksum:

      ```console
      grype db status
      ```

8. Ensure that the built parameters in the `listing.json` have timestamps in this proper format `yyyy-MM-ddTHH:mm:ssZ`.

9. After you complete troubleshooting, to trigger reconciliation, run:

  ```console
  kctrl package installed kick -i <PACKAGE-INSTALL-NAME> -n tap-install
  ```

  Where `PACKAGE-INSTALL-NAME` is the name of the `grype.scanning.apps.tanzu.vmware.com` package, such as Grype.

### Grype package overlays are not applied to scantemplates created by Namespace Provisioner

If you used the Namespace Provisioner to provision a new developer namespace and
want to apply a package overlay for Grype, see [Import overlay
secrets](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.8/tap/namespace-provisioner-customize-installation.html)[Import overlay secrets](/docs-tap/namespace-provisioner/customize-installation.hbs.md#import-overlay-secrets).
