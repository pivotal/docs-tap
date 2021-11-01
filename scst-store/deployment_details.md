# Deployment Details

## What is Installed

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

## Database Details

The default database that ships with the deployment is meant to get users started with using the metadata store. The default database deployment is not meant support for many enterprise production requirements including scaling, redundancy, or failover. However, it is still a secure deployment.