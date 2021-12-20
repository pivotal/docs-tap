# Getting started with the Tanzu Application Platform

## Purpose

Welcome to the Tanzu Application Platform. This document guides you through getting started with the platform. Specifically, you will learn how to:

* Develop and promote an application
* Create an application accelerator
* Add testing and security scanning to an application
* Administer, set up, and manage supply chains


### Prerequisites

To take full advantage of this document, ensure you have followed [Installing Tanzu Application Platform](install-intro.md).

Before getting started, ensure the following prerequisites are in place:

1. Tanzu Application Platform is installed on the target Kubernetes cluster. For installation instructions, see [Installing Part I: Prerequisites, EULA, and CLI](install-general.md) and [Installing Part II: Profiles](install.md).

2. Default kubeconfig context is set to the target Kubernetes cluster.

3. The Out of The Box Supply Chain Basic is installed. See [Install default Supply Chain](install-components.md#install-ootb-supply-chain-basic).

4. A developer namespace is set up to accommodate the developer's Workload.
   See [Set Up Developer Namespaces to Use Installed Packages](install-components.md#-set-up-developer-namespaces-to-use-installed-packages).

5. Tanzu Application Platform GUI is successfully installed.

6. Install the VSCode Tanzu Extension.
   See [How to Install the VSCode Tanzu Extension](vscode-extension/install.md).



## Section 1: Develop your first application on Tanzu Application Platform

In this section, you deploy a simple web application to the platform, enable debugging,
and see your code updates added to the running application as you save them.

#### About application accelerators

The Application Accelerator Plugin of Tanzu Application Platform GUI is located on the left-hand side navigation bar (**Create** button). It helps application developers and administrators to create and generate application accelerators. Accelerators are templates that codify best practices and ensure important configuration and structures are in place.

Developers can bootstrap their applications and get started with feature development. Application administrators can create custom accelerators that reflect their desired architectures and configurations, and enable fleets of developers to utilize them instantly. This decreases administrator concerns about whether developers are implementing their desired best practices.

Application Accelerator templates are available as a quick start from [Tanzu Network](https://network.tanzu.vmware.com/products/app-accelerator). To create your own Application Accelerator, see [Creating an accelerator](#creating-an-accelerator).


### Deploy your application

To deploy your application, you need to download an accelerator, upload it on your Git repository of choice, and run a CLI command. We recommend using the accelerator called `Tanzu-Java-Web-App`.


1. From the Tanzu Application Platform GUI portal, click **Create** located on the left-hand side of the
navigation bar to see the list of available accelerators.
For information about connecting to Tanzu Application Platform GUI, see
[Accessing Tanzu Application Platform GUI](tap-gui/accessing-tap-gui.md).

    ![List of accelerators in Tanzu Application Platform GUI](images/getting-started-tap-gui-1.png)

2. Locate the Tanzu Java Web App accelerator, which is a Spring Boot web app, and click on `CHOOSE` button.

    ![Tile for Tanzu Java Web App](images/getting-started-tap-gui-2.png)

3. In the **Generate Accelerators** prompt, replace the default value `dev.local` in the **prefix for container image registry** field with the registry in the form of `SERVER-NAME/REPO-NAME`. The `SERVER-NAME/REPO-NAME` must match what was specified for `registry` as part of the installation values for `ootb_supply_chain_basic`. Click `NEXT STEP`, verify the provided information, and click `CREATE`.

    ![Generate Accelerators prompt](images/getting-started-tap-gui-3.png)

4. After the Task Activity processes are complete, click on the `DOWNLOAD ZIP FILE` button

    ![Task Activity progress bar](images/getting-started-tap-gui-4.png)

5. After downloading the ZIP file, expand it in a workspace directory and follow your preferred procedure for uploading the generated project files to a Git repository for your new project.

6. Deploy the Tanzu Java Web App accelerator by running the `tanzu apps workload create` command:

    ```
    tanzu apps workload create tanzu-java-web-app \
    --git-repo GIT-URL-TO-PROJECT-REPO \
    --git-branch main \
    --type web \
    --label app.kubernetes.io/part-of=tanzu-java-web-app \
    --yes
    ```

    Where `GIT-URL-TO-PROJECT-REPO` is the path you uploaded to in step 5.

    If you bypassed step 5 and were unable to upload your accelerator to a Git repository, then you can use the public version to test with:
    ```
    tanzu apps workload create tanzu-java-web-app \
    --git-repo https://github.com/sample-accelerators/tanzu-java-web-app \
    --git-branch main \
    --git-tag tap-beta4 \
    --type web \
    --label app.kubernetes.io/part-of=tanzu-java-web-app \
    --yes
    ```

    For more information, see [Tanzu Apps Workload Create](cli-plugins/apps/command-reference/tanzu_apps_workload_create.md).

    >**Note:** This first deployment uses accelerator source from Git, but in later steps you use the VSCode extension
    to debug and live-update this application.

7. View the build and runtime logs for your app by running the `tail` command:

    ```
    tanzu apps workload tail tanzu-java-web-app --since 10m --timestamp
    ```

8. After the workload is built and running, you can view the web-app in your browser. View the URL of the web-app by running the command below, and then press **ctrl-click** on the
Workload Knative Services URL at the bottom of the command output.

    ```
    tanzu apps workload get tanzu-java-web-app
    ```


### Add your application to the Tanzu Application Platform GUI Software Catalog

To see this application in your organization catalog, you must register new entities as described below.


1. Ensure you have already installed the Blank Software Catalog. For installation information, see [Configure the Tanzu Application Platform GUI](install.md#configure-tap-gui).

2. Go to the `Home` screen of Tanzu Application Platform GUI by clicking the “Home” button on the left-side navigation bar and select `REGISTER ENTITY` button on the top.

    ![REGISTER button on the right side of the header](images/getting-started-tap-gui-5.png)

3. In the Register, an existing component prompt provides a link to the `catalog-info.yaml` file in the Git repo and click on `ANALYZE`

    ![Select URL](images/getting-started-tap-gui-6.png)

4. Review the entities that will be added to the catalog and click on `IMPORT`

    ![Review the entities to be added to the catalog](images/getting-started-tap-gui-7.png)

Once you navigate back to the `Home` screen, the catalog changes should be reflected immediately and you should be able to see the entry in the catalog and interact with it.

### <a id='iterate'></a>Iterate on your Application

Now that you have a skeleton workload working, you are ready to iterate on your application
and test code changes on the cluster.
Tanzu Developer Tools for VSCode, VMware Tanzu’s official IDE extension for VSCode,
helps you develop & receive fast feedback on your workloads running on the Tanzu Application Platform.

The VSCode extension enables live updates of your application while it runs on the cluster
and lets you debug your application directly on the cluster.

For information about installing the pre-requisites and the Tanzu Developer Tools extension, see
[Install Tanzu Dev Tools for VSCode](vscode-extension/install.md).

>**Note:** For this sample app, you must use Tilt v0.23.2 or later

Open the "Tanzu Java Web App" as a project within your VSCode IDE.

In order to ensure your extension helps you iterate on the correct project, you will need to configure its settings:

1. Within VSCode, go to `Preferences` > `Settings` > `Extensions` > `Tanzu`.

1. In the **Local Path** field, enter the path to the directory containing the Tanzu Java Web App. Defaults to current directory.

1. In the **Source Image** field, enter the destination image repository where
you’d like to publish an image containing your workload source code.
For example `harbor.vmware.com/myteam/tanzu-java-web-app-source`.

You are now ready to iterate on your application.

### Live update your application

Deploy the application and see it live update on the cluster. Doing so allows you to understand how your code changes will behave on a production-like cluster much earlier in the development process.

Follow these steps:

1. From the Command Palette (⇧⌘P), type in and select `Tanzu: Live Update Start`.
You will see output from the Tanzu Application Platform and from Tilt indicating that the container is being built and deployed. 
    - You will also see "Live Update starting..." in the status bar at the bottom right
    - Because this is your first time starting live update for this workload, it might take 1-3 minutes for the workload to be deployed and the Knative service to become available.

1. Once you see the Live Update status in the status bar resolve to "Live Update Started", navigate to `http://localhost:8080` in your browser and view your workload running.
1. Return to the IDE and make a change to the source code. For example, in `HelloController.java`, modify the string returned to say `Hello!` and save.
1. Once the logs stop streaming, the container has been updated. Navigate back to your browser and refresh the page.
1. View the changes to your workload that is running on the cluster. 

You can now continue to make more changes. If you are finished, you can stop or disable live update. Open the command palette (⇧⌘P), type in `Tanzu`, and select either option.


### Debug your application

You can debug your cluster on your application or in your local environment.

Follow the steps below to debug your cluster:

1. Set a breakpoint in your code.
2. Right-click the file `workload.yaml` within the `config` folder, and select `Tanzu: Java Debug Start`. In a few moments, the workload will be redeployed with debugging enabled. You will see the "Deploy and Connect" Task complete and the debug menu actions will be available to you, indicating that the debugger has attached.
3. Return to your browser and navigate to `http://localhost:8080`. This will hit the breakpoint within VSCode. You can now step through or play to the end of the debug session using VSCode debugging controls.

### Monitor your running application

Now that your application is deployed, you can inspect the runtime characteristics of the running
application.
You can use the Application Live View UI to look into the running application to monitor resource
consumption, Java Virtual Machine (JVM) status, incoming traffic, and change log level.
You can also troubleshoot environment variables and fine-tune the running application.

Currently, Spring Boot-based applications can be diagnosed using Application Live View.
To do so:

1. Follow the
[Verify the Application Live View components](https://docs.vmware.com/en/Application-Live-View-for-VMware-Tanzu/1.0/docs/GUID-installing.html#verify-the-application-live-view-components-5) procedure
to ensure the Application Live View components are successfully installed.

1. Access the Application Live View Tanzu Application Platform GUI by following the
[Entry point to Application Live View plug-in](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/0.4/tap/GUID-tap-gui-plugins-app-live-view.html#entry-point-to-application-live-view-plugin-1) procedure.

1. Select your application to view inside the running application and see the diagnostic options.
For more information, see
[Product Features](https://docs.vmware.com/en/Application-Live-View-for-VMware-Tanzu/1.0/docs/GUID-product-features.html).


---


## <a id='creating-an-accelerator'></a>Section 2: Creating an accelerator

In this section, you will create a New Application Accelerator by using the Tanzu Application Platform GUI.

### Create a New Application Accelerator ###

Use the following procedure to create an accelerator:

1. From the Tanzu Application Platform GUI portal, click on the `Create` button on the left-hand side of the navigation bar to see the list of available accelerators. Select the **New Accelerator** tile by pressing on the `CHOOSE` button.

    ![New Accelerator tile](images/getting-started-section2-1.png)

2. Fill in the new project form with the information below. To browse the files of the accelerator, click on the `EXPLORE` button (optional). When finished, click on the `NEXT STEP` button.

    * Name: Your Accelerator name. This is the name of the generated ZIP file.
    * (Optional) Description: A description of your accelerator.
    * K8s Resource Name: A Kubernetes resource name to use for the Accelerator.
    * Git Repository URL: The URL for the git repository that contains the accelerator source code.
    * Git Branch: The branch for the git repository.
    * (Optional) Tags: Any associated tags that can be used for searches in the UI.


    ![Generate Accelerators first prompt](images/getting-started-section2-2.png)

    ![Explore project dialog box](images/getting-started-section2-3.png)


3. Verify the provided information and click on `CREATE`

    ![Verify information for creating an accelerator](images/getting-started-section2-4.png)


4. Download and expand the ZIP file by clicking on the `DOWNLOAD ZIP FILE` and expand it.

    * The output contains a YAML file for an Accelerator resource, pointing to the Git repository.
    * The output contains a file named `new-accelerator.yaml` which defines the metadata for your new accelerator.


    ![Download ZIP file with the accelerator](images/getting-started-section2-5.png)


5. To apply the k8s-resource.yml, run the following command in your terminal in the folder where you expanded the zip file:

    ```
    kubectl apply -f k8s-resource.yaml --namespace accelerator-system
    ```

6. The Tanzu Application Platform GUI refreshes periodically. Once the GUI refreshes, the new accelerator becomes available. After waiting a few minutes, click the `Create` button on the left-hand side navigation bar of the Tanzu Application Platform GUI to see if the accelerator appears.


### Using accelerator.yaml

The Accelerator ZIP file contains a file called `new-accelerator.yaml`.
This file is a starting point for the metadata for your new accelerator and the associated options and file processing instructions.
This `new-accelerator.yaml` file should be copied to the root directory of your git repo and named `accelerator.yaml`.

Copy this file into your git repo as `accelerator.yaml` to have additional attributes rendered in the web UI.
See [Creating Accelerators](https://docs.vmware.com/en/Application-Accelerator-for-VMware-Tanzu/0.2/acc-docs/GUID-creating-accelerators-index.html).

After you push that change to your git repository, the Accelerator is refreshed based on the `git.interval` setting for the Accelerator resource. The default is 10 minutes. You can run the following command to force an immediate reconciliation:

```
tanzu accelerator update <accelerator-name> --reconcile
```
---

## <a id='add-testing-and-scanning'></a> Section 3: Add Testing and Security Scanning to Your Application

### What is a Supply Chain?

Supply Chains provide a way of codifying all of the steps of your path to production, or what is
more commonly known as CI/CD.
A supply chain differs from CI/CD in that you can add any and every step that is necessary for an
application to reach production, or a lower environment.

![Diagram depicting a simple path to production: CI to Security Scan to Build Image to Image Scan to CAB Approval to Deployment.](images/path-to-production.png)

#### A simple path to production

A path to production allows users to create a unified access point for all of the tools required
for their applications to reach a customer-facing environment.
Instead of having four tools that are loosely coupled to each other, a path to production defines
all four tools in a single, unified layer of abstraction.

Where tools typically are not able to integrate with one another and additional scripting or
webhooks are necessary, there would be a unified automation tool to codify all the interactions
between each of the tools.
Supply chains used to codify the organization's path to production are configurable, allowing their
authors to add all of the steps of their application's path to production.

Tanzu Application Platform provides three out of the box supply chains designed to
work with Tanzu Application Platform components.


#### Supply Chains included in Beta 3

The Tanzu Application Platform installation steps cover installing the default Supply Chain, but
others are available.
If you follow the installation documentation, the **Out of the Box Basic** Supply Chain and its
dependencies are installed on your cluster.
The table and diagrams below describe the two supply chains included in Tanzu Application Platform
Beta 3 and their dependencies.

The **Out of the Box with Testing** runs a Tekton pipeline within the supply chain. It is dependent on
[Tekton](https://tekton.dev/) being installed on your cluster.

The **Out of the Box with Testing and Scanning** supply chain includes integrations for secure scanning tools.

The following section installs the second supply chain, includes steps to install Tekton and provides a sample Tekton pipeline that tests your
sample application.
The pipeline is configurable, therefore you can customize the steps
to perform additional testing, or any other tasks that can be performed with a
Tekton pipeline.

![Diagram depicting the Source-to-URL chain: Watch Repo (Flux) to Build Image (TBS) to Apply Conventions to Deploy to Cluster (CNR).](images/source-to-url-chain.png)

**Out of the Box Basic - default Supply Chain**

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
   <td>This supply chain monitors a repository that is identified in the developer’s `workload.yaml` file. When any new commits are made to the application, the supply chain will:
<ul>

<li>Automatically create a new image of the application

<li>Apply any predefined conventions to the Kubernetes configuration

<li>Deploy the application to the cluster
</li>
</ul>
   </td>
   <td>
<ul>

<li>Flux/Source Controller

<li>Tanzu Build Service

<li>Convention Service

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

![Diagram depicting the Source-and-Test-to-URL chain: Watch Repo (Flux) to Test Code (Tekton) to Build Image (TBS) to Apply Conventions to Deploy to Cluster (CNR).](images/source-and-test-to-url-chain.png)

**Out of the Box Testing**

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

<li>The application tests using the Tekton pipeline

<li>A new image is automatically created

<li>Any predefined conventions are applied

<li>The application is deployed to the cluster
</li>
</ul>
   </td>
   <td>All of the Source to URL dependencies, as well as:
<ul>

<li>Tekton
</li>
</ul>
   </td>
  </tr>
</table>

![Diagram depicting the Source-and-Test-to-URL chain: Watch Repo (Flux) to Test Code (Tekton) to Build Image (TBS) to Apply Conventions to Deploy to Cluster (CNR).](images/source-test-scan-to-url.png)

**Out of the Box Testing and Scanning**

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

<li>The application will be testing using the provided Tekton pipeline
<li>The application source code will be scanned for vulnerabilities

<li>A new image will be automatically created
<li>The image will be scanned for vulnerabilities

<li>Any predefined conventions will be applied

<li>The application will be deployed to the cluster
</li>
</ul>
   </td>
   <td>All of the Source to URL dependencies, as well as:
<ul>

<li>The secure scanning components included with Tanzu Application Platform
</li>
</ul>
   </td>
  </tr>
</table>

### Install Out of the Box with testing

When you chose not to use the preceding install method, see [Install
Tekton](install-components.md#install-tekton).

With Tekton installed, you can activate the Out of the Box Supply Chain with Testing by updating our profile to use `testing` rather than `basic` as the selected supply chain for workloads in this cluster. Update `tap-values.yml`(the file used to customize the profile in `Tanzu package install tap
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

Then update the installed profile:

```
tanzu package installed update tap -p tap.tanzu.vmware.com -v 0.3.0 --values-file tap-values.yml -n tap-install
```


### Example Tekton pipeline config

In this section, we’ll add a Tekton pipeline to our cluster and in the following section,
we’ll update the workload to point to the pipeline and resolve any of the current errors.

The next step is to add a Tekton pipeline to our cluster.
Because a developer knows how their application needs to be tested this step could be performed by the developer.
The Operator could also add these to a cluster prior to the developer getting access to it.

In order to add the Tekton supply chain to the cluster, we’ll apply the following YAML to the cluster:

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

              wget -qO- $(params.source-url) | tar xvz
              ./mvnw test
```

The YAML above defines a Tekton Pipeline with a single step.
The step itself contained in the `steps` will pull the code from the repository indicated
in the developers `workload` and run the tests within the repository.
The steps of the Tekton pipeline are configurable and allow the developer to add any additional items
that they may need to test their code.
Because this step is just one in the supply chain (and the next step is an image build in this case),
the developer is free to focus on just testing their code.
Any additional steps that the developer adds to the Tekton pipeline will be independent
for the image being built and any subsequent steps of the supply chain being executed.

The `params` are templated by the Supply Chain Choreographer.
Additionally, Tekton pipelines require a Tekton `pipelineRun` in order to execute on the cluster.
The Supply Chain Choreographer handles creating the `pipelineRun` dynamically each time
that step of the supply requires execution.

### Workload update

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

### Install Out of the Box with Testing and Scanning

Follow the steps below to install an out of the box supply chain with testing and scanning.

1. Supply Chain Security Tools - Scan is installed as part of the profiles.
Verify that both Scan Link and Grype Scanner are installed by running:

    ```
    tanzu package installed get scanning -n tap-install
    tanzu package installed get grype -n tap-install
    ```

    If the packages are not already installed, follow the steps in [Supply Chain Security Tools - Scan](install-components.md#install-scst-scan) to install the required scanning components.

    During installation of the Grype Scanner, sample ScanTemplates are installed into the `default` namespace. If the workload is deployed into another namespace, these sample ScanTemplates also need to be present in the other namespace. One way to accomplish this is to install Grype Scanner again, and provide the namespace in the values file.

    A ScanPolicy is required and the following code must be included in the required namespace. You can either add the namespace flag to the `kubectl` command or add the namespace field to the template itself. Run:

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

2. (Optional) To persist and query the vulnerability results post-scan, ensure that [Supply Chain Security Tools - Store](scst-store/overview.md) is installed using the following command. Tanzu Application Platform profiles already install the package by default.

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
    tanzu package installed update tap -p tap.tanzu.vmware.com -v 0.3.0 --values-file tap-values.yml -n tap-install
    ```


### Workload update

To connect the new supply chain to the workload, update the workload to point at your Tekton
pipeline:

1. Update the workload by running the following with the Tanzu CLI:

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

1. After accepting the workload creation, see the new resources that the workload created by running:

    ```
    kubectl get workload,gitrepository,sourcescan,pipelinerun,images.kpack,imagescan,podintent,app,services.serving
    ```

    Example output, which shows the objects that Supply Chain Choreographer created:

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


## Section 4: Advanced use cases - Supply Chain Security Tools

### Supply Chain Security Tools overview

In this section, we will provide an overview of the supply chain security use cases that are available in Tanzu Application Platform:

1. **Sign**: Introducing image signing and verification to your supply chain

2. **Scan & Store**: Introducing vulnerability scanning and metadata storage to your supply chain

### Sign: introducing image signing and verification to your Supply Chain

#### Overview

This component allows a platform operator to define a policy that will
restrict unsigned images from running on clusters.
To enforce the configured policies this component communicates with external
container registries to verify signatures on container images and make a
decision based on the results of this verification. In order to make admission
decisions this component is implemented as a dynamic admission control webhook.

Currently, this component supports cosign signatures and its key formats.
Although this component does not sign container images, you could use tools such
as the [cosign CLI](https://github.com/sigstore/cosign#quick-start),
[kpack](https://github.com/pivotal/kpack/blob/main/docs/image.md#cosign-config),
and [Tanzu Build Service](https://docs.vmware.com/en/VMware-Tanzu-Build-Service/index.html)
(which is what we will overview in this document) to generate signatures for
your images.

Signing an artifact creates metadata about it that allows consumers to verify
its origin and integrity.
Operators can increase their confidence that trusted software is running on their
clusters by verifying signatures on artifacts prior to their deployment.

#### Use cases

* Validate signatures from a given registry.
* Deny unsigned images from being admitted in the cluster.

> **Note**: this component does not verify images that are already running in a
> cluster.

**Signing container images**

Tanzu Application Platform supports verifying container image signatures that
follow the cosign format.
Application operators may sign container images and store them in the registry
in several different ways, including:

* Using [Tanzu Build Service v1.4](https://docs.vmware.com/en/Tanzu-Build-Service/1.4/vmware-tanzu-build-service-v14/GUID-index.html).
* Using [kpack](https://github.com/pivotal/kpack/blob/main/docs/image.md#cosign-config)
v0.4.0 or higher.
* Signing existing images with [cosign](https://github.com/sigstore/cosign#quick-start).

**Supplying secrets for private registries**

If your images and signatures are hosted in a private registry you will need to
provide the package with credentials to pull those signatures.

If your resources already have `imagePullSecrets` configured, either
[directly in their specs](https://kubernetes.io/docs/concepts/configuration/secret/#using-imagepullsecrets)
or [via the `ServiceAccount` they run authenticated as](https://kubernetes.io/docs/concepts/configuration/secret/#arranging-for-imagepullsecrets-to-be-automatically-attached),
no further configuration is required.

However, in situations where your cluster pulls credentials from your container
runtime configuration, you can choose to provide secrets through:

* The `ClusterImagePolicy` resource configuration for a given name pattern.
* Creating a `ServiceAccount` named `image-policy-registry-credentials` in the
`image-policy-system` namespace and adding `imagePullSecrets` to that service
account.

For more information on how to configure these secrets, see
[Providing credentials for the package](scst-sign/configuring.md#providing-credentials-package).

**Creating a `ClusterImagePolicy`**

The `ClusterImagePolicy` is a custom resource containing the following information:

* A list of namespaces to which the policy should not be enforced.
* A list of public keys complementary to the private keys that were used to sign
  the images.
* A list of image name patterns to which we want to enforce the policy, mapping
  to the public keys to use for each pattern, and, optionally, a secret reference
  to be used to authenticate to the referred registry.

An example policy would look like this:

```
---
apiVersion: signing.run.tanzu.vmware.com/v1beta1
kind: ClusterImagePolicy
metadata:
  name: image-policy
spec:
  verification:
    exclude:
      resources:
        namespaces:
        - kube-system
    keys:
    - name: first-key
      publicKey: |
        ​​-----BEGIN PUBLIC KEY-----
        <content ...>
        -----END PUBLIC KEY-----
    images:
    - namePattern: registry.example.org/myproject/*
      keys:
      - name: first-key
    images:
    - namePattern: registry.example.org/otherproject/*
      secretRef:
        name: credential-to-other-project
        namespace: secret-namespace
      keys:
      - name: first-key
```

The custom resource for the policy must have a name of `image-policy`.

> **Important**: The platform operator should add to the
> `spec.verification.exclude.resources.namespaces` section any namespaces that
> are known to run container images that are not currently signed, such as the
> `kube-system` namespace.

#### Examples and expected results

If a platform operator creates the following policy, there are different scenarios
and expected outcomes:

```
---
apiVersion: signing.run.tanzu.vmware.com/v1beta1
kind: ClusterImagePolicy
metadata:
  name: image-policy
spec:
  verification:
    exclude:
      resources:
        namespaces:
        - kube-system
        - test-namespace
    keys:
    - name: first-key
      publicKey: |
        ​​-----BEGIN PUBLIC KEY-----
        <content ...>
        -----END PUBLIC KEY-----
    images:
    - namePattern: registry.example.org/myproject/*
      keys:
      - name: first-key
```

* **Scenario 1:** A developer deploys a runnable resource with an image name that matches a
name pattern in the policy and that image is signed with an expected signature.
Expected result: resource is created successfully.

* **Scenario 2:** A developer deploys a runnable resources with an image name that matches a
name pattern in the policy and the image is unsigned.
Expected result: resource is not created and an error message is shown in the
CLI output or via API responses.

* **Scenario 3:** A developer deploys a runnable resource with an image name that does not
match any patterns in the policy and the `AllowUnmatchedImages` feature gate is
turned on.
Expected result: resource is created successfully and a warning message is shown
in the CLI output or via API responses.

* **Scenario 4:** A developer deploys a runnable resource with an image name that does not
match any patterns in the policy and the `AllowUnmatchedImages` feature gate is
turned off.
Expected result: a resource is not created and an error message is shown in the
CLI output or via API responses.

The Supply Chain Security Tools - Sign component outputs logs for the above
scenarios. To examine the logs the platform operator can run:

```
kubectl logs -n image-policy-system -l "signing.run.tanzu.vmware.com/application-name=image-policy-webhook" -f
```

#### Next steps and further information

* [Overview for Supply Chain Security Tools - Sign](scst-sign/overview.md)
* [Configuring Supply Chain Security Tools - Sign](scst-sign/configuring.md)
* [Supply Chain Security Tools - Sign Known Issues](scst-sign/known_issues.md)


### Scan and Store: Introducing vulnerability scanning and metadata storage to your Supply Chain

**Overview**

This feature set allows an application operator to introduce source code and image vulnerability scanning,
as well as scan-time rules, to their Tanzu Application Platform Supply Chain. The scan-time rules prevent critical vulnerabilities from flowing through the supply chain unresolved.

All vulnerability scan results are stored over time in a metadata store that allows a team
to easily reference historical scan results, and provides querying functionality to support the following use cases:

* What images and packages are affected by a specific vulnerability?
* What source code repos are affected by a specific vulnerability?
* What packages and vulnerabilities does a particular image have?
* What images are using a given package?

[Supply Chain Security Tools - Store](scst-store/overview.md) takes the scanning results and stores them. Users can query for information about CVEs, images, packages, and their relationships through the CLI, or directly from the API.

**Features**

* Scan source code repositories and images for known CVEs prior to deploying to a cluster
* Identify CVEs by scanning continuously on each new code commit and/or each new image built
* Analyze scan results against user-defined policies using Open Policy Agent
* Produce vulnerability scan results and post them to the Supply Chain Security Tools - Store where they can later be queried

To try the scan and store features in a supply chain, see [Section 3: Add testing and security scanning to your application](#add-testing-and-scanning).

#### Running Public source code and image scans with policy enforcement

Follow the instructions in [Sample public source code and image scans with policy enforcement](scst-scan/running-scans.md)
to perform the following two types of public scans:

1. Source code scan on a public repository
2. Image scan on a public image

Both examples include a policy that considers CVEs with Critical severity ratings as violations.


#### Running private source code and image scans with policy enforcement

Follow the instructions in [Sample private source scan](scst-scan/samples/private-source.md) to perform a source code scan against a private registry or
[Sample private image scan](scst-scan/samples/private-image.md)
to do an image scan on a private image.


#### Viewing vulnerability reports using Supply Chain Security Tools - Store capabilities

After completing the scans from the previous step,
query the [Supply Chain Security Tools - Store](scst-store/overview.md) to view your vulnerability results.
It is a Tanzu component that stores image, package, and vulnerability metadata about your dependencies.
Use the Supply Chain Security Tools - Store CLI, called Insight,
to query metadata that have been submitted to the component after the scan step.

For a complete guide on how to query the store,
see [Querying Supply Chain Security Tools - Store](scst-store/query_data.md).

#### Example Supply Chain including source and image scans

One of the out of the box supply chains we are working on for a future release will include image and source code vulnerability scanning and metadata storage into a preset Tanzu Application Platform supply chain. Until then, you can use this example to see how to try this out:
[Example Supply Chain including Source and Image Scans](scst-scan/choreographer.md).

**Next steps and further information**

* [Configure Code Repositories and Image Artifacts to be Scanned](scst-scan/scan-crs.md)

* [Code and Image Compliance Policy Enforcement Using Open Policy Agent (OPA)](scst-scan/policies.md)

* [How to Create a ScanTemplate](scst-scan/create-scan-template.md)

* [Viewing and Understanding Scan Status Conditions](scst-scan/results.md)

* [Observing and Troubleshooting](scst-scan/observing.md)

## <a id='consuming-services'></a> Section 5: Consuming Services on Tanzu Application Platform

Tanzu Application Platform makes it easy to discover, curate, consume, and manage
services across single-cluster or multi-cluster environments.
This section introduces procedures for implementing several use cases regarding services journey on Tanzu Application Platform.

### Overview

Nowadays most applications depend on backing services such as databases, queues, and caches.
Developers spend more time focusing on developing their applications and less
time worrying about the provision, configuration, and operations of the backing services.
In Tanzu Application Platform, Services Toolkit is the component that enables this experience.

### Use cases enabled by Services Toolkit on Tanzu Application Platform

All four use cases are for binding an application to a pre-provisioned service instance.
The use cases vary according to where the service instance is located. The four use cases are summarized in the following table:
<table class="nice">
<col width="60%">
<col width="10%">
	<th><strong>Bind application to a service instance running:</strong></th>
	<th><strong>Status:</strong></th>
  <th><strong>See:</strong></th>
	<tr>
		<td>in the same namespace</td>
		<td>GA</td>
    <td><a href="#services-journey-use-case-1">Use case 1</a></td>
	</tr>
	<tr>
		<td>in different namespace on the same Kubernetes cluster</td>
    <td>GA</td>
    <td><a href="#services-journey-use-case-2">Use case 2</a></td>
	</tr>
  <tr>
    <td>outside Kubernetes, for example, on an external Azure DB</td>
    <td>GA</td>
    <td><a href="#services-journey-use-case-3">Use case 3</a></td>
  </tr>
  <tr>
    <td>on a different Kubernetes cluster</td>
    <td>Beta</td>
    <td><a href="#services-journey-use-case-4">Use case 4</a></td>
  </tr>
</table>

Services Toolkit comprises the following Kubernetes-native components:

* [Service Offering](https://docs.vmware.com/en/Services-Toolkit-for-VMware-Tanzu/0.5/services-toolkit-0-5/GUID-service_offering-terminology_and_apis.html)
* [Service Resource Claims](https://docs.vmware.com/en/Services-Toolkit-for-VMware-Tanzu/0.5/services-toolkit-0-5/GUID-service_resource_claims-terminology_and_apis.html)
* [Service API Projection (Experimental)](https://docs.vmware.com/en/Services-Toolkit-for-VMware-Tanzu/0.5/services-toolkit-0-5/GUID-api_projection_and_resource_replication-terminology_and_apis.html)
* [Service Resource Replication (Experimental)](https://docs.vmware.com/en/Services-Toolkit-for-VMware-Tanzu/0.5/services-toolkit-0-5/GUID-api_projection_and_resource_replication-terminology_and_apis.html)

>**Note:** Services marked with Experimental/Beta are subject to change.

Each component has its value, however the best use cases are enabled by combining multiple components together.
For information about each of the Services Toolkit components, including the use cases and the API reference guides,
see the [About Services Toolkit](https://docs.vmware.com/en/Services-Toolkit-for-VMware-Tanzu/0.4/services-toolkit-0-4/GUID-overview.html).

Within the context of Tanzu Application Platform, one of the most important use cases
is binding an application workload to a backing service such as a PostgreSQL database or a
RabbitMQ queue. This ensures the best user experience for working with backing services
as part of the development life cycle.

Before exploring the cases, we need to first install a service and a few supporting resources
so Application Teams can discover, provision, and bind to services in Tanzu Application Platform.
The [setup procedure](#consuming-services-setup) is typically performed by the Service Operator.

>**Note:** The [Service Binding Specification](https://github.com/servicebinding/spec) for Kubernetes is required in this use case.

>**Note:** Any service that adheres to the [Provisioned Service](https://github.com/servicebinding/spec#provisioned-service) in the specification is compatible with Tanzu Application Platform.

<!-- * [Use Case 1 - **Binding an App Workload to a Service Resource**](#services-journey-use-case-1)
* [Use Case 2 - **Binding an App Workload to a Service Resource across multiple clusters**](#services-journey-use-case-2)
* [Use Case 3 - **Binding an App Workload directly to a Secret (support for external services)**](#services-journey-use-case-3) -->

### <a id='consuming-services-setup'></a> Set Up

Follow these steps to install RabbitMQ Operator, create the necessary role-based access control (RBAC),
and create a Services Toolkit resource called `ClusterResource` for RabbitmqCluster.

1. Install RabbitMQ Operator which provides a RabbitmqCluster API kind on the `rabbitmq.com/v1beta1 API Group/Version`.

    ```
    kapp -y deploy --app rmq-operator --file https://github.com/rabbitmq/cluster-operator/releases/download/v1.9.0/cluster-operator.yml
    ```

1. After a new API is installed and available on the cluster,
create the corresponding RBAC rules to give relevant permissions to both the
services-toolkit controller manager and the users of the cluster by configuring `resource-claims-rmq.yaml`.

    **Example:**

    In the following example, we start with the RBAC required by the services-toolkit controller-manager.
    The rules in this `ClusterRole` get aggregated to the services-toolkit controller
    manager through the label, so the services-toolkit controller manager
    is able to get, list, watch and update all rabbitmqcluster resources.

    >**Note:** A ClusterRole with the RBAC required by the services-toolkit controller-manager
     must be enabled for each additional API resource installed onto the cluster.

    ```
    # resource-claims-rmq.yaml
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

1. Apply `resource-claims-rmq.yaml` by running:

    ```
    kubectl apply -f resource-claims-rmq.yaml
    ```

1. In `rabbitmqcluster-reader.yaml`, ensure you have RBAC enabled for all users.
The following example grants `get`, `list` and `watch` to all `rabbitmqcluster` resources for all authenticated
users.

    >**Note:** The specifics of these permissions vary depending on the desired level
    of access to resources.

    ```
    # rabbitmqcluster-reader.yaml
    ---
    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRole
    metadata:
    name: rabbitmqcluster-reader
    rules:
    - apiGroups: ["rabbitmq.com"]
    resources: ["rabbitmqclusters"]
    verbs: ["get", "list", "watch"]
    ---
    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRoleBinding
    metadata:
    name: rabbitmqcluster-reader
    roleRef:
    apiGroup: rbac.authorization.k8s.io
    kind: ClusterRole
    name: rabbitmqcluster-reader
    subjects:
    - apiGroup: rbac.authorization.k8s.io
    kind: Group
    name: system:authenticated
    ```

1. Apply `rabbitmqcluster-reader.yaml` by running:

    ```
    kubectl apply -f rabbitmqcluster-reader.yaml
    ```

1. Create a dedicated namespace in which to create service instances by running:

    ```
    kubectl create namespace service-instances
    ```

1. Make the API discoverable to the Application Development team by creating the
ClusterResources in `rabbitmq-clusterresource.yaml`.

    **Example:**

    ```
    # rabbitmq-clusterresource.yaml
    apiVersion: services.apps.tanzu.vmware.com/v1alpha1
    kind: ClusterResource
    metadata:
    name: rabbitmq
    spec:
    shortDescription: It's a RabbitMQ cluster!
    resourceRef:
      group: rabbitmq.com
      kind: RabbitmqCluster
    ```

1. Apply `rabbitmq-clusterresource.yaml` by running:

    ```
    kubectl apply -f rabbitmq-clusterresource.yaml
    ```

    For information about `ClusterResource`, see the
    [Service Offering for VMware Tanzu](https://docs.vmware.com/en/Services-Toolkit-for-VMware-Tanzu/0.4/services-toolkit-0-4/GUID-service_offering-terminology_and_apis.html).


### <a id='services-journey-use-case-1'></a> Use case 1: Binding an application to a pre-provisioned service instance running in the same namespace

Follow these steps to bind an application to a pre-provisioned service instance running
in the same namespace.

1. Create a RabbitMQ service instance with the following YAML:

    ```
    # example-rabbitmq-cluster-service-instance.yaml
    ---
    apiVersion: rabbitmq.com/v1beta1
    kind: RabbitmqCluster
    metadata:
      name: example-rabbitmq-cluster-1
    spec:
      replicas: 1
    ```

1. Apply `example-rabbitmq-cluster-service-instance.yaml` by running:

    ```
    kubectl apply -f example-rabbitmq-cluster-service-instance.yaml
    ```

1. List the resource by running:

    ```
    kubectl get rabbitmqclusters
    ```

1. Follow these steps to create an application workload that automatically claims and binds to the
RabbitMQ instance:

    >**Note:** Ensure your namespace can use the installed Tanzu Application Platform packages so that Services Toolkit can create application workloads.
    For more information, see [Set Up Developer Namespaces to Use Installed Packages](install-components.md#setup).

    1. Obtain a service reference by running:

        ```
        $ tanzu service instance list -owide
        ```

        Expect to see the following outputs:

        ```
        NAME                        KIND             SERVICE TYPE  AGE  SERVICE REF
        example-rabbitmq-cluster-1  RabbitmqCluster  rabbitmq      50s  rabbitmq.com/v1beta1:RabbitmqCluster:default:example-rabbitmq-cluster-1
        ```

    1. Create the application workload and the `rabbitmq-sample` application hosted at
    `https://github.com/jhvhs/rabbitmq-sample` by running:

        ```
        tanzu apps workload create rmq-sample-app-usecase-1 --git-repo https://github.com/jhvhs/rabbitmq-sample --git-branch v0.1.0 --type web --service-ref "rmq=<SERVICE-REF>"
        ```

        Where `<SERVICE-REF>` is the value of `SERVICE REF` from the output in the last step.

1. Get the Knative web-app URL by running:

    ```
    tanzu apps workload get rmq-sample-app-usecase-1
    ```

    >**Note:** It can take some time before the workload is ready.

1. Visit the URL and confirm the app is working by refreshing the page and checking
the new message IDs.

### <a id='services-journey-use-case-2'></a> Use case 2 - Binding an application to a pre-provisioned service instance running in a different namespace on the same Kubernetes cluster

[Use case 1](#services-journey-use-case-1) introduces binding a sample application workload to a service
instance that is running in the same namespace.
Use case 2 is for binding a sample application workload to a service instance that is running in a different
namespace. This is a common scenario as it separates concerns
between those users working with application workloads, and those who are responsible
for service instances.

1. Create a new service instance in a different namespace.

    For example, the `service-instances` namespace:

    ```
    # example-rabbitmq-cluster-service-instance-2.yaml
    ---
    apiVersion: rabbitmq.com/v1beta1
    kind: RabbitmqCluster
    metadata:
      name: example-rabbitmq-cluster-2
    spec:
      replicas: 1
    ```

1. Apply `example-rabbitmq-cluster-service-instance-2.yaml` by running:

    ```
    kubectl -n service-instances apply -f example-rabbitmq-cluster-service-instance-2.yaml
    ```

1. Obtain a service reference by running:

    ```
    $ tanzu service instances list --all-namespaces -owide
    ```

    Expect to see the following outputs:

    ```
    NAMESPACE          NAME                        KIND             SERVICE TYPE  AGE   SERVICE REF
    default            example-rabbitmq-cluster-1  RabbitmqCluster  rabbitmq      105s  rabbitmq.com/v1beta1:RabbitmqCluster:default:example-rabbitmq-cluster-1
    service-instances  example-rabbitmq-cluster-2  RabbitmqCluster  rabbitmq      14s   rabbitmq.com/v1beta1:RabbitmqCluster:service-instances:example-rabbitmq-cluster-2
    ```

1. Create a `ResourceClaimPolicy` to enable cross-namespace binding.

    >**Note:** The service instance is in a different namespace to the one the application workload is running in. By default, it is impossible to bind an application workload to a service instance that resides in a different namespace as this would break tenancy of the Kubernetes namespace model.

    ```
    # resource-claim-policy.yaml
    ---
    apiVersion: services.apps.tanzu.vmware.com/v1alpha1
    kind: ResourceClaimPolicy
    metadata:
    name: rabbitmqcluster-cross-namespace
    spec:
    consumingNamespaces:
    - '*'
    subject:
      group: rabbitmq.com
      kind: RabbitmqCluster

    ```
    Where `*` indicates this policy permits any namespace to claim a RabbitmqCluster resource from
    the service-instances namespace.

1. Apply `resource-claim-policy.yaml` by running:

    ```
    kubectl -n service-instances apply -f resource-claim-policy.yaml
    ```

    For more information about `ResourceClaimPolicy`, see the
    [ResourceClaimPolicy documentation](https://docs.vmware.com/en/Services-Toolkit-for-VMware-Tanzu/0.5/services-toolkit-0-5/GUID-service_resource_claims-terminology_and_apis.html#resourceclaimpolicy-4).

1. Bind the application workload to the RabbitmqCluster Service Instance:

    ```
    $ tanzu apps workload update rmq-sample-app-usecase-2 --service-ref="rmq=<SERVICE-REF>" --yes
    ```

    Where `<SERVICE-REF>` is the value of `SERVICE REF` from the output in the step 3.

1. Get the Knative web-app URL by running:

    ```
    tanzu apps workload get rmq-sample-app-usecase-2
    ```

1. Visit the URL and confirm the app is working by refreshing the page and
checking the new message IDs.

### <a id='services-journey-use-case-3'></a> Use case 3 - Binding an application to a service running outside Kubernetes

This use case leverages direct references to Kubernetes `Secret` resources to enable developers to connect their application workloads to almost
any backing service, including backing services that:

* are running external to the platform
* do not adhere to the [Provisioned Service specifications](https://github.com/servicebinding/spec#provisioned-service)

>**Note:** Kubernetes Secret resource must abide by
the [Well-known Secret Entries specifications](https://github.com/servicebinding/spec#well-known-secret-entries).

The following example demonstrates the procedures to bind a new application on Tanzu Application Platform to an
existing PostgreSQL database that exists in Azure.

1. Create a Kubernetes `Secret` resource similar to the following example:

    ```
    # external-azure-db-binding-compatible.yaml
    ---
    apiVersion: v1
    kind: Secret
    metadata:
      name: external-azure-db-binding-compatible
    type: Opaque
    stringData:
      type: postgresql
      provider: azure
      host: EXAMPLE.DATABASE.AZURE.COM
      port: "5432"
      database: "EXAMPLE-DB-NAME"
      username: "USER@EXAMPLE"
      password: "PASSWORD"
    ```

1. Apply the YAML file by running:

    ```
    kubectl apply -f external-azure-db-binding-compatible.yaml
    ```
    >**Note:** The `Secret` can be defined in a different namespace than the Workload
    >and claimed cross namespace by using `ResourceClaimPolicy` resources.
    >For more information, see [Use case 2](#services-journey-use-case-2).

1. Create your application workload by running:

    Example:

    ```
    tanzu apps workload create <WORKLOAD-NAME> --git-repo https://github.com/spring-projects/spring-petclinic --git-branch main --type web --service-ref db=<REFERENCE>
    ```

    Where:

    - `<WORKLOAD-NAME>` is the name of the application workload. For example, `pet-clinic`.
    - `<REFERENCE>` is a reference provided to the `Secret`. For example, `v1:Secret:external-azure-db-binding-compatible`.

### <a id='services-journey-use-case-4'></a> **Use case 4: Binding an application to a service instance running on a different Kubernetes cluster (Experimental).**

>**Note:** Use cases marked with Experimental are subject to change.

This use case is identical to [use case 1](#services-journey-use-case-1),
but rather than installing and running the RabbitMQ Cluster Kubernetes Operator on the same cluster
as Tanzu Application Platform, we install and run it on an entirely separate dedicated services cluster.
There are several reasons why we want to implement this use case:

- **Dedicated cluster requirements for Workload or Service clusters:** service clusters, for instance,
might need access to more powerful SSDs.
- **Different cluster life cycle management:** upgrades to Service clusters can occur more cautiously.
- **Unique compliance requirements:** data is stored on a Service cluster, which might have different compliance needs.
- **Separation of permissions and access:** application teams can only access the clusters where their
applications are running.

The benefits of implementing this use case include:

- The experience of application developers working on their Tanzu Application Platform cluster is
unaltered.
- All complexity in the setup and management of backing infrastructure is abstracted away
from application developers, which gives them more time to focus on developing their applications.

>**Note:** The components of Services Toolkit that drive this experience are Service API Projection and
Service Resource Replication. These components are not currently considered to be GA.

For more information about network requirements and recommended topologies, see the
[Topology section](https://docs.vmware.com/en/Services-Toolkit-for-VMware-Tanzu/0.5/services-toolkit-0-5/GUID-reference-topologies.html) of the Services Toolkit documentation.

#### Prerequisites

>**Important:** Ensure you have completed the previous use cases prior to continuing with use case 4.

Ensure you have met the following prerequisites before starting the [procedures of use case 4](#steps-use-case-4).

1. Uninstall the RabbitMQ Cluster Operator that was installed in [consuming services setup procedures](#consuming-services-setup).

    ```
    kapp delete -a rmq-operator -y
    ```

1. Follow the documentation to install Tanzu Application Platform on to a second separate Kubernetes
cluster.

    * This cluster must be able to create LoadBalanced services.

    * After adding the Tanzu Application Platform package repository, instead of
    installing all packages, you only need to install the Services Toolkit package.
    For installation information, see [Add the Tanzu Application Platform Package Repository](install.md#add-package-repositories)
    and [Install Services Toolkit](install-components.md#install-services-toolkit).

    * From now on this cluster is called the **Service Cluster**.

1. Download and install the `kubectl-scp` plug-in from [Tanzu Application Platform Tanzu Network](https://network.tanzu.vmware.com/products/tanzu-application-platform).

    **Note:** This plug-in is in Beta phase.

    **Note:** To install the plug-in you must place it in your `PATH` and ensure it is executable.

    For example:

    ```
    sudo cp PATH-TO-KUBECTL-SCP /usr/local/bin/kubectl-scp
    sudo chmod +x /usr/local/bin/kubectl-scp
    ```

    Now you have two Kubernetes clusters:

    - **Workload Cluster**, which is where Tanzu Application Platform, including Services Toolkit, is installed.
    The RabbitMQ Cluster Operator is not installed on this cluster.
    - **Services Cluster**, which is where only Services Toolkit is installed. No other component is installed in this cluster.

#### <a id='steps-use-case-4'></a> Steps

Follow these steps to bind an application to a service instance running on a different Kubernetes cluster:

>**Important:** Some of the commands listed in the following steps have placeholder values `<WORKLOAD-CONTEXT>` and `<SERVICE-CONTEXT>`.
>Change these values before running the commands.

1. As the Service Operator, run the following command to link the Workload Cluster and Service Cluster together by using the `kubectl scp` plug-in:

    ```
    kubectl scp link --workload-kubeconfig-context=<WORKLOAD-CONTEXT> --service-kubeconfig-context=<SERVICE-CONTEXT>
    ```

1. Install the RabbitMQ Kubernetes Operator in the Services Cluster using kapp.

    >**Note:** This Operator is installed in the Workload Cluster, but developers can still create
    RabbitmqCluster service instances from the Workload Cluster.

    >**Note:** Use the exact `deploy.yml` specified in the command as this RabbitMQ Operator deployment includes specific changes to enable cross-cluster
    service binding.

    ```
     kapp -y deploy --app rmq-operator \
        --file https://raw.githubusercontent.com/rabbitmq/cluster-operator/lb-binding/hack/deploy.yml  \
        --kubeconfig-context <SERVICE-CONTEXT>
    ```

1. Verify that the Operator is installed by running:

    ```
    kubectl --context <SERVICE-CONTEXT> get crds rabbitmqclusters.rabbitmq.com
    ```

    The following steps federate the `rabbitmq.com/v1beta1` API group, which is available in the
    Service Cluster, into the Workload Cluster.
    This occurs in two parts: projection and replication.

    - Projection applies to custom API groups.
    - Replication applies to core Kubernetes resources, such as
    Secrets.

1. Create a corresponding namespace in the Service cluster. In [use case 2](#services-journey-use-case-2),
we created a namespace named `service-instances`, we must now create a namespace with the same name on the Service cluster.

    For example:

    ```
    kubectl --context <SERVICE-CONTEXT> create namespace service-instances
    ```

1. Federate using the `kubectl-scp` plug-in by running:

    ```
     kubectl scp federate \
      --workload-kubeconfig-context=<WORKLOAD-CONTEXT> \
      --service-kubeconfig-context=<SERVICE-CONTEXT> \
      --namespace=service-instances \
      --api-group=rabbitmq.com \
      --api-version=v1beta1 \
      --api-resource=rabbitmqclusters
    ```

1. After federation, verify the `rabbitmq.com/v1beta1` API is also available in the Workload Cluster by running:

    ```
    kubectl --context <WORKLOAD-CONTEXT> api-resources
    ```

    The application operator takes over from here.
    Ensure you are targeting the Tanzu Application Platform workload cluster, not
    the service cluster.

1. Discover the new service and provision an instance by running:

    ```
    tanzu service types list
    ```

    The following output appears:

    ```
    Warning: This is an ALPHA command and may change without notice.

    NAME      DESCRIPTION               APIVERSION            KIND
    rabbitmq  It's a RabbitMQ cluster!  rabbitmq.com/v1beta1  RabbitmqCluster
    ```

1. Provision a service instance on the Tanzu Application Platform cluster.

    For example:

    ```
    # rabbitmq-cluster.yaml
    ---
    apiVersion: rabbitmq.com/v1beta1
    kind: RabbitmqCluster
    metadata:
      name: projected-rmq
    spec:
      service:
        type: LoadBalancer
    ```

1. Apply the YAML file by running:

    ```
    kubectl --context <WORKLOAD-CONTEXT> -n service-instances apply -f rabbitmq-cluster.yaml
    ```

1. Confirm that the RabbitmqCluster resource reconciles successfully from the
Workload Cluster by running:

    ```
    kubectl --context <WORKLOAD-CONTEXT> -n service-instances get -f rabbitmq-cluster.yaml
    ```

1. Confirm that RabbitMQ Pods are running in the Service Cluster, but not in the
Workload Cluster by running:

    ```
    kubectl --context <WORKLOAD-CONTEXT> -n service-instances get pods
    kubectl --context <SERVICE-CONTEXT> -n service-instances get pods
    ```

    Finally, the app developer takes over. The experience is the same for
    the application developer as in [use case 1](#services-journey-use-case-1).

1. Create the application workload by running:

    ```
    tanzu apps workload create rmq-sample-app-usecase-4 --git-repo https://github.com/jhvhs/rabbitmq-sample --git-branch v0.1.0 --type web --service-ref "rmq=rabbitmq.com/v1beta1:RabbitmqCluster:service-instances:projected-rmq"
    ```

1. Get the web-app URL by running:

    ```
    tanzu apps workload get rmq-sample-app-usecase-4
    ```

1. Visit the URL and refresh the page to confirm the app is running by checking
the new message IDs.



<br>
<br>
<br>
