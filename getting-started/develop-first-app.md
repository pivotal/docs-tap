# Develop your first application on Tanzu Application Platform

This topic will guide you through developing your first application on Tanzu Application Platform. Before you start, be sure you've completed all of the [Getting started prerequisites](../getting-started.md#get-started-prereqs).

## <a id="about-app-accs"></a>About application accelerators

Developers can create applications and get started with feature development immediately with the help of application accelerators. Application accelerators are templates that not only codify best practices, but also provide important configuration and structures ready and available for use. Admins can create custom application accelerators that reflect desired architectures and configurations, enabling developers to develop according to the defined best practices. The Application Accelerator plug-in of Tanzu Application Platform GUI assists both application developers and admins with creating and generating application accelerators. To create your own application accelerator, see [Create your application accelerator](create-app-accelerator.md).

## <a id="deploy-your-app"></a>Deploy your application

To deploy your application, you must download an accelerator, upload it on your Git repository of choice, and run a CLI command. VMware recommends using the accelerator called `Tanzu-Java-Web-App`.

1. From  Tanzu Application Platform GUI portal, click **Create** located on the left-hand side of the
   navigation bar to see the list of available accelerators.
   For information about connecting to Tanzu Application Platform GUI, see
   [Accessing Tanzu Application Platform GUI](../tap-gui/accessing-tap-gui.md.hbs).

    ![List of accelerators in Tanzu Application Platform GUI](../images/getting-started-tap-gui-1.png)

2. Locate the Tanzu Java Web App accelerator, which is a Spring Boot web app, and click **CHOOSE**.

    ![Tile for Tanzu Java Web App Getting Started GUI](../images/getting-started-tap-gui-2.png)

3. In the **Generate Accelerators** dialog box, replace the default value `dev.local` in the **prefix for container image registry** field
   with the registry in the form of `SERVER-NAME/REPO-NAME`.
   The `SERVER-NAME/REPO-NAME` must match what was specified for `registry` as part of the installation values for `ootb_supply_chain_basic`.
   Click **NEXT STEP**, verify the provided information, and click **CREATE**.

    ![Generate Accelerators prompt](../images/getting-started-tap-gui-3.png)

4. After the Task Activity processes complete, click **DOWNLOAD ZIP FILE**.

    ![Task Activity progress bar](../images/getting-started-tap-gui-4.png)

5. After downloading the ZIP file, expand it in a workspace directory and follow your preferred procedure for uploading the generated project files to a Git repository for your new project.

6. Ensure you have [set up developer namespaces to use installed packages](../install-components.md#setup).

7. Deploy the Tanzu Java Web App accelerator by running the `tanzu apps workload create` command:

    ```console
    tanzu apps workload create tanzu-java-web-app \
    --git-repo GIT-URL-TO-PROJECT-REPO \
    --git-branch main \
    --type web \
    --label app.kubernetes.io/part-of=tanzu-java-web-app \
    --yes \
    --namespace YOUR-DEVELOPER-NAMESPACE
    ```

    Where `GIT-URL-TO-PROJECT-REPO` is the path you uploaded to in step 5 and `YOUR-DEVELOPER-NAMESPACE` is the namespace configured in step 6.

    If you bypassed step 5 or were unable to upload your accelerator to a Git repository, use the following public version to test:

    ```console
    tanzu apps workload create tanzu-java-web-app \
    --git-repo https://github.com/sample-accelerators/tanzu-java-web-app \
    --git-branch main \
    --type web \
    --label app.kubernetes.io/part-of=tanzu-java-web-app \
    --yes \
    --namespace YOUR-DEVELOPER-NAMESPACE
    ```

    Where `YOUR-DEVELOPER-NAMESPACE` is the namespace configured in step 6.

    For more information, see [Tanzu Apps Workload Create](../cli-plugins/apps/command-reference/tanzu-apps-workload-create.md).

    > **Note:** This deployment uses an accelerator source from Git, but in later steps you use the VSCode extension
    to debug and live-update this application.

8. View the build and runtime logs for your app by running the `tail` command:

    ```console
    tanzu apps workload tail tanzu-java-web-app --since 10m --timestamp --namespace YOUR-DEVELOPER-NAMESPACE
    ```

    Where `YOUR-DEVELOPER-NAMESPACE` is the namespace configured in step 6.

9. After the workload is built and running, you can view the Web App in your browser. View the URL of the Web App by running the command below, and then press **ctrl-click** on the
   Workload Knative Services URL at the bottom of the command output.

    ```console
    tanzu apps workload get tanzu-java-web-app --namespace YOUR-DEVELOPER-NAMESPACE
    ```

    Where `YOUR-DEVELOPER-NAMESPACE` is the namespace configured in step 6.

    ![Tanzu-java-web-app default screen](../images/getting-started-tap-gui-8.png)


## <a id="add-app-to-gui-cat"></a>Add your application to Tanzu Application Platform GUI Software Catalog

1. Navigate to the home page of Tanzu Application Platform GUI and click **Home**, located on the left-side navigation bar.
   Click **REGISTER ENTITY**.

    ![REGISTER button on the right side of the header](../images/getting-started-tap-gui-5.png)

    Alternatively, you can add a link to the `catalog-info.yaml` to the `tap-values.yaml` configuration file in the `tap_gui.app_config.catalog.locations` section. See [Installing the Tanzu Application Platform Package and Profiles](../install.md.hbs#full-profile).

1. **Register an existing component** prompts you to type a repository URL.
Type the link to the `catalog-info.yaml` file of the tanzu-java-web-app in the Git repository field, for example,
`https://github.com/USERNAME/PROJECTNAME/blob/main/catalog-info.yaml`.

1. Click **ANALYZE**.

    ![Select URL](../images/getting-started-tap-gui-6.png)

1. Review the catalog entities to be added and click **IMPORT**.

    ![Review the entities to be added to the catalog](../images/getting-started-tap-gui-7.png)

1. Navigate back to the home page. The catalog changes and entries are visible for further inspection.

>**Note:** If your Tanzu Application Platform GUI instance does not have a [PostgreSQL](../tap-gui/database.md.hbs) database configured, the `catalog-info.yaml` location must be re-registered after the instance is restarted or upgraded.

## Next step

- [Work with your new application](work-with-new-app.md)
