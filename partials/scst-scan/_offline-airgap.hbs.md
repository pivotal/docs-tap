The `grype` CLI attempts to perform two over the Internet calls: one to verify for later versions of the CLI and another to update the vulnerability database before scanning.

You must deactivate both of these external calls. For the `grype` CLI to function in an offline or air-gapped environment, the vulnerability database must be hosted within the environment. You must configure the `grype` CLI with the internal URL.

The `grype` URL accepts environment variables to satisfy these needs.

For information about setting up an offline vulnerability database, see the [Anchore Grype README](https://github.com/anchore/grype#offline-and-air-gapped-environments) in GitHub.

## <a id="overview"></a> Overview

To enable Grype in offline air-gapped environments:

1. Create ConfigMap
2. Create Patch Secret
3. [Optional] Update Grype PackageInstall
4. Configure tap-values.yaml to use `package_overlays`
5. Update Tanzu Application Platform

## <a id="use-grype"></a> Use Grype

To use Grype in offline and air-gapped environments:

1. Create a ConfigMap that contains the public ca.crt to the file server hosting the Grype database files. Apply this ConfigMap to your developer namespace.

2. Create a secret that contains the ytt overlay to add the Grype environment variables to the ScanTemplates.

    ```yaml
    apiVersion: v1
    kind: Secret
    metadata:
      name: grype-airgap-overlay
      namespace: tap-install #! namespace where tap is installed
    stringData:
      patch.yaml: |
        #@ load("@ytt:overlay", "overlay")

        #@overlay/match by=overlay.subset({"kind":"ScanTemplate","metadata":{"namespace":"<DEV-NAMESPACE>"}}),expects="1+"
        #! developer namespace you are using
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
                  - name: GRYPE_DB_AUTO_UPDATE
                    value: "true"
                  - name: GRYPE_DB_UPDATE_URL
                    value: <INTERNAL-VULN-DB-URL> #! url points to the internal file server
                  - name: GRYPE_DB_CA_CERT
                    value: "/etc/ssl/certs/custom-ca.crt"
                  - name: GRYPE_DB_MAX_ALLOWED_BUILT_AGE #! see note on best practices
                    value: "120h"
                volumeMounts:
                  #@overlay/append
                  - name: ca-cert
                    mountPath: /etc/ssl/certs/custom-ca.crt
                    subPath: <INSERT-KEY-IN-CONFIGMAP> #! key pointing to ca certificate
            volumes:
            #@overlay/append
            - name: ca-cert
              configMap:
                name: <CONFIGMAP-NAME> #! name of the configmap created
    ```

 >**Note** The default maximum allowed built age of Grype's vulnerability database is 5 days. This means that scanning with a 6 day old database causes the scan to fail. Stale databases weaken your security posture. VMware recommends updating the database daily. You can use the `GRYPE_DB_MAX_ALLOWED_BUILT_AGE` parameter to override the default in accordance with your security posture.

    You can also add more certificates to the ConfigMap created earlier, to handle connections to a private registry for example, and mount them in the `volumeMounts` section if needed.

    For example:

    ```yaml
    #! ...
    volumeMounts:
      #@overlay/append
      #! ...
      - name: ca-cert
        mountPath: /etc/ssl/certs/another-ca.crt
        subPath: another-ca.cert #! key pointing to ca certificate
    ```

    >**Note** If you have more than one developer namespace and you want to apply this change to all of them, change the `overlay match` on top of the patch.yaml to the following:

    ```yaml
    #@overlay/match by=overlay.subset({"kind":"ScanTemplate"}),expects="1+"
    ```
1. [Optional] If Grype was installed by using a Tanzu Application Platform profile, you can skip to the next step.

If Grype was installed manually, you must update your `PackageInstall` to include the annotation to reference the overlay `Secret`.

  ```yaml
  apiVersion: packaging.carvel.dev/v1alpha1
  kind: PackageInstall
  metadata:
  name: grype
  namespace: tap-install
  annotations:
    ext.packaging.carvel.dev/ytt-paths-from-secret-name.0: grype-airgap-overlay
  ...
  ```

For more information, see [Customize package installation](/docs-tap/customize-package-installation.hbs.md#customize-a-package-that-was-manually-installed).

1. Configure tap-values.yaml to use `package_overlays`. Add the following to your tap-values.yaml:

  ```yaml
  package_overlays:
     - name: "grype"
       secrets:
          - name: "grype-airgap-overlay"
  ```

5. Update Tanzu Application Platform.

### Vulnerability database is invalid

```console
scan-pod[scan-plugin]  1 error occurred:
scan-pod[scan-plugin]  * failed to load vulnerability db: vulnerability database is invalid (run db update to correct): database metadata not found: /.cache/grype/db/5
```

#### Solution

Examine the `listing.json` file you created. This matches the format of the listing file. The listing file is located at Anchore Grype's public endpoint. See the [Grype README.md](https://github.com/anchore/grype#how-database-updates-work) in GitHub.

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

- `5` refers to the Grype's vulnerability database schema.
- `built` is the build timestamp in the format `yyyy-MM-ddTHH:mm:ssZ`.
- `url` is the download URL for the tarball containing the database. This points at your internal endpoint. The tarball contains the following files:
  - ` vulnerability.db` is an SQLite file that is Grype's vulnerability database. Each time the data shape of the vulnerability database changes, a new schema is created. Different Grype versions require specific database schema versions. For example, Grype `v0.54.0` requires database schema v5.
  - `metadata.json` file
- `checksum` is the SHA used to verify the database's integrity.

Verify these possible reasons why the vulnerability database is not valid:

1. The database schema is invalid. First confirm that the required database schema for the installed Grype version is being used. Next, confirm that the top level version key matches the nested `version`. For example, the top level version `1` in the following snippet does not match the nested `version: 5`.

```json
{
  "available": {
    "1": [{
            "built": "2023-02-08T08_17_20Z",
            "version": 5,
            "url": "https://INTERNAL-ENDPOINT/releases/vulnerability-db_v5_2023-02-08T08_17_20Z_6ef73016d160043c630f.tar.gz",
            "checksum": "sha256:aab8d369933c845878ef1b53bb5c26ee49b91ddc5cd87c9eb57ffb203a88a72f"
    }]
  }
}
```

As stale databases weaken your security posture, VMware recommends using the newest entry of the relevant schema version in the `listing.json` file. See Anchore’s [grype-db](https://github.com/anchore/grype-db) in GitHub.

1. The `built` parameters in the `listing.json` file are incorrectly formatted. The proper format is `yyyy-MM-ddTHH:mm:ssZ`.

2. The `url` which you modified to point at an internal endpoint is not reachable from within the cluster. For information about verifying connectivity, see [Debug Grype database in a cluster](#debug-grype-database-in-a-cluster).

#### Debug Grype database in a cluster

1. Describe the failed source or image scan to determine verify the name of the ScanTemplate being used:

```console
kubectl describe sourcescan/imagescan SCAN-NAME -n DEV-NAMESPACE
```

Where `SCAN-NAME` is the name of the source/image scan that failed.

1. Edit the ScanTemplate's `scan-plugin` container to include a sleep entrypoint which allows you to troubleshoot inside the container:

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

2. Re-run the scan.

3. Get the name of the `scan-plugin` pod.

    ```console
    kubectl get pods -n DEV-NAMESPACE
    ```

4. Get a shell to the container. See the [Kubernetes documentation](https://kubernetes.io/docs/tasks/debug/debug-application/get-shell-running-container/).

    ```console
    kubectl exec --stdin --tty SCAN-PLUGIN-POD -c step-scan-plugin -- /bin/bash
    ```

    Where `SCAN-PLUGIN-POD` is the name of the `scan-plugin` pod.

5. Inside the container, run Grype CLI commands to report database status and verify connectivity from cluster to mirror. See the [Anchore Grype documentation](https://github.com/anchore/grype#cli-commands-for-database-management) in GitHub.

   - Report current status of Grype's database, such as location, build date, and checksum:

      ```console
      grype db status
      ```

   - Download the listing file configured at `db.update-url` and show databases that are available for download:

     ```console
     grype db list
     ```
