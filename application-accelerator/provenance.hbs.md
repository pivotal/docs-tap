# Application Bootstrapping Provenance

This topic tells you about the Application Accelerator `Provenance` transform in Tanzu Application Platform (commonly known as TAP).

The `Provenance` transform is a special transform used to generate a file that
provides details of the accelerator engine transform.

The `Provenance` transform provides traceability and visibility into the generation of an application from an accelerator. The following information is embedded into a file that is part of the generated project:

- Which accelerator was used to bootstrap the project
- Which version of the accelerator was used
- When the application was bootstrapped
- Who bootstrapped the application

For more information on the structure of the file and how to enable application bootstrapping provenance, see [Provenance transform](creating-accelerators/transforms/provenance.hbs.md).