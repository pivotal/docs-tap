# Architecture

This topic describes architecture of Supply Chain Security Tools (SCST) - Artifact Metadata Repository (AMR).

[//]: # (TODO(dhoang): Insert Architecture Image)

AMR Observer consists of managed controllers that watch on resources. In TAP 1.6, AMR Observer can watch for ImageVulnerabilityScans and workload ReplicaSets*. When changes to these resources occur, AMR Observer will create CloudEvents and send these events to Artifact Metadata Repository CloudEvent Handler. Artifact Metadata Repository CloudEvent Handler will then consume these CloudEvents and make the required API calls to Metadata Store and Artifact Metadata Repository. 

\* “workload ReplicaSets” are ReplicaSets that contain one container named workload, as it is produced by the Out of the Box SupplyChains.
