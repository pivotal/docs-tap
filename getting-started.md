# Getting Started with Tanzu Application Platform

## Purpose

The intention of this guide is to walk you through the experience of promoting your first application using the Tanzu Application Platform.

The intended user of this guide is anyone curious about Tanzu Application Platform and its parts.
There are two high-level workflows described in this document:

1. The application development experience with the Developer Toolkit components.

2. The administration, set up, and management of Supply Chains, Security Tools, Services, and Application Accelerators.


### Prerequisites

In order to take full advantage of this document, ensure you have followed [Installing Tanzu Application Platform](install-intro.md).

---

## Section 1: Developing Your First Application on Tanzu Application Platform

In this section, you will deploy a simple web application to the platform, enable debugging and see your code updates added to the running application as you save them.

Before getting started, ensure the following prerequisites are in place:

1. Tanzu Application Platform is installed on the target Kubernetes cluster. For installation instructions, see [Installing Part I: Prerequisites, EULA, and CLI](install-general.md) and [Installing Part II: Profiles](install.md).

2. Default kubeconfig context is set to the target Kubernetes cluster.

3. The Out of The Box Supply Chain Basic is installed. See [Install default Supply Chain](install-components.md#install-ootb-supply-chain-basic).

4. A developer namespace is setup to accommodate the developer's Workload.
   See [Set Up Developer Namespaces to Use Installed Packages](install-components.md#setup).


#### A note about Application Accelerators

The Application Accelerator component helps app developers and app operators through the creation and generation of application accelerators. Accelerators are templates that codify best practices and ensure important configuration and structures are in place from the start.

Developers can bootstrap their applications and get started with feature development right away. Application Operators can create custom accelerators that reflect their desired architectures and configurations and enable fleets of developers to utilize them, decreasing operator concerns about whether developers are implementing their desired best practices.

Application Accelerator templates are available as a quick start from [Tanzu Network](https://network.tanzu.vmware.com/products/app-accelerator). To create your own Application Accelerator, see [Creating an Accelerator](#creating-an-accelerator).


### Deploy Your Application

Follow these steps to get started with an accelerator called `Tanzu-Java-Web-App`.

1. Visit your Application Accelerator by following the steps in
[Installing Application Accelerator for VMware Tanzu](https://docs.vmware.com/en/Application-Accelerator-for-VMware-Tanzu/0.3/acc-docs/GUID-installation-install.html).

    <img src="images/app-acc.png" alt="Screenshot of Application Accelerator that shows a search field and two accelerators" width="600">

1. Select the **Tanzu Java Web App** accelerator, which is a sample Spring Boot web app.

    <img src="images/tanzu-java-web-app.png" alt="Screenshot of the Tanzu Java Web App within Application Accelerator. It includes empty text boxes for new project information." width="600">

1. Replace the default value `dev.local` in the _"prefix for container image registry"_ field
with the URL to your registry. The URL must match the registry server you want the default Supply Chain to push container images to.

For more information, see [Install default Supply Chain](install-components.md#install-ootb-supply-chain-basic).

    >**Note:** This entry should not include the project ID or image name.

    <img src="images/store-image-on-server.png" alt="Screenshot of the Tanzu Java Web App within Application Accelerator. It includes empty text boxes for new project information, and buttons labeled 'Generate Project', 'Explore Files', and 'Cancel'." width="600">

1. Click the **Generate Project** button to download the accelerator zip file.
You use this accelerator code in the [Iterate on your Application](#iterate) section later.

1. Deploy the Tanzu Java Web App accelerator by running the `tanzu apps workload create` command:

    ```console
    tanzu apps workload create tanzu-java-web-app \
    --git-repo https://github.com/sample-accelerators/tanzu-java-web-app \
    --git-branch main \
    --type web \
    --label app.kubernetes.io/part-of=tanzu-java-web-app \
    --yes
    ```

    For more information, see [Tanzu Apps Workload Create](cli-plugins/apps/command-reference/tanzu_apps_workload_create.md).

    >**Note:** This first deploy uses accelerator source from Git, but you use the VSCode extension
    to debug and live-update this app in later steps.

1. View the build and runtime logs for your app by running the `tail` command:

    ```console
    tanzu apps workload tail tanzu-java-web-app --since 10m --timestamp
    ```

1. After the workload is built and running, get the web-app URL by running
`tanzu apps workload get tanzu-java-web-app` and then pressing **ctrl-click** on the
Workload Knative Services URL at the bottom of the command output.


### Add Your Application to Tanzu Application Platform GUI

To see this application in your organization catalog, you must point to the catalog definition file
included in the accelerator zip file.

1. Ensure you have already installed the Blank Software Catalog. For installation information, see
[Configure the Tanzu Application Platform GUI](install.md#configure-tap-gui).

1. Add the path to the application in the `catalog-info.yaml` file for your catalog, as seen in
this example:

    ```yaml
    apiVersion: backstage.io/v1alpha1
    kind: Location
    metadata:
      name: backstage-catalog-info
      description: A sample catalog for Backstage
      annotations:
        'backstage.io/techdocs-ref': dir:.
    spec:
      targets:
        - ./components/backstage.yaml
        - ./groups/default-org.yaml
        - ./systems/backstage-system.yaml
        - ./domains/backstage-domain.yaml
        - https://<GIT-LOCATION-OF-ACCELERATOR>/catalog-info.yaml
    ```
    Where `<GIT-LOCATION-OF-ACCELERATOR>` is the location of the accelerator's catalog definition file.

The default catalog refresh is 200 seconds.
After your catalog refreshes you can see the entry in the catalog and interact with it.


### <a id='iterate'></a>Iterate on your Application

##### Set up your IDE

Now that you have a skeleton workload working, you are ready to iterate on your application
and test code changes on the cluster.
Tanzu Developer Tools for VSCode, VMware Tanzu’s official IDE extension for VSCode,
helps you develop & receive fast feedback on the Tanzu Application Platform.

The VSCode extension enables live updates of your application while it runs on the cluster
and lets you debug your application directly on the cluster.

For information about installing the pre-requisites and the Tanzu Developer Tools extension, see
[How to Install the VSCode Tanzu Extension](vscode-extension/install.md).

Open the ‘Tanzu Java Web App’ as a project within your VSCode IDE.

In order to ensure your extension helps you iterate on the correct project, you will need to configure its settings:

1. Within VSCode, go to Preferences -> Settings -> Extensions -> Tanzu.

2. In the **Local Path** field, enter the path to the directory containing the ‘Tanzu Java Web App’.

3. In the **Source Image** field, enter the destination image repository where you’d like to publish an image containing your workload’s source code. For example “harbor.vmware.com/myteam/tanzu-java-web-app-source”.

You are now ready to iterate on your application.


##### Live Update your Application

Deploy the application and see it live update on the cluster. Doing so allows you to understand how your code changes will behave on a production-like cluster much earlier in the development process.

Follow these steps:
1. From the Command Palette (⇧⌘P), type in & select **Tanzu: Live Update Start**.

    Tanzu Logs opens up in the Output tab and you will see output from the Tanzu Application Platform and from Tilt indicating that the container is being built and deployed.

    Since this is your first time starting live update for this application, it may take 1-3 minutes for the workload to be deployed and the Knative service to become available.

2. Once you see output indicating that the workload is ready, navigate to http://localhost:8080 in your browser and view your application running.
3. Return to the IDE and make a change to the source code. For example, in HelloController.java, modify the string returned to say `Hello!` and save.
4. If you look in the Tanzu Logs section of the Output tab, you will see the container has updated. Navigate back to your browser and refresh the page.


You will see your changes on the cluster.

You can now continue to make more changes. If you are finished, you can stop or disable live update. Open the command palette (⇧⌘P), type in Tanzu, and select either option.


##### Debug your Application

You can debug your cluster on your application or in your local environment.

Follow the steps below to debug your cluster:
1. Set a breakpoint in your code.
2. Right-click the file `workload.yaml` within the `config` folder, and select `Tanzu: Java Debug Start`. In a few moments, the workload will be redeployed with debugging enabled.
3. Return to your browser and navigate to http://localhost:8080. This will hit the breakpoint within VSCode. You can now step through or play to the end of the debug session using VSCode debugging controls.


##### Troubleshooting a Running Application

Now that your application is developed you may be interested in inspecting the run time
characteristics of the running application. You can use Application Live View UI to look
into the running application to monitor resource consumption, JVM status, incoming traffic
as well as change log level, environment variables to troubleshoot and fine-tune the running application.
Currently, Spring Boot based applications can be diagnosed using Application Live View.

Make sure that you have installed Application Live View components successfully.

Access Application Live View Tanzu Application Platform GUI following the instruction
[here](https://docs-staging.vmware.com/en/VMware-Tanzu-Application-Platform/0.3/tap-0-3/GUID-tap-gui-plugins-app-live-view.html).
Select your application to look inside the running application and
[explore](https://docs.vmware.com/en/Application-Live-View-for-VMware-Tanzu/0.3/docs/GUID-product-features.html)
the various diagnostic capabilities.


---


## <a id='creating-an-accelerator'></a>Section 2: Creating an Accelerator

You can use any git repository to create an Accelerator.
You need the URL for the repository to create an Accelerator.

Use the following procedure to create an accelerator:

1. Select the **New Accelerator** tile from the accelerators in the Application Accelerator web UI.

2. Fill in the new project form with the following information:

    * Name: Your Accelerator name. This is the name of the generated ZIP file.
    * (Optional) Description: A description of your accelerator.
    * K8s Resource Name: A Kubernetes resource name to use for the Accelerator.
    * Git Repository URL: The URL for the git repository that contains the accelerator source code.
    * Git Branch: The branch for the git repository.
    * (Optional) Tags: Any associated tags that can be used for searches in the UI.

3. Download and expand the zip file.

    * The output contains a YAML file for an Accelerator resource, pointing to the git repository.
    * The output contains a file named `new-accelerator.yaml` which defines the metadata for your new accelerator.

4. To apply the k8s-resource.yml, run the following command in your terminal in the folder where you expanded the zip file:

    ```bash
    kubectl apply -f k8s-resource.yaml
    ```

5. Refresh the Accelerator web UI to reveal the newly published accelerator.


#### Using application.yaml

The Accelerator zip file contains a file called `new-accelerator.yaml`.
This file is a starting point for the metadata for your new accelerator and the associated options and file processing instructions.
This `new-accelerator.yaml` file should be copied to the root directory of your git repo and named `accelerator.yaml`.

Copy this file into your git repo as `accelerator.yaml` to have additional attributes rendered in the web UI.
See [Creating Accelerators](https://docs.vmware.com/en/Application-Accelerator-for-VMware-Tanzu/0.2/acc-docs/GUID-creating-accelerators-index.html).

After you push that change to your git repository, the Accelerator is refreshed based on the `git.interval` setting for the Accelerator resource. The default is 10 minutes. You can run the following command to force an immediate reconciliation:

```bash
tanzu accelerator update <accelerator-name> --reconcile
```
---

## Section 3: Add Testing and Security Scanning to Your Application

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

<li>Apply any predefined conventions to the K8s configuration

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

### Install Out of the Box with Testing

When you chose not to use the preceding install method, see [Install
Tekton](install-components.md#install-tekton).

With Tekton installed, you can activate the Out of the Box Supply Chain with Testing by updating our profile to use `testing` rather than `basic` as the selected supply chain for workloads in this cluster. Update `tap-values.yml`(the file used to customize the profile in `Tanzu package install tap
--values-file=...`) with the following changes:

```diff
- supply_chain: basic
+ supply_chain: testing

- ootb_supply_chain_basic:
+ ootb_supply_chain_testing:
    registry:
      server: "<SERVER-NAME>"
      repository: "<REPO-NAME>"
```

Then update the installed profile:

```bash
tanzu package installed update tap -p tap.tanzu.vmware.com -v 0.3.0 --values-file tap-values.yml -n tap-install
```


### Example Tekton Pipeline Config

In this section, we’ll add a Tekton pipeline to our cluster and in the following section,
we’ll update the workload to point to the pipeline and resolve any of the current errors.

The next step is to add a Tekton pipeline to our cluster.
Because a developer knows how their application needs to be tested this step could be performed by the developer.
The Operator could also add these to a cluster prior to the developer getting access to it.

In order to add the Tekton supply chain to the cluster, we’ll apply the following YAML to the cluster:

```yaml
apiVersion: tekton.dev/v1beta1
kind: Pipeline
metadata:
  name: developer-defined-tekton-pipeline
spec:
  params:
    - name: source-url
    - name: source-revision
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
the workload must be updated to point at the your Tekton pipeline.
1. Update the workload by running the following with the Tanzu CLI:

  ```bash
  tanzu apps workload create tanzu-java-web-app \
    --git-repo  https://github.com/sample-accelerators/tanzu-java-web-app \
    --git-branch main \
    --type web \
    --param tekton-pipeline-name=developer-defined-tekton-pipeline \
    --yes
  ```

  ```console
  Create workload:
        1 + |apiVersion: carto.run/v1alpha1
        2 + |kind: Workload
        3 + |metadata:
        4 + |  labels:
        5 + |    apps.tanzu.vmware.com/workload-type: web
        6 + |  name: tanzu-java-web-app
        7 + |  namespace: default
        8 + |spec:
        9 + |  params:
       10 + |  - name: tekton-pipeline-name
       11 + |    value: developer-defined-tekton-pipeline
       12 + |  source:
       13 + |    git:
       14 + |      ref:
       15 + |        branch: main
       16 + |      url: https://github.com/sample-accelerators/tanzu-java-web-app

  ? Do you want to create this workload? Yes
  Created workload "tanzu-java-web-app"
  ```

2. After accepting the workload creation, monitor the creation of new resources by the workload by running:

  ```bash
  kubectl get workload,gitrepository,pipelinerun,images.kpack,podintent,app,services.serving
  ```

  You will see output similar to the following example that shows the objects that were created by the Supply Chain Choreographer:


  ```bash
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

    ```bash
    tanzu package installed get scanning -n tap-install
    tanzu package installed get grype -n tap-install
    ```

Follow the steps in [Supply Chain Security Tools - Scan](install-components.md#install-scst-scan) to install the required scanning components.

During installation of the Grype Scanner, sample ScanTemplates are installed into the `default` namespace. If the workload is to be deployed into another namespace, then these sample ScanTemplates also need to be present in the other namespace. One way to accomplish this is to install Grype Scanner again, and provide the namespace in the values file.

A ScanPolicy is required and the following is to be applied into the required namespace (either add the namespace flag to the `kubectl` command or add the namespace field into the template itself):

```bash
kubectl apply -f - -o yaml << EOF
---
apiVersion: scanning.apps.tanzu.vmware.com/v1alpha1
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

2. (Optional, but recommended) To persist and query the vulnerability results post-scan, [install Supply Chain Security Tools - Store](install-components.md#install-scst-store). Refer to the *Prerequisite* in [Supply Chain Security Tools - Scan](install-components.md#install-scst-scan) for more details.

3. Update the profile to use the supply chain with testing and scanning by
   updating `tap-values.yml` (the file used to customize the profile in `tanzu
   package install tap --values-file=...`) with the following changes:


    ```diff
    - supply_chain: testing
    + supply_chain: testing_scanning

    - ootb_supply_chain_testing:
    + ootb_supply_chain_testing_scanning:
        registry:
          server: "<SERVER-NAME>"
          repository: "<REPO-NAME>"
    ```

4. Update the `tap` package:

```bash
tanzu package installed update tap -p tap.tanzu.vmware.com -v 0.3.0 --values-file tap-values.yml -n tap-install
```


### Workload update

Finally, in order to have the new supply chain connected to the workload,
the workload needs to be updated to point at the newly created Tekton pipeline.
The workload can be updated using the Tanzu CLI as follows:

```bash
tanzu apps workload create tanzu-java-web-app \
  --git-repo https://github.com/sample-accelerators/tanzu-java-web-app \
  --git-branch main \
  --type web \
  --param tekton-pipeline-name=developer-defined-tekton-pipeline \
  --yes
```

```console
Create workload:
      1 + |apiVersion: carto.run/v1alpha1
      2 + |kind: Workload
      3 + |metadata:
      4 + |  labels:
      5 + |    apps.tanzu.vmware.com/workload-type: web
      6 + |  name: tanzu-java-web-app
      7 + |  namespace: default
      8 + |spec:
      9 + |  params:
     10 + |  - name: tekton-pipeline-name
     11 + |    value: developer-defined-tekton-pipeline
     12 + |  source:
     13 + |    git:
     14 + |      ref:
     15 + |        branch: main
     16 + |      url: https://github.com/sample-accelerators/tanzu-java-web-app

? Do you want to create this workload? Yes
Created workload "tanzu-java-web-app"
```

After accepting the creation of the new workload, we can monitor the creation of new resources by the workload using:

```bash
kubectl get workload,gitrepository,pipelinerun,images.kpack,podintent,app,services.serving
```

That should result in an output which will show all of the objects that have been created by the Supply Chain Choreographer:


```bash
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

---

## Section 4: Advanced Use Cases - Supply Chain Security Tools

### Supply Chain Security Tools Overview

In this section, we will provide an overview of the supply chain security use cases that are available in TAP:

1. **Sign**: Introducing image signing and verification to your supply chain

2. **Scan & Store**: Introducing vulnerability scanning and metadata storage to your supply chain

### Sign: Introducing Image Signing & Verification to your Supply Chain

**Overview**

This feature-set allows an application operator to define a policy that will restrict unsigned images from running on clusters.
This is done using a dynamic admission control component on Kubernetes clusters.
This component contains logic to communicate with external registries and verify signatures on container images,
making a decision based on the results of this verification.
Currently, this component supports cosign signatures and its key formats.
It will work with open source cosign, kpack and Tanzu Build Service (which is what we will overview in this document).

Signing an artifact creates metadata about it that allows consumers to verify its origin and integrity.
By verifying signatures on artifacts prior to their deployment,
this allows operators to increase their confidence that trusted software is running on their clusters.

**Use Cases**

* Validate signatures from a given registry.

**Signing Container Images**

Tanzu Application Platform supports verifying container image signatures that follow the `cosign` format.
Application operators may apply image signatures and store them in the registry in one of several ways:

* Using Tanzu Build Service v1.3

* Using [kpack](https://github.com/pivotal/kpack/blob/main/docs/image.md#cosign-config) v0.4.0

* Signing existing images with [cosign](https://github.com/sigstore/cosign#quick-start)


**Configure the Image Policy Webhook**

After the webhook is running, create a service account named `image-policy-registry-credentials` in the `image-policy-system` namespace. This is required, even if the images and signatures are in public registries.

After the image policy webhook is installed in the cluster, configure the image policy you want to enforce and the credentials to access private registries.

**Configure a service account to hold private registry secrets**

When the platform operator is expecting to verify signatures stored in a private registry,
it is required that you configure a service account with all the secrets for those private registries.
The service account:

* Must be created in the `image-policy-system` namespace

* Must be called `image-policy-registry-credentials`

* All secrets for accessing private registries must be added to the `imagePullSecrets` section of the service account

The manifest for the service account is similar to the following example:

```
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: image-policy-registry-credentials
  namespace: image-policy-system
imagePullSecrets:
- name: secret1
- name: secret2
```

**Create a Cluster Image Policy**

The cluster image policy is a custom resource definition containing the following information:

* A list of namespaces to which the policy should not be enforced.

* A list of public keys complementary to the private keys that were used to sign the images.

* A list of image name patterns to which we want to enforce the policy, mapping to the public keys to use for each pattern.

An example policy would look like this:

```
---
apiVersion: signing.run.tanzu.vmware.com/v1alpha1
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
```


As of this writing, the custom resource for the policy must have a name of image-policy.

The platform operator should add to the `verification.exclude.resources.namespaces`
section any namespaces that are known to run container images that are not currently signed, such as `kube-system`.


**Examples and Expected Results**

Assuming a platform operator creates the following policy:


```
---
apiVersion: signing.run.tanzu.vmware.com/v1alpha1
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


When a developer deploys an application with a matched image name and the image is signed:

* **Expected result**: resource is created successfully.

When a developer deploys an application with a matched image name and the image is unsigned:

* **Expected result**: resource is not created and an error message is shown in the CLI output.

When a developer deploys an application with an image from an unmatched pattern and the warnOnUnmatched feature flag is turned on:

* **Expected result**: resource is created successfully and a warning message is shown in the CLI output.

When a developer deploys an application with an image from an unmatched pattern and the warnOnUnmatched feature flag is turned off:

* **Expected result**: resource is not created and an error message is shown in the CLI output.

The Sign add-on outputs logs for the above scenarios.
To have a look at the logs, the platform operator runs:

```console
kubectl logs -n image-policy-system -l "signing.run.tanzu.vmware.com/application-name=image-policy-webhook" -f
```


### Scan & Store: Introducing Vulnerability Scanning & Metadata Storage to your Supply Chain

**Overview**

This feature-set allows an application operator to introduce source code and image vulnerability scanning,
as well as scan-time rules, to their Tanzu Application Platform Supply Chain. The scan-time rules prevent critical vulnerabilities from flowing through the supply chain unresolved.

All vulnerability scan results are stored over time in a metadata store that allows a team
to easily reference historical scan results, and provides querying functionality to support the following use cases:

* What images and packages are affected by a specific vulnerability?
* What source code repos are affected by a specific vulnerability?
* What packages and vulnerabilities does a particular image have?
* What images are using a given package?

The Store accepts any CycloneDX input and outputs in both human-readable and machine-readable (JSON, text, CycloneDX) formats. Querying can be performed via a CLI, or directly from the API.

**Use Cases**

* Scan source code repositories and images for known CVEs prior to deploying to a cluster
* Identify CVEs by scanning continuously on each new code commit and/or each new image built
* Analyze scan results against user-defined policies using Open Policy Agent
* Produce vulnerability scan results and post them to the Metadata Store from where they can be queried

To try the scan and store features in a supply chain, see [Section 3: Add Testing and Security Scanning to Your Application].

#### Running Public Source Code and Image Scans with Policy Enforcement

Follow the instructions [here](scst-scan/running-scans.md)
to try the following two types of public scans:

1. Source code scan on a public repository
2. Image scan on a image found in a public registry

Both examples include a policy to consider CVEs with Critical severity ratings as violations.


#### Running Private Source Code and Image Scans with Policy Enforcement

Follow the instructions [here](scst-scan/samples/private-source.md) to perform a source code scan against a private registry or
[here](scst-scan/samples/private-image.md)
to do an image scan on a private image.


#### Viewing Vulnerability Reports using Supply Chain Security Tools - Store Capabilities

After completing the scans from the previous step,
query the [Supply Chain Security Tools - Store](scst-store/overview.md) to view your vulnerability results.
The Supply Chain Security Tools - Store is a Tanzu component that stores image, package, and vulnerability metadata about your dependencies.
Use the Supply Chain Security Tools - Store CLI, called `insight`,
to query metadata that have been submitted to the store after the scan step.

For a complete guide on how to query the store,
see [Querying Supply Chain Security Tools - Store](scst-store/querying_the_metadata_store.md).

> **Note**: You must have the Supply Chain Security Tools - Store prerequisites in place to query
the store successfully. For more information, see
[Install Supply Chain Security Tools - Store](install-components.md#install-scst-store).



#### Example Supply Chain including Source and Image Scans

One of the out of the box supply chains we are working on for a future release will include image and source code vulnerability scanning and metadata storage into a preset Tanzu Application Platform supply chain. Until then, you can use this example to see how to try this out:
[Example Supply Chain including Source and Image Scans](scst-scan/choreographer.md).

**Next Steps and Further Information**

* [Configure Code Repositories and Image Artifacts to be Scanned](scst-scan/scan-crs.md)

* [Code and Image Compliance Policy Enforcement Using Open Policy Agent (OPA)](scst-scan/policies.md)

* [How to Create a ScanTemplate](scst-scan/create-scan-template.md)

* [Viewing and Understanding Scan Status Conditions](scst-scan/results.md)

* [Observing and Troubleshooting](scst-scan/observing.md)

## Section 5: Advanced Use Cases - Services Journey

### Overview

Most applications require backing services, such as databases, queues, and caches, to run
successfully.

Tanzu Application Platform makes it easy to discover, curate, consume, and manage such backing
services across single or multi-cluster environments.
This enables developers to spend more time focussing on developing their applications and less
time worrying about the provision, configuration, and operations of the backing services they
depend on.

This experience is made possible in Tanzu Application Platform through the Services Toolkit
component. Services Toolkit comprises the following Kubernetes-native components:

* Service Offering
* Service Resource Claims
* Service API Projection (Beta)
* Service Resource Replication (Beta)

Each component has value on its own, however the most powerful and valuable use cases are unlocked
by combining them.
For detailed information on each of the Services Toolkit components, including the use cases they
unlock as well as API reference guides, see the [Services Toolkit documentation](https://docs.vmware.com/en/Services-Toolkit-for-VMware-Tanzu/0.4/services-toolkit-0-4/GUID-overview.html).

Within the context of Tanzu Application Platform, one of the most important use cases
is binding an Application Workload to a backing service such as a PostgreSQL database or a
RabbitMQ queue.
This use case is made possible by the Service Binding Specification for Kubernetes.
Any service that adheres to the Provisioned Service part of the specification is automatically
compatible with Tanzu Application Platform.

For more information, see the
[Service Binding Specification for Kubernetes](https://github.com/servicebinding/spec) and
[Provisioned Service](https://github.com/servicebinding/spec#provisioned-service) in GitHub.

This leads to a simple, but powerful, first-class user experience for working with backing services
as part of the development life cycle. This is described further in the following use cases.

* [Use Case 1 - **Binding an App Workload to a Service Resource**](#services-journey-use-case-1)
* [Use Case 2 - **Binding an App Workload to a Service Resource across multiple clusters**](#services-journey-use-case-2)
* [Use Case 3 - **Binding an App Workload directly to a Secret (support for external services)**](#services-journey-use-case-3)

### <a id='services-journey-use-case-1'></a> Use Case 1 - **Binding an App Workload to a Service Resource**

This first use case demonstrates the binding of a sample Application Workload to a RabbitMQ Cluster
provided by the RabbitMQ Cluster Operator for Kubernetes. For more information, see the
[RabbitMQ documentation](https://www.rabbitmq.com/kubernetes/operator/operator-overview.html).

The RabbitMQ Cluster Operator is installed and runs on the same Kubernetes cluster
as Tanzu Application Platform. Then you use Services Toolkit to install and run the Operator on
a separate dedicated “Service” cluster, while still allowing service resources to be consumed from
Tanzu Application Platform cluster.

#### Steps

The Service Operator is responsible for installing and managing the RabbitMQ Cluster Operator:

1. Install the RabbitMQ Operator by running:

    ```console
     kapp -y deploy --app rmq-operator --file https://github.com/rabbitmq/cluster-operator/releases/download/v1.9.0/cluster-operator.yml
    ```

2. Create a ClusterRole that grants read permissions to the ResourceClaim controller to the Service resources, in this case RabbitMQ. See the example below.

    ```yaml
    #resource-claims-rmq.yaml
    ---
    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRole
    metadata:
      name: resource-claims-rmq
      labels:
        services.vmware.tanzu.com/aggregate-to-resource-claims: "true"
    rules:
    - apiGroups: ["rabbitmq.com"]
      resources: ["rabbitmqclusters"]
      verbs: ["get", "list", "watch"]
    ```

1. Apply the YAML by running the following command.

    ```console
     kubectl apply -f resource-claims-rmq.yaml
    ```

1. Ensure that the namespace is set up to use installed packages so that Application Workloads can
be created successfully. For more information, see [Set Up Developer Namespaces to Use Installed Packages](install-components.md#setup).

The Application Operator is responsible for provisioning, upgrading, and deleting service
resources:

1.  Create a `RabbitmqCluster` Service Instance that you can use to bind to your Application Workload. See the example below.

    ```yaml
    #rmq-1.yaml
    ---
    apiVersion: rabbitmq.com/v1beta1
    kind: RabbitmqCluster
    metadata:
      name: rmq-1
    ```

1. Apply the YAML by running the following command.

    ```console
     kubectl apply -f rmq-1.yaml
    ```

The Application Developer is responsible for developing applications and creating Application Workloads:

1. For this example you use a sample Spring application that simply sends and receives messages
through RabbitMQ to itself.
Both the Application Workload and RabbitmqCluster service instance must exist in the same namespace.

    >**Note:** This requirement is expected to be removed from an upcoming release.

    ```console
     tanzu apps workload create rmq-sample-app-usecase-1 --git-repo https://github.com/jhvhs/rabbitmq-sample --git-branch v0.1.0 --type web --service-ref "rmq=rabbitmq.com/v1beta1:RabbitmqCluster:rmq-1"
    ```

    The `--service-ref` flag instructs Tanzu Application Platform to bind the Application Workload
    to the service instance.

    >**Note:** Currently users are expected to provide a full object reference to a specific
    >resource, which is `rmq-1` in this case. Improvements to this user experience are planned with
    >anticipated new features for the Service Resource Claims component.

1. Confirm that the Application Workload is built and running by using the following command to get
the Knative web-app URL.

    ```console
     tanzu apps workload get rmq-sample-app-usecase-1
    ```

1. Visit the URL and confirm the app is working by refreshing the page and checking the new message IDs.

### <a id='services-journey-use-case-2'></a> Use Case 2 - **Binding an App Workload to a Service Resource across multiple clusters**

This use case is almost identical to the one mentioned earlier but with one key difference:
now rather than installing and running the RabbitMQ Cluster Kubernetes Operator on the same cluster
as Tanzu Application Platform, you install and run it on an entirely separate dedicated Services
cluster. There are many reasons why you might want to do this:

* Dedicated cluster requirements for Workload or Service clusters. For example, Service clusters
might need access to powerful SSDs.
* Different cluster life cycle management. Upgrades to Service clusters can occur more cautiously.
* Unique compliance requirements. Because data is stored on a Service cluster it might have
different compliance needs.
* Separation of permissions and access. Application teams can only access the clusters where their
applications are running.

The experience of an application developer working on their Tanzu Application Platform cluster is  
unaltered. All complexity in the setup and management of backing infrastructure is abstracted away
from application developers, which gives them more time to focus on developing their apps.

The components of Services Toolkit that drive this experience are Service API Projection and
Service Resource Replication. Both are currently beta software.

For more information about network requirements and recommended topologies, see the
[Topology section](https://docs.vmware.com/en/Services-Toolkit-for-VMware-Tanzu/0.4/services-toolkit-0-4/GUID-reference-topologies.html) of the Services Toolkit documentation.

#### Prerequisites

1. If you followed previous instructions for [Services Journey - Use Case 1](#services-journey-use-case-1), uninstall the cluster Operator from that cluster.

1. Follow the documentation to install Tanzu Application Platform on to a second separate Kubernetes
cluster.

    * This cluster must be able to create LoadBalanced services.

    * This time after you have added the Tanzu Application Platform package repository, instead of
    installing a profile, you only need to install the Services Toolkit package.
    For installation information, see
    [Add the Tanzu Application Platform Package Repository](install.md#add-package-repositories)
    and [Install Services Toolkit](install-components.md#install-services-toolkit).
    You can skip all other packages.

    * From now on this cluster is called the Service Cluster.

1. Download and install the `kubectl-scp` plug-in from [Tanzu Application Platform Tanzu Network](https://network.tanzu.vmware.com/products/tanzu-application-platform).
This plug-in is for demonstration and experimentation purposes only. `tanzu` CLI UX might
replace it in the future.
To install the plug-in you must place it in your `PATH-TO-KUBECTL-SCP` and ensure it is executable. For example:

    ```console
    sudo cp PATH-TO-KUBECTL-SCP /usr/local/bin/kubectl-scp
    sudo chmod +x /usr/local/bin/kubectl-scp
    ```

    You are left with two Kubernetes clusters:

    - Workload Cluster, which is where Tanzu Application Platform, including Services toolkit, is installed.
    The cluster Operator is not installed on this cluster.
    - Services Cluster, which is where only Services toolkit is installed. Nothing else is installed here.

#### Steps

>**Important:** The following steps have placeholder values `WORKLOAD-CONTEXT` and `SERVICE-CONTEXT` that you need to change accordingly.

1. As the Service operator, you enable API Projection and Resource Replication between the Workload
Cluster and Service Cluster by linking the two clusters together using the `kubectl scp` plug-in.

    ```console
    kubectl scp link --workload-kubeconfig-context=WORKLOAD-CONTEXT --service-kubeconfig-context=SERVICE-CONTEXT
    ```

1. Install the RabbitMQ Kubernetes Operator in the Services Cluster using kapp.
This Operator is installed in the Workload Cluster, but developers can still create
RabbitmqCluster service instances from the Workload Cluster.

    >**Note:** This RabbitMQ Operator deployment has specific changes in it to enable cross-cluster
    Service Binding. Use the exact `deploy.yml` specified here.

    ```console
     kapp -y deploy --app rmq-operator \
        --file https://raw.githubusercontent.com/rabbitmq/cluster-operator/lb-binding/hack/deploy.yml  \
        --kubeconfig-context SERVICE-CONTEXT
    ```

1. Verify that the Operator installed by running the following command.

    ```console
      kubectl --context SERVICE-CONTEXT get crds rabbitmqclusters.rabbitmq.com
    ```

1. In the Workload Cluster, create a ClusterRole that grants read permissions to the ResourceClaim
controller to the Service resources, in this case RabbitMQ.

    ```yaml
    #resource-claims-rmq.yaml
    ---
    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRole
    metadata:
      name: resource-claims-rmq
      labels:
        services.vmware.tanzu.com/aggregate-to-resource-claims: "true"
    rules:
    - apiGroups: ["rabbitmq.com"]
      resources: ["rabbitmqclusters"]
      verbs: ["get", "list", "watch"]
    ```

1. Apply the YAML file by running the following command.

    ```console
     kubectl apply -f resource-claims-rmq.yaml
    ```

The following steps federate the `rabbitmq.com/v1beta1` API group, which is available in the
Service Cluster, into the Workload Cluster.
This occurs in two parts: projection and replication.
Projection applies to custom API groups. Replication applies to core Kubernetes resources, such as
Secrets.

1. Create a pair of target namespaces in which you create `RabbitmqCluster` Service instances.
The namespace name must be identical in the Application Workload and Service Cluster.
See the example below.

    ```console
    kubectl --context WORKLOAD-CONTEXT create namespace my-project-1
    kubectl --context SERVICE-CONTEXT create namespace my-project-1
    ```

1. Ensure that the namespace is set up to use installed packages so that Application Workloads can
be created successfully.
For more information, see [Set Up Developer Namespaces to Use Installed Packages](install-components.md#setup).

1. Federate using the `kubectl-scp` plug-in by running:

    ```console
     kubectl scp federate \
      --workload-kubeconfig-context=WORKLOAD-CONTEXT \
      --service-kubeconfig-context=SERVICE-CONTEXT \
      --namespace=my-project-1 \
      --api-group=rabbitmq.com \
      --api-version=v1beta1 \
      --api-resource=rabbitmqclusters
    ```

1. After federation, the `rabbitmq.com/v1beta1` API is also available in the Workload cluster.
Verify this by running the following command.

    ```console
    kubectl --context WORKLOAD-CONTEXT api-resources
    ```

1. Make this service discoverable as a service offering by running the following command.

    ```console
     kubectl scp make-discoverable \
      --workload-kubeconfig-context=WORKLOAD-CONTEXT \
      --api-group=rabbitmq.com \
      --api-resource-kind=RabbitmqCluster
    ```

    The Service Offering component makes application operators and developers aware that the new
    API is available and that they can create service instances using it.

The application operator takes over from here:

1. Discover this new service and provision an instance by running the following command.

    ```console
    kubectl --context=WORKLOAD-CONTEXT get clusterresources.services.apps.tanzu.vmware.com

    NAME                           API KIND          API GROUP      DESCRIPTION
    rabbitmq.com-rabbitmqcluster   RabbitmqCluster   rabbitmq.com
    ```

    >**Note:** This step currently requires the use of kubectl, but the `tanzu` CLI UX is intended
    to replace it in the future.

1. As done previously, provision a service instance on the Tanzu Application Platform cluster.
See the example below.

    ```yaml
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

1. Apply the YAML file by running the following command.

    ```console
    kubectl --context WORKLOAD-CONTEXT -n my-project-1 apply -f rabbitmq-cluster.yaml
    ```

1. Confirm that the RabbitmqCluster resource reconciles successfully from the Workload Cluster by
running the following command.

    ```console
     kubectl --context WORKLOAD-CONTEXT -n my-project-1 get -f rabbitmq-cluster.yaml
    ```

1. Confirm that RabbitMQ Pods are running in the Service Cluster, but not in the Workload Cluster
by running the following command:

    ```console
    kubectl --context WORKLOAD-CONTEXT -n my-project-1 get pods
    kubectl --context SERVICE-CONTEXT -n my-project-1 get pods
    ```

Finally, the application developer takes over:

1. Create the Application Workload. See the example command below.

    ```console
     tanzu apps workload create -n my-project-1 rmq-sample-app-usecase-2 --git-repo https://github.com/jhvhs/rabbitmq-sample --git-branch v0.1.0 --type web --service-ref "rmq=rabbitmq.com/v1beta1:RabbitmqCluster:projected-rmq"
    ```

1. Confirm that the workload is running by using the following command to get the web-app URL.

    ```console
     tanzu apps workload get -n my-project-1 rmq-sample-app-usecase-2
    ```

1. Visit the URL and refresh the page to confirm the app is running by checking the new message IDs.

### <a id='services-journey-use-case-3'></a> Use Case 3 - **Binding an App Workload directly to a Secret (support for external services)**

This use case enables developers to connect their Application Workloads to almost any backing
service, including those that are running external to the platform, as well as those that do not
adhere to the Provisioned Service part of the binding specifications.
This is made possible through direct references to Kubernetes Secret objects.

For more information, see the
[Provisioned Service specifications](https://github.com/servicebinding/spec#provisioned-service) in GitHub.

In the previous two use cases you saw the use of the `--service-ref` flag on the
`tanzu apps workload create` command, and you used it to provide a reference to a Provisioned Service service instance, which is a RabbitmqCluster resource.

You can also provide a reference directly to a Kubernetes Secret resource that, itself, abides by
the Well-known Secret Entries part of the binding specifications.

For more information, see the
[Well-known Secret Entries specifications](https://github.com/servicebinding/spec#well-known-secret-entries) in GitHub.

In this example, bind a new application on Tanzu Application Platform to an existing PostgreSQL
database that exists in Azure:

1. Create a Kubernetes Secret resource similar to the following example:

    ```yaml
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
      username: "user@example"
      password: "PASSWORD"
    ```

1. Apply the YAML file by running the following command.

    ```console
    kubectl apply -f external-azure-db-binding-compatible.yaml
    ```

1. Provide a reference to the Secret when creating your Application Workload. For example:

    ```console
    tanzu apps workload create pet-clinic --git-repo https://github.com/spring-projects/spring-petclinic --git-branch main --type web --service-ref db=v1:Secret:external-azure-db-binding-compatible
    ```

## Appendix


### Exploring more Tanzu apps CLI commands

Here are some additional CLI commands to explore using the same app that you deployed and debugged
earlier in this guide.

Add some envars by running:

```console
tanzu apps workload update tanzu-java-web-app --env foo=bar
```

Export the current running workload definition, to check into git, or promote to another environment, by running:

```console
tanzu apps workload get tanzu-java-web-app --export \
 \
```

Explore the flags available for the workload commands by running:

```console
tanzu apps workload -h
tanzu apps workload get -h
tanzu apps workload create -h
```

Create a simple java app from source code on your local file system by running:

```console
git clone git@github.com:spring-projects/spring-petclinic.git
tanzu apps workload create pet-clinic --source-image <YOUR-REGISTRY.COM>/pet-clinic --local-path ./spring-petclinic
```
