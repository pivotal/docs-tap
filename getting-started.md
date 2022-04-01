# Getting started with the Tanzu Application Platform

## <a id="purpose"></a>Purpose

Welcome to the Tanzu Application Platform. This document guides you through getting started on the platform. Specifically, you are going to learn how to:

  - Develop and promote an application
  - Create an application accelerator
  - Add testing and security scanning to an application
  - Administer, set up, and manage supply chains

Before getting started, you must complete the prerequisites in the next section.


## <a id="get-started-prereqs"></a>Getting started prerequisites

Verify you have successfully:

  - **Installed the Tanzu Application Platform**<br>
See [Installing Tanzu Application Platform](install-intro.md).

  - **Installed the Tanzu Application Platform on the target Kubernetes cluster**<br>
See [Installing the Tanzu CLI](install-tanzu-cli.md) and [Installing the Tanzu Application Platform Package and Profiles](install.md).

  - **Set the default kubeconfig context to the target Kubernetes cluster**<br>
See [Changing clusters](cli-plugins/apps/usage.md#changing-clusters).

  - **Installed Out of The Box (OOTB) Supply Chain Basic**<br>
See [Install Out of The Box Supply Chain Basic](scc/install-ootb-sc-basic.md).

    >**Note:** If you used the default profiles provided in [Installing the Tanzu Application Platform Package and Profiles](install.md),
    you have already installed the Out of The Box (OOTB) Supply Chain Basic.

  - **Installed Tekton-Pipelines**<br>
See [Install Tekton Pipelines](install-components.md#install-tekton-pipelines).

    >**Note:** If you used the default profiles provided in [Installing the Tanzu Application Platform Package and Profiles](install.md),
    you have already installed Tekton Pipelines.

  - **Set up a developer namespace to accommodate the developer Workload**<br>
See [Set up developer namespaces to use installed packages](install-components.md#setup).

  - **Installed Tanzu Application Platform GUI**<br>
See [Install Tanzu Application Platform GUI](install-components.md#install-tap-gui).

  - **Installed the VSCode Tanzu Extension**<br>
See [Install the Visual Studio Code Tanzu Extension](vscode-extension/installation.md) for instructions.

When you have completed the prerequisites, you are ready to get started.

## <a id="dev-first-app"></a>Section 1: Develop your first application on the Tanzu Application Platform

In this section, you are going to:

  - Learn about application accelerators
  - Deploy your application
  - Add your application to Tanzu Application Platform GUI Software Catalog
  - Set up your integrated development environment (IDE)
  - Iterate on your application
  - Live update your application
  - Debug your application
  - Monitor your running application


### <a id="about-app-accs"></a>About application accelerators


Application accelerators are templates that not only codify best practices, but also provide important configuration and structures ready and available for use. Developers can create applications and get started with feature development immediately. Admins can create custom application accelerators that reflect desired architectures and configurations, enabling developer use according to the best practices defined. The Application Accelerator plug-in of Tanzu Application Platform GUI assists both application developers and admins with creating and generating application accelerators. To create your own application accelerator, see [Create your accelerator](#create-app-acc).


### <a id="deploy-your-app"></a>Deploy your application

To deploy your application, you must download an accelerator, upload it on your Git repository of choice, and run a CLI command. VMware recommends using the accelerator called `Tanzu-Java-Web-App`.

1. From  Tanzu Application Platform GUI portal, click **Create** located on the left-hand side of the
   navigation bar to see the list of available accelerators.
   For information about connecting to Tanzu Application Platform GUI, see
   [Accessing Tanzu Application Platform GUI](tap-gui/accessing-tap-gui.md).

    ![List of accelerators in Tanzu Application Platform GUI](images/getting-started-tap-gui-1.png)

2. Locate the Tanzu Java Web App accelerator, which is a Spring Boot web app, and click **CHOOSE**.

    ![Tile for Tanzu Java Web App Getting Started GUI](images/getting-started-tap-gui-2.png)

3. In the **Generate Accelerators** dialog box, replace the default value `dev.local` in the **prefix for container image registry** field
   with the registry in the form of `SERVER-NAME/REPO-NAME`.
   The `SERVER-NAME/REPO-NAME` must match what was specified for `registry` as part of the installation values for `ootb_supply_chain_basic`.
   Click **NEXT STEP**, verify the provided information, and click **CREATE**.

    ![Generate Accelerators prompt](images/getting-started-tap-gui-3.png)

4. After the Task Activity processes complete, click **DOWNLOAD ZIP FILE**.

    ![Task Activity progress bar](images/getting-started-tap-gui-4.png)

5. After downloading the ZIP file, expand it in a workspace directory and follow your preferred procedure for uploading the generated project files to a Git repository for your new project.

6. Ensure you have [set up developer namespaces to use installed packages](install-components.md#setup).

7. Deploy the Tanzu Java Web App accelerator by running the `tanzu apps workload create` command:

    ```
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

    ```
    tanzu apps workload create tanzu-java-web-app \
    --git-repo https://github.com/sample-accelerators/tanzu-java-web-app \
    --git-branch main \
    --type web \
    --label app.kubernetes.io/part-of=tanzu-java-web-app \
    --yes \
    --namespace YOUR-DEVELOPER-NAMESPACE
    ```
    
    Where `YOUR-DEVELOPER-NAMESPACE` is the namespace configured in step 6.
    
    For more information, see [Tanzu Apps Workload Create](cli-plugins/apps/command-reference/tanzu-apps-workload-create.md).

    > **Note:** This deployment uses an accelerator source from Git, but in later steps you use the VSCode extension
    to debug and live-update this application.

8. View the build and runtime logs for your app by running the `tail` command:

    ```
    tanzu apps workload tail tanzu-java-web-app --since 10m --timestamp --namespace YOUR-DEVELOPER-NAMESPACE
    ```
    
    Where `YOUR-DEVELOPER-NAMESPACE` is the namespace configured in step 6.

9. After the workload is built and running, you can view the Web App in your browser. View the URL of the Web App by running the command below, and then press **ctrl-click** on the
   Workload Knative Services URL at the bottom of the command output.

    ```
    tanzu apps workload get tanzu-java-web-app --namespace YOUR-DEVELOPER-NAMESPACE
    ```
    
    Where `YOUR-DEVELOPER-NAMESPACE` is the namespace configured in step 6.

    ![Tanzu-java-web-app default screen](images/getting-started-tap-gui-8.png)


### <a id="add-app-to-gui-cat"></a>Add your application to Tanzu Application Platform GUI Software Catalog

1. Navigate to the home page of Tanzu Application Platform GUI and click **Home**, located on the left-side navigation bar.
   Click **REGISTER ENTITY**.

    ![REGISTER button on the right side of the header](images/getting-started-tap-gui-5.png)

>**Note:** Alternatively, you can add a link to the `catalog-info.yaml` to the `tap-values.yml` configuration file in the `tap_gui.app_config.catalog.locations` section. See [Installing the Tanzu Application Platform Package and Profiles](install.md#a-idfull-profilea-full-profile).

1. **Register an existing component** prompts you to type a repository URL.
Type the link to the `catalog-info.yaml` file of the tanzu-java-web-app in the Git repository field, for example,
`https://github.com/USERNAME/PROJECTNAME/blob/main/catalog-info.yaml`.

1. Click **ANALYZE**.

    ![Select URL](images/getting-started-tap-gui-6.png)

1. Review the catalog entities to be added and click **IMPORT**.

    ![Review the entities to be added to the catalog](images/getting-started-tap-gui-7.png)

1. Navigate back to the home page. The catalog changes and entries are visible for further inspection.

>**Note:** If your Tanzu Application Platform GUI instance does not have a [PostgreSQL](tap-gui/database.md) database configured, then the `catalog-info.yaml` location must be re-registered after the instance is restarted or upgraded.

### <a id="iterate"></a>Iterate on your application

Now that you have a skeleton workload working, you are ready to iterate on your application
and test code changes on the cluster.
Tanzu Developer Tools for Visual Studio Code, VMware Tanzu’s official IDE extension for VSCode,
helps you develop and receive fast feedback on your workloads running on the Tanzu Application Platform.

The VSCode extension enables live updates of your application while running on the cluster
and allows you to debug your application directly on the cluster.
For information about installing the prerequisites and the Tanzu Developer Tools extension, see
[Install Tanzu Dev Tools for VSCode](vscode-extension/installation.md).


>**Note:** Use Tilt v0.23.2 or a later version for the sample application.

1. Open the Tanzu Java Web App as a project within your VSCode IDE.

2. To ensure your extension assists you with iterating on the correct project, configure its settings using the following instructions.

   -  In Visual Studio Code, navigate to `Preferences` > `Settings` > `Extensions` > `Tanzu`.
   - In the **Local Path** field, provide the path to the directory containing the Tanzu Java Web App. The current directory is the default.
   - In the **Source Image** field, provide the destination image repository to publish an image containing your workload source code.
    For example, `gcr.io/myteam/tanzu-java-web-app-source`.

You are now ready to iterate on your application.

### <a id="live-update-your-app"></a>Live update your application

Deploy the application to view it updating live on the cluster to demonstrate how code changes are going to behave on a production cluster early in the development process.

Follow the following steps to live update your application:

1. From the Command Palette (⇧⌘P), type in and select `Tanzu: Live Update Start`.
You can view output from Tanzu Application Platform and from Tilt indicating that the container is being built and deployed.
    - You see "Live Update starting..." in the status bar at the bottom right.
    - Live update can take 1 to 3 minutes while the workload deploys and the Knative service becomes available.

    >**Note:** Depending on the type of cluster you use, you might see an error similar to the following:

    >`ERROR: Stop! cluster-name might be production.
    >If you're sure you want to deploy there, add:
    >allow_k8s_contexts('cluster-name')
    >to your Tiltfile. Otherwise, switch k8scontexts and restart Tilt.
      `
    >Follow the instructions and add the line `allow_k8s_contexts('cluster-name')` to your `Tiltfile`.

2. When the Live Update status in the status bar is visible, resolve to "Live Update Started", navigate to `http://localhost:8080` in your browser, and view your running application.
3. Enter to the IDE and make a change to the source code. For example, in `HelloController.java`, edit the string returned to say `Hello!` and save.
4. The container is updated when the logs stop streaming. Navigate to your browser and refresh the page.
5. View the changes to your workload running on the cluster.
6. Either continue making changes, or stop and deactivate the live update when finished. Open the command palette (⇧⌘P), type `Tanzu`, and choose an option.

### <a id="debug-your-app"></a>Debug your application

Debug your cluster either on the application or in your local environment.

Follow the following steps to debug your cluster:

1. Set a breakpoint in your code.
2. Right-click the file `workload.yaml` within the `config` directory, and select **Tanzu: Java Debug Start**. In a few moments, the workload is redeployed with debugging enabled. You are going to see the "Deploy and Connect" Task complete and the debug menu actions are available to you, indicating that the debugger has attached.
3. Navigate to `http://localhost:8080` in your browser. This hits the breakpoint within VSCode. Play to the end of the debug session using VSCode debugging controls.

### <a id="monitor-running-app"></a>Monitor your running application

Inspect the runtime characteristics of your running application using the Application Live View UI to monitor:

* Resource consumption
* Java Virtual Machine (JVM) status
* Incoming traffic
* Change log level

You can also troubleshoot environment variables and fine-tune the running application.

Follow the following steps to diagnose Spring Boot-based applications using Application Live View:

1. Confirm that the Application Live View components installed successfully. For instructions, see [Verify the Application Live View components](https://docs.vmware.com/en/Application-Live-View-for-VMware-Tanzu/1.0/docs/GUID-installing.html#verify-the-application-live-view-components-5).

1. Access the Application Live View Tanzu Application Platform GUI. For instructions, see [Entry point to Application Live View plug-in](tap-gui/plugins/app-live-view.html#plug-in-entry-point).

1. Select your running application to view the diagnostic options and inside the application. For more information, see [Product Features](https://docs.vmware.com/en/Application-Live-View-for-VMware-Tanzu/1.0/docs/GUID-product-features.html).


---


## <a id='create-app-acc'></a>Section 2: Create your application accelerator

In this section, you are going to create an application accelerator by using Tanzu Application Platform GUI and CLI.

### <a id="create-an-app-acc"></a>Create an application accelerator

You can use any Git repository to create an accelerator. You need the repository URL to create an accelerator.

The Git repository must be `public` and contain a `README.md` file. These options are available to configure when you create repositories on GitHub.

To create a new application accelerator by using your Git repository, follow these steps:

1. Clone your Git repository.

2. Create a file named `accelerator.yaml` in the root directory of this Git repository.

3. Add the following content to the `accelerator.yaml` file:

    ```yaml
    accelerator:
      displayName: Simple Accelerator
      description: Contains just a README
      iconUrl: https://images.freecreatives.com/wp-content/uploads/2015/05/smiley-559124_640.jpg
      tags:
      - simple
      - getting-started
    ```

    >**Note:** You can use any icon with a reachable URL.

4. Add the new `accelerator.yaml` file, commit this change and push to your Git repository.

## <a id="publish-accelerator"></a>Publish the new accelerator

To publish the new application accelerator that is created in your Git repository, follow these steps:

1. Run the following command to publish the new application accelerator:

    ```sh
    tanzu accelerator create simple --git-repository YOUR-GIT-REPOSITORY-URL --git-branch YOUR-GIT-BRANCH
    ```

    Where:
    
    - `YOUR-GIT-REPOSITORY-URL` is the URL of your Git repository.
    - `YOUR-GIT-BRANCH` is the name of the branch where you pushed the new `accelerator.yaml` file.

2. Refresh Tanzu Application Platform GUI to reveal the newly published accelerator.

    ![Another accelerator appears in Tanzu Application Platform GUI](images/new-accelerator-deployed-v1.1.png)

    >**Note:** It might take a few seconds for Tanzu Application Platform GUI to refresh the catalog and add an entry for new accelerator.

## <a id="work-with-accelerators"></a>Working with accelerators

### <a id="accelerator-updates"></a>Updating an accelerator

After you push any changes to your Git repository, the Accelerator is refreshed based on the `git.interval` setting for the Accelerator resource. The default value is 10 minutes. You can run the following command to force an immediate reconciliation:

```
tanzu accelerator update ACCELERATOR-NAME --reconcile
```

### <a id="accelerator-deletes"></a>Deleting an accelerator

When you no longer need your accelerator, you can delete it by using the Tanzu CLI:

```
tanzu accelerator delete ACCELERATOR-NAME
```

### <a id="accelerator-manifest"></a>Using an accelerator manifest

You can also create a separate manifest file and apply it to the cluster by using the Tanzu CLI:

1. Create a `simple-manifest.yaml` file and add the following content:

    ```yaml
    apiVersion: accelerator.apps.tanzu.vmware.com/v1alpha1
    kind: Accelerator
    metadata:
      name: simple
      namespace: accelerator-system
    spec:
      git:
        url: YOUR-GIT-REPOSITORY-URL
        ref:
          branch: YOUR-GIT-BRANCH
    ```

    Where:

    - `YOUR-GIT-REPOSITORY-URL` is the URL of your Git repository.
    - `YOUR-GIT-BRANCH` is the name of the branch.

1. Apply the `simple-manifest.yaml` by running the following command in the directory where you created this file:

    ```sh
    kubectl apply -f simple-manifest.yaml
    ```

---

## <a id="add-test-and-scan"></a> Section 3: Add Testing and Security Scanning to Your Application

In this section, you are going to:
- Learn about supply chains
- Discover available out of the box (OOTB) supply chains
  -  OOTB Basic (default)
  -  OOTB Testing
  -  OOTB Testing+Scanning
- Install OOTB Testing (optional)
- Install OOTB Testing+Scanning (optional)


### <a id="intro-supply-chain"></a>Introducing a Supply Chain

Supply Chains provide a way of codifying all of the steps of your path to production, more commonly known as continuous integration/Continuous Delivery (CI/CD). CI/CD is a method to frequently deliver applications by introducing automation into the stages of application development. The main concepts attributed to CI/CD are continuous integration, continuous delivery, and continuous deployment. CI/CD is the method used by supply chain to deliver applications through automation where supply chain allows you to use CI/CD and add any other steps necessary for an application to reach production, or a different environment such as staging.

![Diagram depicting a simple path to production: CI to Security Scan to Build Image to Image Scan to CAB Approval to Deployment.](images/path-to-production-new.png)

### <a id="path-to-prod"></a>A path to production

A path to production allows users to create a unified access point for all of the tools required
for their applications to reach a customer-facing environment.
Instead of having four tools that are loosely coupled to each other, a path to production defines
all four tools in a single, unified layer of abstraction, which may be automated and repeatable between teams for applications at scale.

Where tools typically are not able to integrate with one another and additional scripting or
webhooks are necessary, there would be a unified automation tool to codify all the interactions
between each of the tools.
Supply chains used to codify the organization's path to production are configurable, allowing their
authors to add all of the steps of their application's path to production.

### <a id="avail-supply-chains"></a>Available Supply Chains

The Tanzu Application Platform provides three OOTB supply chains to
work with the Tanzu Application Platform components, and they include:

### <a id="OOTB-basic-sc-default"></a>1: **OOTB Basic (default)**

The default **OOTB Basic** supply chain and its dependencies were installed on your cluster during the Tanzu Application Platform install.
The following table and diagrams provide descriptions for each of the supply chains and dependencies provided with the Tanzu Application Platform.

![Diagram depicting the Source-to-URL chain: Watch Repo (Flux) to Build Image (TBS) to Apply Conventions to Deploy to Cluster (CNR).](images/source-to-url-chain-new.png)

<table>
  <tr>
   <td><strong>Name</strong>
   </td>
   <td><strong>Package Name</strong>
   </td>
   <td><strong>Description</strong>
   </td>
   <td><strong>Dependencies</strong>
   </td>
  </tr>
  <tr>
   <td><strong>Out of the Box Basic (Default - Installed during Installing Part 2)</strong>
   </td>
   <td><code>ootb-supply-chain-basic.tanzu.vmware.com</code>
   </td>
   <td>This supply chain monitors a repository that is identified in the developer’s `workload.yaml` file. When any new commits are made to the application, the supply chain:
<ul>

<li>Creates a new image.

<li>Applies any predefined conventions.

<li>Deploys the application to the cluster.
</li>
</ul>
   </td>
   <td>
<ul>

<li>Flux/Source Controller

<li>Tanzu Build Service

<li>Convention Service

<li>Tekton

<li>Cloud Native Runtimes
<li>If using Service References:
   </li>
<ul>
<li>Service Bindings
<li>Services Toolkit
   </li>
   </ul>
</ul>
   </td>
  </tr>
</table>

### <a id="OOTB-testing"></a>2: **OOTB Testing**

The **OOTB Testing** supply chain runs a Tekton pipeline within the supply chain.

![Diagram depicting the Source-and-Test-to-URL chain: Watch Repo (Flux) to Test Code (Tekton) to Build Image (TBS) to Apply Conventions to Deploy to Cluster (CNR).](images/source-and-test-to-url-chain-new.png)

<table>
  <tr>
   <td><strong>Name</strong>
   </td>
   <td><strong>Package Name</strong>
   </td>
   <td><strong>Description</strong>
   </td>
   <td><strong>Dependencies</strong>
   </td>
  </tr>
  <tr>
   <td><strong>Out of the Box Testing</strong>
   </td>
   <td><code>ootb-supply-chain-testing.tanzu.vmware.com</code>
   </td>
   <td>The Out of the Box Testing contains all of the same elements as the Source to URL. It allows developers to specify a Tekton pipeline that runs as part of the CI step of the supply chain.
<ul>

<li>The application tests using the Tekton pipeline.

<li>A new image is created.

<li>Any predefined conventions are applied.

<li>The application is deployed to the cluster.
</li>
</ul>
   </td>
   <td>All of the Source to URL dependencies
<ul>

</ul>
   </td>
  </tr>
</table>

### <a id="OOTB-test-and-scan"></a>3: **OOTB Testing+Scanning**

The **OOTB Testing+Scanning** supply chain includes integrations for secure scanning tools.

![Diagram depicting the Source-and-Test-to-URL chain: Watch Repo (Flux) to Test Code (Tekton) to Build Image (TBS) to Apply Conventions to Deploy to Cluster (CNR).](images/source-test-scan-to-url-new.png)

<table>
  <tr>
   <td><strong>Name</strong>
   </td>
   <td><strong>Package Name</strong>
   </td>
   <td><strong>Description</strong>
   </td>
   <td><strong>Dependencies</strong>
   </td>
  </tr>
  <tr>
   <td><strong>Out of the Box Testing and Scanning</strong>
   </td>
   <td><code>ootb-supply-chain-testing-scanning.tanzu.vmware.com</code>
   </td>
   <td>The Out of the Box Testing and Scanning contains all of the same elements as the Out of the Box Testing supply chains but it also includes integrations out of the box with the secure scanning components of Tanzu Application Platform.
<ul>

<li>The application is tested using the provided Tekton pipeline.
<li>The application source code is scanned for vulnerabilities.

<li>A new image is created.
<li>The image is scanned for vulnerabilities.

<li>Any predefined conventions are applied.

<li>The application deploys to the cluster.
</li>
</ul>
   </td>
   <td>All of the Source to URL dependencies, and:
<ul>

<li>The secure scanning components included with Tanzu Application Platform
</li>
</ul>
   </td>
  </tr>
</table>

### <a id="install-ootb-test"></a>Install OOTB Testing

This section introduces how to install the OOTB Testing supply chain and
provides a sample Tekton pipeline that tests your sample application.  The
pipeline is configurable. Therefore, you can customize the steps to perform
either additional testing or other tasks with Tekton Pipelines.

To apply this install method, follow the following steps:

1. You can activate the Out of the Box Supply Chain with Testing by updating our profile to use `testing` rather than `basic` as the selected supply chain for workloads in this cluster. Update `tap-values.yml` (the file used to customize the profile in `Tanzu package install tap
--values-file=...`) with the following changes:

    ```
    - supply_chain: basic
    + supply_chain: testing

    - ootb_supply_chain_basic:
    + ootb_supply_chain_testing:
        registry:
          server: "<SERVER-NAME>"
          repository: "<REPO-NAME>"
    ```

2. Update the installed profile by running:

    ```
    tanzu package installed update tap -p tap.tanzu.vmware.com -v 1.0.0 --values-file tap-values.yml -n tap-install
    ```


#### <a id="tekton-config-example"></a>Tekton pipeline config example

In this section, a Tekton pipeline is added to the cluster. In the next section,
the workload is updated to point to the pipeline and resolve any current errors.

To add the Tekton supply chain to the cluster, apply the following YAML to the cluster:

>**Note:** Developers can perform this step because they know how their application needs to be tested.
The operator can also add the Tekton supply chain to a cluster before the developer get access.

```
apiVersion: tekton.dev/v1beta1
kind: Pipeline
metadata:
  name: developer-defined-tekton-pipeline
  labels:
    apps.tanzu.vmware.com/pipeline: test     # (!) required
spec:
  params:
    - name: source-url                       # (!) required
    - name: source-revision                  # (!) required
  tasks:
    - name: test
      params:
        - name: source-url
          value: $(params.source-url)
        - name: source-revision
          value: $(params.source-revision)
      taskSpec:
        params:
          - name: source-url
          - name: source-revision
        steps:
          - name: test
            image: gradle
            script: |-
              cd `mktemp -d`

              wget -qO- $(params.source-url) | tar xvz -m
              ./mvnw test
```

The preceding YAML defines a Tekton Pipeline with a single step.
The step itself contained in the `steps` pull the code from the repository indicated
in the developers `workload` and run the tests within the repository.
The steps of the Tekton pipeline are configurable and allow the developer to add any additional items
that is needed to test their code.
Because this step is one of many in the supply chain (and the next step is an image build in this case),
the developer is free to focus on testing their code.
Any additional steps that the developer adds to the Tekton pipeline is independent
for the image being built and any subsequent steps of the supply chain being executed.

The `params` are templated by the Supply Chain Choreographer.
Additionally, Tekton pipelines require a Tekton `pipelineRun` in order to execute on the cluster.
The Supply Chain Choreographer handles creating the `pipelineRun` dynamically each time
that step of the supply requires execution.

#### <a id="test-workload-update"></a>Workload update

To connect the new supply chain to the workload,
the workload must be updated to point at your Tekton pipeline.

1. Update the workload by running the following with the Tanzu CLI:

    ```
    tanzu apps workload create tanzu-java-web-app \
      --git-repo https://github.com/sample-accelerators/tanzu-java-web-app \
      --git-branch main \
      --type web \
      --label apps.tanzu.vmware.com/has-tests=true \
      --yes
    ```

    ```
    Create workload:
        1 + |---
        2 + |apiVersion: carto.run/v1alpha1
        3 + |kind: Workload
        4 + |metadata:
        5 + |  labels:
        6 + |    apps.tanzu.vmware.com/has-tests: "true"
        7 + |    apps.tanzu.vmware.com/workload-type: web
        8 + |  name: tanzu-java-web-app
        9 + |  namespace: default
       10 + |spec:
       11 + |  source:
       12 + |    git:
       13 + |      ref:
       14 + |        branch: main
       15 + |      url: https://github.com/sample-accelerators/tanzu-java-web-app

    ? Do you want to create this workload? Yes
    Created workload "tanzu-java-web-app"
    ```

2. After accepting the workload creation, monitor the creation of new resources by the workload by running:

    ```
    kubectl get workload,gitrepository,pipelinerun,images.kpack,podintent,app,services.serving
    ```

  You will see output similar to the following example that shows the objects that were created by the Supply Chain Choreographer:

    ```
    NAME                                    AGE
    workload.carto.run/tanzu-java-web-app   109s

    NAME                                                        URL                                                         READY   STATUS                                                            AGE
    gitrepository.source.toolkit.fluxcd.io/tanzu-java-web-app   https://github.com/sample-accelerators/tanzu-java-web-app   True    Fetched revision: main/872ff44c8866b7805fb2425130edb69a9853bfdf   109s

    NAME                                              SUCCEEDED   REASON      STARTTIME   COMPLETIONTIME
    pipelinerun.tekton.dev/tanzu-java-web-app-4ftlb   True        Succeeded   104s        77s

    NAME                                LATESTIMAGE                                                                                                      READY
    image.kpack.io/tanzu-java-web-app   10.188.0.3:5000/foo/tanzu-java-web-app@sha256:1d5bc4d3d1ffeb8629fbb721fcd1c4d28b896546e005f1efd98fbc4e79b7552c   True

    NAME                                                             READY   REASON   AGE
    podintent.conventions.apps.tanzu.vmware.com/tanzu-java-web-app   True             7s

    NAME                                      DESCRIPTION           SINCE-DEPLOY   AGE
    app.kappctrl.k14s.io/tanzu-java-web-app   Reconcile succeeded   1s             2s

    NAME                                             URL                                               LATESTCREATED              LATESTREADY                READY     REASON
    service.serving.knative.dev/tanzu-java-web-app   http://tanzu-java-web-app.developer.example.com   tanzu-java-web-app-00001   tanzu-java-web-app-00001   Unknown   IngressNotConfigured
    ```

### <a id="install-OOTB-test-scan"></a>Install OOTB Testing+Scanning

Follow these steps to install the OOTB Testing+Scanning supply chain:

  > **Note:** When leveraging both TBS and Grype in your Tanzu Application Platform supply chain, you can receive enhanced scanning coverage for Java workloads that includes application runtime layer dependencies.


>**Important:** The grype must be installed for scanning.

1. Supply Chain Security Tools - Scan is installed as part of the profiles.
Verify that both Scan Link and Grype Scanner are installed by running:

    ```
    tanzu package installed get scanning -n tap-install
    tanzu package installed get grype -n tap-install
    ```

    If the packages are not already installed, follow the steps in [Supply Chain Security Tools - Scan](install-components.md#install-scst-scan) to install the required scanning components.

    During installation of the Grype Scanner, sample ScanTemplates are installed into the `default` namespace. If the workload is deployed into another namespace, these sample ScanTemplates also must be present in the other namespace. One way to accomplish this is to install Grype Scanner again, and provide the namespace in the values file.

    A ScanPolicy is required and the following code must be in the required namespace. You can either add the namespace flag to the kubectl  command or add the namespace field to the template itself. Run:

    ```
    kubectl apply -f - -o yaml << EOF
    ---
    apiVersion: scanning.apps.tanzu.vmware.com/v1beta1
    kind: ScanPolicy
    metadata:
      name: scan-policy
    spec:
      regoFile: |
        package policies

        default isCompliant = false

        # Accepted Values: "Critical", "High", "Medium", "Low", "Negligible", "UnknownSeverity"
        violatingSeverities := ["Critical","High","UnknownSeverity"]
        ignoreCVEs := []

        contains(array, elem) = true {
          array[_] = elem
        } else = false { true }

        isSafe(match) {
          fails := contains(violatingSeverities, match.Ratings.Rating[_].Severity)
          not fails
        }

        isSafe(match) {
          ignore := contains(ignoreCVEs, match.Id)
          ignore
        }

        isCompliant = isSafe(input.currentVulnerability)
    EOF
    ```

2. (optional) To persist and query the vulnerability results post-scan, ensure that [Supply Chain Security Tools - Store](scst-store/overview.md) is installed using the following command. The Tanzu Application Platform profiles install the package by default.

    ```
    tanzu package installed get metadata-store -n tap-install
    ```

    If the package is not installed, follow [the installation instructions](install-components.md#install-scst-store).


3. Update the profile to use the supply chain with testing and scanning by
   updating `tap-values.yml` (the file used to customize the profile in `tanzu
   package install tap --values-file=...`) with the following changes:


    ```
    - supply_chain: testing
    + supply_chain: testing_scanning

    - ootb_supply_chain_testing:
    + ootb_supply_chain_testing_scanning:
        registry:
          server: "<SERVER-NAME>"
          repository: "<REPO-NAME>"
    ```

4. Update the `tap` package:

    ```
    tanzu package installed update tap -p tap.tanzu.vmware.com -v 1.0.0 --values-file tap-values.yml -n tap-install
    ```


#### <a id="test-scan-workload-update"></a>Workload update

To connect the new supply chain to the workload, update the workload to point to your Tekton
pipeline:

1. Update the workload by running the following using the Tanzu CLI:

    ```
    tanzu apps workload create tanzu-java-web-app \
      --git-repo https://github.com/sample-accelerators/tanzu-java-web-app \
      --git-branch main \
      --type web \
      --label apps.tanzu.vmware.com/has-tests=true \
      --yes
    ```

    Example output:

    ```
    Create workload:
          1 + |---
          2 + |apiVersion: carto.run/v1alpha1
          3 + |kind: Workload
          4 + |metadata:
          5 + |  labels:
          6 + |    apps.tanzu.vmware.com/has-tests: "true"
          7 + |    apps.tanzu.vmware.com/workload-type: web
          8 + |  name: tanzu-java-web-app
          9 + |  namespace: default
        10 + |spec:
        11 + |  source:
        12 + |    git:
        13 + |      ref:
        14 + |        branch: main
        15 + |      url: https://github.com/sample-accelerators/tanzu-java-web-app

    ? Do you want to create this workload? Yes
    Created workload "tanzu-java-web-app"
    ```

1. After accepting the workload creation, view the new resources that the workload created by running:

    ```
    kubectl get workload,gitrepository,sourcescan,pipelinerun,images.kpack,imagescan,podintent,app,services.serving
    ```

    The following is an example output, which shows the objects that the Supply Chain Choreographer created:

    ```
    NAME                                    AGE
    workload.carto.run/tanzu-java-web-app   109s

    NAME                                                        URL                                                         READY   STATUS                                                            AGE
    gitrepository.source.toolkit.fluxcd.io/tanzu-java-web-app   https://github.com/sample-accelerators/tanzu-java-web-app   True    Fetched revision: main/872ff44c8866b7805fb2425130edb69a9853bfdf   109s

    NAME                                                           PHASE       SCANNEDREVISION                            SCANNEDREPOSITORY                                           AGE    CRITICAL   HIGH   MEDIUM   LOW   UNKNOWN   CVETOTAL
    sourcescan.scanning.apps.tanzu.vmware.com/tanzu-java-web-app   Completed   187850b39b754e425621340787932759a0838795   https://github.com/sample-accelerators/tanzu-java-web-app   90s

    NAME                                              SUCCEEDED   REASON      STARTTIME   COMPLETIONTIME
    pipelinerun.tekton.dev/tanzu-java-web-app-4ftlb   True        Succeeded   104s        77s

    NAME                                LATESTIMAGE                                                                                                      READY
    image.kpack.io/tanzu-java-web-app   10.188.0.3:5000/foo/tanzu-java-web-app@sha256:1d5bc4d3d1ffeb8629fbb721fcd1c4d28b896546e005f1efd98fbc4e79b7552c   True

    NAME                                                          PHASE       SCANNEDIMAGE                                                                                                AGE   CRITICAL   HIGH   MEDIUM   LOW   UNKNOWN   CVETOTAL
    imagescan.scanning.apps.tanzu.vmware.com/tanzu-java-web-app   Completed   10.188.0.3:5000/foo/tanzu-java-web-app@sha256:1d5bc4d3d1ffeb8629fbb721fcd1c4d28b896546e005f1efd98fbc4e79b7552c   14s

    NAME                                                             READY   REASON   AGE
    podintent.conventions.apps.tanzu.vmware.com/tanzu-java-web-app   True             7s

    NAME                                      DESCRIPTION           SINCE-DEPLOY   AGE
    app.kappctrl.k14s.io/tanzu-java-web-app   Reconcile succeeded   1s             2s

    NAME                                             URL                                               LATESTCREATED              LATESTREADY                READY     REASON
    service.serving.knative.dev/tanzu-java-web-app   http://tanzu-java-web-app.developer.example.com   tanzu-java-web-app-00001   tanzu-java-web-app-00001   Unknown   IngressNotConfigured
    ```

    If the source or image scan has a "Failed" phase, then the scan has failed compliance and the supply chain will not continue.  

#### <a id="query-for-vuln"></a> Query for vulnerabilities

Scan reports are automatically saved to the [Supply Chain Security Tools - Store](scst-store/overview.md), and can be queried for vulnerabilities and dependencies. For example, open-source software (OSS) or third party packages.

1. Query the tanzu-java-web-app image dependencies and vulnerabilities with the following commands:

  ```
    insight image get --digest DIGEST
    insight image vulnerabilities --digest  DIGEST
  ```

  `DIGEST` is the component version, or image digest printed in the `KUBECTL GET` command.

  Important: The `Insight CLI` is separate from the Tanzu CLI.

See [Query Data](scst-store/query-data.md) or [CLI Details](scst-store/cli-docs/insight.md) for
additional examples.
<br>


### <a id="successful-deploy"></a>Congratulations! You have successfully deployed your application on the Tanzu Application Platform.
Through the next two sections to learn about recommended supply chain security best practices and access to a powerful Services Journey experience on the Tanzu Application Platform by enabling several advanced use cases.

## <a id="config-img-sign-verify"></a>Section 4: Configure image signing and verification in your supply chain

In this section, you are about to:

  - Configure your supply chain to sign your image builds.
  - Configure an admission control policy to verify image signatures before admitting Pods to the cluster.

### <a id="config-sc-to-img-builds"></a>Configure your supply chain to sign your image builds

1. Configure Tanzu Build Service to sign your container image builds by using cosign. See [Managing Image Resources and Builds](https://docs.vmware.com/en/Tanzu-Build-Service/1.3/vmware-tanzu-build-service-v13/GUID-managing-images.html) for instructions.
2. Create a `values.yaml` file, and install the sign supply chain security tools and image policy web-hook. See [Install Supply Chain Security Tools - Sign](install-components.html#install-scst-sign) for instructions.
3. Configure a `ClusterImagePolicy` resource to verify image signatures when deploying resources.

> **Note:** The resource must be named `image-policy`.

    For example:

    ```
    ---
    apiVersion: signing.apps.tanzu.vmware.com/v1beta1
    kind: ClusterImagePolicy
    metadata:
       name: image-policy
    spec:
       verification:
         exclude:
           resources
             namespaces:
             - kube-system
             - test-namespace
         keys:
         - name: first-key
           publicKey: |
             -----BEGIN PUBLIC KEY-----
             <content ...>
             -----END PUBLIC KEY-----
         images:
         - namePattern: registry.example.org/myproject/*
           keys:
           - name: first-key

    ```

When you apply the `ClusterImagePolicy` resource, your cluster requires valid signatures for all images that match the `namePattern:` you define in the configuration. For more information about configuring an image signature policy, see [Configuring Supply Chain Security Tools - Sign](scst-sign/configuring.html).


#### <a id="config-img-next-steps"></a>Next steps

- [Overview for Supply Chain Security Tools - Sign](scst-sign/overview.md)
- [Configuring Supply Chain Security Tools - Sign](scst-sign/configuring.md)
- [Supply Chain Security Tools - Sign known issues](release-notes.md)


### <a id="intro-vuln-scan-and-more"></a>Scan and Store: Introducing vulnerability scanning and metadata storage to your Supply Chain

**Overview**

This feature set allows an application operator to introduce source code and image vulnerability scanning,
and scan-time rules, to their Tanzu Application Platform Supply Chain. The scan-time rules prevent critical vulnerabilities from flowing to the supply chain unresolved.

All vulnerability scan results are stored over time in a metadata store that allows a team
to reference historical scan results, and provides querying capability to support the following use cases:

  - What images and packages are affected by a specific vulnerability?
  - What source code repos are affected by a specific vulnerability?
  - What packages and vulnerabilities does a particular image have?

[Supply Chain Security Tools - Store](scst-store/overview.md) takes the scanning results and stores them. Users can query for information about CVEs, images, packages, and their relationships by using the CLI, or directly from the API.

**Features**

  - Scan source code repositories and images for known CVEs before deploying to a cluster
  - Identify CVEs by scanning continuously on each new code commit or each new image built
  - Analyze scan results against user-defined policies using Open Policy Agent
  - Produce vulnerability scan results and post them to the Supply Chain Security Tools Store where they can later be queried

To try the scan and store features as individual one-off scans, see [Scan samples](scst-scan/samples/overview.md).

To try the scan and store features in a supply chain, see [Section 3: Add testing and security scanning to your application](#add-test-and-scan).

After completing scans, query the [Supply Chain Security Tools - Store](scst-store/overview.md) to view your vulnerability results.
It is a Tanzu component that stores image, package, and vulnerability metadata about your dependencies.
Use the Supply Chain Security Tools - Store CLI, called Insight,
to query metadata that is submitted to the component after the scan step.

For a complete guide on how to query the store,
see [Querying Supply Chain Security Tools - Store](scst-store/query-data.md).


#### <a id="scst-scan-next-steps"></a>Next steps

  - [Configure Code Repositories and Image Artifacts to be Scanned](scst-scan/scan-crs.md)

  - [Code and Image Compliance Policy Enforcement Using Open Policy Agent (OPA)](scst-scan/policies.md)

  - [How to Create a ScanTemplate](scst-scan/create-scan-template.md)

  - [Viewing and Understanding Scan Status Conditions](scst-scan/results.md)

  - [Observing and Troubleshooting](scst-scan/observing.md)

## <a id='stk'></a> Section 5: Consuming Services on Tanzu Application Platform

In this section you will learn about working with backing services such as RabbitMQ, PostgreSQL and MySQL as part of Tanzu Application Platform. Particular focus is given to the most common of services use cases - that of binding Application Workloads to Service Instances.

### <a id="stk-overview"></a> Overview

There are a few key concepts to familiarize yourself with in order to fully appreciate how best to work with services on Tanzu Application Platform - these are Service Instances, Service Bindings and Resource Claims. A brief overview of each is provided below.

A **Service Instance** is considered to be any Kubernetes resource which exposes its functionality via a well-defined interface. For example we could consider Kubernetes resources with an API Kind of `MySQL` to be "MySQL Service Instances", all of which expose their functionality over the MySQL protocol. Other examples may include resources with an API Kind of `PostreSQL` or, as we'll see a little later on, `RabbitmqCluster`.

**Service Binding** refers to a mechanism in which Service Instance credentials and other related connectivity information are communicated to Application Workloads in an automated way. Tanzu Application Platform makes use of a standard named [Service Binding for Kubernetes](https://servicebinding.io/) to implement such a mechanism. An understanding and appreciation of this standard is an important part of fully understanding the services aspect of Tanzu Application Platform.

**Resource Claims**, inspired in part by Kubernetes' [Persistent Volume Claims](https://kubernetes.io/docs/concepts/storage/persistent-volumes/), provide a mechanism for users to "claim" Service Instance resources on a given cluster while also serving to decouple the lifecycle of Application Workloads and Service Instances.

### <a id="stk-available-services"></a> Services available for use with Tanzu Application Platform today

There is a short and a long answer to the question of, "Which services can I use on Tanzu Application Platform today?". The short answer is that the following list of Kubernetes Operators all expose APIs which are known to integrate well with Tanzu Application Platform:

1. [RabbitMQ Cluster Operator for Kubernetes](https://www.rabbitmq.com/kubernetes/operator/operator-overview.html)
1. [VMware Tanzu SQL with Postgres for Kubernetes](https://docs.vmware.com/en/VMware-Tanzu-SQL-with-Postgres-for-Kubernetes/index.html)
1. [VMware Tanzu SQL with MySQL for Kubernetes](https://docs.vmware.com/en/VMware-Tanzu-SQL-with-MySQL-for-Kubernetes/index.html)

The long answer is slightly more nuanced and considers that compatibility of services on Tanzu Application Platform exists as a scale, rather than a simple "works" vs "doesn't work" option.

At present, the minimum requirement for entry onto the scale of compatibility is that there must exist a declarative, Kubernetes-based API on which there is at least one API Resource Type adhering to the [Provisioned Service](https://docs.vmware.com/en/VMware-Tanzu-SQL-with-MySQL-for-Kubernetes/index.html) duck type defined by the [Service Binding for Kubernetes](https://servicebinding.io/) standard. In other words, any resource type with the following schema:

```yaml
status:
  binding:
    name: # string
```

The value of `.status.binding.name` must point to a `Secret` in the same namespace which then contains any required credentials and connectivity information for the resource.

Typically APIs including such resource types would be installed into the Tanzu Application Platform cluster as Kubernetes Operators providing CRDs and controllers to reconcile them, as is the case with the three Kubernetes Operators listed above.

**Note**: There are plans to introduce tooling to Tanzu Application Platform to loosen this requirement in the near future, enabling a much wider range of services and Kubernetes Operators to integrate well with the platform. 

### <a id="stk-user-roles-responsibilities"></a> User Roles and Responsibilities

It is important to understand the User Roles considered when discussing services on Tanzu Application Platform along with the responsibilities assumed of each.

<table class="nice">
  <th><strong>User Role</strong></th>
  <th><strong>Exists as a default Role in TAP?</strong></th>
  <th><strong>Responsibilities</strong></th>
  <tr>
    <td>Service Operator</td>
    <td>No (may be introduced in a future release)</td>
    <td>Namespace and cluster topology design<br>Lifecycle management (CRUD) of Kubernetes Operators<br>Lifecycle management (CRUD) of Service Instances<br>Lifecycle management (CRUD) of Resource Claim Policies</td>
  </tr>
  <tr>
    <td>Application Operator</td>
    <td>Yes - <a href="https://docs.vmware.com/en/Tanzu-Application-Platform/1.1/tap/GUID-default-roles-role-descriptions.html#appoperator-2">app-operator</a></td>
    <td>Lifecycle management (CRUD) of Resource Claims</td>
  </tr>
  <tr>
    <td>Application Developer</td>
    <td>Yes - <a href="https://docs.vmware.com/en/Tanzu-Application-Platform/1.1/tap/GUID-default-roles-role-descriptions.html#appeditor-0">app-editor</a> / <a href="https://docs.vmware.com/en/Tanzu-Application-Platform/1.1/tap/GUID-default-roles-role-descriptions.html#appviewer-1">app-viewer</a></td>
    <td>Binding Service Instances to Application Workloads</td>
  </tr>
</table>

### <a id="stk-walkthrough"></a> Walkthrough

With an understanding of the main services concepts and user roles in mind it's now time to exercise our understanding with a practical walkthrough. In this section we'll walk through the deployment of two Application Workloads and learn how to configure them to communicate over RabbitMQ. In doing so we will learn about the `tanzu services` CLI plug-in as well as the most important APIs for working with services on Tanzu Application Platform. A summary of what we'll cover is captured in the diagram below.

![Multiple Application Workloads binding to a Service Instance](images/getting-started-stk-1.png)

It is worth bearing the following key observations in mind as you work your way through the Walkthrough.

1. Clear separation of concerns across the various user roles
    * Lifecycle of Workloads determined by Application Developers
    * Lifecycle of Resource Claims determined by Application Operators
    * Lifecycle of Service Instances determined by Service Operators
    * Lifecycle of Service Bindings implicitly tied to lifecycle of Workloads
1. Resource Claims and Resource Claim Policies as the mechanism to enable cross-namespace binding
1. [ProvisionedService](https://github.com/servicebinding/spec#provisioned-service) as the contract allowing credentials and connectivity information to flow from the Service Instance, through the Resource Claim, through the Service Binding and ultimately to the Application Workloads
1. Exclusivity of Resource Claims
    * Resource Claims are considered to be mutually exclusive, meaning that Service Instances can be claimed by at most 1 Resource Claim

#### <a id="stk-walkthrough-1-pre-reqs"></a> Pre-Requisites

Please note the following assumptions / pre-requisites for completing the walkthrough:

1. You have access to a cluster with Tanzu Application Platform installed
1. You have downloaded and installed the `tanzu` CLI along with the corresponding plug-ins
1. You have setup the `default` namespace to use installed packages (see [Set up developer namespaces to use installed packages](https://docs.vmware.com/en/Tanzu-Application-Platform/1.1/tap/GUID-install-components.html#setup)) and will use it as your "developer namespace"
1. Your Tanzu Application Platform cluster is able to pull source code from GitHub
1. Your Tanzu Application Platform cluster is able to pull the images required by the [RabbitMQ Cluster Kubernetes Operator](https://www.rabbitmq.com/kubernetes/operator/using-operator.html)

#### <a id="stk-walkthrough-2-set-up"></a> Set up

Covered in this section:

* Installation of the [RabbitMQ Cluster Kubernetes Operator](https://www.rabbitmq.com/kubernetes/operator/using-operator.html)
* Creation of required RBAC rules
* Creation of additional supporting resources to aid with discovery of services

For this part of the walkthrough we will assume the role of the **Service Operator**.

We'll begin by installing the [RabbitMQ Cluster Kubernetes Operator](https://www.rabbitmq.com/kubernetes/operator/using-operator.html). Then, we'll look to create a set of RBAC rules which will grant Tanzu Application Platform permission to interact with the newly-installed APIs provided by the RabbitMQ Cluster Operator. Finally we'll create some supporting resources to aid with the discovery of the new APIs in the cluster.

**Note**: While this walkthrough uses the RabbitMQ Cluster Operator as an example, the set up steps detailed here will remain largely the same for any compatilble Operator.

1. Install the RabbitMQ Cluster Operator

Use `kapp` to install the operator, as follows:

```
kapp -y deploy --app rmq-operator --file https://github.com/rabbitmq/cluster-operator/releases/download/v1.9.0/cluster-operator.yml
```

2. Apply RBAC rules to permit interaction with the new API

As a result of the previous step a new API Group (`rabbitmq.com`) and Kind (`RabbitmqCluster`) are now available in the cluster. We now need to grant Tanzu Application Platform permission to interact with the resources of this new API. This is achieved by creating a new `ClusterRole` defining the rules and labelling it such that the rules are aggregated to the appropriate controller, as follows:

```yaml
# resource-claims-rmq.yml
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: resource-claims-rmq
  labels:
    resourceclaims.services.apps.tanzu.vmware.com/controller: "true"
rules:
- apiGroups: ["rabbitmq.com"]
  resources: ["rabbitmqclusters"]
  verbs: ["get", "list", "watch", "update"]
```

Apply `resource-claims-rmq.yml` by running:

```
kubectl apply -f resource-claims-rmq.yml
```

Additionally we can also define RBAC rules permitting users of the cluster to interact with the new APIs. For example to permit Application Operators to get, list and watch for `RabbitmqCluster` Service Instances (something they will be doing later in this walkthrough), we can apply the following RBAC `ClusterRole`, labelled such that the rules are aggregated to the `app-operator` role:

```yaml
# rabbitmqcluster-app-operator-reader.yml
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: rabbitmqcluster-app-operator-reader
  labels:
    apps.tanzu.vmware.com/aggregate-to-app-operator-cluster-access: "true"
rules:
- apiGroups: ["rabbitmq.com"]
  resources: ["rabbitmqclusters"]
  verbs: ["get", "list", "watch"]
```

Apply `rabbitmqcluster-app-operator-reader.yml` by running:

```
kubectl apply -f rabbitmqcluster-app-operator-reader.yml
```

3. Make the new API discoverable by creating a `ClusterResource` to reference and describe it

The final step in setting up a new service for Tanzu Application Platform is to make it discoverable. This is achieved by the Service Operator creating a `ClusterResource` referring to the new service and setting any additional relevant metadata about it. For example:

```yaml
# rabbitmqcluster-clusterresource.yml
apiVersion: services.apps.tanzu.vmware.com/v1alpha1
kind: ClusterResource
metadata:
  name: rabbitmq
spec:
  shortDescription: It's a RabbitMQ cluster!
  longDescription: A consistent and easy way to deploy RabbitMQ clusters to Kubernetes and run them, including "day two" (continuous) operations.
  resourceRef:
    group: rabbitmq.com
    kind: RabbitmqCluster
```

7. Apply `rabbitmqcluster-clusterresource.yml` by running:

```
kubectl apply -f rabbitmqcluster-clusterresource.yml
```

The result of applying this resource is that it will now be listed in the output of the `tanzu service types list` command, and thus has been made discoverable in the `tanzu` tooling.

#### <a id="stk-walkthrough-3-service-instance"></a> Creating Service Instances

Covered in this section:

* Using `kubectl` to create a `RabbitmqCluster` Service Instance
* Creation of a Resource Claim Policy permitting claiming of the Service Instance

For this part of the walkthrough we will continue to assume the role of the **Service Operator**.

1. Create a dedicated namespace for Service Instances

Use `kubectl` to create a dedicated namespace in which to hold Service Instances, as follows:

```
kubectl create namespace service-instances
```

Using namespaces to separate Service Instances from Application Workloads allows for greater separation of concerns and means that greater control can be achieved over who has access to what. However it should be noted that this is not a strict requirement and it is perfectly possible to create both Service Instances and Application Workloads in the same namespace if desired.

2. Create a `RabbitmqCluster` Service Instance

It's now time to create our first Service Instance. Let's use the `tanzu service types list` command to discover the list of services that are available on our cluster, as follows:

```
tanzu service types list
```

The following will be output:

```
Warning: This is an ALPHA command and may change without notice.

 NAME      DESCRIPTION               APIVERSION                    KIND
 rabbitmq  It's a RabbitMQ cluster!  rabbitmq.com/v1beta1          RabbitmqCluster
```

**Note**: If you see `No service types found.`, make sure you have first run through the [Set Up](#stk-walkthrough-2-set-up).

The output of the `tanzu service types list` command tells us the API Group/Version and Kind, which we can now use to create our Service Instance.

```yaml
# rmq-1-service-instance.yml
---
apiVersion: rabbitmq.com/v1beta1
kind: RabbitmqCluster
metadata:
  name: rmq-1
  namespace: service-instances
```

Apply `rmq-1-service-instance.yml` by running:

```
kubectl apply -f rmq-1-service-instance.yml
```

3. Create a Resource Claim Policy

Now that we have a `RabbitmqCluster` Service Instance running in the `service-instances` namespace, the next step is to create a Resource Claim Policy to define the namespaces the instance can be claimed (and subsequently bound) from. By default it is only possible to claim and subsequently bind to Service Instances that are running in the _same_ namespace as the Application Workloads. But as we've just seen here our Service Instance is running in a different namespace. So, let's create a Resource Claim Policy to unblock ourselves.

```yaml
# rmq-claim-policy.yml
---
apiVersion: services.apps.tanzu.vmware.com/v1alpha1
kind: ResourceClaimPolicy
metadata:
  name: rabbitmqcluster-cross-namespace
  namespace: service-instances
spec:
  consumingNamespaces:
  - '*'
  subject:
    group: rabbitmq.com
    kind: RabbitmqCluster
```

Apply `rmq-claim-policy.yml` by running:

```
kubectl apply -f rmq-claim-policy.yml
```

This policy states that any resource of kind `RabbitmqCluster` on the `rabbitmq.com` API group in the `service-instances` namespace can be consumed from any namespace. With the Service Instance created and the policy in place, let's now switch gears to the Application Operator role and see how we can claim this instance for use with our Application Workloads.

#### <a id="stk-walkthrough-4-claim"></a> Claiming Service Instances

Covered in this section:

* Using `tanzu service instance list` to view details about Service Instances
* Using `tanzu service claim create` to create a claim for the Service Instance

For this part of the walkthrough we will assume the role of the **Application Operator**.

Resource Claims in Tanzu Application Platform are a powerful concept that serve many purposes. Arguably their most important role is in enabling Appliction Operators to request services to be used with their Application Workloads without them having to actually create and manage the services themselves. In simpler terms, they provide a mechanism for Application Operators to say what they want, without having to worry about anything that goes into providing what they want. To learn more about Resource Claims please refer to [Resource Claims](https://docs.vmware.com/en/Services-Toolkit-for-VMware-Tanzu/0.6/services-toolkit-0-6/GUID-service_resource_claims-terminology_and_apis.html).

Let's see how to create a claim that can be fulfilled by our `RabbitmqCluster` Service Instance. We'll use the `tanzu service claims create` command to do just that. This command requires some information to be able to create a claim successfully. As of today, we have to provide the following:

1. `--resource-name`
1. `--resource-kind`
1. `--resource-api-version`

And in addition we'll need to provide the optional `--resource-namespace` argument as well. As of today it is required to provide a lot of very specific information in order to create a claim. In particular the requirement to provide a specific name and namespace here is less than ideal as it means that Application Operators have to somehow determine this information prior to creating a claim. The plan is that over time such requirements can be relaxed as more functionality is added to the Resource Claims component in upcoming releases of Tanzu Application Platform. For now we can fall back to the `tanzu service instance list` command to determine the appropriate information, as follows:

```
tanzu service instance list -A
```

The following will be output:

```
  Warning: This is an ALPHA command and may change without notice.

  NAMESPACE          NAME   KIND             SERVICE TYPE  AGE
  service-instances  rmq-1  RabbitmqCluster  rabbitmq      24h
```

We can now use the information displayed to create a claim for the Service Instance, as follows:

```
tanzu service claim create rmq-1 \
  --resource-name rmq-1 \
  --resource-namespace service-instances \
  --resource-kind RabbitmqCluster \
  --resource-api-version rabbitmq.com/v1beta1
```

In the next section we'll see how to inspect the claim and to then use it to bind to Application Workloads.

#### <a id="stk-walkthrough-5-bind"></a> Binding Application Workloads to the Service Instance

Covered in this section:

* Using `tanzu service claim list` and `tanzu service claim get` to find information about the claim to use for binding
* Using `tanzu apps workload create` with the `--service-ref` flag to create a Workload and bind it to the Service Instance

For this part of the walkthrough we will assume the role of the **Application Developer**.

We're nearing the end of the walkthrough and all that is left to do now is to actually create our Application Workloads and to bind them, via the claim, to the Service Instance.

**Note** In cases where Service Instances are running in the same namespace as Application Workloads, it is not technically necessary to create a claim, rather you can bind to the Service Instance directly.

1. Determine a suitable value to pass to `--service-ref` on the `tanzu apps workload create` command

In Tanzu Application Platform Service Bindings are created when Application Workloads that specify `.spec.serviceClaims` are created. In this section we will see how to create such Workloads using the `--service-ref` flag of the `tanzu apps workload create` command. But first, we need to determine a suitable value to pass to this flag. This can be achieved by inspecting existing claims in our developer namespace, as follows:


```
tanzu services claims list
```

The following will be output:

```
  Warning: This is an ALPHA command and may change without notice.

  NAME   READY  REASON
  rmq-1  True
```

Retrieve detailed information about the claim by running:

```
tanzu services claims get rmq-1
```

The following will be output:

```
  Warning: This is an ALPHA command and may change without notice.

Name: rmq-1
Status:
  Ready: True
Namespace: default
Claim Reference: services.apps.tanzu.vmware.com/v1alpha1:ResourceClaim:rmq-1
Resource to Claim:
  Name: rmq-1
  Namespace: service-instances
  Group: rabbitmq.com
  Version: v1beta1
  Kind: RabbitmqCluster
```

The information we're interested in here is the `Claim Reference`. This is the value we will pass to `--service-ref` when it comes to creating our Application Workloads, as follows:

```
tanzu apps workload create \
  spring-sensors-web-ui \
  --git-repo https://github.com/sample-accelerators/spring-sensors-rabbit \
  --git-branch main \
  --type web \
  --service-ref="rmq=services.apps.tanzu.vmware.com/v1alpha1:ResourceClaim:rmq-1"

tanzu apps workload create \
  spring-sensors-sensor \
  --git-repo https://github.com/sample-accelerators/spring-sensors-sensor \
  --git-branch main \
  --type web \
  --service-ref="rmq=services.apps.tanzu.vmware.com/v1alpha1:ResourceClaim:rmq-1"
```

Usage of the `--service-ref` flag instructs Tanzu Application Platform to bind the Application Workload to the service provided in the ref. Note that here we are not passing a service ref to the `RabbitmqCluster` Service Instance directly, but rather to the Resource Claim (which itself has successfully claimed the `RabbitmqCluster` Service Instance). Refer back to the earlier diagram for an explanation as to why.

Once the Workloads are ready, visit the URL of the `spring-sensors-web-ui` Application and confirm that sensor data (passing from the sensor workload to the web UI workload via our RabbitmqCluster Service Instance) is displayed.

### <a id="stk-walkthrough-6-summary"></a> Walkthrough Summary

We covered a lot of ground in the walkthrough. The hope is that this introduction to the various components and tooling has laid the ground work for you to begin your services journey on Tanzu Application Platform.

### <a id="stk-advanced-use-cases"></a> Advanced Use Cases and Further Reading

There are a couple of slighly more advanced services use cases not covered in the above walkthrough, namely "Direct Secret References" and "Dedicated Service Clusters".

<table class="nice">
  <th><strong>Advanced Use Case</strong></th>
  <th><strong>Short Description</strong></th>
  <th><strong>Link</strong></th>
  <tr>
    <td>Direct Secret References</td>
    <td>Bind to services running external to the cluster (e.g. in-house oracle DB)<br />Bind to services not conformant with the binding spec</td>
    <td><a href="https://docs.vmware.com/en/Services-Toolkit-for-VMware-Tanzu/0.6/services-toolkit-0-6/GUID-reference-use_cases.html">Link</a></td>
  </tr>
  <tr>
    <td>Dedicated Service Clusters</td>
    <td>Separate Application Workloads from Service Instances across dedicated clusters</td>
    <td><a href="https://docs.vmware.com/en/Services-Toolkit-for-VMware-Tanzu/0.6/services-toolkit-0-6/GUID-reference-use_cases.html">Link</a></td>
  </tr>
</table>

Please refer to the [Services Toolkit Component documentation](https://docs.vmware.com/en/Services-Toolkit-for-VMware-Tanzu/0.6/services-toolkit-0-6) for full details on the APIs and concepts underpinning Services on Tanzu Application Platform.
