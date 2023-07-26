# Configure and deploy to multiple environments with custom parameters

This topic describes how to  use carvel packages, Git repositories, and Flux CD
to deploy workloads to multiple environments with Supply Chain Choreographer. By using a continuous delivery
(CD) tool, you can apply Carvel packages to a runtime. 

Flux CD is the VMware recommended CD tool. You can configure different parameters
for each environment, such as replicas or host names. When you edit package
parameters and commit them to a Git repository, Flux CD watches the Git
repository and applies the package to your runtime environments.

## <a id="prerecs"></a> Feature limits 

To configure and deploy to multiple environments with custom parameters, ensure
that your supply chains are compatible with the feature limits.

This feature is in alpha and has the following limits: 

- Only the Out of the Box Basic Supply Chain package is supported. 
- The Testing and Scanning supply chains are not supported. 
- Only workloads of type server are supported. 
- Innerloop development is not supported. 
- Azure GitOps repositories are not supported.

## <a id="using-carvel"></a> Using Carvel packages

You can configure your supply chain to outputs Carvel packages and deliver
configuration for each environment. For information about using Carvel, see
[Carvel Package Supply Chains (alpha)](carvel-package-supply-chain.hbs.md).

## <a id="using-flux"></a> Using GitOps delivery with Flux CD

You can deliver packages created by the Carvel package supply chain, and add
them to clusters, by using a GitOps repository. For information about this
delivery method, see [Use Gitops Delivery with Flux CD
(alpha)](delivery-with-flux.hbs.md).

## <a id="using-app"></a> Using GitOps delivery with Carvel App

Alternatively, you can deliver packages created by the Carvel package supply
chain, and add them to clusters by using a GitOps repository. For information
about this delivery method, see [Use Gitops Delivery with Carvel App](delivery-with-carvel-app.hbs.md)

## <a id="config-blue-grn"></a> Configuring blue-green deployment

You can use blue-green deployment to transfer user traffic from one version of
an app to a later version while both are running. For information about setting
up blue-green deployment, see [Use blue-green deployment with Contour and
PackageInstall (alpha)](blue-green-with-packageinstall.hbs.md).
