# Track life cycle using Provenance transform

This topic tells you about the Application Accelerator `Provenance` transform in Tanzu Application
Platform (commonly known as TAP).

Use the `Provenance` transform to track the life cycle of generated projects.

The `Provenance` transform is a special transform used to generate a file that
provides details of the accelerator engine transform.

The `Provenance` transform provides traceability and visibility into the generation of an application
from an accelerator. The following information is embedded into a file that is part of the generated
project:

- Which accelerator was used to bootstrap the project
- Which version of the accelerator was used
- When the application was bootstrapped
- Who bootstrapped the application

For more information about the structure of the file and how to enable application bootstrapping
provenance, see [Provenance transform](creating-accelerators/transforms/provenance.hbs.md).

## Integration with AMR

Application Accelerator also closely integrates with the [Artifact Metadata Repository](../scst-store/amr/overview.hbs.md) (AMR).

When an application is generated with an accelerator, an event that contains the same information captured by the `Provenance` transform is sent to the AMR store.

The relevant AMR data models are:

- [AppAcceleratorRun](../scst-store/amr/data-model-and-concepts.hbs.md#appacceleratorruns). There is one AppAcceleratorRun for each invocation of an accelerator. Includes version information about which accelerator was used.
- [AppAcceleratorFragments](../scst-store/amr/data-model-and-concepts.hbs.md#appacceleratorfragments) There is one instance of AppAcceleratorFragment for each named fragment used by the accelerator being run. There is between 0 and N instances, N being the number of fragments used by the accelerator.

When some invocations have been recorded, use the
[AMR GraphQL](../scst-store/amr/graphql-query.hbs.md) capability to query the system about
accelerator usage and gain insights about generated applications.

For more information about the AMR data model, how to use the Artifact Metadata Repository,
and some sample queries relevant to AppAcceleratorRun, see the [Artifact Metadata Repository](../scst-store/amr/overview.hbs.md).
