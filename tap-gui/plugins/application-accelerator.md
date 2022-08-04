# Application Accelerator in Tanzu Application Platform GUI

This topic describes Application Accelerator in Tanzu Application Platform GUI.

## <a id="overview"></a> Overview

Application Accelerator for VMware Tanzu helps you bootstrap developing and deploying your
applications in a discoverable and repeatable way.

Enterprise architects author and publish accelerator projects that provide developers and operators
with ready-made, enterprise-conforming code and configurations.
You can then use Application Accelerator to create new projects based on those accelerator projects.

The Application Accelerator UI enables you to discover available accelerators, configure them, and
generate new projects to download.

## <a id='entry-point'></a>Access Application Accelerator

To open the Application Accelerator UI plug-in and select an accelerator:

1. Click **Create** in the left-hand navigation bar of Tanzu Application Platform to open the
   **Accelerators** page.

    ![Screenshot of Accelerators page](images/aa1-acc-page.png)

    Here you can view accelerators already registered with the system.
    Developers can add new accelerators by registering them with Kubernetes.

2. Every accelerator provides a title and short description.
   Click **View Repository** to view an accelerator definition. This opens the accelerator's Git
   repository in a new browser tab.

3. Search and filter based on text and tags associated with the accelerators to find the accelerator
   representing the project you want to create.

4. Click **Choose** next to the accelerator you want. This opens the **Generate Accelerators** page.

## <a id='configure-project'></a> Configure project generation

To configure how projects are generated:

1. On the **Generate Accelerators** page, add any configuration values needed to generate the
   project. The application architect defined these values in `accelerator.yaml` in the accelerator
   definition.
   Filling some fields can cause other fields to appear that you must also fill in.

    ![Example configuration page for an accelerator.](images/aa2-configuringAnAccelerator.png)

2. Click **Explore** on the **Generate Accelerators** page to view the project before it is generated.
   This opens the **Explore Project** page.

    ![Screenshot of the Explore Project page.](images/aa3-exploringProject.png)

3. After configuring your project, click **Next Step** to see the project summary page.

4. Review the values you specified for the configurable options.

5. Click **Back** to make more changes, if necessary. Otherwise, proceed to [create the project](#create-project).

    ![Screenshot showing the configured project summary.](images/aa4-configuredProjectSummary.png)

## <a id='create-project'></a> Create the project

To create the project:

1. Click **Create** to start generating your project. See the progress on the **Task Activity** page.
   Detailed logs are displayed on the right.

    ![Task activity during project creation](images/aa5-taskActivity.png)

2. After the project is generated, click **Explore Zip File** to open the **Explore Project**
   page to verify configuration.

3. Click **Download Zip File** to download the project in a ZIP file.

## <a id='develop-your-code'></a>Develop your code

1. Expand the ZIP file.
2. Open the project in your integrated development environment (IDE).

    ![Screenshot of working on a project in Visual Studio Code](images/aa6-ide.png)

## <a id='next-steps'></a>Next steps

To learn more about Application Accelerator for VMware Tanzu, see the
[Application Accelerator documentation](../../application-accelerator/about-application-accelerator.md).
