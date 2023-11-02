# Components and installation profiles for Tanzu Application Platform

This topic lists the components you can install with Tanzu Application Platform (commonly known as TAP).
You can install components as individual packages or you can install them using a profile containing
a predefined group of packages.

## <a id='TAP-packages'></a> Tanzu Application Platform components

- **[API Auto Registration](api-auto-registration/about.md)**

  When users deploy a [workload](workloads/workload-types.hbs.md) that exposes an API, they want that API to automatically show in
  Tanzu Application Platform GUI without requiring any added manual steps.

  API Auto Registration is an automated workflow that can use a supply chain to create and manage a
  Kubernetes Custom Resource (CR) of type `APIDescriptor`. A Kubernetes controller reconciles the CR
  and updates the API entity in Tanzu Application Platform GUI to achieve automated API registration
  from workloads. You can also use API Auto Registration without supply chains by directly applying
  an `APIDescriptor` CR to the cluster.

- **[API portal for VMware Tanzu](https://docs.pivotal.io/api-portal)**

  API portal for VMware Tanzu enables API consumers to find APIs they can use in their own
  applications.

  Consumers can view detailed API documentation and try out an API to see if it meets their needs.
  API portal assembles its dashboard and detailed API documentation views by ingesting OpenAPI
  documentation from the source URLs. An API portal operator can add any number of OpenAPI source
  URLs to to appear in a single instance.

- **[API Scoring and Validation](api-validation-scoring/about.hbs.md)**

  API Validation and Scoring focuses on scanning and validating an OpenAPI specification.
  The API specification is generated from the [API Auto Registration](api-auto-registration/about.hbs.md).
  After an API is registered, the API specification goes through static scan analysis and is validated.
  Based on the validation, a scoring is provided to indicate the quality and health of the API specification
  as it relates to Documentation, OpenAPI best practices, and Security.

- **[Application Accelerator for VMware Tanzu](application-accelerator/about-application-accelerator.md)**

  The Application Accelerator component helps app developers and app operators create application
  accelerators.

  Accelerators are templates that codify best practices and ensure that important configurations and
  structures are in place. Developers can bootstrap their applications and get
  started with feature development right away.

  Application operators can create custom accelerators that reflect their desired architectures and
  configurations and enable fleets of developers to use them. This helps ease operator concerns about
  whether developers are implementing their best practices.

- **[Application Live View](app-live-view/about-app-live-view.md)**

  Application Live View is a lightweight insight and troubleshooting tool that helps application
  developers and application operators look inside running applications.

  It is based on the concept of Spring Boot Actuators.
  The application provides information from inside the running processes by using
  endpoints (in our case, HTTP endpoints). Application Live View uses those endpoints to get the
  data from the application and to interact with it.

- **[Application Single Sign-On for VMware Tanzu](app-sso/about.md)**

  Application Single Sign-On enables application users to sign in to their identity provider once
  and be authorized and identified to access any Kubernetes-deployed workload. It is a secure and
  straightforward approach for developers and operators to manage access across all workloads in the
  enterprise.

- **[Cloud Native Runtimes for VMware Tanzu](../docs-tap/cloud-native-runtimes/about.hbs.md)**

  Cloud Native Runtimes for Tanzu is a serverless application runtime for Kubernetes that is based on
  Knative and runs on a single Kubernetes cluster. For information about Knative, see the
  [Knative documentation](https://knative.dev/docs/).

- **[cert-manager](cert-manager/about.hbs.md)**

  cert-manager adds certificates and certificate issuers as resource types to Kubernetes clusters. It also helps you to
  obtain, renew, and use those certificates. For more information about cert-manager, see
  the [cert-manager documentation](https://cert-manager.io/docs).

- **[Contour](contour/about.hbs.md)**

  Contour is an ingress controller for Kubernetes that supports dynamic configuration updates and multi-team ingress
  delegation. It provides the control plane for the Envoy edge and service proxy. For more information about Contour, see
  the [Contour documentation](https://projectcontour.io/docs/v1.22.0/).

- **[Convention Service for VMware Tanzu](convention-service/about.md)**

  Convention Service provides a means for people in operational roles to express their hard-won
  knowledge and opinions about how apps run on Kubernetes as a convention. The convention
  service applies these opinions to fleets of developer workloads as they are deployed to the
  platform, saving time for operators and developers.

- **[Default roles for Tanzu Application Platform](authn-authz/overview.md)**

  This package includes five default roles for users, including app-editor, app-viewer, app-operator,
  and service accounts including workload and deliverable. These roles are available to help
  operators limit permissions a user or service account requires on a cluster that runs Tanzu
  Application Platform. They are built by using aggregated cluster roles in Kubernetes role-based
  access control (RBAC).

  Default roles only apply to a user interacting with the cluster by using kubectl and Tanzu CLI.
  Tanzu Application Platform GUI support for default roles is planned for a future release.

- **[Developer Conventions](convention-service/about.md)**

  Developer conventions configure workloads to prepare them for inner loop development.

  It’s meant to be a “deploy and forget” component for developers. After it is installed on the
  cluster with the Tanzu Package CLI, developers do not need to directly interact with it.
  Developers instead interact with the Tanzu Developer Tools for VSCode IDE Extension or
  Tanzu CLI Apps plug-in, which rely on the Developer Conventions to edit the workload to enable
  inner loop capabilities.

- **[Eventing for VMware Tanzu](eventing/about.hbs.md)**

  Eventing for VMware Tanzu focuses on providing tooling and patterns for Kubernetes applications to
  manage event-triggered systems through Knative Eventing. For information about Knative, see
  the [Knative documentation](https://knative.dev/docs/).

- **[Flux CD Source Controller](fluxcd-source-controller/about.hbs.md)**

  The main role of this source management component is to provide a common interface for artifact
  acquisition.

- **[Grype](https://github.com/anchore/grype)**

  Grype is a vulnerability scanner for container images and file systems.

- **[Namespace Provisioner](namespace-provisioner/about.hbs.md)**

  Namespace provisioner provides an easy, secure, automated way for Platform Operators to provision
  namespaces with the resources and proper namespace-level privileges needed for developer workloads
  to function as intended.

- **[Services Toolkit for VMware Tanzu](services-toolkit/about.hbs.md)**

  Services Toolkit comprises a number of Kubernetes-native components that support the management,
  life cycle, discoverability, and connectivity of Service Resources (databases, message queues,
  DNS records, and so on) on Kubernetes.

- **[Source Controller](source-controller/about.hbs.md)**

  Tanzu Source Controller provides a standard interface for artifact acquisition and extends the
  function of [Flux CD Source Controller](fluxcd-source-controller/about.hbs.md).
  Tanzu Source Controller supports the following two resource types:

      - ImageRepository
      - MavenArtifact

- **[Spring Boot conventions](spring-boot-conventions/about.hbs.md)**

  The Spring Boot convention server has a bundle of smaller conventions applied to any Spring Boot
  application that is submitted to the supply chain in which the convention controller is configured.

- **[Supply Chain Choreographer for VMware Tanzu](scc/about.md)**

  Supply Chain Choreographer is based on open-source [Cartographer](https://cartographer.sh/docs/).
  It enables app operators to create preapproved paths to production by integrating Kubernetes
  resources with the elements of their existing toolchains, such as Jenkins.

  Each pre-approved supply chain creates a paved road to production. It orchestrates supply chain
  resources, namely test, build, scan, and deploy. Enabling developers to focus on delivering
  value to their users. Pre-approved supply chains also assure application operators that all code in
  production has passed through the steps of an approved workflow.

- **[Supply Chain Security tools for Tanzu - Scan](scst-scan/overview.md)**

  With Supply Chain Security Tools for VMware Tanzu - Scan, you can build and deploy
  secure trusted software that complies with their corporate security requirements.

  To enable this, Supply Chain Security Tools - Scan provides scanning and gate keeping capabilities
  that Application and DevSecOps teams can incorporate earlier in their path to production.
  This is an established industry best practice for reducing security risk and ensuring more
  efficient remediation.

- **[Supply Chain Security Tools - Sign (Deprecated)](scst-sign/overview.md)**

  Supply Chain Security Tools - Sign provides an admission controller that allows a cluster operator
  to specify a policy that allows or denies images from running based on signature verification
  against public keys. SCST - Sign works with
  [cosign signature format](https://github.com/sigstore/cosign#quick-start) and allows for fine-tuned
  configuration based on image source patterns.

- **[Supply Chain Security Tools - Policy Controller](scst-policy/overview.md)**

  Supply Chain Security Tools - Policy is an admission controller that allows a cluster operator
  to specify policies to verify image container signatures before admitting them to a cluster. It
  works with [cosign signature format](https://github.com/sigstore/cosign#quick-start) and allows for
  fine-tuned configuration of policies based on image source patterns.

- **[Supply Chain Security Tools - Store](scst-store/overview.md)**

  Supply Chain Security Tools - Store saves software bills of materials (SBoMs) to a database and
  enables you to query for image, source, package, and vulnerability relationships.
  It integrates with SCST - Scan to automatically store the resulting source
  and image vulnerability reports.

- **[Tanzu Application Platform GUI](tap-gui/about.md)**

  Tanzu Application Platform GUI lets your developers view your organization's running applications
  and services. It provides a central location for viewing dependencies, relationships, technical
  documentation, and even service status.
  Tanzu Application Platform GUI is built from the Cloud Native Computing Foundation's project
  Backstage.

- **[Tanzu Build Service](tanzu-build-service/tbs-about.md)**

  Tanzu Build Service uses the open-source Cloud Native Build packs project to turn application
  source code into container images.

  Tanzu Build Service executes reproducible builds that align with modern container standards and keeps
  images up to date. It does so by leveraging Kubernetes infrastructure with kpack, a Cloud Native
  Build packs Platform, to orchestrate the image life cycle.

  The kpack CLI tool, kp, can aid in managing kpack resources. Build Service helps you
  develop and automate containerized software workflows securely and at scale.

- **[Tanzu Developer Tools for IntelliJ](intellij-extension/about.hbs.md)**

  Tanzu Developer Tools for IntelliJ is the official VMware Tanzu IDE extension for IntelliJ IDEA
  to help you develop code by using Tanzu Application Platform.
  This extension enables you to rapidly iterate on your workloads on supported Kubernetes clusters
  that have Tanzu Application Platform installed.

- **[Tanzu Developer Tools for Visual Studio](vs-extension/about.hbs.md)**

  Tanzu Developer Tools for Visual Studio is the official VMware Tanzu IDE extension for Visual Studio
  to help you develop code by using Tanzu Application Platform.
  The Visual Studio extension enables live updates of your application while it runs on the cluster
  and lets you debug your application directly on the cluster.

- **[Tanzu Developer Tools for Visual Studio Code](vscode-extension/about.hbs.md)**

  Tanzu Developer Tools for VS Code is the official VMware Tanzu IDE extension for VS Code
  to help you develop code by using Tanzu Application Platform.
  The VS Code extension enables live updates of your application while it runs on the cluster and
  lets you debug your application directly on the cluster.

- **[Tanzu Learning Center](learning-center/about.md)**

  Learning Center provides a platform for creating and self-hosting workshops. With Learning Center,
  content creators can create workshops from markdown files that learners can view in a terminal
  shell environment with an instructional wizard UI. The UI can embed slide content, an integrated
  development environment (IDE), a web console for accessing the Kubernetes cluster, and other custom
  web applications.

  Although Learning Center requires Kubernetes to run, and it teaches users about Kubernetes,
  you can use it to host training for other purposes as well. For example, you can use it to train
  users on web-based applications, use of databases, or programming languages.

- **[Tekton Pipelines](tekton/tekton-about.hbs.md)**

  Tekton is a powerful and flexible open-source framework for creating CI/CD systems, enabling
  developers to build, test, and deploy across cloud providers and on-premise systems.

- **[Tanzu Application Platform Telemetry](telemetry/overview.hbs.md)**

  Tanzu Application Platform Telemetry is a set of objects that collect data about the use of
  Tanzu Application Platform and send it back to VMware for product improvements. A benefit of
  remaining enrolled in telemetry and identifying your company during Tanzu Application Platform
  installation is that VMware can provide your organization with use reports about Tanzu Application
  Platform. See [Tanzu Application Platform usage reports](telemetry/overview.hbs.md#usage-reports)
  for more information about enrolling in telemetry reports.

>**Note** You can opt out of telemetry collection by following the
>instructions in [Opting out of telemetry collection](opting-out-telemetry.hbs.md).

## <a id='profiles-and-packages'></a> Installation profiles in Tanzu Application Platform v{{ vars.url_version }}

You can deploy Tanzu Application Platform through predefined profiles, each containing various packages,
or you can install the packages individually. The profiles allow Tanzu Application Platform to scale
across an organization's multicluster, multi-cloud, or hybrid cloud infrastructure.
These profiles are not meant to cover all use cases, but serve as a starting point to allow
for further customization.

The following profiles are available in Tanzu Application Platform:

- **Full** (`full`):
  Contains all of the Tanzu Application Platform packages.

- **Iterate** (`iterate`):
  Intended for iterative application development.

- **Build** (`build`):
  Intended for the transformation of source revisions to workload revisions. Specifically, hosting
  workloads and SupplyChains.

- **Run** (`run`):
  Intended for the transformation of workload revisions to running pods. Specifically, hosting
  deliveries and deliverables.

- **View** (`view`):
  Intended for instances of applications related to centralized developer experiences. Specifically,
  Tanzu Application Platform GUI and Metadata Store.

The following table lists the packages contained in each profile.
For a diagram showing the packages contained in each profile, see
[Overview of multicluster Tanzu Application Platform](./multicluster/about.hbs.md).

<table>
  <tr>
   <td><strong>Package Name</strong>
   </td>
   <td><strong>Full</strong>
   </td>
   <td><strong>Iterate</strong>
   </td>
   <td><strong>Build</strong>
   </td>
   <td><strong>Run</strong>
   </td>
   <td><strong>View</strong>
   </td>
  </tr>
  <tr>
   <td>API Auto Registration
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>
   </td>
   <td>&check;
   </td>
   <td>
   </td>
  </tr>
  <tr>
  <tr>
   <td>API portal
   </td>
   <td>&check;
   </td>
   <td>
   </td>
   <td>
   </td>
   <td>
   </td>
   <td>&check;
   </td>
  </tr>
  <tr>
   <td>Application Accelerator
   </td>
   <td>&check;
   </td>
   <td>
   </td>
   <td>
   </td>
   <td>
   </td>
   <td>&check;
   </td>
  </tr>
  <tr>
  <td>Application Live View back end
   </td>
   <td>&check;
   </td>
   <td>
   </td>
   <td>
   </td>
   <td>
   </td>
   <td>&check;
   </td>
  </tr>
  <tr>
   <td>Application Live View connector
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>
   </td>
   <td>&check;
   </td>
   <td>
   </td>
  </tr>
  <tr>
   <td>Application Live View conventions
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>
   </td>
   <td>
   </td>
  </tr>
  <tr>
   <td>Application Single Sign-On
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>
   </td>
   <td>&check;
   </td>
   <td>
   </td>
  </tr>
  <tr>
   <td>cert-manager
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
  </tr>
  <tr>
   <td>Cloud Native Runtimes
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>
   </td>
   <td>&check;
   </td>
   <td>
   </td>
  </tr>
  <tr>
   <td>Contour
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
  </tr>
  <tr>
   <td>Convention controller
    </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>
   </td>
   <td>
   </td>
  </tr>
  <tr>
   <td>Default Roles
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>
   </td>
  </tr>
  <tr>
   <td>Developer Conventions
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>
   </td>
   <td>
   </td>
   <td>
   </td>
  </tr>
  <td>Eventing
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>
   </td>
   <td>&check;
   </td>
   <td>
   </td>
  </tr>
  <tr>
   <td>Flux Source Controller
  </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
  </tr>
  <tr>
   <td>Grype
   </td>
   <td>&check;
   </td>
   <td>
   </td>
   <td>&check;
   </td>
   <td>
   </td>
   <td>
   </td>
  </tr>
  <tr>
   <td>Learning Center
  </td>
   <td>&check;
   </td>
   <td>
   </td>
   <td>
   </td>
   <td>
   </td>
   <td>&check;
   </td>
  </tr>
  <tr>
    <tr>
   <td>Namespace Provisioner
  </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>
   </td>
  </tr>
  <tr>
   <td>Out of the Box Delivery - Basic
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>
   </td>
   <td>&check;
   </td>
   <td>
   </td>
  </tr>
  <tr>
   <td>Out of the Box Supply Chain - Basic
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>
   </td>
   <td>
   </td>
  </tr>
  <tr>
   <td>Out of the Box Supply Chain - Testing
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>
   </td>
   <td>
   </td>
  </tr>
  <tr>
   <td>Out of the Box Supply Chain - Testing and Scanning
   </td>
   <td>&check;
   </td>
   <td>
   </td>
   <td>&check;
   </td>
   <td>
   </td>
   <td>
   </td>
  </tr>
  <tr>
   <td>Out of the Box Templates
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>
   </td>
  </tr>
  <tr>
   <td>Service Bindings
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>
   </td>
   <td>&check;
   </td>
   <td>
   </td>
  </tr>
  <tr>
   <td>Services Toolkit
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>
   </td>
   <td>&check;
   </td>
   <td>
   </td>
  </tr>
  <tr>
   <td>Source Controller
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
  </tr>
  <tr>
   <td>Spring Boot conventions
  </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>
   </td>
   <td>
   </td>
  </tr>
  <tr>
   <td>Supply Chain Choreographer
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>
   </td>
  </tr>
  <tr>
   <td>SCST - Policy Controller
  </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>
   </td>
   <td>&check;
   </td>
   <td>
   </td>
  </tr>
  <tr>
   <td>SCST - Scan</td>
  </td>
   <td>&check;
   </td>
   <td>
   </td>
   <td>&check;
   </td>
   <td>
   </td>
   <td>
   </td>
  </tr>
  <tr>
   <td>SCST - Sign (deprecated)
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>
   </td>
   <td>&check;
   </td>
   <td>
   </td>
  </tr>
  <tr>
   <td>SCST - Store</td>
   </td>
   <td>&check;
   </td>
   <td>
   </td>
   <td>
   </td>
   <td>
   </td>
   <td>&check;
   </td>
  </tr>
  <tr>
   <td>Tanzu Build Service
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>
   </td>
   <td>
   </td>
  </tr>
  <tr>
   <td>Tanzu Application Platform GUI
   </td>
   <td>&check;
   </td>
   <td>
   </td>
   <td>
   </td>
   <td>
   </td>
   <td>&check;
   </td>
  </tr>
  <tr>
   <td>Tekton Pipelines
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>
   </td>
   <td>
   </td>
  </tr>
  <tr>
   <td>Telemetry
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
  </tr>
  <tr>
</table>

>**Note** You can only install one supply chain at any given time. For information about switching
supply chains, see [Add testing and scanning to your application](getting-started/add-test-and-security.md).

## <a id='language-support'></a> Language and framework support in Tanzu Application Platform

The following table shows the languages and frameworks supported by
Tanzu Application Platform components.

<table>
  <tr>
   <td><strong>Language or Framework</strong>
   </td>
   <td><strong>Tanzu Build Service</strong>
   </td>
   <td><strong>Runtime Conventions</strong>
   </td>
   <td><strong>Tanzu Developer Tooling</strong>
   </td>
   <td><strong>Application Live View</strong>
   </td>
   <td><strong>Functions</strong>
   </td>
   <td><strong>Extended Scanning Coverage using Buildpack SBOM's</strong>
   </td>
  </tr>
  <tr>
   <td>Java
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
  </tr>
  <tr>
   <td>Spring Boot
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
  </tr>
  <tr>
   <td>.NET Core
   </td>
   <td>&check;
   </td>
   <td>
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>
   </td>
   <td>&check;
   </td>
  </tr>
  <tr>
   <td>Steeltoe
   </td>
   <td>&check;
   </td>
   <td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
   <td>
   </td>
   <td>
   </td>
  </tr>
  <tr>
   <td>NodeJS
   </td>
   <td>&check;
   </td>
   <td>
   </td>
   <td>
   </td>
   <td>
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
  </tr>
  <tr>
   <td>Python
   </td>
   <td>&check;
   </td>
   <td>
   </td>
   <td>
   </td>
   <td>
   </td>
   <td>&check;
   </td>
   <td>&check;
   </td>
  </tr>
  <tr>
   <td>golang
   </td>
   <td>&check;
   </td>
   <td>
   </td>
   <td>
   </td>
   <td>
   </td>
   <td>
   </td>
   <td>&check;
   </td>
  </tr>
  <tr>
   <td>PHP
   </td>
   <td>&check;
   </td>
   <td>
   </td>
   <td>
   </td>
   <td>
   </td>
   <td>
   </td>
   <td>&check;
   </td>
  </tr>
  <tr>
   <td>Ruby
   </td>
   <td>&check;
   </td>
   <td>
   </td>
   <td>
   </td>
   <td>
   </td>
   <td>
   </td>
   <td>&check;
   </td>
  </tr>
</table>

**Tanzu Developer Tooling:** refers to the developer conventions that enable debugging
and Live Update function in the inner loop.

**Extended Scanning Coverage:** When building container images with the Tanzu Build Service, the Cloud Native Build Packs used in the build process for the specified languages produce a Software Bill of Materials (SBOM).  Some scan engines support the enhanced ability to use this SBOM as a source for the scan. Out of the Box Supply Chain - Testing and Scanning leverages Anchore's Grype for the image scan, which suppports this capability.  In addition, users have the ability to leverage Carbon Black Container image scans, which also supports this enhanced scan coverage.

## <a id='install'></a> Installing Tanzu Application Platform

For more information about installing Tanzu Application Platform, see [Installing Tanzu Application Platform](install-intro.hbs.md).
