# <a id='overview'></a> About Tanzu Application Platform v0.2 (Beta-2)

## <a id='overview'></a> Overview of Tanzu Application Platform

<p class="note warning">
<strong>Warning:</strong> Tanzu Application Platform is currently in beta and is intended for evaluation and test purposes.
</p>

Tanzu Application Platform is a packaged set of components that helps developers and operators to build, deploy, and manage apps on a Kubernetes platform more easily.

Simplify workflows in both the _inner loop_ and _outer loop_ of Kubernetes-based app development with Tanzu Application Platform:

* **Inner Loop**: 
    - The inner loop describes a developer’s personal development cycle of quickly iterating on code. 
    - Inner loop activities include coding, testing, and debugging, up to the point of making a commit.
    - On cloud-native or Kubernetes platforms, developers in the inner loop often build container images and connect their app to all necessary services, apps, and APIs to deploy it to a development environment.

* **Outer Loop**: 
    - The outer loop describes the steps for operators to deploy apps to production and maintain them over time. 
    - On a cloud-native platform, outer loop activities include building container images, adding container security, and configuring continuous integration and continuous delivery (CI/CD) pipelines.
    - Outer loop activities are difficult in a Kubernetes-based development environment due to app delivery platforms being constructed from various third-party and open source components, each with numerous configuration options.

Tanzu Application Platform provides a default set of components that automate the steps to push an app to staging and production on Kubernetes, solving pains for both the inner loop and outer loop. Operators can still customize the platform as needed by replacing Tanzu Application Platform components with other products.

Reduce the complexity of deploying apps on Kubernetes for operators with better automation and standardization of the outer loop, which also gives developers more time to focus on code.

## Packages in Tanzu Application Platform v0.2

The following packages are available in Tanzu Application Platform:

* API portal
* Application Accelerator for VMware Tanzu
* Application Live View for VMware Tanzu
* Cloud Native Runtimes for VMware Tanzu
* Convention Service for VMware Tanzu
* Default Supply Chain
* Default Supply Chain with Testing
* Developer Conventions 
* SCP Toolkit
* Service Bindings for Kubernetes
* Supply Chain Choreographer for VMware Tanzu
* Supply Chain Security Tools - Scan
* Supply Chain Security Tools - Sign
* Supply Chain Security Tools - Store
* Tanzu Source Controller
* VMware Tanzu Build Service

## <a id='install'></a> About Installing Tanzu Application Platform v0.2 (Beta-2) Components

To install the Tanzu Application Platform repo bundle, see [Installing Tanzu Application Platform](install-intro.md).
