# Supply Chain Security Tools - App Scanning (alpha)

Alpha release
Not installed by default with any profile
Dependency on the tekton-pipelines component

## Overview

## Features

## Installing App Scanning in a cluster

### <a id='scst-policy-prereqs'></a> Prerequisites

- Complete all prerequisites to install Tanzu Application Platform. For more information, see [Prerequisites](../prerequisites.md).

### <a id='install-scst-policy'></a> Install

To install Supply Chain Security Tools - App Scanning

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
  workspace.pullSecret    100Mi           string   Size of the Persistent Volume to be used by the tekton pipelineruns
  workspace.storageClass                  string   Name of the storage class to use while creating the Persistent Volume Claims
                                                   used by tekton pipelineruns
```

1. Create a file named `app-scanning-values-file.yaml` and add the setting you want for the installation

1. Install the package:

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

App scanning package should be up and running in your cluster

## Configure and trigger a scan

### Setup namespace

1. Access needed

  - Read access to pull tap images
  - Read access to pull the image to scan (if a private image is scanned)
  - Write access to a registry to publish the result

1. Create a `kubernetes.io/dockerconfigjson` secret which has read access to the tap bundles

```bash
kubectl create secret docker-registry scanning-tap-component-read-creds \
  --docker-username=<TAP-REGISTRY-USERNAME> \ 
  --docker-password=<TAP-REGISTRY-PASSWORD> \
  --docker-server=<TAP-REGISTRY-URL>
```

1. If you are scanning a private image, create a secret which has read access to that image

```bash
kubectl create secret docker-registry scan-image-read-creds \
  --docker-username=<REGISTRY-USERNAME> \
  --docker-password=<REGISTRY-PASSWORD> \
  --docker-server=<REGISTRY-URL>
```

1. Create a `kubernetes.io/dockerconfigjson` secret which has write access to where you
want the scanner to upload the result. The same secret will be used to read private image 

```bash
kubectl create secret docker-registry write-creds \
  --docker-username=<WRITE-USERNAME> \
  --docker-password=<WRITE-PASSWORD> \
  --docker-server=<DESTINATION-REGISTRY-URL>
```

1. Create a service account and attach the read secret created above as `imagePullSecrets` and
the write secret as `secrets`

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

1. Create service account for publisher

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

#### Trigger a grype scan

1. Create the `GrypeImageVulnerabilityScan` and apply to the cluster

```yaml
apiVersion: app-scanning.apps.tanzu.vmware.com/v1alpha1
kind: GrypeImageVulnerabilityScan
metadata:
  name: grypescan
spec:
  image: nginx:latest # The image that has to be scanned
  scanResults:
    location: registry/project/scan-results # Place to upload scan results
  serviceAccountNames:
    scanner: scanner # Service account that enables scanning component to pull the image to be scanned
    publisher: publisher # Service account has the secrets to push the scan results
```

1. When the scanning successfull completes, the digest of the image scanned and the location of the
published results are show

```console
$ kubectl get givs grypescan

NAME        SCANRESULT                           SCANNEDIMAGE          SUCCEEDED   REASON
grypescan   registry/project/scan-results@digest nginx:latest@digest   True        Succeeded

```

#### Integrate your own scanner

If you want to scan with any other scanner, use the generic `ImageVulnerabilityScan` 

```yaml
apiVersion: app-scanning.apps.tanzu.vmware.com/v1alpha1
kind: ImageVulnerabilityScan
metadata:
  name: generic-image-scan
spec:
  image: nginx
  scanResults:
    location: registry/project/scan-results
  serviceAccountNames:
    scanner: scanner
    publisher: publisher
  steps:
  - name: trivy
    image: aquasec/trivy:latest
    command: ["trivy"]
    args:
    - image
    - --format
    - cyclonedx
    - --output
    - /workspace/scan-results/scan.cdx
    - nginx:1.16
```

1. When the scanning successfull completes, the digest of the image scanned and the location of the
published results are show

```console
$ kubectl get ivs

NAME                 SCANRESULT                           SCANNEDIMAGE          SUCCEEDED   REASON
generic-image-scan   registry/project/scan-results@digest nginx:latest@digest   True        Succeeded

```

#### Specify configuration of the scanner through configmaps

The `ImageVulnerabilityScan` CRD has to be used

1. Create a config map with configuration needed for the scanner

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: grype-scanner-configuration
data:
  config.yaml: |
    ---
    output: "cyclonedx"
    file: "/workspace/scan-results/scan.cdx"
    log:
      structured: false
```

1. Bind the configmap as a workspace in the `ImageVulnerabilityScan` CRD

```yaml
apiVersion: app-scanning.apps.tanzu.vmware.com/v1alpha1
kind: ImageVulnerabilityScan
metadata:
  labels:
    app.kubernetes.io/name: imagevulnerabilityscan
    app.kubernetes.io/instance: imagevulnerabilityscan-sample
    app.kubernetes.io/part-of: app-scanning
    app.kubernetes.io/managed-by: kustomize
    app.kubernetes.io/created-by: app-scanning
  name: imagevulnerabilityscan-with-configmap
spec:
  image: nginx
  scanResults:
    location: registry/team/scan-results
  serviceAccountNames:
    scanner: scanner
    publisher: publisher
  workspace: # Attach the configmap as a worksapce
    bindings:
    - name: source
      configMap:
        name: my-configmap
  steps:
  - name: grype
    image: anchore/grype:latest
    args:
    - registry:$(params.image)
    - --config
    - /source/config.yaml # Use it as a config file
    env:
    - name: GRYPE_ADD_CPES_IF_NONE
      value: "false"
    - name: GRYPE_EXCLUDE
    - name: GRYPE_SCOPE
```

Refer to [Using other types of volume sources](https://tekton.dev/docs/pipelines/workspaces/#using-other-types-of-volumesources)
to try out other workspace bindings.

### Use with OOTB supply chains


## Troubleshooting

Get the logs of the controller

```console
kubectl logs -f deployment/app-scanning-controller-manager -n app-scanning-system -c manager
```

To check the status of the scanning CRDs

```console
watch kubectl get givs,ivs,prs,trs,pod
```