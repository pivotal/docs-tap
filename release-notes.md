# Release notes

This topic contains release notes for Tanzu Application Platform v1.0.

## <a id='1-0'></a> v1.0

**Release Date**: MMMM DD, 2022

### Features

This release has the following new features:
- Supply Chain Security Tools – Scan
  - Enhanced scanning coverage is available for Node.js apps
  - CA certificates are automatically imported from the Metadata Store namespace

### Known issues

This release has the following issues:

- **Component: Convention Service** Convention Service does not currently support self-signed certificates for integrating with a private registry. Support for self-signed certificates is planned for an upcoming release.
- **Application Accelerator:** Build scripts provided as part of an accelerator do not have the execute bit set when a new project is generated from the accelerator. To resolve this issue, explicitly set the execute bit by using the "chmod" command: `chmod +x <build-script>`. For example, for a project generated from the "Spring PetClinic" accelerator, run: `chmod +x ./mvnw`.

- **Convention Service:** Convention Service does not currently support self-signed certificates for integrating with a private registry. Support for self-signed certificates is planned for an upcoming release.

- **Installing Tanzu Application Platform on Google Kubernetes Engine (GKE):** When installing Tanzu Application Platform on GKE, Kubernetes control plane can be unavailable for several minutes during the installation. Package installs can enter the `ReconcileFailed` state. When API server becomes available, packages try to reconcile to completion. This can happen on newly provisioned clusters which have not finished GKE API server autoscaling. When GKE scales up an API server, the current Tanzu Application install continues, and any subsequent installs succeed without interruption.

- **Component: Supply Chain Choreographer** Deployment from a public Git repository might require a Git SSH secret. Workaround is to configure SSH access for the public Git repository.

- **Component: Supply Chain Security Tools - Sign** If all webhook nodes or Pods are evicted by the cluster or scaled down, the admission policy blocks any Pods from being created in the cluster. To resolve the issue, delete the MutatingWebhookConfiguration and reapply it when the cluster is stable. For more information, see [Supply Chain Security Tools - Sign known issues](scst-sign/known_issues.md).

- **Component: Tanzu CLI**
  - **`tanzu apps workload get`:** Passing in `--output json` along with and the `--export` flag returns yaml rather than json. Support for honoring the `--output json` with `--export` will be added in the next release.
  - **`tanzu apps workload create/update/apply`:** `--image` is not supported by the default supply chain in Tanzu Application Platform Beta 3 release. `--wait` functions as expected when a workload is created for the first time but may return prematurely on subsequent updates when passed with `workload update/apply` for existing workloads. When the `--wait` flag is included and you decline the "Do you want to create this workload?" prompt, the command continues to wait and must be cancelled manually.
  
- **Component: Supply Chain Security Tools – Scan**
  - **Failing Blob source scans:** Blob Source Scans have an edge case where, when a compressed file without a `.git` directory is provided, sending results to the Supply Chain Security Tools - Store fails and the scanned revision value is not set. The current workaround is to add the `.git` directory to the compressed file.
  - **Events show `SaveScanResultsSuccess` incorrectly:** `SaveScanResultsSuccess` appears in the events when the Supply Chain Security Tools - Store is not configured. The `.status.conditions` output, however, correctly reflects `SendingResults=False`.
  - **Scan Phase indicates `Scanning` incorrectly:** Scans have an edge case where, when an error has occurred during scanning, the Scan Phase field does not get updated to `Error` and instead remains in the `Scanning` phase. Read the scan Pod logs to verify there was an error.
  - **CVE print columns are not getting populated:** After running a scan and using `kubectl get` on the scan, the CVE print columns (CRITICAL, HIGH, MEDIUM, LOW, UNKNOWN, CVETOTAL) are not getting populated.

- **Grype scanner:**
  - **Scanning Java source code may not reveal vulnerabilities:** Source Code Scanning only scans files present in the source code repository. 
    No network calls are made to fetch dependencies.

    For languages that make use of dependency lock files, such as Golang and Node.js, Grype uses the lock
    files to check the dependencies for vulnerabilities.
    In the case of Java, dependency lock files are not guaranteed, so Grype instead uses the dependencies
    present in the built binaries (`.jar` or `.war` files).

    Because best practices do not include committing binaries to source code repositories, Grype fails to
    find vulnerabilities during a Source Scan. The vulnerabilities are still found during the Image Scan,
    after the binaries are built and packaged as images.
  
