# API Auto Registration

## <a id='overview'></a> Overview

API Auto Registration automates the registration of API specification defined in a workload's configuration. The registered API specification will then be accessible in TAP GUI without any additional manual steps. API Auto Registration is leveraged by an automated worklow using a supply chain to create and manage a Kubernetes Custom Resource (CR) of kind `APIDescriptor`. A Kubernetes controller will reconcile the CR and update the API entity in TAP GUI to achieve automated API specification registration from origin workloads. You may also use API Auto Registration without supply chain automation by direction applying an `APIDescriptor` CR to the cluster.
