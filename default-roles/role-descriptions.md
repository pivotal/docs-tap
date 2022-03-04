# Role Descriptions

## app-editor

*(can create, edit, delete a Tanzu Workload or Deliverable)*

This role is recommended if you would like to give a user, for example an app developer, the ability to create running workloads on the cluster (they are able to deploy their applications). This user role will require the ability to:

* View, create, update or delete a Tanzu Workload (and Deliverable), including the ability to view the logs of the pods spun up via the Tanzu Workload and the ability to trace a commit through the build process. 
* Download the image(s) associated with their Tanzu Workload so that they can test images locally, or create a Tanzu Workload from it (instead of starting from source code in a repo). 
* View and use app accelerator templates.
* View, create, update or delete a Tanzu Workload binding with an existing service. 

## app-viewer

*(cannot create, edit, delete a Tanzu Workload or Deliverable)*

This role has a subset of the permissions of the app-editor role. It is recommended if you do not want a user to be able to create, edit or delete a Tanzu Workload (and Deliverable), but they require the ability to view its status. This role does not have the ability to bind services with a Tanzu Workload either. An example of where you may choose to give a user these permissions is if you have an application developer that requires visibility into the state of their Tanzu Workload or micro-service, but does not have the permissions to deploy it (such as in production or staging environments). 

## app-operator

*(can create, edit, delete Supply Chain Resources)*

This role is meant for a user responsible for defining the activities that happen within a supply chain (or the path to production), for example building, testing or scanning. This role requires the ability to view, create, update or delete Tanzu Supply Chain resources, including TBS control plane resources (e.g. kpack's builder, Stack, Store), scanning resources, grype and the metadata store. If this person requires the ability to create Tanzu Workloads, you may bind the user with the app-editor role as well. 

## workload

This role provides the service account associated with the Tanzu Workload with the permissions it requires to execute the activities in the supply chain. This role is meant for a “robot” versus a user.  

## deliverable

This role gives the Delivery “robot” service account the permissions it requires to create running workloads. This role is not meant for a user.

For more information on the specific permissions of each role, see Detailed Role Permissions Breakdown.