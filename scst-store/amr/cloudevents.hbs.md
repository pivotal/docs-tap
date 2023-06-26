# CloudEvent JSON Specification

AMR Observer utilizes CloudEvents to describe events and sends them to AMR CloudEvent Handler. The CloudEvent JSON specification for an ImageVulnerabilityScan is described below.

```json
{
   "specversion": "1.0",
   "id": "<ResourceVersion + ScanResult_filename>",
   "source": "<kube-system namespace UID>",
   "type": "vmware.tanzu.apps.image.sbom.pushed.v1",
   "subject": "/apis/app-scanning.apps.tanzu.vmware.com/v1alpha1/namespaces/<NAMESPACE>/imagevulnerabilityscans/<SCAN NAME>",
   "datacontenttype": "application/vnd.cyclonedx+xml;version=1.4",
   "time": "2023-02-07T19:50:31.436247579Z",
   "data": "<REPORT DATA HERE>",
   "name": "grypescan-m92q8",
   "namespace": "my-apps",
   "correlationid": "[optional] github.com/sample-accelerators/tanzu-java-web-app",
   "image": "<IMAGE_SCANNED>",
   "scanresults": "<SCAN_RESULTS_OCI_LOCATION>",
   "file": "<SCAN_FILENAME>",
   "workloaduid": "<WORKLOAD_UID>",
   "workloadname": "<WORKLOAD_NAME>",
   "workloadnamespace": "<WORKLOAD_NAMESPACE>",
}
```

## CloudEvent Required Attributes

CloudEvents have required attributes that must be defined.

* id
  * The combination of source+id must be unique for each distinct CloudEvent
	Therefore, we can utilize the resourceVersion and scanResult filename as an identifier
* source 
  * Use UID of kube-system namespace resource where the Observer is deployed
* specversion
  * MUST use a value of 1.0 when referring to this version of the specification
* type
  * Must be defined. AMR Observer and CloudEvent Handler support the usage of:
    * `vmware.tanzu.apps.image.sbom.pushed.v1`
      * Contains the ImageVulnerabilityScan report
      * Submits image scan reports to Metadata Store 
    * `vmware.tanzu.apps.image.sbom.pushed.v1alpha1`
      * Contains the ImageVulnerabilityScan report
      * Submits image scan reports to Metadata Store 
      * Submits artifact groups containing workload correlation to image scan reports to Metadata Store
    * `vmware.tanzu.apps.location.created.v1`
      * Contains cluster information and user defined labels
      * Submits cluster location to Artifact Metadata Repository
    * `dev.knative.apiserver.resource.add`
      * Backwards compatibility with Knative APIServerSource in Resource mode
      * AMR CloudEvent Handler supports ReplicaSets with workload named container
      * Submits ReplicaSet status to Artifact Metadata Repository
    * `dev.knative.apiserver.resource.updated`
      * Backwards compatibility with Knative APIServerSource in Resource mode
      * AMR CloudEvent Handler supports ReplicaSets with workload named container
      * Submits ReplicaSet status to Artifact Metadata Repository
    * `dev.knative.apiserver.resource.delete`
      * Backwards compatibility with Knative APIServerSource in Resource mode
      * AMR CloudEvent Handler supports ReplicaSets with workload named container
      * Submits ReplicaSet status to Artifact Metadata Repository* 

## CloudEvent Optional Attributes

CloudEvents have optional attributes that can be defined.

* subject
  * `/apis/<group>/<version>/namespace/<namespace-name>/<kind>/<name>`
* datacontenttype
  * Contains the metadata for the type of data in the data field. We can specify which XML data the scan results are with `application/vnd.cyclonedx+xml` or `application/spdx+json` such that the AMR CloudEvent-Handler knows which unmarshaller to use.
* data
  * Contains the scan result file content
* time
  * timestamp from the observed resource

## CloudEvent Extension Attributes

Fields that are not part of the required and optional attributes for CloudEvents will be considered an extension context attribute.

* correlationid
  * Optional
  * Contains the metadata of the mapping to the source of the resource being scanned.
* image
  * Required for `vmware.tanzu.apps.image.sbom.pushed.*` types
  * Contains the metadata of the scanned image and digest
* scanresults
  * Required
  * Contains the ScanResult OCI location such that AMR can reference where the original scan results are located when results are normalized.
* file
  * Required
  * Scan result filename
* workloaduid
  * Optional
  * Contains the workload UID. Utilized for associating artifact-groups
* workloadname
  * Optional
  * Contains the workload name. Utilized for associating artifact-groups
* workloadnamespace
  * Optional
  * Contains the workload namespace. Utilized for associating artifact-groups
