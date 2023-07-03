# Overview of Tanzu Developer Portal

Tanzu Developer Portal (formerly called Tanzu Application Platform GUI) is a tool for your developers to view your
applications and services running for your organization.
This portal provides a central location in which you can view dependencies, relationships, technical
documentation, and the service status.

Tanzu Developer Portal is built from the
[Cloud Native Computing Foundation's](https://www.cncf.io/) project [Backstage](https://backstage.io/).

Tanzu Developer Portal consists of the following components:

- **Your organization catalog:**

  The catalog serves as the primary visual representation of your running services (components) and
  applications (systems).

- **Tanzu Developer Portal plug-ins:**

  These plug-ins expose capabilities regarding specific Tanzu Application Platform tools.
  Initially the included plug-ins are:

  - Runtime Resources Visibility
  - Application Live View
  - Application Accelerator
  - API Documentation
  - Supply Chain Choreographer

- **TechDocs:**

  This plug-in enables you to store your technical documentation in Markdown format in a source-code
  repository and display it alongside the relevant catalog entries.

  ![Screenshot of a Tanzu Application Platform catalog displayed within Tanzu Developer Portal.](images/tap-gui-catalog.png)

- **Search:**

  This plug-in enables you to search your organization's catalog, including domains, systems,
  components, APIs, accelerators, and TechDocs.

- **A Git repository:**

  Tanzu Developer Portal stores the following in a Git repository:

  - The structure for your application catalog.
  - Your technical documentation about the catalog items, if you enable Tanzu Developer Portal
    TechDocs capabilities.

You can host the structure for your application catalog and your technical documentation in the same
repository as your source code.
