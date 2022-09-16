# API Auto Registration

## <a id='overview'></a> Overview

When users deploy a workload that exposes an API, they want that API to automatically show in TAP GUI without needing any other manual steps. API Auto Registration is an automated workflow that can use a supply chain to create and manage a k8s Custom Resource (CR) of type APIDescriptor, and a controller to reconcile the CR and update the API entity in TAP GUI to achieve automated API registration from workloads. You can also use API Auto Registration without supply chains by directly applying an APIDescriptor to the cluster.
