# API Auto Registration

## <a id='overview'></a> Overview

API Auto Registration automates the registration of API specification defined in
a workload's configuration. The registered API specification is accessible in
Tanzu Application Platform GUI without any additional steps. An automated
workflow using a supply chain, leverages API Auto Registration to create and
manage a Kubernetes Custom Resource (CR) of kind `APIDescriptor`. A Kubernetes
controller periodically reconciles the CR and updates the API entity in Tanzu
Application Platform GUI to achieve automated API specification registration
from origin workloads. You might also use API Auto Registration without supply
chain automation, with other GitOps processes, or by directly applying an
`APIDescriptor` CR to the cluster.

![Flow chart with boxes for each element of the API Auto Registration process.](./images/autoregistering-api-entities-stages.png)

## <a id='getting-started'></a> Getting started

For information about the architecture of API Auto Registration, or the APIDescriptor CR and API entities in Tanzu Application Platform GUI, see [Key Concepts section](key-concepts.md).

For information about configuring iterate, run, and full Tanzu Application Platform cluster profiles, see [Configure API Auto Registration](configuration.hbs.md).

For information about generating API specs and registering them with the TAP GUI catalog, see [Use API Auto Registration](usage.hbs.md).

For information about other profiles, install the `api-auto-registration` package. See [Install API Auto Registration](installation.md).

Troubleshoot and debug problems using the tips in [Troubleshooting](troubleshooting.md).