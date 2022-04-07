# Setting up authentication for Tanzu Application Platform

There are multiple ways to set up authentication for your Tanzu Application Platform deployment. You can choose to manage authentication at the infrastructure level with your kubernetes provider, for example TKG, EKS, AKS or GKE. 

Pinniped provides a lot of supported integrations for widely used identity providers and is therefore a recommended solution to integrate your identity management into Tanzu Application Platform on multi-cloud. See our [guide to install pinniped](pinniped-install-guide.md). See our Documentation for [Logging in using Pinniped](pinniped-login.md) after setting it up.


## Tanzu Kubernetes Grid

For TKG clusters, Pinniped is the default identity solution and is installed as a [core package](https://docs.vmware.com/en/VMware-Tanzu-Kubernetes-Grid/1.4/vmware-tanzu-kubernetes-grid-14/GUID-packages-core-index.html). See [TKG documentation](https://docs.vmware.com/en/VMware-Tanzu-Kubernetes-Grid/1.4/vmware-tanzu-kubernetes-grid-14/GUID-cluster-lifecycle-enable-identity-management.html) for more information about enabling the functionality.
