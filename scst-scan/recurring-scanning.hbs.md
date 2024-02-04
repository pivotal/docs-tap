# Recurring Scanning

In a world where new vulnerabilities are reported daily, it is important that workloads are scanned with updated vulnerability databases frequently.  Tanzu Application Platform provides the capability to use the scanner of your choice to scan images produce by your software supply chain, as well as any container image running in your Tanzu Application Platform clusters.

## <a id="overview"></a>Overview

Scan 2.0 provides the ability to schedule container image scans with the following capabilities:

*  Detect vulnerabilities without a supply chain run for the following sources of container images:
** Images produced by the supply chain using Tanzu Build Service or Kaniko
** Images defined in a workload when using a prebuilt container image in your supply chain
** Images running in a TAP Cluster that was not produced by a software supply chain
* Customize how far back you want to scan container images based on
** When the container image was created via the supply chain
** When the container image entered a running state on your TAP Cluster
* Use the same [ImageVulnerabilityScan]() templates used in Scan 2.0 scans to use one of the provided [samples](scst-scan/ivs-custom-samples.hbs.md) or [create your own](scst-scan/ivs-create-your-own.hbs.md)
* View discovered vulnerabilities from your most recent image in the Tanzu Developer Portal Supply Chain Choreographer plugin
* Use when either Scan 1.0 or Scan 2.0 is defined as your supply chain scanning component

## <a id="recurring-scanning-setup"></a>Recurring Scanning Setup

In order to enable recurring scanning, you must create a recurringimagevulnerabilityscan.  This will define the following:

* The interval in which to scan container images in crontab format
* How far back (in days) of images created via the supply chain to scan
* How far back (in days) of images that have started in your TAP Clusters to scan
* The steps from [IVS template]() to use to scan your images, which defines what scanner to use
* The OCI compliant container registry to push the recurring scan results to

Below, this document will outline the prerequisites needed, an example template for recurring scanning, then a samples for Grype to use with the out of box default for Scan 1.0, and a sample for Trivy to use with the out-of-box default for Scan 2.0.

### <a id="preqrequisites"></a>Prerequisites

Before you define your recurringimagevulnerabilityscan template, you must have the following

A repository created on an OCI compliant container registry that will be used to push scan results to
A service account with the ability to push an oci artifact to the results repository
Credentials for any registry the scanner will need to pull images from to scan

The prerequisites for recurring scan are the same as Scan 2.0.  For service accounts and credentials, you can do this manually following the Scan 2.0 directions, but the recommended approach is to use the  namespace provisioner to create a namespace.  This will create all of the required resources needed for recurring scanning to work.  For the duration of this guide, we will assume namespace provisioner is used.

### <a id="example-template"></a>Example recurringimagevulnerabilityscan Template

Below is a sample template with an explanation of all the input variables that can be provided for the recurringimagevulnerabilityscan CR.  The samples for Grype and Trivy below are intended to used in a namespace that is created by the namespace provisioner and a simple environment.  As such, the Grype and Trivy examples are a subset of this template.  Additional configurations from this template can be added to the Grype and Trivy samples for more advanced configurations.  

