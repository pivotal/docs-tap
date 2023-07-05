# Artifact Metadata Repository (AMR) (alpha/beta)

This topic gives you an overview of Artifact Metadata Repository (AMR).

**Important:** SCST - Artifact Metadata Repository (AMR) have components with alpha and beta statuses, which means that it is still in active development by VMware and might be subject to change at any point. Users might encounter unexpected behavior. This is an opt-in component to gather early feedback from alpha and beta testers and is not installed by default with any profile.

## AMR Observer (alpha)

AMR Observer is a set of managed controllers that will watch for relevant updates on resources of interest. When relevant events are observed, a CloudEvent will be generated and sent to AMR CloudEvent-Handler to be relayed for storage in the Metadata Store. For more information on CloudEvents, see [CloudEvent JSON Specification](./cloudevents.hbs.md)

## AMR CloudEvent Handler (beta)

AMR CloudEvent Handler receives CloudEvents from other sources, such as the AMR Observer, and stores relevant information into the Artifact Metadata Repository or Metadata Store.

## Known Issues

- Periodic reconciliation or restarting of the AMR Observer causes reattempted posting of ImageVulnerabilityScan results. There is an error on duplicate submission of identical ImageVulnerabilityScans which can be ignored so long as the previous submission was successful.

- ReplicaSet status in Artifact Metadata Repository only has two states, `created` and `deleted`. There is a known issue where the `available` and `unavailable` state is not showing. The workaround is that this information can be interpolated from the `instances` metadata in the AMR for the ReplicaSet. 