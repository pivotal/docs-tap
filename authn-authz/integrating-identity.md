# Setting up authentication for Tanzu Application Platform

There are multiple ways to set up authentication for your Tanzu Application Platform deployment.
You can manage authentication at the infrastructure level with your Kubernetes provider,
such as Tanzu Kubernetes Grid, EKS, AKS, or GKE.

VMware recommends Pinniped for integrating your identity management into Tanzu Application Platform 
on multicloud. It provides many supported integrations for widely used identity providers.
To use Pinniped, see [Installing Pinniped on a single cluster](pinniped-install-guide.md) and
[Logging in using Pinniped](pinniped-login.md).

See [Azure Active Directory](azure-ad.md) for Azure Active Directory Integration

## <a id="tkg"></a> Tanzu Kubernetes Grid

For Tanzu Kubernetes Grid clusters, Pinniped is the default identity solution and is installed as a
core package. For more information, see
[Core Packages](https://docs.vmware.com/en/VMware-Tanzu-Kubernetes-Grid/1.4/vmware-tanzu-kubernetes-grid-14/GUID-packages-core-index.html) and
[Enable Identity Management in an Existing Deployment](https://docs.vmware.com/en/VMware-Tanzu-Kubernetes-Grid/1.4/vmware-tanzu-kubernetes-grid-14/GUID-cluster-lifecycle-enable-identity-management.html)
in the Tanzu Kubernetes Grid documentation.