```yaml
apiVersion: app-scanning.apps.tanzu.vmware.com/v1alpha1
kind: RecurringImageVulnerabilityScan
metadata:
  name: recurring-scan-template
spec:
  images:
    ranWithinDays: RAN-INTERVAL
    createdWithinDays: CREATED-INTERVAL
  retentionPolicy:
    maxFailedScans: FAILED-RETENTION
    maxSuccessfulScans: SUCESSFUL-RETENTION
  schedule:
    cron: CRON-SCHEDULE
    startingDeadline: START-DEADLINE
  scan:
    activeKeychains:
      # Only enable keychains for registries you are using
      - name: acr  # Azure Container Registry
      - name: ecr  # Elastic Container Registry
      - name: gcr  # Google Container Registry
      - name: ghcr # Github Container Registry
    workspace:
      size: WORKSPACESIZE
    scanResults:
      location: RESULTS-REPOSITORY
    steps:
      STEPS-FROM-IVS-TEMPLATE
```

    Where:

    - `RAN-INTERVAL` defines how many prior days of images from pods that have started on the TAP clusters should be scanned
    - `CREATED-INTERVAL` defines how many prior days of images from supply chains should be scanned
    - `FAILED-RETENTION` is the number of failed recurring scan executions to keep in Kubernetes.
    - `CRON-SCHEDULE` defines the schedule in which to invoke recurring scans in crontab format.  For example as used in the samples below, if you wanted to execute a scan daily at 3:00 AM, the value here would be `0 3 * * *`
    - `START-DEADLINE` is the period of time beyond the scheduled start time that scans can be started in the event they did not start on time.  If this period elapses, the scheduled scan will be skipped.
    - `SUCESSFUL-RETENTION` is the number of successful recurring scans executions to keep in Kubernetes.  
    - `WORKSPACESIZE` is the size of the workspace used when scanning images.  This will be created as a Kubernetes PVC.  This depends mostly on the size of the vulnerability database, number of images to be scanned, and the output of the vulnerability scanner.  Recommend `3Gi` as a starting point. 
    - `RESULTS-REPOSITORY` is the registry URL where results are uploaded. For example, `my.registry/scan-results`.
    - `STEPS-FROM-IVS-TEMPLATE` are the steps to execute to scan the list of the container images.  See [IVS samples](ivs-custom-samples.hbs.md) for commonly used samples.

### <a id="grype-rivs-template"></a>Grype recurringimagevulnerabilityscan Template

The default out-of-the-box scanner with Scan 1.0 is Anchore’s Grype, and this template is intended to pair with the Scan 1.0 out-of-the-box configuration.

To apply this configuration, save it to to a file and apply it to the namespace created for recurring scans by using the following command:

```console
kubectl apply -f grype-recurring-scan.yaml  --namespace <namespace>
```

```yaml
apiVersion: app-scanning.apps.tanzu.vmware.com/v1alpha1
kind: RecurringImageVulnerabilityScan
metadata:
  name: trivy-recurring-scan
spec:
  images:
    createdWithinDays: 180
    ranWithinDays: 0
  retentionPolicy:
    maxFailedScans: 1
    maxSuccessfulScans: 1
  schedule:
    cron: 0 3 * * *
    startingDeadline: 60m
  scan:
    workspace:
      size: 3Gi
    scanResults:
      location: RESULTS-REPOSITORY
   steps:
   - name: update-db
     image: anchore/grype:latest
     command: [/grype]
     args:
     - db
     - update
   - name: grype
     image: anchore/grype:latest
     command:
     - "/grype"
     args:
     - "{image}"
     - "-o"
     - "cyclonedx-json"
     - "--file"
     - "{output}"
   scanResults:
     location: "harbor.ryanbaker.io/scan-results/recurring-scan"
```

### <a id="trivy-rivs-template"></a>Trivy recurringimagevulnerabilityscan Template

The default out-of-the-box scanner with Scan 2.0 is Aqua Security’s Trivy, and this template is intended to pair with the Scan 2.0 out-of-the-box configuration.

To apply this configuration, save it to to a file and apply it to the namespace created for recurring scans by using the following command:

```console
kubectl apply -f trype-recurring-scan.yaml --namespace <namespace>
```

```yaml
apiVersion: app-scanning.apps.tanzu.vmware.com/v1alpha1
kind: RecurringImageVulnerabilityScan
metadata:
  name: trivy-recurring-scan
spec:
  images:
    createdWithinDays: 180
    ranWithinDays: 0
  retentionPolicy:
    maxFailedScans: 1
    maxSuccessfulScans: 1
  schedule:
    cron: 0 3 * * *
    startingDeadline: 60m
  scan:
    workspace:
      size: 3Gi
    scanResults:
      location: RESULTS-REPOSITORY
    steps:
    -  name: trivy-generate-report
       image: aquasec/trivy:0.48.3
       args:
       - image
       - '{image}'
       - --exit-code=0
       - --no-progress
       - --scanners=vuln
       - --format=cyclonedx
       - '{output}'
       env:
       - name: TRIVY_CACHE_DIR
         value: /workspace/trivy-cache
       - name: XDG_CACHE_HOME
         value: /workspace/.cache
       - name: TMPDIR
         value: /workspace
```