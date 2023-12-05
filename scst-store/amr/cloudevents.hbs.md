# CloudEvent JSON specification for Supply Chain Security Tools - Artifact Metadata Repository

This topic tells you how Artifact Metadata Repository (AMR) Observer uses CloudEvents to describe events and send them to AMR CloudEvent Handler.

## <a id='required-attributes'></a> JSON specification

You can use the following CloudEvent JSON specification for an ImageVulnerabilityScan:

```json
{
   "specversion": "1.0",
   "id": "4461832-scan.cdx.xml", // ResourceVersion-ScanFilename
   "source": "d9fa1ee9-ba42-4262-aaf6-4128f99096b9", // Kube-system namespace UID
   "type": "vmware.tanzu.apps.image.sbom.pushed.v1", // CloudEvent Type
   "subject": "/apis/app-scanning.apps.tanzu.vmware.com/v1alpha1/namespaces/my-apps/imagevulnerabilityscans/grypescan-m92q8",
   "datacontenttype": "application/vnd.cyclonedx+xml",
   "time": "2023-02-07T19:50:31.436247579Z",
   "data": "<REPORT_DATA_HERE>", // scan.cdx.xml content
   "name": "grypescan-m92q8",
   "namespace": "my-apps",
   "correlationid": "github.com/sample-accelerators/tanzu-java-web-app",
   "image": "nginx@sha256:aa0afebbb3cfa473099a62c4b32e9b3fb73ed23f2a75a65ce1d4b4f55a5c2ef2", // scanned image
   "scanresults": "example.registry.com/scan-results@sha256:a9ad6728e08c0bdd8ad7524c129bd85137066332ba8ae0bb78750a07299d820b",
   "file": "scan.cdx.xml", // filename within scanresults bundle
   "workloaduid": "4da69791-b041-4ae6-95de-1e6b3d1fa0d6",
   "workloadname": "tanzu-java-web-app",
   "workloadnamespace": "my-apps",
}
```

## <a id='required-attributes'></a> Required CloudEvent attributes

CloudEvents have the following required attributes. See [required attributes](https://github.com/cloudevents/spec/blob/main/cloudevents/spec.md#required-attributes) in GitHub.

- `id`
  - The combination of `source` and `id` must be unique for each distinct CloudEvent. You can use the resourceVersion and scanResult filename as an identifier.
- `source` 
  - Use UID of kube-system namespace resource where the Observer is deployed.
- `specversion`
  - Must use a value of 1.0 when referring to this version of the specification.
- `type`
  - Must be defined. AMR Observer and CloudEvent Handler supports the use of:
    - `vmware.tanzu.apps.image.sbom.pushed.v1`
      - Contains the ImageVulnerabilityScan report
      - Submits image scan reports to Metadata Store 
    - `vmware.tanzu.apps.image.sbom.pushed.v1alpha1`
      - Contains the ImageVulnerabilityScan report
      - Submits image scan reports to Metadata Store 
      - Submits artifact groups containing workload correlation to image scan reports to Metadata Store
    - `vmware.tanzu.apps.location.created.v1`
      - Contains cluster kube-system namespace UID and user defined labels for location
      - Submits cluster location to Artifact Metadata Repository
    - `dev.knative.apiserver.resource.add`
      - Backwards compatibility with Knative APIServerSource in Resource mode
      - AMR CloudEvent Handler supports ReplicaSets with workload named container
      - Submits ReplicaSet status to Artifact Metadata Repository
    - `dev.knative.apiserver.resource.updated`
      - Backwards compatibility with Knative APIServerSource in Resource mode
      - AMR CloudEvent Handler supports ReplicaSets with workload named container
      - Submits ReplicaSet status to Artifact Metadata Repository
    - `dev.knative.apiserver.resource.delete`
      - Backwards compatibility with Knative APIServerSource in Resource mode
      - AMR CloudEvent Handler supports ReplicaSets with workload named container
      - Submits ReplicaSet status to Artifact Metadata Repository 

## <a id='optional-attributes'></a> Optional CloudEvent attributes

You can define the following CloudEvents optional attributes. See [optional attributes](https://github.com/cloudevents/spec/blob/main/cloudevents/spec.md#optional-attributes) in GitHub.

- `subject`
  - `/apis/<group>/<version>/namespace/<namespace-name>/<kind>/<name>`
- `datacontenttype`
  - Contains the metadata for the type of data in the data field. You can specify which XML data the scan results are with `application/vnd.cyclonedx+xml` or `application/spdx+json` so the AMR CloudEvent-Handler knows which unmarshaller to use.
- `data`
  - Contains the scan result file content
- `time`
  - Timestamp from the observed resource

## <a id='extension-attributes'></a> CloudEvent extension attributes

Fields that are not part of the required and optional attributes for CloudEvents are considered extension context attributes. See [extension context attributes](https://github.com/cloudevents/spec/blob/main/cloudevents/spec.md#extension-context-attributes) in GitHub.

- (Optional) `correlationid`
  - Contains the metadata of the mapping to the source of the resource being scanned.
- `image`
  - Required for `vmware.tanzu.apps.image.sbom.pushed.*` types
  - Contains the scanned image and digest
- `scanresults`
  - Required for `vmware.tanzu.apps.image.sbom.pushed.*` types
  - Contains the ScanResult OCI location so that AMR can reference where the original scan results are located when results are normalized.
- `file`
  - Required for `vmware.tanzu.apps.image.sbom.pushed.*` types
  - Scan result filename
- (Optional) `workloaduid`
  - Contains the workload UID. Utilized for associating artifact-groups in Metadata Store
- (Optional) `workloadname`
  - Contains the workload name. Utilized for associating artifact-groups in Metadata Store
- (Optional) `workloadnamespace`
  - Contains the workload namespace. Utilized for associating artifact-groups in Metadata Store

## <a id='batch'></a> Batch CloudEvents

If you use JSON batch format, you can send multiple CloudEvents to the AMR CloudEvent-Handler in a batch. For more information, see the [CloudEvents documentation](https://github.com/cloudevents/spec/blob/v1.0.2/cloudevents/formats/json-format.md#4-json-batch-format) in GitHub.
