# Artifact Metadata Repository architecture

This topic gives you an overview of the Artifact Metadata Repository (AMR) architecture.

>**Important** Artifact Metadata Repository (AMR) has components with alpha and
>beta statuses, meaning that it is still in active development and is subject to
>change at any point. Users might encounter unexpected behavior. This is an
>opt-in component to gather early feedback from alpha and beta testers and is
>not installed by default with any profile.

![Diagram of Architecture for AMR Interaction shows the kubernetes resources that are part of the TAP resource in yellow](../images/amr-arch.png)

## <a id='amr-observer'></a> AMR Observer

The AMR Observer is deployed to the build and run clusters when it is
[enabled](install-amr-observer.hbs.md#install). It starts by communicating with
the Kubernetes API Server to obtain the cluster's location ID, which is the GUID
of the `kube-system` namespace. After you retrieve the location ID, the AMR
Observer emits a cloud event, including any operator-defined metadata, to the
Artifact Metadata Repository Cloud Event Handler (AMR Cloud Event Handler). This
cloud event registers the location, and subsequent cloud events in the same
cluster use the same location ID in the source field. This mechanism helps the
AMR keep track of artifacts and their associated location.

### <a id='watched-resources'></a> Watched resources

The AMR Observer consists of managed controllers that watch resources. In Tanzu
Application Platform 1.6, AMR Observer watches for `ImageVulnerabilityScans` and
workload `ReplicaSets`. Workload `ReplicaSets` are `ReplicaSets` that contain
one container named `workload` that the out of the box Supply Chain produces.

#### <a id='imagevulnerabilityscans'></a> ImageVulnerabilityScans

The AMR Observer watches the `ImageVulnerabilityScan` Custom Resources for
completed scans. When a scan is completed, the AMR Observer uses the `registry
secret` and the location information from the `ImageVulnerabilityScan` Custom
Resources to fetch the SBOM report. After obtaining the SBOM report, it wraps it
in a cloud event and emits it to the AMR Cloud Event Handler. The AMR Cloud
Event Handler persists this event in the Metadata Store.

#### <a id='replicaset'></a> ReplicaSet

The AMR Observer watches the runtime data of `ReplicaSet` Apps. It reads the
status of the `ReplicaSet`, including number of instances, created, updated,
deleted, and emits a cloud event to the AMR Cloud Event Handler. The AMR Cloud
Event Handler ensures the event is stored in the Artifact Metadata Repository.