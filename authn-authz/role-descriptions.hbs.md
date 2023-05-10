# Role descriptions for Tanzu Application Platform

This topic is a high level overview of each default role. 
For more information about the specific permissions of each role for every 
Tanzu Application Platform (commonly known as TAP) component, 
see [Detailed role permissions for Tanzu Application Platform](permissions-breakdown.md).

## <a id="app-editor"></a>app-editor

The app-editor role can create, edit, and delete a Tanzu workload or deliverable.

Assign this role to a user, for example an app developer, to give permissions to create running workloads on the cluster. This allows them to deploy their applications. This role allows the user to:

* View, create, update, or delete a Tanzu workload or deliverable. This includes viewing the logs of the pods spun up through the Tanzu workload and tracing a commit through the build process.
* Download the images associated with their Tanzu workload so they can test images locally, or create a Tanzu workload from it instead of starting from source code in a repository.
* View and use Application Accelerator templates.
* View, create, update, or delete a Tanzu workload binding with an existing service.

## <a id="app-viewer"></a>app-viewer

The app-viewer role cannot create, edit, or delete a Tanzu workload or deliverable.

This role has a subset of the permissions of the app-editor role.  Use it if you do not want a user to create, edit, or delete a Tanzu workload or deliverable, but they need to view its status. For example, give these permissions to an application developer that requires visibility into the state of their Tanzu workload or micro-service, but does not have the permissions to deploy it, such as to production or staging environments. This role cannot bind services with a Tanzu workload.

## <a id="app-operator"></a>app-operator

The app-operator role can create, edit, and delete supply chain resources.

Assign this role to a user who defines the activities within a supply chain or the path to production. For example, building, testing, or scanning. This role can view, create, update, or delete Tanzu supply chain resources, including Tanzu Build Service control plane resources such as:

- kpack's builder, stack, and store
- Scanning resources
- Grype
- The metadata store 

If this person must create Tanzu workloads, you can bind the user with the app-editor role as well.

## <a id="workload"></a>workload

This role provides the service account associated with the Tanzu workload the permissions needed to execute the activities in the supply chain. This role is for a "robot” versus a user.  

## <a id="deliverable"></a>deliverable

This role gives the delivery “robot” service account the permissions neeeded to create running workloads. This role is not for a user.
