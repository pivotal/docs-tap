# Application accelerators on Tanzu Application Platform

This topic describes the key concepts you need to know about application accelerators on
Tanzu Application Platform (commonly known as TAP).

Application accelerators are templates that not only codify best practices but also provide important
configuration and structures ready and available for use.
Developers can create applications and get started with feature development immediately with the help
of application accelerators.

Enterprise Architects use Application Accelerator to create application accelerators, which provide
developers and admins in their organization with ready-made, enterprise-conformant code and configurations.
Accelerators contain complete and runnable application code and deployment configurations.
They also contain metadata for altering the code and deployment configurations based on input values
provided for specific options defined in the accelerator metadata.

## <a id="work-with-accelerators"></a>Working with accelerators

The Application Accelerator plug-in for Tanzu Application Platform GUI helps you to discover accelerators
and to enter extra information used for processing the files before downloading.
As of Tanzu Application Platform v1.2, developers can also discover and work on accelerators right in
Visual Studio Code with the Tanzu Application Accelerator for VS Code extension.
Developers can use the `list`, `get`, and `generate` commands to use accelerators available in an
Application Accelerator server.

Admins use the `create`, `update`, and `delete` commands for managing accelerators in a Kubernetes context.
When admins want to use the `get` and `list` commands, they can specify the `--from-context` flag to
access accelerators in a Kubernetes context.

## Next steps

Apply what you have learned:

Developers:

- [Deploy an app on Tanzu Application Platform](deploy-first-app.md)

Operators:

- [Create an application accelerator](create-app-accelerator.md)
