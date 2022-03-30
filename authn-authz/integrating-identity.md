# Setting up authentication for Tanzu Application Platform

There are multiple ways to integrate Tanzu Application Platform with your identity provider depending on your Kubernetes deployment.

VMware recommends using the solutions provided by your Kubernetes deployment.

When you have multiple identity management solutions to integrate, for example, if you're operating Tanzu Application Platform on multi-cloud, VMware recommends installing pinniped. See our [guide to install pinniped](pinniped-install-guide.md). 

## Tanzu Kubernetes Grid

For TKG clusters, Pinniped is the default identity solution and is installed as a [core package](https://docs.vmware.com/en/VMware-Tanzu-Kubernetes-Grid/1.4/vmware-tanzu-kubernetes-grid-14/GUID-packages-core-index.html). See [TKG documentation](https://docs.vmware.com/en/VMware-Tanzu-Kubernetes-Grid/1.4/vmware-tanzu-kubernetes-grid-14/GUID-cluster-lifecycle-enable-identity-management.html) for more information about enabling the functionality.
