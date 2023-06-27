# Application Accelerator Overview

This topic tells you about the Application Accelerator component and architecture.

## <a id="overview"></a>Overview

Application Accelerator for VMware Tanzu helps you bootstrap developing your applications and deploying them in a discoverable and repeatable way.

Enterprise Architects author and publish accelerator projects that provide developers and operators in their organization ready-made, enterprise-conformant code and configurations.

Published accelerators projects are maintained in Git repositories. You can then use Application Accelerator to create new projects based on those accelerator projects.

The Application Accelerator user interface(UI) enables you to discover available accelerators, configure them, and generate new projects to download.

## <a id="architecture"></a>Architecture

The following diagram of Accelerator components illustrates the Application Accelerator architecture.

![Accelerator repos interacting with Kubernetes cluster containing Controllers, Template Engine, and API server. APIs, CLI tools, web UI, and IDE also shown.](images/architecture-v1-3-0.png)

### <a id="how-does-it-work"></a>How does Application Accelerator work?

Application Accelerator allows you to generate new projects from files in Git repositories.
An `accelerator.yaml` file in the repository declares input options for the accelerator.
This file also contains instructions for processing the files when you generate a new project.

Accelerator custom resources (CRs) control which repositories appear in the Application Accelerator UI.
You can maintain CRs by using Kubernetes tools such as kubectl or by using the Tanzu CLI accelerator commands.
The Accelerator controller reconciles the CRs with a Flux2 Source Controller to fetch files from GitHub or GitLab.

The Application Accelerator web UI gives you a searchable list of accelerators to choose from.
After you select an accelerator, the UI presents input fields for any input options.

Application Accelerator sends the input values to the Accelerator Engine for processing.
The Engine then returns the project in a ZIP file.
You can open the project in your favorite integrated development environment (IDE) to develop further.

## <a id="next-steps"></a>Next steps

Learn more about:

- [Creating Accelerators](creating-accelerators/creating-accelerators.md)
