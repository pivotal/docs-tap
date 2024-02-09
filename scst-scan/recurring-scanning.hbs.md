# Set up recurring scanning

This topic describes how to set up recurring scans using Supply Chain Security Tools
(SCST) - Scan 2.0.

## <a id="overview"></a>Overview

As new vulnerabilities are reported daily, it is important to scan workloads with updated
vulnerability databases frequently. Use the
scanner of your choice to scan images produced by your software supply chain, and any
container image running in your Tanzu Application Platform clusters.

Use SCST - Scan 2.0 to schedule container image scans with the following capabilities:

Detect vulnerabilities without a supply chain run for the following container image sources:

- Images produced by the supply chain using Tanzu Build Service or kaniko
- Images defined in a workload when using a prebuilt container image in your supply chain
- Images running in a Tanzu Application Platform cluster that was not produced by a software supply chain

Customize how far back you want to scan container images based on:

- When the container image was created in the supply chain
- When the container image entered a running state on your Tanzu Application Platform cluster

Use one of the ImageVulnerabilityScan samples or create your own.
For more information, see [ImageVulnerabilityScan samples](ivs-custom-samples.hbs.md#overview) or [Bring your own scanner using an ImageVulnerabilityScan](ivs-create-your-own.hbs.md).

View discovered vulnerabilities from your most recent image in the Tanzu Developer Portal Supply Chain Choreographer plug-in

Use when either Scan 1.0 or Scan 2.0 is defined as your supply chain scanning component

## <a id="recurring-scanning-setup"></a>Set up recurring scanning

To set up recurring scanning, you must create a `recurringimagevulnerabilityscan`. This defines the
following:

- The interval in which to scan container images in crontab format
- How far back (in days) of images created via the supply chain to scan
- How far back (in days) of images that have started in your Tanzu Application Platform clusters to scan
- The steps from [IVS template]() to use to scan your images, which defines what scanner to use
- The OCI compliant container registry to push the recurring scan results to

### <a id="preqrequisites"></a>Prerequisites

Before you define your `recurringimagevulnerabilityscan` template, you must have the following:

- A repository created on an OCI compliant container registry that scan results are pushed to
- A service account that can push an OCI artifact to the results repository
- Credentials for any registry the scanner needd to pull images from to scan

The prerequisites for recurring scan are the same as Scan 2.0. For service accounts and credentials,
you can do this manually following the Scan 2.0 directions, but the recommended approach is to use
Namespace Provisioner to create a namespace. This creates all of the required resources needed for
recurring scanning to work. The examples in this topic use Namespace Provisioner. For more
information, see [Namespace Provisioner](..//namespace-provisioner/about.hbs.md).

### <a id="example-template"></a>Example recurringimagevulnerabilityscan Template

Below is a sample template with an explanation of the input variables for the `recurringimagevulnerabilityscan` CR. Use the Grype and Trivy samples in a namespace created by
Namespace Provisioner in a simple environment. The Grype and Trivy examples are a subset of this template. Additional configurations from this template can be added to the Grype and Trivy samples for more advanced configurations.

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

- `RAN-INTERVAL`: How many prior days of images from pods that have started on the Tanzu Application Platform clusters to scan.
- `CREATED-INTERVAL` How many prior days of images from supply chains to scan.
- `FAILED-RETENTION`: The number of failed recurring scan executions to keep in Kubernetes.
- `CRON-SCHEDULE`: The schedule in which to invoke recurring scans in crontab format. For example,
to execute a scan daily at 3:00 AM, the value is `0 3 * * *`
- `START-DEADLINE`: The period of time beyond the scheduled start time that scans can be started in the event they did not start on time.  If this period elapses, the scheduled scan is skipped.
- `SUCESSFUL-RETENTION`: The number of successful recurring scan executions to keep in Kubernetes.
- `WORKSPACESIZE`: The size of the workspace used when scanning images. This is created as a Kubernetes PVC.  This depends mostly on the size of the vulnerability database, the number of images to be scanned, and the output of the vulnerability scanner. `3Gi` is the recommended starting point.
- `RESULTS-REPOSITORY`: The registry URL where results are uploaded. For example, `my.registry/scan-results`.
- `STEPS-FROM-IVS-TEMPLATE`: The steps to execute to scan the list of the container images.  See [IVS samples](ivs-custom-samples.hbs.md) for commonly used samples.

### <a id="grype-rivs-template"></a>Grype recurringimagevulnerabilityscan template

The Scan 1.0 default scanner is Grype, and this template works with the Scan 1.0
default configuration.

To apply this configuration, save it to a file and apply it to the namespace created for recurring
scans:

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

### <a id="trivy-rivs-template"></a>Trivy recurringimagevulnerabilityscan template

The SCST - Scan 2.0 default scanner is Trivy, and this template works with the Scan
2.0 default configuration.

To apply this configuration, save it to a file and apply it to the namespace created for recurring
scans:

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
