# Set up authentication for your Tanzu Application Platform deployment

There are multiple ways to set up authentication for your Tanzu Application Platform 
(commonly known as TAP) deployment.
You can manage authentication at the infrastructure level with your Kubernetes provider,
such as Tanzu Kubernetes Grid, EKS, AKS, or GKE.

VMware recommends Pinniped for integrating your identity management into Tanzu Application Platform
on multicloud. It provides many supported integrations for widely used identity providers. 
To use Pinniped, see [Installing Pinniped on Tanzu Application Platform](pinniped-install-guide.hbs.md) and
[Log in by using Pinniped](pinniped-login.hbs.md).

See [Integrating Azure Active Directory](azure-ad.html) for Azure Active Directory Integration.

## <a id="tkg"></a> Tanzu Kubernetes Grid

For Tanzu Kubernetes Grid clusters, Pinniped is the default identity solution and is installed as a
core package. For more information, see
[Core Packages](https://docs.vmware.com/en/VMware-Tanzu-Kubernetes-Grid/2/about-tkg/packages-index.html#auto) and
[Enable Identity Management in an Existing Deployment](https://docs.vmware.com/en/VMware-Tanzu-Kubernetes-Grid/2.4/tkg-deploy-mc/mgmt-iam-configure-id-mgmt.html)
in the Tanzu Kubernetes Grid documentation.
