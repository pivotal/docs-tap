# Supply Chain Security Tools - App Scanning (alpha)

>**Important** This component is in Alpha, which means that it is still in active
>development by VMware and might be subject to change at any point. Users might
>encounter unexpected behavior.  This is an opt-in component
>is not installed by default with any profile.

## <a id="overview"></a>Overview

The App Scanning component within the Supply Chain Security Tools is responsible for providing the framework to scan applications for their security posture. Scanning container images for known Common Vulnerabilities and Exposures (CVEs) implements this framework .

This component is in Alpha and supersedes the [SCST-Scan component](overview.hbs.md)

A core tenet of the app-scanning framework architecture is to simplify integration for new plug-ins by allowing users to integrate new scan engines by minimizing the scope of the scan engine to only scanning and pushing results to an OCI Compliant Registry.

## <a id="features"></a>Features

SCST App Scanning includes the following features:

- Tekton is leveraged as the orchestrator of the scan to align with overall Tanzu Application Platform use of Tekton for multi-step activities.
- New Scans are defined as CRDs that represent specific scanners (e.g. GrypeImageVulnerabilityScan).  Mapping logic turns the domain-specific specifications into a Tekton PipelineRun.
- CycloneDX-formatted scan results are pushed to an OCI registry for long-term storage.

## Installing App Scanning in a cluster

The following sections describe how to install SCST - App Scanning.

### <a id='scst-app-scanning-prereqs'></a> Prerequisites

SCST App Scanning requires the following prerequisites:

- Complete all prerequisites to install Tanzu Application Platform. For more information, see [Prerequisites](../prerequisites.md).
- Install the [Tekton component](../tekton/install-tekton.hbs.md). Tekton is included in the Full and Build profiles of Tanzu Application Platform.

### <a id='install-scst-app-scanning'></a> Install

To install Supply Chain Security Tools - App Scanning:

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

    ```console
    tanzu package available get app-scanning.apps.tanzu.vmware.com/VERSION --values-schema --namespace tap-install
    ```

    Where `VERSION` is the version number you discovered. For example, `0.1.0-alpha`.

    For example:

    ```console
    tanzu package available get app-scanning.apps.tanzu.vmware.com/0.1.0-alpha --values-schema --namespace tap-install
    | Retrieving package details for app-scanning.apps.tanzu.vmware.com/0.1.0-alpha...

      KEY                     DEFAULT         TYPE     DESCRIPTION
      docker.import           true            boolean  Import `docker.pullSecret` from another namespace (requires
                                                      secretgen-controller). Set to false if the secret will already be present.
      docker.pullSecret       registry-creds  string   Name of a docker pull secret in the deployment namespace to pull the scanner
                                                      images.
      workspace.storageSize   100Mi           string   Size of the Persistent Volume to be used by the tekton pipelineruns
      workspace.storageClass                  string   Name of the storage class to use while creating the Persistent Volume Claims
                                                      used by tekton pipelineruns
      caCertData                              string   The custom certificates to be trusted by the scan's connections
    ```

2. Create a file named `app-scanning-values-file.yaml` and add the setting you want for the installation

3. Install the package:

    ```console
    tanzu package install app-scanning-alpha --package-name app-scanning.apps.tanzu.vmware.com \
        --version VERSION \
        --namespace tap-install \
        --values-file app-scanning-values-file.yaml
    ```

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

  App scanning package is up and running in your cluster.

## Configure namespace

The following sections describe how to configure service accounts and registry credentials.

1. The following access is required:

  - Read access to pull tap images
  - Read access to pull the image to scan (if a private image is scanned)
  - Write access to a registry to publish the result

1. Create a `kubernetes.io/dockerconfigjson` secret which has read access to the tap bundles.

    >**Important** If you followed the directions for setting up Tanzu Application Platform, you can skip this step and use the `tap-registry` secret with your service account.

    ```console
    read -s TAP_REGISTRY_PASSWORD
    kubectl create secret docker-registry scanning-tap-component-read-creds \
      --docker-username=TAP-REGISTRY-USERNAME \
      --docker-password=$TAP_REGISTRY_PASSWORD \
      --docker-server=TAP-REGISTRY-URL
    ```

