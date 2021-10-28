# Installation Details

The installation creates the following in your Kubernetes cluster:

* 2 components — an API backend and a database. 
Each component includes:
    * service
    * deployment
    * replicaset
    * pod
* Persistent volume, and persistent volume claim.
* External IP (based on a deployment configuration set to use `LoadBalancer`).
* A Kubernetes secret to allow pulling Supply Chain Security Tools - Store images from a registry.
* A namespace called `metadata-store`.