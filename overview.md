# <a id='overview'></a> About Tanzu Application Platform v0.2 (Beta-2)

## <a id='overview'></a> Overview of Tanzu Application Platform

<p class="note warning">
<strong>Warning:</strong> Tanzu Application Platform is currently in beta and is intended for evaluation and test purposes.
</p>

Tanzu Application Platform is a packaged set of components that helps
developers and operators to more easily build, deploy, and manage apps
on a Kubernetes platform.

Tanzu Application Platform simplifies workflows in both the
_inner loop_ and _outer loop_ of Kubernetes-based app development:

* **Inner Loop**: The _inner loop_ describes a developer’s local development
environment where they code and test apps. The activities that take place
in the inner loop include writing code, committing to a version control
system, deploying to a development or staging environment, testing, and
then making additional code changes. 

* **Outer Loop**: The _outer loop_ describes the steps to deploy apps
to production and maintain them over time. For example, on a cloud-native
platform, the outer loop includes activities such as building container
images, adding container security, and configuring continuous integration
(CI) and continuous delivery (CD) pipelines.

On a cloud-native or Kubernetes platform, developers often spend additional
time in the inner loop to build container images as well as connect their
app to all necessary services, apps, or APIs to deploy it to
a development environment.

Outer loop activities can also be more difficult for operators in a
Kubernetes-based development environment because of the need to construct
an app delivery platform from various third-party and open source
components, each with numerous configuration options.

Tanzu Application Platform provides a default set of components that automate
the steps required to push an app to staging and production
on Kubernetes. It also allows operators to customize the platform as
needed by replacing Tanzu Application Platform components with existing
or preferred products.

This reduces the complexity of deploying apps on Kubernetes
by enabling operators to better automate and standardize the outer loop,
while allowing developers more time to focus on code.

## Packages in Tanzu Application Platform v0.2

The following packages are available in Tanzu Application Platform:

* API portal
* Application Accelerator for VMware Tanzu
* Application Live View for VMware Tanzu
* Cloud Native Runtimes for VMware Tanzu
* Convention Service for VMware Tanzu
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
