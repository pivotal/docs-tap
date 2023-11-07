# Bring your own scanner using an ImageVulnerabilityScan

This topic tells you how to bring your own scanner using an `ImageVulnerabilityScan`.
An `ImageVulnerabilityScan` allows you to scan with any scanner by defining your scan as a Tekton step. For more information, see the [Tekton documentation](https://tekton.dev/docs/pipelines/tasks/#defining-steps).

## <a id="sample-img-vuln"></a> Customize an ImageVulnerabilityScan

To customize an ImageVulnerabilityScan to use your scanner:

1. Create a file named `image-vulnerability-scan.yaml`.

    ```yaml
    apiVersion: app-scanning.apps.tanzu.vmware.com/v1alpha1
    kind: ImageVulnerabilityScan
    metadata:
      name: generic-image-scan
      namespace: DEV-NAMESPACE
    spec:
      image: TARGET-IMAGE
      scanResults:
        location: registry/project/scan-results
      serviceAccountNames:
        scanner: scanner
        publisher: publisher
      steps:
      - name: scan
        image: SCANNER-IMAGE
        command: ["SCANNER-CLI-COMMAND"]
        args:
        ...
    ```

    Where:

    - `DEV-NAMESPACE` is the developer namespace where scanning occurs.
    - `spec.image` is the image that you are scanning. You must specify the digest. See [Retrieving an image digest](./ivs-custom-samples.hbs.md#retrieving-an-image-digest).
    - `scanResults.location` is the registry URL where results are uploaded. For example, `my.registry/scan-results`.
    - `serviceAccountNames` includes:
        - `scanner` is the service account that runs the scan. It must have read access to `image`.
        - `publisher` is the service account that uploads results. It must have write access to `scanResults.location`.
    - `SCANNER-IMAGE` is your vulnerability scanner image, such as the image containing the scanner of your choice.
    - `SCANNER-CLI-COMMAND` is the scanner's CLI command.
    - `SCANNER-NAME` is the scanner image name that is reported in the Tanzu Developer Portal, formerly Tanzu Application Platform GUI.

    >**Important** Do not define `write-certs` or `cred-helper` as step names. These names are already used during scanning.

2. Configure the `scan` step. You must input your scanner specific `image`, `command`, and `args`. For example:

    ```yaml
    - name: scan
      image: anchore/grype:latest
      command: ["grype"]
      args:
      - registry:$(params.image)
      - -o
      - cyclonedx
      - --file
      - $(params.scan-results-path)/scan.cdx
    ```

    To pass `spec.image` and `scanResults.location` to `args`, you can use `$(params.image)` and `$(params.scan-results-path)`.

    Because volumes on a Tekton pipeline are shared amongst steps, files created by one step are consumable by the other steps. The scan controller applies the following security context to `pipelinerun.spec.podTemplate`:

  ```console
  runAsUser: 65534
  fsGroup: 65534
  runAsGroup: 65534
  ```

  The `SCANNER-IMAGE` runs and manipulates files with user and group ids of `65534`.

## <a id="img-vuln-config-options"></a> Configuration options

This section lists optional and required ImageVulnerabilityScan specifications fields.

Required fields:

- `image` is the registry URL and digest of the target image.
  For example, `nginx@sha256:aa0afebbb3cfa473099a62c4b32e9b3fb73ed23f2a75a65ce1d4b4f55a5c2ef2`.

- `scanResults.location` is the registry URL where results are uploaded.
  For example, `my.registry/scan-results`.

Optional fields:

- `activeKeychains` is an array of enabled credential helpers to authenticate against registries using workload identity mechanisms.

  ```yaml
  activeKeychains:
  - name: acr  # Azure Container Registry
  - name: ecr  # Elastic Container Registry
  - name: gcr  # Google Container Registry
  - name: ghcr # Github Container Registry
  ```

- `serviceAccountNames` includes:
  - `scanner` is the service account that runs the scan. It must have read access to `image`.
  - `publisher` is the service account that uploads results. It must have write access to `scanResults.location`.
- `workspace` includes:
  - `size` is size of the PersistentVolumeClaim the scan uses to download the image and vulnerability database.
  - `bindings` are additional array of secrets, ConfigMaps, or EmptyDir volumes to mount to the running scan. The `name` is used as the mount path.

    ```yaml
    bindings:
    - name: additionalconfig
      configMap:
        name: my-configmap
    - name: additionalsecret
      secret:
        secretName: my-secret
    - name: scratch
      emptyDir: {}
    ```

    For information about workspace bindings, see [Using other types of volume
    sources](https://tekton.dev/docs/pipelines/workspaces/#using-other-types-of-volumesources).
    Only Secrets, ConfigMaps, and EmptyDirs are  supported.

## <a id="default-env"></a> Default environment

The following describes the default environment for Tekton workspaces:

- `/home/app-scanning` is a memory-backed EmptyDir mount that contains service account credentials loaded by Tekton.
- `/cred-helper` is a memory-backed EmptyDir mount containing:
  - config.json combines static credentials with workload identity credentials when `activeKeychains` is enabled.
  - `trusted-cas.crt` when SCST - Scan 2.0 is deployed with `caCertData`
- `/workspace` is a PersistentVolumeClaim to hold scan artifacts and results.
  - The working directory for all Steps is by default located at `/workspace/scan-results`.

### <a id="env-variables"></a> Environment variables

If undefined by your `step` definition the environment uses the following default variables:

- HOME=/home/app-scanning
- DOCKER_CONFIG=/cred-helper
- XDG_CACHE_HOME=/workspace/.cache
- TMPDIR=/workspace/tmp
- SSL_CERT_DIR=/etc/ssl/certs:/cred-helper

Tekton pipeline parameters:

These parameters are populated after creating the GrypeImageVulnerabilityScan. For information about parameters, see the [Tekton documentation](https://tekton.dev/docs/pipelines/pipelines/#specifying-parameters).

| Parameters | Default | Type | Description |
| --- | --- | --- | --- |
| image | "" | string | The scanned image |
| scan-results-path | /workspace/scan-results | string | Location to save scanner output |
| trusted-ca-certs  | "" | string | PEM data from the installation's `caCertData` |

>**Note** The `publisher` service account uploads any files, such as scanner
>output, in the `scan-results-path` directory to the registry of your choice.
>For information about configuring the registry URL where the `publisher` service account uploads scan results, see [Configure your custom ImageVulnerabilityScan samples](./ivs-custom-samples.hbs.md#use-samples).

## <a id="retrieve-digest"></a> Retrieving an image digest

SCST - Scan 2.0 custom resources require the digest form of the URL. For example,  `nginx@sha256:aa0afebbb3cfa473099a62c4b32e9b3fb73ed23f2a75a65ce1d4b4f55a5c2ef2`.

Use the [Docker documentation](https://docs.docker.com/engine/install/) to pull and inspect an image digest:

```console
docker pull nginx:latest
docker inspect --format='\{{index .RepoDigests 0}}' nginx:latest
```

Alternatively, you can install [krane](https://github.com/google/go-containerregistry/tree/main/cmd/krane) to retrieve the digest without pulling the image:

```console
krane digest nginx:latest
