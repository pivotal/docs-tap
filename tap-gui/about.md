# Tanzu Application Platform GUI

Tanzu Application Platform GUI is a tool for your developers to view your organization's running
applications and services.
This portal provides a central location in which you can view dependencies, relationships, technical
documentation, and even service status.

Tanzu Application Platform GUI is built from the
[Cloud Native Computing Foundation's](https://www.cncf.io/) project [Backstage](https://backstage.io/).

Tanzu Application Platform GUI is comprised of the following components:

* **Your Organization Catalog:**
  The catalog serves as the primary visual representation of your running services (Components) and
  Applications (Systems).

* **Tanzu Application Platform GUI plugins:**
  These plugins expose capabilities regarding specific Tanzu Application Platform tools.
  Initially the included plugins are:
  * Runtime Resources Visibility
  * Application Live View
  * Application Accelerator
  * API Documentation

* **TechDocs:**
  This plugin enables you to store your technical documentation in Markdown format in a source-code
  repository and display it alongside the relevant catalog entries.

  ![Tanzu Application Platform Catalog](./images/tap-gui-catalog.png)
  
* **A Git Repository:**  
The Tanzu Application Platform GUI stores the following in a Git repository:
  * The structure for your application catalog.
  * Your technical documentation about the catalog items, if you enable the Tanzu Application Platform GUI TechDocs capabilities.

You can host the structure for your application catalog and your technical documentation in the same repository as your source code. 