- **Component: Supply Chain Security Tools - Sign**
  - **MutatingWebhookConfiguration prevents pods from being admitted:** Under certain circumstances, if the `image-policy-controller-manager` deployment
  pods do not start up before the `MutatingWebhookConfiguration` is applied to the
  cluster, it can prevent the admission of all pods. 
  - For example, pods can be prevented from starting if nodes in a cluster are
  scaled to zero and the webhook is forced to restart at the same time as
  other system components. A deadlock can occur when some components expect the
  webhook to verify their image signatures and the webhook is not running yet.
  - **Symptoms:**
    You will see a message similar to the following in your `ReplicaSet` statuses:

    ```
    Events:
      Type     Reason            Age                   From                   Message
      ----     ------            ----                  ----                   -------
      Warning  FailedCreate      4m28s (x18 over 14m)  replicaset-controller  Error creating: Internal error occurred: failed calling webhook "image-policy-webhook.signing.apps.tanzu.vmware.com": Post "https://image-policy-webhook-service.image-policy-system.svc:443/signing-policy-check?timeout=10s": no endpoints available for service "image-policy-webhook-service"
    ```
  - **Solution:**
    By deleting the `MutatingWebhookConfiguration` resource, you can resolve the
    deadlock and enable the system to start up again. Once the system is stable,
    you can restore the `MutatingWebhookConfiguration` resource to re-enable image
    signing enforcement.

    > **Important**: the steps below will temporarily disable signature verification
    > in your cluster.

    To do so:

    1. Backup the `MutatingWebhookConfiguration` to a file by running the following
    command:
        ```
        kubectl get MutatingWebhookConfiguration image-policy-mutating-webhook-configuration -o yaml > image-policy-mutating-webhook-configuration.yaml
        ```

    1. Delete the `MutatingWebhookConfiguration`:
        ```
        kubectl delete MutatingWebhookConfiguration image-policy-mutating-webhook-configuration
        ```

    1. Wait until all components are up and running in your cluster, including the
    `image-policy-controller-manager` pods (namespace `image-policy-system`).

    1. Re-apply the `MutatingWebhookConfiguration`:
        ```
        kubectl apply -f image-policy-mutating-webhook-configuration.yaml
        ```
        
- **Priority class of webhook's pods may preempt less privileged pods:**
  This component uses a privileged `PriorityClass` to start up its pods in order
  to prevent node pressure from preempting its pods. However, this can cause other
  less privileged components to have their pods preempted or evicted instead.
  - **Symptoms:**
    You will see events similar to this in the output of `kubectl get events`:

    ```
    $ kubectl get events
    LAST SEEN   TYPE      REASON             OBJECT               MESSAGE
    28s         Normal    Preempted          pod/testpod          Preempted by image-policy-system/image-policy-controller-manager-59dc669d99-frwcp on node test-node
    ```
  - **Solution:** 
    - **Reduce the amount of pods deployed by the Sign component:**

      In case your deployment of the Sign component is running more pods than
      necessary, you may scale the deployment down. To do so:

      1. Create a values file called `scst-sign-values.yaml` with the following
      contents:
          ```
          ---
          replicas: N
          ```
          where N should be the smallest amount of pods you can have for your current
          cluster configuration.

      1. Apply your new configuration by running:
          ```
          tanzu package installed update image-policy-webhook \
            --package-name image-policy-webhook.signing.apps.tanzu.vmware.com \
            --version 1.0.0-beta.3 \
            --namespace tap-install \
            --values-file scst-sign-values.yaml
          ```

      1. It may take a few minutes until your configuration takes effect in the cluster.

    - **Increase your cluster's resources:**
      - Node pressure may be caused by not enough nodes or not enough resources on nodes
      for deploying the workloads you have. In this case, follow your cloud provider
      instructions on how to scale out or scale up your cluster.
  
- **Application Live View:**
  The Live View section in Tanzu Application Platform GUI might show "No live information for pod with ID" after deploying Tanzu Application Platform workloads. Resolve this issue by recreating the Application Live View Connector pod. This allows the connector to discover the application instances and render the details in Tanzu Application Platform GUI. For example:

  ```
  kubectl -n app-live-view delete pods -l=name=application-live-view-connector
  ```

