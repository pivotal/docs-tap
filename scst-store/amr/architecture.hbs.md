# Architecture

This topic describes architecture of Artifact Metadata Repository (AMR) (alpha/beta).

**Important:** SCST - Artifact Metadata Repository (AMR) have components with alpha and beta statuses, which means that it is still in active development by VMware and might be subject to change at any point. Users might encounter unexpected behavior. This is an opt-in component to gather early feedback from alpha and beta testers and is not installed by default with any profile.

![Diagram of Architecture for AMR Interaction](../images/amr-arch.png)
[//]: # (^ diagram is produced from https://docs.google.com/drawings/d/1IChjcsCL8wcjQ4YG35JNWWy50TGZ1_N-osv-QTBnELg)

AMR Observer consists of managed controllers that watch on resources. In TAP 1.6, AMR Observer can watch for ImageVulnerabilityScans and workload ReplicaSets[1]. When changes to these resources occur, AMR Observer will create CloudEvents and send these events to Artifact Metadata Repository CloudEvent Handler. Artifact Metadata Repository CloudEvent Handler will then consume these CloudEvents and make the required API calls to Metadata Store and Artifact Metadata Repository. 

[1] "workload ReplicaSets" are ReplicaSets that contain one container named workload, as it is produced by the Out of the Box SupplyChains.
