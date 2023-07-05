# Supply Chain Security Tools for Tanzu – Artifact Metadata Repository (AMR) (alpha/beta)

This topic gives you an overview of Supply Chain Security Tools (SCST) – Artifact Metadata Repository (AMR).

>**Important** SCST - Artifact Metadata Repository (AMR) has components with alpha and beta statuses, meaning that it is still in active development and is subject to change at any point. Users might encounter unexpected behavior. This is an opt-in component to gather early feedback from alpha and beta testers and is not installed by default with any profile.

## <a id='observer'></a> AMR Observer (alpha)

AMR Observer is a set of managed controllers that watches for relevant updates on resources of interest. When relevant events are observed, a CloudEvent is generated and sent to AMR CloudEvent-Handler to be relayed for storage in the Metadata Store. For information about CloudEvents, see [CloudEvent JSON Specification](./cloudevents.hbs.md)

## <a id='handler'></a> AMR CloudEvent Handler (beta)

AMR CloudEvent Handler receives CloudEvents from other sources, such as the AMR Observer, and stores relevant information into the Artifact Metadata Repository or Metadata Store.

## <a id='ki'></a> Known Issues

The following known issues are associated with SCST - AMR:

- Periodic reconciliation or restarting of the AMR Observer causes reattempted posting of ImageVulnerabilityScan results. There is an error on duplicate submission of identical ImageVulnerabilityScans that you can ignore if the previous submission was successful.
- ReplicaSet status in Artifact Metadata Repository only has two states, `created`, and `deleted`. There is a known issue where the `available` and `unavailable` state is not showing. The workaround is that you can  interpolate information from the `instances` metadata in the AMR for the ReplicaSet. 