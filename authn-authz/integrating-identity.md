# Setting up Authentication for Tanzu Application Platform

Customer have multiple ways of integrating Tanzu Application Platform with their identity provider depending on their Kubernetes deployment.

Our recommendation is to use the solutions provided by your Kubernetes deployment.

In the scenario where you have multiple identity management solutions that you want to integrate into one experience, we recommend [installing open source Pinniped](https://pinniped.dev/docs/). For example, if you're operating Tanzu Application Platform on multi-cloud.

## Tanzu Kubernetes Grid

For TKG clusters, Pinniped is the default identity solution and is installed as a [core package](https://docs.vmware.com/en/VMware-Tanzu-Kubernetes-Grid/1.4/vmware-tanzu-kubernetes-grid-14/GUID-packages-core-index.html). Follow the [TKG documentation for enabling the functionality](https://docs.vmware.com/en/VMware-Tanzu-Kubernetes-Grid/1.4/vmware-tanzu-kubernetes-grid-14/GUID-cluster-lifecycle-enable-identity-management.html).
