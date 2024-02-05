# Trivy Scanning Component

## Description

This document describes the Trivy Scanning Component for Tanzu Supply Chains. The Trivy Component provides out of the box trivy scanning that invokes [Supply Chain Security Tools - Scan 2.0](../../scst-scan/scan-2-0.hbs.md) in a Tanzu Supply Chain. See aquasecurity trivy [docs](https://github.com/aquasecurity/trivy) for more details on the trivy scanner.

## API

Component input: `image` is an input from the buildpack component

Workload input: `spec.registry` is where the scan results are uploaded

Workload input: `spec.source` is for the source component to retrieve source from git

Workload input: `spec.scanning` is for configurations for [Supply Chain Security Tools - Scan 2.0](../../scst-scan/scan-2-0.hbs.md)

Configuring the Trivy Scanning component:
```
spec:
  registry:
    repository: REGISTRY-REPOSITORY
    server: REGISTRY-SERVER
  source:
    git:
      branch: BRANCH-NAME
      url: GIT-URL
  scanning:
    service-account-scanner: SERVICE-ACCOUNT-SCANNER
    service-account-publisher: SERVICE-ACCOUNT-PUBLISHER
    active-keychains:
    workspace:
      bindings: WORKSPACE-BINDINGS
      size: WORKSPACE-SIZE
```
Where:
* REGISTRY-REPOSITORY is the registry server repository where scan results are uploaded
* REGISTRY-SERVER is the registry server where scan results are uploaded
* BRANCH-NAME is the git branch ref
* GIT-URL is the url to the git source repository
* SERVICE-ACCOUNT-SCANNER is the service account that runs the scan. It must have read access to the image being scanned.
* SERVICE-ACCOUNT-PUBLISHER is the service account that uploads results. It must have write access to where the scan results are being published which is the REGISTRY-SERVER/REGISTRY-REPOSITORY.
* spec.scanning.active-keychains is an array of enabled credential helpers to authenticate against registries using workload identity mechanisms.
* WORKSPACE-BINDINGS are additional array of secrets, ConfigMaps, or EmptyDir volumes to mount to the running scan. The name is used as the mount path.
* WORKSPACE-SIZE is size of the PersistentVolumeClaim the scan uses to download the image and vulnerability database.

**Note:** See more examples of these IVS configurations [here](../../scst-scan/ivs-create-your-own.hbs.md).

## Dependencies

* To enable this Trivy Scanning Component in the Tanzu Supply Chain workload, the following packages must be installed:
  * Supply Chain
  * Supply Chain Catalog
  * Managed Resource Controller
  * Tekton
  * [Supply Chain Security Tools - Scan 2.0](../../scst-scan/scan-2-0.hbs.md)
  * Source Component
  * Buildpack Component
  * Trivy Scanning Component
* RBAC enabled for the default ServiceAccount for the DEV-NAMESPACE to the buildpacks.

## Input Description

* The Trivy Component takes an `image` input from the buildpack component earlier in the supply chain. The component expects the `image` to be provided as a reference to a runnable artifact in an OCI registry. The Trivy Component will pass this `image` reference to the Supply Chain Security Tools Scan 2.0 to perform scanning.
* The Trivy Component takes a `git` input from the workload `spec.source` which is used for the correlation-id label on the ImageVulnerabilityScan.
