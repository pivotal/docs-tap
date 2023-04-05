# Supply Chain Security Tools - Scan 2.0 (alpha)

>**Important** This component is in Alpha, which means that it is still in
>active development by VMware and might be subject to change at any point. Users
>might encounter unexpected behavior due to capability gaps. This is an opt-in
>component to gather early feedback from Alpha testers and is not installed by
>default with any profile.

## <a id="overview"></a>Overview

SCST - Scan 2.0 is responsible
for providing the framework to scan applications for their security posture.
Scanning container images for known Common Vulnerabilities and Exposures (CVEs)
implements this framework.

During scanning:

- Tekton creates Tekton Steps to perform operations, such as setting up
  workspace and environment configuration, running scanning, and publishing
  results to a metadata store.
- Tekton creates a Tekton Sidecar as a no-op sidecar to trigger Tekton's
  injected sidecar cleanup. See [Tekton
  pipeline](https://github.com/tektoncd/pipeline/blob/main/cmd/nop/README.md#stopping-sidecar-containers)
  in github.

SCST - Scan 2.0 is in Alpha and supersedes the [SCST - Scan component](overview.hbs.md).

A core tenet of the app-scanning framework architecture is to simplify integration for new plug-ins by allowing users to integrate new scan engines by minimizing the scope of the scan engine to only scanning and pushing results to an OCI Compliant Registry.

## <a id="features"></a>Features

SCST - Scan 2.0 includes the following features:

- Tekton is used as the orchestrator of the scan to align with overall Tanzu Application Platform use of Tekton for multi-step activities.
- New scans are defined as CRDs that represent specific scanners (e.g. GrypeImageVulnerabilityScan).  Mapping logic turns the domain-specific specifications into a Tekton PipelineRun.
- CycloneDX-formatted scan results are pushed to an OCI registry for long-term storage.

## Installing SCST - Scan 2.0 in a cluster

The following sections describe how to install SCST - Scan 2.0.

### <a id='scst-app-scanning-prereqs'></a> Prerequisites

SCST - Scan 2.0 requires the following prerequisites:

- Complete all prerequisites to install Tanzu Application Platform. For more information, see [Prerequisites](../prerequisites.hbs.md).
- Install the [Tekton component](../tekton/install-tekton.hbs.md). Tekton is in the Full and Build profiles of Tanzu Application Platform.

### <a id='configure-app-scanning'></a> Configure properties

When you install SCST - Scan 2.0, you can configure the following optional properties:

| Key | Default | Type | Description |
| --- | --- | --- | --- |
| caCertData | "" | string | The custom certificates trusted by the scan's connections. |
| docker.import | true | Boolean | Import `docker.pullSecret` from another namespace (requires secretgen-controller). Set to false if the secret is already present. |
| docker.pullSecret | registries-credentials | string | Name of a Docker pull secret in the deployment namespace to pull the scanner images. |
| workspace.storageSize  | 100Mi | string | Size of the PersistentVolume that the Tekton pipelineruns uses. |
| workspace.storageClass  | "" | string | Name of the storage class to use while creating the PersistentVolume claims used by tekton pipelineruns. |

### <a id='install-scst-app-scanning'></a> Install

To install SCST - Scan 2.0:

1. List version information for the package by running:

    ```console
    tanzu package available list app-scanning.apps.tanzu.vmware.com --namespace tap-install
    ```

    For example:

    ```console
    $ tanzu package available list app-scanning.apps.tanzu.vmware.com --namespace tap-install
    - Retrieving package versions for app-scanning.apps.tanzu.vmware.com...
        NAME                                VERSION              RELEASED-AT
        app-scanning.apps.tanzu.vmware.com  0.1.0-alpha          2023-03-01 20:00:00 -0400 EDT
    ```

1. (Optional) Make changes to the default installation settings:

    Create an `app-scanning-values-file.yaml` file which contains any changes to the default installation settings.

    Retrieve the configurable settings and append the key-value pairs to be modified to the `app-scanning-values-file.yaml` file:

    ```console
    tanzu package available get app-scanning.apps.tanzu.vmware.com/VERSION --values-schema --namespace tap-install
    ```

    Where `VERSION` is your package version number. For example, `0.1.0-alpha`.

    For example:

    ```console
    tanzu package available get app-scanning.apps.tanzu.vmware.com/0.1.0-alpha --values-schema --namespace tap-install
    | Retrieving package details for app-scanning.apps.tanzu.vmware.com/0.1.0-alpha...

      KEY                     DEFAULT                 TYPE     DESCRIPTION
      docker.import           true                    boolean  Import `docker.pullSecret` from another namespace (requires
                                                               secretgen-controller). Set to false if the secret will already be present.
      docker.pullSecret       registries-credentials  string   Name of a docker pull secret in the deployment namespace to pull the scanner
                                                               images.
      workspace.storageSize   100Mi                   string   Size of the Persistent Volume to be used by the tekton pipelineruns
      workspace.storageClass                          string   Name of the storage class to use while creating the Persistent Volume Claims
                                                               used by tekton pipelineruns
      caCertData                                      string   The custom certificates to be trusted by the scan's connections
    ```

2. Install the package by running:

    ```console
    tanzu package install app-scanning-alpha --package-name app-scanning.apps.tanzu.vmware.com \
        --version VERSION \
        --namespace tap-install \
        --values-file app-scanning-values-file.yaml
    ```
    Where `VERSION` is your package version number. For example, `0.1.0-alpha`.

    For example:

    ```console
    tanzu package install app-scanning-alpha --package-name app-scanning.apps.tanzu.vmware.com \
        --version 0.1.0-alpha \
        --namespace tap-install \
        --values-file app-scanning-values-file.yaml

        Installing package 'app-scanning.apps.tanzu.vmware.com'
        Getting package metadata for 'app-scanning.apps.tanzu.vmware.com'
        Creating service account 'app-scanning-default-sa'
        Creating cluster admin role 'app-scanning-default-cluster-role'
        Creating cluster role binding 'app-scanning-default-cluster-rolebinding'
        Creating package resource
        Waiting for 'PackageInstall' reconciliation for 'app-scanning'
        'PackageInstall' resource install status: Reconciling
        'PackageInstall' resource install status: ReconcileSucceeded
    ```

## Configure namespace

The following sections describe how to configure service accounts and registry credentials.

The following access is required:

  - Read access to the registry containing the Tanzu Application Platform bundles. This is the registry from [Relocate images to a registry](../../docs-tap/install.hbs.md#relocate-images-to-a-registry) or `registry.tanzu.vmware.com`.
  - Read access to the registry containing the image to scan, if scanning a private image
  - Write access to the registry to which results are published

1. Create a secret `scanning-tap-component-read-creds` with read access to the registry containing the Tanzu Application Platform bundles. This pulls the SCST - Scan 2.0 images.

    >**Important** If you followed the directions for [Install Tanzu Application Platform](../install-intro.hbs.md), you can skip this step and use the `tap-registry` secret with your service account.

    ```console
    read -s TAP_REGISTRY_PASSWORD
    kubectl create secret docker-registry scanning-tap-component-read-creds \
      --docker-username=TAP-REGISTRY-USERNAME \
      --docker-password=$TAP_REGISTRY_PASSWORD \
      --docker-server=TAP-REGISTRY-URL \
      -n DEV-NAMESPACE
    ```

    Where `DEV-NAMESPACE` is the developer namespace where scanning occurs.

2. If you are scanning a private image, create a secret `scan-image-read-creds` with read access to the registry containing that image.

    >**Important** If you followed the directions for [Install Tanzu Application Platform](../install-intro.hbs.md), you can skip this step and use the `targetImagePullSecret` secret with your service account as referenced in your tap-values.yaml [here](../install.hbs.md#full-profile).

    ```console
    read -s REGISTRY_PASSWORD
    kubectl create secret docker-registry scan-image-read-creds \
      --docker-username=REGISTRY-USERNAME \
      --docker-password=$REGISTRY_PASSWORD \
      --docker-server=REGISTRY-URL \
      -n DEV-NAMESPACE
    ```

3. Create a secret `write-creds` with write access to the registry for the scanner to upload the scan results to.

    ```console
    read -s WRITE_PASSWORD
    kubectl create secret docker-registry write-creds \
      --docker-username=WRITE-USERNAME \
      --docker-password=$WRITE_PASSWORD \
      --docker-server=DESTINATION-REGISTRY-URL \
      -n DEV-NAMESPACE
    ```

4. Create the service account `scanner` which enables SCST - Scan 2.0 to pull the image to be scanned. Attach the read secret created earlier under `imagePullSecrets` and the write secret under `secrets`.

    ```yaml
    apiVersion: v1
    kind: ServiceAccount
    metadata:
      name: scanner
      namespace: DEV-NAMESPACE
    imagePullSecrets:
    - name: scanning-tap-component-read-creds # Used by the component to pull the scan component image from the registry
    secrets:
    - name: scan-image-read-creds # Used by the component to pull the image to scan. Needed if
                                  # the image you are scanning is private
    ```

5. Create the service account `publisher` which enables SCST - Scan 2.0 to push the scan results to a user specified registry.

    ```yaml
    apiVersion: v1
    kind: ServiceAccount
    metadata:
      name: publisher
      namespace: DEV-NAMESPACE
    imagePullSecrets:
    - name: scanning-tap-component-read-creds # Used by the component to pull the scan component image from the registry
    secrets:
    - name: write-creds # Used by the component to publish the scan results
    ```

## Scan an image

The following section describes how to scan an image with SCST - Scan 2.0.

### Retrieving an image digest

SCST - Scan 2.0 CRs require the digest form of the URL. For example,  `nginx@sha256:aa0afebbb3cfa473099a62c4b32e9b3fb73ed23f2a75a65ce1d4b4f55a5c2ef2`.

Use the [Docker documentation](https://docs.docker.com/engine/install/) to pull and inspect an image digest:

```console
docker pull nginx:latest
docker inspect --format='\{{index .RepoDigests 0}}' nginx:latest
```

Alternatively, you can install [krane](https://github.com/google/go-containerregistry/tree/main/cmd/krane) to retrieve the digest without pulling the image:

```console
krane digest nginx:latest
```

### Using the provided Grype scanner

The following sections describe how to use Grype with SCST - Scan 2.0.

#### Sample Grype scan

To create a sample Grype scan:

1. Create a file named `grype-image-vulnerability-scan.yaml`. Configure the `image` and `scanResults.location`:

    ```yaml
    apiVersion: app-scanning.apps.tanzu.vmware.com/v1alpha1
    kind: GrypeImageVulnerabilityScan
    metadata:
      name: grypescan
      namespace: DEV-NAMESPACE
    spec:
      image: nginx@sha256:... # The image to be scanned. Digest must be specified.
      scanResults:
        location: registry/project/scan-results # Registry to upload scan results
      serviceAccountNames:
        scanner: scanner # Service account that enables scanning component to pull the image to be scanned
        publisher: publisher # Service account has the secrets to push the scan results
    ```

#### Configuration Options

This section describes optional and required GrypeImageVulnerabilityScan specifications.

Required fields:

- `image` is the registry URL and digest of the scanned image. For example, `nginx@sha256:aa0afebbb3cfa473099a62c4b32e9b3fb73ed23f2a75a65ce1d4b4f55a5c2ef2`

- `scanResults.location` is the registry URL where results are uploaded. For example, `my.registry/scan-results`.

Optional fields:

- `activeKeychains` is an array of enabled credential helpers to authenticate against registries using workload identity mechanisms. See cloud registry documentation for details.

  ```yaml
  activeKeychains:
  - name: acr  # Azure Container Registry
  - name: ecr  # Elastic Container Registry
  - name: gcr  # Google Container Registry
  - name: ghcr # Github Container Registry
  ```

- `advanced` is the adjusted configuration of Grype for your needs. See Grype's [configuration](https://github.com/anchore/grype#configuration) for details.

- `serviceAccountNames` includes:
  - `scanner` is the service account that runs the scan. Must have read access to `image`.
  - `publisher` is the service account that uploads results. Must have write access to `scanResults.location`.

- `workspace` includes:
  - `size` is the size of the PersistentVolumeClaim the scan uses to download the image and vulnerability database.
  - `bindings` are additional array of secrets, ConfigMaps, or EmptyDir volumes to mount to the
    running scan. The `name` is used as the mount path.

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

#### Trigger a Grype scan

To trigger a Grype scan:

1. Apply the `GrypeImageVulnerabilityScan` to the cluster.

    ```console
    kubectl apply -f grype-image-vulnerability-scan.yaml -n DEV-NAMESPACE
    ```

1. Child resources are created.

    - view the child ImageVulnerabilityScan by running: `kubectl get imagevulnerabilityscan -n DEV-NAMESPACE`
    - view the child PipelineRun, TaskRuns, and pods by running: `kubectl get -l imagevulnerabilityscan pipelinerun,taskrun,pod -n DEV-NAMESPACE`

1. When the scanning completes, the status is shown. Specify `-o wide` to see
the digest of the image scanned and the location of the published results.

    ```console
    $ kubectl get grypeimagevulnerabilityscans grypescan -n DEV-NAMESPACE -o wide

    NAME        SCANRESULT                           SCANNEDIMAGE          SUCCEEDED   REASON
    grypescan   registry/project/scan-results@digest nginx:latest@digest   True        Succeeded

    ```

### Integrate your own scanner

To scan with any other scanner, use the generic `ImageVulnerabilityScan`.
ImageVulnerabilityScans can also change the version of a scanner or customize
the behavior of provided scanners.

ImageVulnerabilityScans allow you to define your scan as a [Tekton step](https://tekton.dev/docs/pipelines/tasks/#defining-steps)

#### Sample ImageVulnerabilityScan

To create a sample Sample ImageVulnerabilityScan:

1. Create a file named `image-vulnerability-scan.yaml`. Configure the `image`, `scanResults.location` of the scan, and define the scanner `image`, `command`, and `args` for your scanner `step`:

    ```yaml
    apiVersion: app-scanning.apps.tanzu.vmware.com/v1alpha1
    kind: ImageVulnerabilityScan
    metadata:
      name: generic-image-scan
      namespace: DEV-NAMESPACE
    spec:
      image: nginx@sha256:...
      scanResults:
        location: registry/project/scan-results
      serviceAccountNames:
        scanner: scanner
        publisher: publisher
      steps:
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

    Where `DEV-NAMESPACE` is the developer namespace where scanning occurs.

    **Note**: Do not define `write-certs` or `cred-helper` as step names. These names are already used as steps during the scan process.

#### Configuration Options

This section lists optional and required ImageVulnerabilityScan specifications fields.

Required fields:

- `image` is the registry URL and digest of the image to be scanned.
  For example, `nginx@sha256:aa0afebbb3cfa473099a62c4b32e9b3fb73ed23f2a75a65ce1d4b4f55a5c2ef2`.

- `scanResults.location` is the registry URL where results are uploaded.
  For example, `my.registry/scan-results`.

Optional fields:

- `activeKeychains` is an array of enabled credential helpers to authenticate against registries using workload identity mechansims. See cloud registry documentation for details.

  ```yaml
  activeKeychains:
  - name: acr  # Azure Container Registry
  - name: ecr  # Elastic Container Registry
  - name: gcr  # Google Container Registry
  - name: ghcr # Github Container Registry
  ```

- `serviceAccountNames` includes:
  - `scanner` is the service account that runs the scan. Must have read access to `image`.
  - `publisher` is the service account that uploads results. Must have write access to `scanResults.location`.

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

#### Default Environment

Tekton Workspaces:

- `/home/app-scanning`: a memory-backed EmptyDir mount that contains service account credentials loaded by Tekton
- `/cred-helper`: a memory-backed EmptyDir mount containing:
  - config.json which combines static credentials with workload identity credentials when `activeKeychains` is enabled
  - trusted-cas.crt when SCST - Scan 2.0 is deployed with `caCertData`
- `/workspace`: a PersistentVolumeClaim to hold scan artifacts and results

Environment Variables:
If undefined by your `step` definition the environment uses the following default variables:

- HOME=/home/app-scanning
- DOCKER_CONFIG=/cred-helper
- XDG_CACHE_HOME=/workspace/.cache
- TMPDIR=/workspace/tmp
- SSL_CERT_DIR=/etc/ssl/certs:/cred-helper

Tekton Pipeline Parameters:

These parameters are populated after creating the GrypeImageVulnerabilityScan. For information about parameters, see the [Tekton documentation](https://tekton.dev/docs/pipelines/pipelines/#specifying-parameters).

| Parameters | Default | Type | Description |
| --- | --- | --- | --- |
| image | "" | string | The scanned image. |
| scan-results-path | /workspace/scan-results | string | Location to save scanner output. |
| trusted-ca-certs  | "" | string | PEM data from the installation's `caCertData`. |

#### Trigger your scan

To trigger your scan:

1. Deploy your ImageVulnerabilityScan to the cluster by running:

    ```console
    kubectl apply -f image-vulnerability-scan.yaml -n DEV-NAMESPACE
    ```

2. Child resources are created.

    - view the child PipelineRun, TaskRuns, and pods `kubectl get -l imagevulnerabilityscan pipelinerun,taskrun,pod -n DEV-NAMESPACE`

3. When the scanning completes, the status is shown. Specify `-o wide` to see the digest of the image scanned and the location of the
published results.

    ```console
    $ kubectl get imagevulnerabilityscans -n DEV-NAMESPACE -o wide

    NAME                 SCANRESULT                           SCANNEDIMAGE          SUCCEEDED   REASON
    generic-image-scan   registry/project/scan-results@digest nginx:latest@digest   True        Succeeded

    ```

## Retrieving Results

Scan results are uploaded to the container image registry as an [imgpkg](https://carvel.dev/imgpkg/) bundle.
To retrieve a vulnerability report:

1. Retrieve the result location from the ImageVulnerabilityScan CR Status
   ```console
   SCAN_RESULT_URL=$(kubectl get imagevulnerabilityscan my-scan -o jsonpath='{.status.scanResult}')
   ```

1. Download the bundle to a local directory and list the content
   ```console
   imgpkg pull -b $SCAN_RESULT_URL -o myresults/
   ls myresults/
   ```


## <a id="observability"></a> Observability

To watch the status of the scanning CRDs and child resources:

```console
kubectl get grypeimagevulnerabilityscan,imagevulnerabilityscan
kubectl get -l imagevulnerabilityscan pipelinerun,taskrun,pod'
```

View the status, reason, and urls:

```console
kubectl get grypeimagevulnerabilityscan -o wide
kubectl get imagevulnerabilityscan -o wide
```

View the complete status and events of scanning CRDs:

```console
kubectl describe grypeimagevulnerabilityscan
kubectl describe imagevulnerabilityscan
```

List the child resources of a scan:

```console
kubectl get -l grypeimagevulnerabilityscan=$NAME pipelinerun,taskrun,pod,configmap
kubectl get -l imagevulnerabilityscan=$NAME pipelinerun,taskrun,pod
```

Get the logs of the controller:

```console
kubectl logs -f deployment/app-scanning-controller-manager -n app-scanning-system -c manager
```

## Troubleshooting

## <a id="debugging-commands"></a> Debugging commands

The following sections describe commands you can run to get logs and details about scanning errors.

### <a id="debug-source-image-scan"></a> Debugging resources

If a resource fails or has errors, inspect the resource.

To get status conditions on a resource:

```console
kubectl describe RESOURCE RESOURCE-NAME -n DEV-NAMESPACE
```

Where:

- `RESOURCE` is one of the following: `GrypeImageVulnerabilityScan`, `ImageVulnerabilityScan`, `PipelineRun`, or `TaskRun`.
- `RESOURCE-NAME` is the name of the `RESOURCE`.
- `DEV-NAMESPACE` is the name of the developer namespace you want to use.

### <a id="debugging-scan-pods"></a> Debugging scan pods

To get error logs from a pod when scan pods fail:

```console
kubectl logs SCAN-POD-NAME -n DEV-NAMESPACE
```

Where `SCAN-POD-NAME` is the name of the scan pod.

For information
about debugging Kubernetes pods, see the [Kubernetes documentation](https://jamesdefabia.github.io/docs/user-guide/kubectl/kubectl_logs/).

A scan run that has an error means that one of the following init containers has a failure:

- `step-write-certs`
- `step-cred-helper`
- `step-publisher`
- `sidecar-sleep`
- `working-dir-initializer`

To inspect a specific init container in a pod:

```console
kubectl logs scan-pod-name -n DEV-NAMESPACE -c init-container-name
```

For information about debugging init container, see the [Kubernetes documentation](https://kubernetes.io/docs/tasks/debug/debug-application/debug-init-containers/).

### <a id="view-scan-controller-manager-logs"></a> Viewing the Scan-Controller manager logs

To retrieve scan-controller manager logs:

```console
kubectl logs deployment/app-scanning-controller-manager -n app-scanning-system
```

To tail scan-controller manager logs:

```console
kubectl logs -f deployment/app-scanning-controller-manager -n app-scanning-system
```

### <a id="debug-scanning-in-supplychain"></a> Debugging scanning within a SupplyChain

You can use workload commands to tail build and runtime logs, get workload
status, and get workload details. See [Debugging
workloads](../cli-plugins/apps/debug-workload.hbs.md). 
