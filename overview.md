# <a id='overview'></a> About Tanzu Application Platform v0.1 (Beta)

## <a id='overview'></a> Overview of Tanzu Application Platform

Tanzu Application Platform is a packaged set of components that helps
developers and operators to more easily build, deploy, and manage apps
on a Kubernetes platform.

Tanzu Application Platform improves and simpifies workflows in both the
_inner loop_ and _outer loop_ of Kubernetes-based app development:

* **Inner Loops**: The _inner loop_ describes a developer’s local development
environment where they code and test apps. The activities that take place
in the inner loop include writing code, committing to a version control
system, deploying to a development or staging environment, testing,
then making additional code changes. 

* **Outer Loop**: The _outer loop_ describes the steps to deploy apps
to production and maintain them over time. For example, on a cloud native
platform, the outer loop includes activities such as building container
images, adding container security, and configuring continuous integration
(CI) and continuous delivery (CD) pipelines.

On a cloud native or Kubernetes platform, developers often spend additional
time in the inner loop to build container images as well as connect their
app to all necessary services, apps, or APIs to deploy their app to
a development environment.

Outer loop activities can also be more difficult for operators in a
Kubernetes-based development environment because of the need to build
an app delivery platform using various different third-party and open
source components, each with numerous configuration options.

Tanzu Application Platform reduces complexity for developers
and operators by providing a default set of components that automate the
steps required to push an app the production in a Kubernetes environment.
For example, configuring development and production environments, building
CI/CD pipelines, building and deploying containers, and enforcing security
policies.

It also allows operators to customize the platform as needed by replacing
Tanzu Application Platform components with existing or prefered products.
This separates the needs of developers and operators, allowing developers
more time to focus on code.

## <a id='components'></a> Tanzu Application Platform v0.1 (Beta) Components

Tanzu Application Platform v0.1 (Beta) includes the following components: 

| Component Name | Version | Link to Documentation |
|--------------------------------|-------------------------------|------|
| Cloud Native Runtimes for VMware Tanzu | v1.0.2 | [Cloud Native Runtimes](https://docs.vmware.com/en/Cloud-Native-Runtimes-for-VMware-Tanzu/1.0/tanzu-cloud-native-runtimes-1-0/GUID-cnr-overview.html) |
| VMware Tanzu Build Service | v1.2.2 | [Tanzu Build Service](https://docs.pivotal.io/build-service/1-2/) |
| Application Accelerator for VMware Tanzu (Beta) | v0.2.0 | [Application Accelerator for VMware Tanzu](https://docs.vmware.com/en/Application-Accelerator-for-VMware-Tanzu/index.html) |
| Application Live View for VMware Tanzu (Beta) | v0.1.0 | INSERT DOCS LINK|

## <a id='install'></a> Install Tanzu Application Platform v0.1 (Beta) Components

You can install the Tanzu Application Platform components in one of two ways:

* **Install as a package bundle (Recommended)**: Installing the components
as part of the package bundle allows you to use the default, recommended
Tanzu Application Platform experience. To install the package bundle, see
INSERT LINK TO INSTALLATION DOC.
* **Install components individually**: You can also choose to use the
Tanzu Application Platform components independently of one another on
an existing Kubernetes platform. For information about how to install
and use each component, see the documentation for the components listed
in the table above.

## <a id='use'></a> Use Tanzu Application Platform v0.1 (Beta) Components

To follow a tutorial that shows how to use Tanzu Application Platform
v0.1 (Beta) components to deploy a sample app, see INSERT LINK TO USE-CASE.