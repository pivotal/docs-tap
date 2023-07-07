# Supply Chain Security Tools - Artifact Metadata Repository Architecture

This topic describes the architecture of Artifact Metadata Repository (AMR).

>**Important** SCST - Artifact Metadata Repository (AMR) has components with alpha and beta statuses, meaning that it is still in active development and is subject to change at any point. Users might encounter unexpected behavior. This is an opt-in component to gather early feedback from alpha and beta testers and is not installed by default with any profile.

![Diagram of Architecture for AMR Interaction](../images/amr-arch.png)

AMR Observer consists of managed controllers that watch resources. In Tanzu Application Platform 1.6, AMR Observer watches for ImageVulnerabilityScans and workload ReplicaSets. Workload ReplicaSets are ReplicaSets that contain one container named workload that is produced by the out of the box Supply Chains.

When enabled, the AMR Observer is deployed to the build and run clusters. It starts by communicating with the Kubernetes API Server to obtain the cluster's location ID, which is the GUID of the kube-system namespace. Once the location ID is retrieved, the AMR Observer emits a cloud event, including any operator-defined metadata, to the Artifact Metadata Repository Cloud Event Handler (AMR Cloud Event Handler). This cloud event registration marks that particular location, and subsequent cloud events in the same cluster use the location ID in the source field. This mechanism helps the AMR keep track of observed locations and artifacts.

The AMR Observer focuses on two main tasks. Firstly, it observes the ImageVulnerabilityScan Custom Resources for completed scans. When a scan is finished, the AMR Observer utilizes the registry secret and the location information from the ImageVulnerabilityScan Custom Resources to fetch the SBOM report. After obtaining the SBOM report, it wraps it in a cloud event and emits it to the AMR Cloud Event Handler. The AMR Cloud Event Handler persists this event in the Metadata Store.

Secondly, the AMR Observer observes the runtime data of ReplicaSet Apps. It reads the status of the ReplicaSet (e.g., number of instances, created, updated, deleted) and emits a cloud event to the AMR Cloud Event Handler accordingly. The AMR Cloud Event Handler ensures the event is stored in the Artifact Metadata Repository.