2. If you are scanning a private image, create a secret which has read access to that image.

    >**Important** If you followed the directions for setting up Tanzu Application Platform, you can skip this step and use the `tap-registry` secret with your service account.

    ```console
    read -s REGISTRY_PASSWORD
    kubectl create secret docker-registry scan-image-read-creds \
      --docker-username=REGISTRY-USERNAME \
      --docker-password=$REGISTRY_PASSWORD \
      --docker-server=REGISTRY-URL
    ```

3. Create a `kubernetes.io/dockerconfigjson` secret which has write access to where you
want the scanner to upload the result .

    ```console
    read -s WRITE_PASSWORD
    kubectl create secret docker-registry write-creds \
      --docker-username=WRITE-USERNAME \
      --docker-password=$WRITE_PASSWORD \
      --docker-server=DESTINATION-REGISTRY-URL
    ```

1. Create a service account and attach the read secret created earlier as `imagePullSecrets` and
the write secret as `secrets`.

    ```yaml
    apiVersion: v1
    kind: ServiceAccount
    metadata:
      name: scanner
    imagePullSecrets:
    - name: scanning-tap-component-read-creds # Used by the component to pull the scan component image from tap registry
    secrets:
    - name: scan-image-read-creds # Used by the component to pull the image to scan. Needed if
                                  # the image you are scanning is private
    ```

1. Create service account for publisher.

    ```yaml
    apiVersion: v1
    kind: ServiceAccount
    metadata:
      name: publisher
    imagePullSecrets:
    - name: scanning-tap-component-read-creds # Used by the component to pull the scan component image from tap registry
    secrets:
    - name: write-creds # Used by the component to publish the scan results
    ```

## Scan an image

The following section describe how to scan an image with SCST - App Scanning.

### Retrieving an image digest

The App Scanning CRs require the digest form of the URL. For example,  nginx@sha256:aa0afebbb3cfa473099a62c4b32e9b3fb73ed23f2a75a65ce1d4b4f55a5c2ef2.

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

The following sections describe how to use Grype with SCST - App Scanning.

#### Sample Grype scan

To create a sample Grype scan:

1. Create a file named `grype-image-vulnerability-scan.yaml`. Configure the `image` and `scanResults.location`:

    ```yaml
    apiVersion: app-scanning.apps.tanzu.vmware.com/v1alpha1
    kind: GrypeImageVulnerabilityScan
    metadata:
      name: grypescan
    spec:
      image: nginx@sha256:... # The image that has to be scanned. Digest must be specified.
      scanResults:
        location: registry/project/scan-results # Place to upload scan results
      serviceAccountNames:
        scanner: scanner # Service account that enables scanning component to pull the image to be scanned
        publisher: publisher # Service account has the secrets to push the scan results
    ```

#### Configuration Options

This section describes optional and required GrypeImageVulnerabilityScan specifications.

Required fields:

- image 
  The registry URL and digest of the scanned image.
  For example, `nginx@sha256:aa0afebbb3cfa473099a62c4b32e9b3fb73ed23f2a75a65ce1d4b4f55a5c2ef2`

- scanResults.location
  The registry URL where results are uploaded.
  For example, `my.registry/scan-results`.

Optional fields:

- activeKeychains
  Array of enabled credential helpers to authenticate against registries using workload identity mechansims. See cloud registry documentation for details.

  ```yaml
  activeKeychains:
  - name: acr  # Azure Container Registry
  - name: ecr  # Elastic Container Registry
  - name: gcr  # Google Container Registry
  - name: ghcr # Github Container Registry
  ```

- advanced
  Adjust the configuration of Grype for your needs. See Grype's [configuration](https://github.com/anchore/grype#configuration) for details.

- serviceAccountNames
  - scanner
    Set the service account that runs the scan. Must have read access to `image`.
  - publisher
    Set the service account that uploads results. Must have write access to `scanResults.location`.

