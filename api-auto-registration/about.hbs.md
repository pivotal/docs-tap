# API Auto Registration

## <a id='overview'></a> Overview

API Auto Registration automates the registration of API specification defined in a workload's configuration. The registered 
API specification will then be accessible in TAP GUI without any additional manual steps. API Auto Registration is leveraged 
by an automated workflow using a supply chain to create and manage a Kubernetes Custom Resource (CR) of kind `APIDescriptor`. 
A Kubernetes controller will reconcile the CR and update the API entity in TAP GUI to achieve automated API specification 
registration from origin workloads. You may also use API Auto Registration without supply chain automation with other GitOps 
processes or by directly applying an `APIDescriptor` CR to the cluster.

## <a id='getting-started'></a> Getting Started

Learn more about APIDescriptor CR and API entities in TAP GUI in the [Key Concepts section](key-concepts.md)

For "iterate", "run" and "full" TAP cluster profiles, start at the [Usage section](usage.md)

For other profiles, install the api-auto-registration package using the [Installation section](installation.md)

Troubleshoot and debug problems using the tips mentioned in the [Troubleshooting section](troubleshooting.md)