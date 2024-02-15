# Set up recurring scanning

This topic describes how to set up recurring scans using Supply Chain Security Tools
(SCST) - Scan 2.0.

## <a id="overview"></a>Overview

Scan workloads with updated vulnerability databases frequently. Use the
scanner of your choice to scan images produced by your software supply chain, and any
container images running in your Tanzu Application Platform clusters.

Use SCST - Scan 2.0 to schedule container image scans with the following capabilities:

- Detect vulnerabilities without a supply chain run for the following container image sources:

  - Images produced by the supply chain using Tanzu Build Service or kaniko.
  - Images defined in a workload when using a prebuilt container image in your supply chain.
  - Images running in a Tanzu Application Platform cluster that were not produced by a software supply chain.

- Customize how far back you want to scan container images based on:

  - When the container image was created in the supply chain.
  - When the container image entered a running state on your Tanzu Application Platform cluster.

- Use one of the `ImageVulnerabilityScan` samples or create your own.
  - For more information, see [ImageVulnerabilityScan samples](ivs-custom-samples.hbs.md#overview) or [Bring your own scanner using an ImageVulnerabilityScan](ivs-create-your-own.hbs.md).

- View discovered vulnerabilities from your most recent image built for a workload in the Tanzu Developer Portal Supply Chain Choreographer plug-in.

- Use when either SCST - Scan 1.0 or SCST - Scan 2.0 is used to scan a recently built container in
your supply chain.

## <a id="recurring-scanning-setup"></a>Set up recurring scanning

To set up recurring scanning, you must create a `RecurringImageVulnerabilityScan`. This defines:

- The interval in which to scan container images in crontab format.
- How far back (in days) of images created using the supply chain to scan.
- How far back (in days) of images that have started in your Tanzu Application Platform clusters to scan.
- The steps from [IVS template](./ivs-custom-samples.hbs.md) to use to scan your images, which define what scanner to use.
- The OCI-compliant registry to push the recurring scan results to.

### <a id="preqrequisites"></a>Prerequisites

Before you define your `RecurringImageVulnerabilityScan` template, you must have:

- A repository created on an OCI compliant registry that scan results are pushed to.
- A service account that can push an OCI artifact to the results repository.
- Credentials for any registry the scanner must pull images from to scan.

Recurring scanning uses the SCST - Scan 2.0 component, which is included in the `Full` and `Build Profiles`.

> **Note** Special attention should be paid to the service accounts and credentials that are needed.
If you only use recurring scanning for images built in your supply chain, VMware recommends you
use Namespace Provisioner to create a namespace, which automatically creates the service accounts and
secrets needed. The examples in this topic use a namespace created by Namespace Provisioner. For more
information, see [Namespace Provisioner](..//namespace-provisioner/about.hbs.md).

### <a id="example-template"></a>Example RecurringImageVulnerabilityScan template

The following sample template provides an explanation of the input variables for the `RecurringImageVulnerabilityScan` CR. Use the Grype and Trivy samples in a namespace created by
Namespace Provisioner. The Grype and Trivy examples are a subset of this template. Add additional configurations from this template to the Grype and Trivy samples for more advanced configurations.

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
      size: WORKSPACE-SIZE
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
- `START-DEADLINE`: The period of time beyond the scheduled start time when scans can be started if they did not start on time. If this period elapses, the scheduled scan is skipped.
- `SUCESSFUL-RETENTION`: The number of successful recurring scan executions to keep in Kubernetes.
- `WORKSPACE-SIZE`: The size of the workspace used when scanning images. This is created as a Kubernetes PVC.  This depends mostly on the size of the vulnerability database, the number of images to be scanned, and the output of the vulnerability scanner. `10Gi` is the recommended starting point.
- `RESULTS-REPOSITORY`: The registry URL where results are uploaded. For example, `my.registry/scan-results`.
- `STEPS-FROM-IVS-TEMPLATE`: The steps to execute to scan the list of the container images.  See [IVS samples](ivs-custom-samples.hbs.md) for commonly used samples.

### <a id="grype-rivs-template"></a>Grype RecurringImageVulnerabilityScan template

The SCST - Scan 1.0 default scanner is Grype, and this template works with the SCST - Scan 1.0
default configuration.

>**Note** You must match the scanner and version to the scanner and version used in the software
supply chain. Using different types of scanners between build time and recurring scans is not
supported and results in vulnerabilities being double counted in the Security Analysis plug-in
in Tanzu Developer Portal.

To apply this configuration, save it to a file and apply it to the namespace created for recurring
scans:

```console
kubectl apply -f grype-recurring-scan.yaml  --namespace <namespace>
```

```yaml
apiVersion: app-scanning.apps.tanzu.vmware.com/v1alpha1
kind: RecurringImageVulnerabilityScan
metadata:
  name: grype-recurring-scan
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
      size: 10Gi
    scanResults:
      location: RESULTS-REPOSITORY
    steps:
    - name: update-db
      image: anchore/grype:latest
      command: [/grype]
      args:
      - db
      - update
      env:
      - name: GRYPE_DB_CACHE_DIR
        value: /workspace/grype-cache
    - name: grype-scan
      image: anchore/grype:latest
      command: [/grype]
      args:
      - "{image}"
      - "-o"
      - "cyclonedx-json"
      - "--file"
      - "{output}"
      env:
      - name: GRYPE_DB_AUTO_UPDATE
        value: "false"
      - name: GRYPE_CHECK_FOR_APP_UPDATE
        value: "false"
      - name: GRYPE_DB_CACHE_DIR
        value: /workspace/grype-cache
```

This sample configuration, downloads the latest Grype vulnerability
database and then scans with the stored database. This prevents multiple database updates
while running concurrent scans.

### <a id="trivy-rivs-template"></a>Trivy RecurringImageVulnerabilityScan template

The SCST - Scan 2.0 default scanner is Trivy, and this template works with the Scan
2.0 default configuration.

>**Note** You must match the scanner and version to the scanner and version used in the software
supply chain. Using different types of scanners between build time and recurring scans is not
supported and results in vulnerabilities being double counted in the Security Analysis plug-in
in Tanzu Developer Portal.

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
      size: 10Gi
    scanResults:
      location: RESULTS-REPOSITORY
    steps:
    - name: update-db
      image: aquasec/trivy:0.48.3
      command: [/usr/local/bin/trivy]
      args:
      - image
      - --download-db-only
      - --no-progress
      - --cache-dir=/workspace/trivy-cache
    - name: update-java-db
      image: aquasec/trivy:0.48.3
      command: [/usr/local/bin/trivy]
      args:
      - image
      - --download-java-db-only
      - --no-progress
      - --cache-dir=/workspace/trivy-cache
    - name: trivy-generate-report
      image: aquasec/trivy:0.48.3
      command: [/usr/local/bin/trivy]
      args:
      - image
      - '{image}'
      - --exit-code=0
      - --no-progress
      - --scanners=vuln
      - --format=cyclonedx
      - --output={output}
      - --cache-dir=/workspace/trivy-cache
      - --skip-db-update
      - --skip-java-db-update
```

This sample configuration downloads the latest Trivy vulnerability
and Java databases and then scans with the stored databases. This prevents
multiple database updates while running concurrent scans.

>**Note** Do not enclose the `{output}` interpolation value in quotes for Trivy scan.
