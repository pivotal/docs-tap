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
