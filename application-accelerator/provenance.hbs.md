# Track life cycle using Provenance transform

This topic tells you about the Application Accelerator `Provenance` transform in Tanzu Application
Platform, commonly known as TAP.

## <a id="overview"></a> Overview

Use the `Provenance` transform to track the life cycle of generated projects.

The `Provenance` transform generates a file that
provides details of the accelerator engine transform.

The `Provenance` transform provides traceability and visibility for the generation of an application
from an accelerator. The following information is embedded into a file that is part of the generated
project:

- Which accelerator was used to bootstrap the project
- Which version of the accelerator was used
- When the application was bootstrapped
- Who bootstrapped the application

For more information about the structure of the file and how to enable application bootstrapping
provenance, see [Provenance transform](creating-accelerators/transforms/provenance.hbs.md).

## <a id="amr"></a> Integration with AMR

Application Accelerator integrates with [Artifact Metadata Repository](../scst-store/overview.hbs.md) (AMR).

When you generate an application with an accelerator, an event that contains the same information captured by the `Provenance` transform is sent to the AMR store.

The relevant AMR data models are:

- [AppAcceleratorRuns](../scst-store/amr/data-model-and-concepts.hbs.md#appacceleratorruns): There is one AppAcceleratorRuns for each invocation of an accelerator, including version information about which accelerator was used.
- [AppAcceleratorFragments](../scst-store/amr/data-model-and-concepts.hbs.md#appacceleratorfragments): There is one instance of AppAcceleratorFragment for each named fragment used by the running accelerator. There are between `0` and `N` instances, `N` being the number of fragments used by the accelerator.

When invocations were recorded, use the
[AMR GraphQL](../scst-store/amr/graphql-query.hbs.md) capability to query the system about
accelerator use and gain insights about generated applications.

For more information about the AMR data model, how to use the Artifact Metadata Repository,
and some sample queries relevant to AppAcceleratorRuns, see the [Artifact Metadata Repository](../scst-store/overview.hbs.md).