### Security issues

This release has the following security issues:

* The installation specifies that the installer's Tanzu Network credentials be exported to all namespaces. Customers can optionally choose to mitigate this concern using one of the following methods:
  *  Create a Tanzu Network account with their own credentials and use this for the installation exclusively.
  *  Using [Carvel tool's imgpkg](https://carvel.dev/imgpkg/) customers can create a dedicated OCI registry on their own infrastructure that can comply with any required security policies that may exist.
* Security issue 2

### Breaking changes

This release has the following breaking changes:

- **Supply Chain Security Tools - Store:** Changed package name to `metadata-store.apps.tanzu.vmware.com`.

### Component release notes

The following components have separate release notes.

| Component                                | Release notes                                                |
| ---------------------------------------- | ------------------------------------------------------------ |
| Application Accelerator for VMware Tanzu | [Release notes](https://docs.vmware.com/en/Application-Accelerator-for-VMware-Tanzu/0.5/acc-docs/GUID-release-notes.html) |
| Application Live View for VMware Tanzu   | [Release notes](https://docs.vmware.com/en/Application-Live-View-for-VMware-Tanzu/1.0/docs/GUID-release-notes.html) |
| Cloud Native Runtimes for VMware Tanzu   | [Release notes](https://docs.vmware.com/en/Cloud-Native-Runtimes-for-VMware-Tanzu/1.0/tanzu-cloud-native-runtimes-1-0/GUID-release-notes.html) |
| Supply Chain Security Tools - Scan   | [Release notes](scst-scan/release-notes.md)                  |
| Supply Chain Security Tools - Sign       | [Release notes](scst-sign/release-notes.md)                  |
| Supply Chain Security Tools - Store      | [Release notes](scst-store/release_notes.md)                 |
| VMware Tanzu Build Service               | [Release notes](https://docs.vmware.com/en/Tanzu-Build-Service/1.3/vmware-tanzu-build-service-v13/GUID-release-notes.html) |
| VMware Tanzu Developer Tools for Visual Studio Code | [Release notes](vscode-extension/release-notes.md) |

### Bug fixes 

This release has the following bug fixes:

- **Tanzu Dev Tools for VSCode:**
  - Fixed issue where the Tanzu Dev Tools extension could not support projects with multi-document YAML files
  - Modified debug to remove any leftover port-forwards from past runs
- **Supply Chain Security Tools - Store:**  
  - Upgrade golang version from `1.17.1` to `1.17.5`

## <a id='0-4-0'></a> v0.4.0 beta release

**Release Date**: December 13, 2021

### Features

New features and changes in this release:

**Component: Supply Chain Security Tools – Scan**
  - Enhanced scanning coverage is available for Node.js apps
  - CA certificates are automatically imported from the Metadata Store namespace

**Installation Profiles**

The Full profile now includes Supply Chain Security Tools - Store.

The Dev profile now includes:

- Application Accelerator
- Out of the Box Supply Chain - Testing

The Dev profile no longer includes Image Policy Webhook.

**Updated Components**

The following components have been updated in Tanzu Application Platform v0.4.0:

- Supply Chain Security Tools
    - [Scan v1.0.0](scst-scan/overview.md)
    - [Sign v1.0.0-beta.2](scst-sign/overview.md)
- [Tanzu Application Platform GUI v1.0.0-rc.72](tap-gui/about.md)

**Renamed Components**

Workload Visibility Plugin is renamed Runtime Visibility Plugin.


### Known issues

This release has the following issues:

- **Convention Service:** Convention Service does not currently support self-signed certificates for integrating with a private registry. Support for self-signed certificates is planned for an upcoming release.
- **Installing Tanzu Application Platform on Google Kubernetes Engine (GKE):** When installing Tanzu Application Platform on GKE, Kubernetes control plane may be unavailable for several minutes during the install. Package installs can enter the ReconcileFailed state. When API server becomes available, packages try to reconcile to completion.
  - This can happen on newly provisioned clusters which have not gone through GKE API server autoscaling. When GKE scales up an API server, the current Tanzu Application install continues, and any subsequent installs succeed without interruption.
- **Supply Chain Security Tools - Sign:** If all webhook nodes or Pods are evicted by the cluster or scaled down,
the admission policy blocks any Pods from being created in the cluster.
To resolve the issue, delete the `MutatingWebhookConfiguration` and reapply it when the cluster is stable.
For more information, see [Supply Chain Security Tools - Sign known issues](scst-sign/known_issues.md).
- **Component: Supply Chain Security Tools - Sign**
  - **MutatingWebhookConfiguration prevents pods from being admitted**
    - Under certain circumstances, if the `image-policy-controller-manager` deployment
    pods do not start up before the `MutatingWebhookConfiguration` is applied to the
    cluster, it can prevent the admission of all pods.
    - For example, pods can be prevented from starting if nodes in a cluster are
    scaled to zero and the webhook is forced to restart at the same time as
    other system components. A deadlock can occur when some components expect the
    webhook to verify their image signatures and the webhook is not running yet.
    - Symptoms
      - You will see a message similar to the following in your `ReplicaSet` statuses:

      ```
      Events:
        Type     Reason            Age                   From                   Message
        ----     ------            ----                  ----                   -------
        Warning  FailedCreate      4m28s (x18 over 14m)  replicaset-controller  Error creating: Internal error occurred: failed calling webhook "image-policy-webhook.signing.run.tanzu.vmware.com": Post "https://image-policy-webhook-service.image-policy-system.svc:443/signing-policy-check?timeout=10s": no endpoints available for service "image-policy-webhook-service"
      ```

      - Solution
        - By deleting the `MutatingWebhookConfiguration` resource, you can resolve the
        deadlock and enable the system to start up again. Once the system is stable,
        you can restore the `MutatingWebhookConfiguration` resource to re-enable image
        signing enforcement.

        > **Important**: the steps below will temporarily disable signature verification
        > in your cluster.
        To do so:

        1. Backup the `MutatingWebhookConfiguration` to a file by running the following
        command:
            ```
            kubectl get MutatingWebhookConfiguration image-policy-mutating-webhook-configuration -o yaml > image-policy-mutating-webhook-configuration.yaml
            ```

        1. Delete the `MutatingWebhookConfiguration`:
            ```
            kubectl delete MutatingWebhookConfiguration image-policy-mutating-webhook-configuration
            ```

        1. Wait until all components are up and running in your cluster, including the
        `image-policy-controller-manager` pods (namespace `image-policy-system`).

        1. Re-apply the `MutatingWebhookConfiguration`:
            ```
            kubectl apply -f image-policy-mutating-webhook-configuration.yaml
            ```
  - **Priority class of webhook's pods may preempt less privileged pods**
    - This component uses a privileged `PriorityClass` to start up its pods in order
    to prevent node pressure from preempting its pods. However, this can cause other
    less privileged components to have their pods preempted or evicted instead.
    - Symptoms
      - You will see events similar to this in the output of `kubectl get events`:

        ```
        $ kubectl get events
        LAST SEEN   TYPE      REASON             OBJECT               MESSAGE
        28s         Normal    Preempted          pod/testpod          Preempted by image-policy-system/image-policy-controller-manager-59dc669d99-frwcp on node test-node
        ```

    - Solution
      - Reduce the amount of pods deployed by the Sign component
      - In case your deployment of the Sign component is running more pods than
      necessary, you may scale the deployment down. To do so:
      
        1. Create a values file called `scst-sign-values.yaml` with the following
        contents:
        ```
        ---
        replicas: N
        ```
        where N should be the smallest amount of pods you can have for your current
        cluster configuration

        1. Apply your new configuration by running:
        ```
        tanzu package installed update image-policy-webhook \
          --package-name image-policy-webhook.signing.run.tanzu.vmware.com \
          --version 1.0.0-beta.2 \
          --namespace tap-install \
          --values-file scst-sign-values.yaml
        ```

        1. It may take a few minutes until your configuration takes effect in the cluster.

      - Increase your cluster's resources
        - Node pressure may be caused by not enough nodes or not enough resources on nodes
        for deploying the workloads you have. In this case, follow your cloud provider
        instructions on how to scale out or scale up your cluster.
- **Component: Tanzu CLI apps plugin**        
  - **`tanzu apps workload get`**
    - Passing in `--output json` along with and the `--export` flag returns yaml rather than json. Support for honoring the `--output json` with `--export` will be added in the next release.
  - **`tanzu apps workload create/update/apply`**
    - `--image` is not supported by the default supply chain in Tanzu Application Platform Beta 3 release.
    - `--wait` functions as expected when a workload is created for the first time but may return prematurely on subsequent updates when passed with `workload update/apply` for existing workloads. 
      - When the `--wait` flag is included and you decline the "Do you want to create this workload?" prompt, the command continues to wait and must be cancelled manually.
- **Component: Supply Chain Security Tools – Scan**  
  - **Failing Blob source scans:** Blob Source Scans have an edge case where, when a compressed file without a `.git` directory is
  provided, sending results to the Supply Chain Security Tools - Store fails and the scanned revision
  value is not set. The current workaround is to add the `.git` directory to the compressed file.
  - **Events show `SaveScanResultsSuccess` incorrectly:** `SaveScanResultsSuccess` appears in the events when the Supply Chain Security Tools - Store is not
  configured. The `.status.conditions` output, however, correctly reflects `SendingResults=False`.
  - **Scan Phase indicates `Scanning` incorrectly:** Scans have an edge case where, when an error has occurred during scanning, the Scan Phase field does
  not get updated to `Error` and instead remains in the `Scanning` phase.
  Read the scan Pod logs to verify that there was an error.
  
  
### Known limitations with Grype scanner
- **Component: Supply Chain Security Tools – Scan** 
  - Scanning Java source code may not reveal vulnerabilities:
    - Source Code Scanning only scans files present in the source code repository. No network calls are made to fetch dependencies.
    - For languages that make use of dependency lock files, such as Golang and Node.js, Grype uses the lock
    files to check the dependencies for vulnerabilities.
    In the case of Java, dependency lock files are not guaranteed, so Grype instead uses the dependencies
    present in the built binaries (`.jar` or `.war` files).
    - Because best practices do not include committing binaries to source code repositories, Grype fails to
    find vulnerabilities during a Source Scan. The vulnerabilities are still found during the Image Scan,
    after the binaries are built and packaged as images.  
              
## <a id='0-3-0'></a> v0.3.0 beta release

**Release Date**: November 8, 2021

### Features

New features and changes in this release:

**Installation Profiles**

You can now install Tanzu Application Platform through profiles.
The Full profile installs all of the component packages.
The Dev profile installs the packages that a developer needs.

For more information, see [Installation Profiles and Profiles in Tanzu Application Platform v0.3](overview.md#profiles-and-packages) and
[About Tanzu Application Platform Package Profiles](install.md#about-package-profiles).

**New Components**

The following components are new in Tanzu Application Platform v0.3.0:

Tanzu Packages:

- Supply Chain Choreographer for VMware Tanzu:
  - Out of the Box Supply Chain Basic v0.3.0
  - Out of the Box Supply Chain with Testing v0.3.0
  - Out of the Box Supply Chain with Testing and Scanning v0.3.0
  - Out of the Box Templates v0.3.0
- Tanzu Application Platform GUI v0.3.0
  - Workload Visibility Plugin v1.0.0
  - Application Live View Plugin v0.3.0
- Convention Service for VMware Tanzu
  - Spring Boot Convention v0.1.2
- Tanzu Learning Center

**Updated Components**

The following components have been updated in Tanzu Application Platform v0.3.0:

- [Supply Chain Choreographer for VMware Tanzu](scc/about.md)
  - Cartographer v0.0.7
- Supply Chain Security Tools for VMware Tanzu
  - [Scan v1.0.0-beta.2](scst-scan/overview.md)
  - Image Policy Webhook v1.0.0-beta.1
  - [Store v1.0.0-beta.1](scst-store/overview.md)
- Services Toolkit v0.4.0
- [Convention Service for VMware Tanzu](convention-service/about.md)
  - [Developer Conventions](developer-conventions/about.md) v0.3.0
- [Cloud Native Runtimes v1.0.3](https://docs.vmware.com/en/Cloud-Native-Runtimes-for-VMware-Tanzu/1.0/tanzu-cloud-native-runtimes-1-0/GUID-cnr-overview.html)
- [Application Accelerator for VMware Tanzu v0.4.0](https://docs.vmware.com/en/Application-Accelerator-for-VMware-Tanzu/0.4/acc-docs/GUID-index.html)
- [Application Live View for VMware Tanzu v0.3.0](https://docs.vmware.com/en/Application-Live-View-for-VMware-Tanzu/0.3/docs/GUID-index.html)
- [Tanzu Developer Tools for Visual Studio Code v0.3.0](https://docs-staging.vmware.com/en/VMware-Tanzu-Application-Platform/0.3/tap-0-3/GUID-vscode-extension-about.html)


### Known issues

This release has the following issues:

- **Image Policy Webhook:** If all webhook nodes or Pods are evicted by the cluster or scaled down, the admission policy blocks any Pods from being created in the cluster. To resolve the issue, the administrator needs to kubectl delete the Image Policy Webhook and reapply it once the cluster is stable.
- When you use the `Tanzu Developer Tools for VSCode` extension, delete the workload before performing any of the following actions. This will avoid workload update errors.
    - Switching between the `Live Update` & `Debug` capabilities
    - Disabling `Live Update` & re-starting `Live Update`

    You can do so by performing the following steps:
    1. Click the `Terminal` menu and select the `Run Task` option
    2. Type `tanzuWorkload delete` in the command palette that appears and hit enter
    3. View the Terminal tab to confirm that the Workload has been deleted

- Tanzu App CLI Plugin:
  - *`tanzu apps workload get`*: passing in `--output json` along with and the `--export` flag will return YAML rather than JSON (support for honoring the `--output json` in conjunction with `--export` will be added in the next release).
  - *`tanzu apps workload create/update/apply`*: when the `--wait` flag has been included and the "Do you want to create this workload?" prompt is declined, the command continues to wait rather exit
- **Component: Tanzu CLI apps plugin**
  - **`tanzu apps workload get`**
    - Passing in `--output json` along with and the `--export` flag returns yaml rather than json. Support for honoring the `--output json` with `--export` will be added in the next release.
  - **`tanzu apps workload create/update/apply`**
    - `--image` is not supported by the default supply chain in Tanzu Application Platform Beta 3 release.
    - `--wait` functions as expected when a workload is created for the first time but may return prematurely on subsequent updates when passed with `workload update/apply` for existing workloads. 
      - When the `--wait` flag is included and you decline the "Do you want to create this workload?" prompt, the command continues to wait and must be cancelled manually.

### Security issues

This release has the following security issue:

**In Learning Center, exported registry credentials are visible across namespaces:**
Because SecretExport CR allows you to export registry credentials to other namespaces, they are
visible to users of those namespaces.
VMware recommends that the registry credentials you export give read-only access to the registry and
have minimal scope within the registry.

## <a id='0-2-0'></a> v0.2.0 beta release

**Release Date**: October 07, 2021

### New features

This release has the following new features:
- **Component: Supply Chain Security Tools - Store**
  - Add logs to Images, Vulnerabilities, Sources, and Package endpoints
  - Supporting AWS RDS
  - Add default read-only clusterrole
  - Manually update go dependencies
  - Export CA Cert to a specified namespace. By default, the CA Cert will be exported to the default namespace `scan-link-system`
  - `db_password` is generated with secretgen when not provided by user
  - Support cyclonedx 1.3
- **Component: Tanzu Packages**
  - Supply Chain Choreographer for VMware Tanzu
    - Cartographer v0.0.6
    - Default Supply Chain v0.2.0
    - Default Supply Chain with Testing v0.2.0
  - Supply Chain Security Tools for VMware Tanzu
    - Scan v1.0.0-beta
    - Image Policy Webhook v1.0.0-beta.0
    - Store v1.0.0-beta.0
  - Convention Service for VMware Tanzu
    - Conventions Controller v0.4.2
    - Image Source Controller v0.1.2
    - Developer Conventions v0.2.0
  - API Portal for VMware Tanzu v1.0.2
  - Service Control Plane Toolkit v0.3.0
  - Service Bindings for Kubernetes v0.5.0
  - Tanzu Developer Tools for Visual Studio Code v0.2.0
- **Component: Tanzu CLI Plugins**
  - Tanzu Accelerator CLI Plugin v0.3.0
  - Tanzu App CLI Plugin v0.2.0
  - Tanzu ImagePullSecret CLI Plugin v0.5.0
  - Tanzu Package CLI Plugin v0.5.0
- **Component: Supply Chain Security Tools - Sign**
  - Added configuration for ResourceQuotas. See `quota.pod_number`
  - Number of replicas can be configured via `replicas` value

The following components have been updated in Tanzu Application Platform v0.2.0

- [VMware Tanzu Build Service v1.3](https://docs.vmware.com/en/Tanzu-Build-Service/1.3/vmware-tanzu-build-service-v13/GUID-index.html)
- [Cloud Native Runtimes v1.0.2](https://docs.vmware.com/en/Cloud-Native-Runtimes-for-VMware-Tanzu/1.0/tanzu-cloud-native-runtimes-1-0/GUID-cnr-overview.html)
- [Application Accelerator for VMware Tanzu v0.3.0](https://docs.vmware.com/en/Application-Accelerator-for-VMware-Tanzu/index.html)
- [Application Live View for VMware Tanzu v0.2.0](https://docs.vmware.com/en/Application-Live-View-for-VMware-Tanzu/0.2/docs/GUID-index.html)

### Known issues

This release has the following issues:

- If your install workflow involves [Carvel imgpkg](https://github.com/vmware-tanzu/carvel-imgpkg), use version.
  v0.19.0 or later to avoid auth errors.
- If package installation fails, use `tanzu package installed update` with the `--install` flag to continue installation.
- When you use the `Tanzu Developer Tools for VSCode` extension,
  delete the workload before performing any of the following actions. This will avoid workload update errors.
    - Switching between the `Live Update` & `Debug` capabilities
    - Disabling `Live Update` & re-starting `Live Update`
    You can do so by performing the following steps:
    1. Click the `Terminal` menu and select the `Run Task` option
    2. Type `tanzuWorkload delete` in the command palette that appears and hit enter
    3. View the Terminal tab to confirm that the Workload has been deleted
- **Component: Supply Chain Security Tools - Sign**
  - A grype scan has reported the following false positives:
    - CVE-2015-5237 - This is a CVE on the C implementation of Protocol Buffers. We use the Golang version.
    - CVE-2017-7297 - This is a CVE on Rancher Server which is not a dependency we include.
- **Component: Tanzu CLI apps plugin** 
  - `--image`:
    - This flag isn't supported by the supply chain in Tanzu Application Platform Beta 2 release.
  - `tanzu apps workload get`:
    - passing in `--output json` along with and the `--export` flag will return yaml rather than json (support for honoring the `--output json` in conjunction with `--export` will be added in the next release).
  - `tanzu apps workload create/update/apply`:
     - `--wait` functions as expected when a workload is created for the first time but may return prematurely on subsequent updates (when passed in with `workload update/apply` for existing workloads). 
     - when the `--wait` flag has been included and the "Do you want to create this workload?" prompt is declined, the command continues to wait rather exit.
       
### Breaking Changes

- **Component: Supply Chain Security Tools - Store**
  - (possibly breaking) `storageClassName` and `databaseRequestStorage` fields have been changed to `storage_class_name` and `database_request_storage` respectively. This change was made to keep the format of all available fields consistent with other available fields.
  - (possibly breaking) Change output for unhappy paths to be more consistent. Empty results due to sources not existing when searching by package or source information now returns an empty array with a 200 response. Previously it would give an error JSON with a 404.

### Bug Fixes

- **Component: Supply Chain Security Tools - Store**
  - Change DB and app service type
  - Containers no longer need root user to run

### Limitations

- **Component: Supply Chain Security Tools - Store**
  - Air gapped environments are not supported
  
## <a id='0-1-0'></a> v0.1.0 beta release

**Release Date**: September 1, 2021

### Software component versions

- PostgresSQL 13.4

### New features
This release has the following new features: 

- **Component: Supply Chain Security Tools - Store**
  - Added a /health endpoint and `insight health` command
  - Upgraded to golang 1.17
  - Added support for query parameters
  - Updated repository parsing logic
  - Squashed some minor bugs

### Limitations
This release has the following limitations:

- **Component: Supply Chain Security Tools - Store**
  - Air gapped environments are not supported
  
### Breaking changes
This release has the following breaking changes:

- **Component: Supply Chain Security Tools - Sign**
  - `warn_on_unmatched` value has been renamed to `allow_unmatched_images`.
