# Tanzu Application Platform v1.3

## <a id='overview'></a> Overview of Tanzu Application Platform

VMware Tanzu Application Platform is an application development platform with a rich set
of developer tools. It offers developers a paved path to production to build and deploy software quickly and
securely on any compliant public cloud or on-premises Kubernetes cluster.

Tanzu Application Platform:

- Delivers a superior developer experience for enterprises building and deploying cloud-native applications on Kubernetes.
- Allows developers to quickly build and test applications regardless of their familiarity with Kubernetes.
- Helps application teams get to production faster by automating source-to-production pipelines.
- Clearly defines the roles of developers and operators so they can work collaboratively and integrate their efforts.

Operations teams can create application scaffolding templates with built-in security and compliance
guardrails, making those considerations mostly invisible to developers. Starting with the templates,
developers turn source code into a container and get a URL to test their app in minutes.

After the container is built, it updates every time there’s a new code commit or dependency patch. An internal API management portal facilitates connecting to other applications and data, regardless of how they’re built or the infrastructure they run on.

## <a id='simplified-workflows'></a> Simplified workflows

When creating supply chains, you can simplify workflows in both the inner and outer loop of Kubernetes-based app development with Tanzu Application Platform.

![Illustration of TAP conceptual value, starting with components that serve the developer and finishing with the components that serve the operations staff and security staff.](images/tap-conceptual-value.png)

- **Inner Loop**
    - The inner loop describes a developer’s development cycle of iterating on code.
    - Inner loop activities include coding, testing, and debugging before making a commit.
    - On cloud-native or Kubernetes platforms, developers in the inner loop often build container images and connect their apps to all necessary services and APIs to deploy them to a development environment.

- **Outer Loop**
    - The outer loop describes how operators deploy apps to production and maintain them over time.
    - On a cloud-native platform, outer loop activities include:
      - Building container images.
      - Adding container security.
      - Configuring continuous integration and continuous delivery (CI/CD) pipelines.
    - Outer loop activities are challenging in a Kubernetes-based development environment. App delivery platforms are constructed from various third-party and open source components with numerous configuration options.

- **Supply Chains and choreography**
    - Tanzu Application Platform uses the choreography pattern inherited from the context of microservices[^1] and applies it to CI/CD to create a path to production.[^2]

[^1]: https://stackoverflow.com/questions/4127241/orchestration-vs-choreography
[^2]: https://tanzu.vmware.com/developer/guides/supply-chain-choreography/

Supply chains provide a way of codifying all of the steps of your path to production, or what is more commonly known as CI/CD. A supply chain differs from CI/CD in that with a supply chain, you can add every step necessary for an application to reach production or a lower environment.

![Diagram depicting a simple path to production: CI to Security Scan to Build Image to Image Scan to CAB Approval to Deployment.](images/path-to-production.png)

In order to address the developer experience gap, the path to production allows users to create a
unified access point for all of the tools required for their applications to reach a customer-facing
environment.

Instead of having four tools that are loosely coupled to each other, a path to production defines
all four tools in a single, unified layer of abstraction. Where tools typically can't integrate with
one another and additional scripting or webhooks are necessary, a unified automation tool codifies
all interactions between each of the tools.

Tanzu Application Platform provides a default set of components that automates pushing an app to
staging and production on Kubernetes. This removes the pain points for both inner and outer loops.
It also allows operators to customize the platform by replacing Tanzu Application Platform components with other products.

![Diagram depicting the layered structure of TAP](images/tap-layered-capabilities.png)

For more information about Tanzu Application Platform components, see [About Tanzu Application Platform components and profiles](about-package-profiles.md).