- workspace
  - size
    Size of the PersistentVolumeClaim the scan uses to download the image and vulnerability database.
  - bindings
    Additional array of secrets, ConfigMaps, or EmptyDir volumes to mount to the
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
    kubectl apply -f grype-image-vulnerability-scan.yaml
    ```

1. Child resources are created.

    - view the child ImageVulnerabilityScan by running: `kubectl get imagevulnerabilityscan`
    - view the child PipelineRun, TaskRuns, and pods by running: `kubectl get -l imagevulnerabilityscan pipelinerun,taskrun,pod`

1. When the scanning completes, the status is shown. Specify `-o wide` to see
the digest of the image scanned and the location of the published results.

    ```console
    $ kubectl get givs grypescan -o wide

    NAME        SCANRESULT                           SCANNEDIMAGE          SUCCEEDED   REASON
    grypescan   registry/project/scan-results@digest nginx:latest@digest   True        Succeeded

    ```

### Integrate your own scanner

To scan with any other scanner, use the generic `ImageVulnerabilityScan`. ImageVulnerabilityScans can also change the version of a scanner or customize the behavior of provided scanners.

ImageVulnerabilityScans allow you to define your scan as a [Tekton Step](https://tekton.dev/docs/pipelines/tasks/#defining-steps)

#### Sample ImageVulnerabilityScan

To create a sample Sample ImageVulnerabilityScan:

1. Create a file named `image-vulnerability-scan.yaml`. Configure the `image`, `scanResults.location` of the scan, and define the scanner `image`, `command`, and `args` for your scanner `step`:

  ```yaml
  apiVersion: app-scanning.apps.tanzu.vmware.com/v1alpha1
  kind: ImageVulnerabilityScan
  metadata:
    name: generic-image-scan
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

#### Configuration Options

This section lists optional and required ImageVulnerabilityScan specifications fields.

Required fields:

- image
  The registry URL and digest of the image to be scanned.
  For example, `nginx@sha256:aa0afebbb3cfa473099a62c4b32e9b3fb73ed23f2a75a65ce1d4b4f55a5c2ef2`.

- scanResults.location
  The registry URL where results are uploaded.
  For example, `my.registry/scan-results`.

Optional fields:

- activeKeychains
  Array of enabled credential helpers to authenticate against registries using workload identity mechansims. See cloud registry documentation for details.

  ```yaml
  activeKeychains:
  - name: acr  # Azure Container Registry
  - name: ecr  # Elastic Container Registry
  - name: gcr  # Google Container Registry
  - name: ghcr # Github Container Registry
  ```

- serviceAccountNames
  - scanner
    Set the service account that runs the scan. Must have read access to `image`.
  - publisher
    Set the service account that uploads results. Must have write access to `scanResults.location`.

- workspace
  - size
    Size of the PersistentVolumeClaim the scan uses to download the image and vulnerability database.
  - bindings
    Additional array of secrets, ConfigMaps, or EmptyDir volumes to mount to the running scan. The `name` is used as the mount path.

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

Workspaces:

- /home/app-scanning: a memory-backed EmptyDir mount that contains service account credentials loaded by Tekton
- /cred-helper: a memory-backed EmptyDir mount containing:
  - config.json combines static credentials with workload identity credentials when `activeKeychains` is enabled
  - trusted-cas.crt when App Scanning is deployed with `caCertData`
- /workspace: a PVC to hold scan artifacts and results

Environment Variables:
If undefined by your `step` definition the environment uses the following default variables:

- HOME=/home/app-scanning
- DOCKER_CONFIG=/cred-helper
- XDG_CACHE_HOME=/workspace/.cache
- TMPDIR=/workspace/tmp
- SSL_CERT_DIR=/etc/ssl/certs:/cred-helper

Parameters:

- $(params.image): the image to be scanned
- $(params.scan-results-path): location to save scanner output
- $(params.trusted-ca-certs): PEM data from the installation's `caCertData`

#### Trigger your scan

To trigger your scan:

1. Deploy your ImageVulnerabilityScan to the cluster by running:

    ```console
    kubectl apply -f image-vulnerability-scan.yaml
    ```

2. Child resources are created.

    - view the child PipelineRun, TaskRuns, and pods `kubectl get -l imagevulnerabilityscan pipelinerun,taskrun,pod`

3. When the scanning completes, the status is shown. Specify `-o wide` to see the digest of the image scanned and the location of the
published results.

    ```console
    $ kubectl get ivs -o wide

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

2. Download the bundle to a local directory and list the content
   ```console
   imgpkg pull -b $SCAN_RESULT_URL -o myresults/
   ls myresults/
   ```

## Troubleshooting

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