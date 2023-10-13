# Tracking Provenance with Application Accelerator

Application Accelerator provides several features to track
the lifecycle of generated projects. This topic is known as "provenance".

## Provenance Transform
This section tells you about the Application Accelerator `Provenance` transform in Tanzu Application Platform (commonly known as TAP).

The `Provenance` transform is a special transform used to generate a file that
provides details of the accelerator engine transform.

The `Provenance` transform provides traceability and visibility into the generation of an application from an accelerator. The following information is embedded into a file that is part of the generated project:

- Which accelerator was used to bootstrap the project
- Which version of the accelerator was used
- When the application was bootstrapped
- Who bootstrapped the application

For more information on the structure of the file and how to enable application bootstrapping provenance, see [Provenance transform](creating-accelerators/transforms/provenance.hbs.md).

## Integration with AMR
Application Accelerator also closely integrates with the [Artifact Metadata Repository](../scst-store/amr/overview.hbs.md) (AMR).

Every time an application is generated with an accelerator, an event is sent to the AMR store that
roughly captures the same set of information as described in the paragraph above.

The relevant AMR data models are [AppAcceleratorRun](../scst-store/amr/data-model-and-concepts.hbs.md#appacceleratorruns) (one for each invocation, also includes version information
about which accelerator was used) and [AppAcceleratorFragments](../scst-store/amr/data-model-and-concepts.hbs.md#appacceleratorfragments) (zero to N, tracks which fragments were used
in that particular invocation, if any).

Once some invocations have been recorded, you can use the [AMR GraphQL](../scst-store/amr/graphql-query.hbs.md) capability to query
the system about accelerator usage and gain insights about generated apps.

For more information on the AMR data model and how to use the Artifact Metadata Repository
(including some sample queries relevant to AppAcceleratorRun), see the [AMR section](../scst-store/amr/overview.hbs.md). 