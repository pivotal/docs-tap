# Release notes

This topic contains release notes for Tanzu Application Platform v1.0.

## <a id='1-0'></a> v1.0

**Release Date**: January 11, 2022

### Known issues

This release has the following issues:

#### Installing

When installing Tanzu Application Platform on Google Kubernetes Engine (GKE), Kubernetes control
plane can be unavailable for several minutes during the installation.
Package installations can enter the `ReconcileFailed` state. When API server becomes available,
packages try to reconcile to completion.

This can happen on newly provisioned clusters which have not finished GKE API server autoscaling.
When GKE scales up an API server, the current Tanzu Application install continues, and any
subsequent installs succeed without interruption.

#### Application Accelerator

Build scripts provided as part of an accelerator do not have the execute bit set when a new
project is generated from the accelerator.

To resolve this issue, explicitly set the execute bit by running the `chmod` command:

```
chmod +x <build-script>
```

For example, for a project generated from the "Spring PetClinic" accelerator, run:

```
chmod +x ./mvnw
```

#### Application Live View

The Live View section in Tanzu Application Platform GUI might show
"No live information for pod with ID" after deploying Tanzu Application Platform workloads.

Resolve this issue by recreating the Application Live View Connector pod. This allows the connector
to discover the application instances and render the details in Tanzu Application Platform GUI.

For example:

```
kubectl -n app-live-view delete pods -l=name=application-live-view-connector
```

#### Convention Service

Convention Service does not currently support custom certificates for integrating with a private
registry. Support for custom certificates is planned for an upcoming release.

#### Developer Conventions

**Debug Convention might not apply:** If you upgraded from Tanzu Application Platform v0.4 then the
the debug convention might not apply to the app run image. This is because of the missing SBOM data
in the image.
To prevent this issue, delete existing app images that were built using Tanzu Application Platform
v0.4.

#### Grype scanner

**Scanning Java source code may not reveal vulnerabilities:** Source Code Scanning only scans
files present in the source code repository.
No network calls are made to fetch dependencies.
For languages that make use of dependency lock files, such as Golang and Node.js, Grype uses the
lock files to check the dependencies for vulnerabilities.

In the case of Java, dependency lock files are not guaranteed, so Grype instead uses the
dependencies present in the built binaries (`.jar` or `.war` files).

Because best practices do not include committing binaries to source code repositories, Grype
fails to find vulnerabilities during a Source Scan. The vulnerabilities are still found during the
Image Scan, after the binaries are built and packaged as images.

#### Learning Center

- **Training Portal in pending state:** Under certain circumstances, the training portal is stuck in
a pending state. The best way to discover the issue is to view the operator logs. To get the logs,
run:

    ```
    kubectl logs deployment/learningcenter-operator -n learningcenter
    ```

    Depending on the log, the issue might be that the TLS secret `tls` is not available.
    The TLS secret should be on the Learning Center operator namespace. Otherwise, you get this
    error:

    ```
    ERROR:kopf.objects:Handler 'learningcenter' failed temporarily: TLS secret tls is not available
    ```

    To recover from this issue, you can follow
    [these steps](learning-center/getting-started/learningcenter-operator.md#enforcing-secure-connections) to create the TLS Secret.
    After the TLS is created, redeploy the TrainingPortal resource.

- **image-policy-webhook-service not found** If you are installing a Tanzu Application Platform
profile, you might see the error:

    ```
    Internal error occurred: failed calling webhook "image-policy-webhook.signing.apps.tanzu.vmware.com": failed to call webhook: Post "https://image-policy-webhook-service.image-policy-system.svc:443/signing-policy-check?timeout=10s": service "image-policy-webhook-service" not found
    ```

    This is a rare condition error among some packages. To recover from this error, redeploy the
    `trainingPortal` resource.

- **Updating parameters don't work**

    Normally you need to update some parameters provided to the Learning Center Operator, such as
    ingressDomain, TLS secret, ingressClass, and so on.
    Try running one of these commands to validate if the parameters were changed:

    ```
    kubectl describe systemprofile
    ```

    or

    ```
    kubectl describe pod  -n learningcenter
    ```

    If the Training Portals don't work or you can't get the updated values, there is another
    workaround.
    By design, the Training Portal resources do not react to any changes on the parameters provided
    when the training portals were created.
    This is because any change on the `trainingportal` resource affect any online user who is
    running a workshop. To get the new values, redeploy `trainingportal` in a maintenance window
    where Learning Center is unavailable while the `systemprofile` is updated.

- **Increase your cluster's resources**
Node pressure may be caused by not enough nodes or not enough resources on nodes for deploying the
workloads you have. In this case, follow your cloud provider instructions on how to scale out or
scale up your cluster.

#### Supply Chain Choreographer

Deployment from a public Git repository might require a Git SSH secret.
Workaround is to configure SSH access for the public Git repository.

#### Supply Chain Security Tools – Scan

- **Failing Blob source scans:** Blob source scans have an edge case where, when a compressed file
without a `.git` directory is provided, sending results to the Supply Chain Security Tools - Store
fails and the scanned revision value is not set. The current workaround is to add the `.git`
directory to the compressed file.
- **Events show `SaveScanResultsSuccess` incorrectly:** `SaveScanResultsSuccess` appears in the
events when the Supply Chain Security Tools - Store is not configured. The `.status.conditions`
output, however, correctly reflects `SendingResults=False`.
- **Scan Phase indicates `Scanning` incorrectly:** Scans have an edge case where, when an error has
occurred during scanning, the Scan Phase field is not updated to `Error` and instead remains in the
`Scanning` phase. Read the scan Pod logs to verify there was an error.
- **CVE print columns are not getting populated:** After running a scan and using `kubectl get` on
the scan, the CVE print columns (CRITICAL, HIGH, MEDIUM, LOW, UNKNOWN, CVETOTAL) are not populated.
You can run `kubectl describe` on the scan and look for `Scan completed. Found x CVE(s): ...` under
`Status.Conditions` to find these severity counts and `CVETOTAL`.

#### Supply Chain Security Tools - Sign

- If all webhook nodes or pods are evicted by the cluster or scaled down, the admission policy
blocks any pods from being created in the cluster.
To resolve the issue, delete `MutatingWebhookConfiguration` and re-apply it when the cluster is
stable.

- **MutatingWebhookConfiguration prevents pods from being admitted:** Under certain circumstances,
if the `image-policy-controller-manager` deployment pods do not start up before the
`MutatingWebhookConfiguration` is applied to the cluster, it can prevent the admission of all
pods.<br><br>
For example, pods can be prevented from starting if nodes in a cluster are scaled to zero and the
webhook is forced to restart at the same time as other system components.
A deadlock can occur when some components expect the webhook to verify their image signatures and
the webhook is not running yet.<br><br>
There is a known rare condition during Tanzu Application Platform profiles installation that could
cause this issue to happen.

  - **Symptom:**
  You may see a message similar to one of the following in component statuses:

    ```
    Events:
      Type     Reason            Age                   From                   Message
      ----     ------            ----                  ----                   -------
      Warning  FailedCreate      4m28s                 replicaset-controller  Error creating: Internal error occurred: failed calling webhook "image-policy-webhook.signing.apps.tanzu.vmware.com": Post "https://image-policy-webhook-service.image-policy-system.svc:443/signing-policy-check?timeout=10s": no endpoints available for service "image-policy-webhook-service"
    ```

    ```
    Events:
      Type     Reason            Age                   From                   Message
      ----     ------            ----                  ----                   -------
      Warning FailedCreate 10m replicaset-controller Error creating: Internal error occurred: failed calling webhook "image-policy-webhook.signing.apps.tanzu.vmware.com": Post "https://image-policy-webhook-service.image-policy-system.svc:443/signing-policy-check?timeout=10s": service "image-policy-webhook-service" not found
    ```

  - **Solution:**
    By deleting the `MutatingWebhookConfiguration` resource, you can resolve the
    deadlock and enable the system to start up again. After the system is stable,
    you can restore the `MutatingWebhookConfiguration` resource to re-enable image
    signing enforcement.

    >**Important:** These steps temporarily disable signature verification in your cluster.

    To do so:

    1. Back up the `MutatingWebhookConfiguration` to a file by running:

        ```
        kubectl get MutatingWebhookConfiguration image-policy-mutating-webhook-configuration -o yaml > image-policy-mutating-webhook-configuration.yaml
        ```

    2. Delete `MutatingWebhookConfiguration` by running:

        ```
        kubectl delete MutatingWebhookConfiguration image-policy-mutating-webhook-configuration
        ```

    3. Wait until all components are up and running in your cluster, including the
    `image-policy-controller-manager` pods (namespace `image-policy-system`).

    4. Re-apply the `MutatingWebhookConfiguration` by running:

        ```
        kubectl apply -f image-policy-mutating-webhook-configuration.yaml
        ```

**Priority class of webhook's pods might preempt less privileged pods:**
This component uses a privileged `PriorityClass` to start up its pods in order to prevent node
pressure from preempting its pods. However, this can cause other less privileged components to have
their pods preempted or evicted instead.

  - **Symptom:**

    You see events similar to this in the output of `kubectl get events`:

    ```
    $ kubectl get events
    LAST SEEN   TYPE      REASON             OBJECT               MESSAGE
    28s         Normal    Preempted          pod/testpod          Preempted by image-policy-system/image-policy-controller-manager-59dc669d99-frwcp on node test-node
    ```

  - **Solutions:**
    - **Reduce the amount of pods deployed by the Sign component:**
    In case your deployment of the Sign component is running more pods than
    necessary, you can scale the deployment down. To do so:

        1. Create a values file called `scst-sign-values.yaml` with the following
        contents:
            ```
            ---
            replicas: N
            ```
            Where N should be the smallest amount of pods you can have for your current
            cluster configuration.

        1. Apply your new configuration by running:
            ```
            tanzu package installed update image-policy-webhook \
              --package-name image-policy-webhook.signing.apps.tanzu.vmware.com \
              --version 1.0.0-beta.3 \
              --namespace tap-install \
              --values-file scst-sign-values.yaml
            ```

        1. Wait a few minutes for your configuration to take effect in the cluster.

    - **Increase your cluster's resources:** Node pressure might be caused by a lack of nodes or
    resources on nodes for deploying the workloads you have.
    In this case, follow your cloud provider instructions for how to scale out or scale up your
    cluster.

#### Supply Chain Security Tools - Store

- **CrashLoopBackOff from password authentication failed**
Supply Chain Security Tools - Store does not start up. You see the following error in the `metadata-store-app` Pod logs:

    ```
    $ kubectl logs pod/metadata-store-app-* -n metadata-store -c metadata-store-app
    ...
    [error] failed to initialize database, got error failed to connect to `host=metadata-store-db user=metadata-store-user database=metadata-store`: server error (FATAL: password authentication failed for user "metadata-store-user" (SQLSTATE 28P01))
    ```

    If you see this error then you have changed the database password between deployments,
    which is not supported. To change the password, see **Persistent Volume Retains Data**.
    > **Warning:** Changing the database password deletes your Supply Chain Security Tools - Store data.

- **Persistent volume retains data**
If Supply Chain Security Tools - Store is deployed, deleted, and then redeployed the
`metadata-store-db` Pod fails to start up if the database password changed during redeployment.
This is due to the persistent volume used by postgres retaining old data, even though the retention
policy is set to `DELETE`.<br><br>
To redeploy the app either use the same database password or follow these steps below to erase
the data on the volume:
    1. Deploy `metadata-store app` with kapp.
    1. Verify that the `metadata-store-db-*` Pod fails.
    1. Run:

        ```
        kubectl exec -it metadata-store-db-<some-id> -n metadata-store /bin/bash
        ```
        Where `<some-id>` is the ID generated by Kubernetes and appended to the Pod name.
    1. Run `rm -rf /var/lib/postgresql/data/*` to delete all database data.
    This is the path found in `postgres-db-deployment.yaml`.
    1. Delete the `metadata-store` app with kapp.
    1. Deploy the `metadata-store` app with kapp.

- **Missing persistent volume**
After Store is deployed, `metadata-store-db` Pod might fail for missing volume while
`postgres-db-pv-claim` pvc is in the `PENDING` state.
This issue might occur because the cluster where Store is deployed does not have `storageclass`
defined.<br><br>
The provisioner of `storageclass` is responsible for creating the persistent volume after
`metadata-store-db` attaches `postgres-db-pv-claim`.<br><br>
Solution:
    1. Verify that your cluster has `storageclass` by running `kubectl get storageclass`.
    1. Create a `storageclass` in your cluster before deploying Store. For example:

        ```
        # This is the storageclass that Kind uses
        kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/master/deploy/local-path-storage.yaml

        # set the storage class as default
        kubectl patch storageclass local-path -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
        ```

- **Querying local path source reports**
If a source report has a local path as the name -- for example, `/path/to/code` -- the leading
`/` on the resulting repository name causes the querying packages and vulnerabilities to return
the following error from the client lib and the CLI: `{ "message": "Not found" }`.<br><br>
The URL of the resulting HTTP request is properly escaped: for example,
`/api/sources/%2Fpath%2Fto%2Fdir/vulnerabilities`.<br><br>
The rbac-proxy used for authentication handles this URL in a way that the response is a
redirect. For example, `HTTP 301\nLocation: /api/sources/path/to/dir/vulnerabilities`.
The Client Lib follows the redirect, making a request to the new URL which does not exist in the
Supply Chain Security Tools - Store API, resulting in this error message.

- **No support for installing in custom namespaces**
All of our testing uses the `metadata-store` namespace. Using a different namespace breaks ]
authentication and certificate validation for the `metadata-store` API.


#### Tanzu CLI

- `tanzu apps workload get`: Passing in `--output json` with the `--export` flag returns YAML
rather than JSON. Support for honoring the `--output json` with `--export` is planned for the next
release.
- `tanzu apps workload create/update/apply`: `--image` is not supported by the default supply chain
in Tanzu Application Platform v0.3.
`--wait` functions as expected when a workload is created for the first time but might return
prematurely on subsequent updates when passed with `workload update/apply` for existing workloads.
When the `--wait` flag is included and you decline the "Do you want to create this workload?"
prompt, the command continues to wait and must be cancelled manually.

#### Tanzu Dev Tools for VSCode

**Unable to configure task**: Launching the `Extension Host`, and configuring `tasks` in a workspace that does not contain
workload YAML files might not work. Solution: Uninstall the Tanzu Dev Tools extension to proceed.

**Extension Pack for Java:** The `Extention Pack for Java` (vscjava.vscode-java-pack) may not be automatically installed. Live-Update will not work. Solution: Manually install `Extension Pack for Java` in the extension marketplace.

#### Services Toolkit

* It is not possible for more than one application workload to consume the same service instance.
Attempting to create two or more application workloads while specifying the same `--service-ref`
value causes only one of the workloads to bind to the service instance and reconcile successfully.
This limitation is planned to be relaxed in an upcoming release.
* The `tanzu services` CLI plug-in is not compatible with Kubernetes clusters running on GKE.

### Security issues

This release has the following security issues:

* The installation specifies that the installer's Tanzu Network credentials be exported to all
namespaces. Customers can choose to mitigate this concern using one of the following methods:
    * Create a Tanzu Network account with their own credentials and use this for the installation exclusively.
    * Using [Carvel tool's imgpkg](https://carvel.dev/imgpkg/) customers can create a dedicated OCI
    registry on their own infrastructure that can comply with any required security policies that
    might exist.


### Breaking changes

This release has the following breaking change:

- **Supply Chain Security Tools - Store:** Changed package name to `metadata-store.apps.tanzu.vmware.com`.

### Issue fixes

This release has the following issue fixes:

#### Tanzu Dev Tools for VSCode

- Fixed issue where the Tanzu Dev Tools extension might not support projects with multi-document
YAML files
- Modified debug to remove any leftover port-forwards from past runs

#### Supply Chain Security Tools - Store

- Upgrade golang version from `1.17.1` to `1.17.5`

## <a id='0-4-0'></a> v0.4.0 beta release

**Release Date**: December 13, 2021

### Features

New features and changes in this release:

#### Supply Chain Security Tools – Scan

- Enhanced scanning coverage is available for Node.js apps
- CA certificates are automatically imported from the Metadata Store namespace

#### Tanzu Dev Tools for VSCode*

- Updated support for Tilt to v0.23.2 by removing the reference to the running image in the Tiltfile
and requiring the `container_selector` argument
- Added Code Snippets to help users create config files to enable existing projects to be deployable
on Tanzu Application Platform. This helps the user generate `workload.yaml`, `Tiltfile`, and
`catalog-info.yaml` files.
- Improved error handling and messaging for the following cases:
  - Tilt is not installed on the developer's machine.
  - The incorrect version of Tilt is installed.
  - A source image is missing in Tanzu settings.

#### Installation Profiles

The Full profile now includes Supply Chain Security Tools - Store.

The Dev profile now includes:

- Application Accelerator
- Out of the Box Supply Chain - Testing

The Dev profile no longer includes Image Policy Webhook.

#### Updated Components

The following components are updated in Tanzu Application Platform v0.4.0:

- Supply Chain Security Tools
    - [Scan v1.0.0](scst-scan/overview.md)
    - [Sign v1.0.0-beta.2](scst-sign/overview.md)
- [Tanzu Application Platform GUI v1.0.0-rc.72](tap-gui/about.md)

#### Renamed Components

Workload Visibility plug-in is renamed Runtime Visibility plug-in.

### Known issues

This release has the following issues:

#### Installing

When installing Tanzu Application Platform on Google Kubernetes Engine (GKE), Kubernetes control
plane might be unavailable for several minutes during the installation.
Package installations can enter the ReconcileFailed state. When API server becomes available,
packages try to reconcile to completion.

This can happen on newly provisioned clusters that have not gone through GKE API server autoscaling.
When GKE scales up an API server, the current Tanzu Application installation continues, and any
subsequent installations succeed without interruption.

#### Convention Service

Convention Service does not currently support self-signed certificates for integrating with a
private registry. Support for self-signed certificates is planned for an upcoming release.

#### Supply Chain Security Tools - Sign

- If all webhook nodes or pods are evicted by the cluster or scaled down, the admission policy
blocks any pods from being created in the cluster.
To resolve the issue, delete the `MutatingWebhookConfiguration` and reapply it when the cluster is
stable.

- **MutatingWebhookConfiguration prevents pods from being admitted**
Under certain circumstances, if the `image-policy-controller-manager` deployment pods do not start
up before the `MutatingWebhookConfiguration` is applied to the cluster, it can prevent the admission
of all pods.<br><br>
For example, pods can be prevented from starting if nodes in a cluster are scaled to zero and the
webhook is forced to restart at the same time as other system components. A deadlock can occur when
some components expect the webhook to verify their image signatures and the webhook is not running
yet.<br><br>
You see a message similar to the following in your `ReplicaSet` statuses:

    ```
    Events:
      Type     Reason            Age                   From                   Message
      ----     ------            ----                  ----                   -------
      Warning  FailedCreate      4m28s (x18 over 14m)  replicaset-controller  Error creating: Internal error occurred: failed calling webhook "image-policy-webhook.signing.run.tanzu.vmware.com": Post "https://image-policy-webhook-service.image-policy-system.svc:443/signing-policy-check?timeout=10s": no endpoints available for service "image-policy-webhook-service"
    ```

    By deleting the `MutatingWebhookConfiguration` resource, you can resolve the deadlock and enable
    the system to start up again. After the system is stable, you can restore the
    `MutatingWebhookConfiguration` resource to re-enable image-signing enforcement.

    >**Important:** These steps temporarily disable signature verification in your cluster.

    To do so:

      1. Back up the `MutatingWebhookConfiguration` to a file by running the following
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
This component uses a privileged `PriorityClass` to start up its pods in order to prevent node
pressure from preempting its pods. However, this can cause other less privileged components to have
their pods preempted or evicted instead.<br><br>
You see events similar to this in the output of `kubectl get events`:

    ```
    $ kubectl get events
    LAST SEEN   TYPE      REASON             OBJECT               MESSAGE
    28s         Normal    Preempted          pod/testpod          Preempted by image-policy-system/image-policy-controller-manager-59dc669d99-frwcp on node test-node
    ```

One possible solution is to reduce the amount of pods deployed by the Sign component.
If your deployment of the Sign component is running more pods than necessary, you can scale the
deployment down. To do so:

      1. Create a values file called `scst-sign-values.yaml` with the following
      contents:

        ```
        ---
        replicas: N
        ```

      Where `N` should be the smallest amount of pods you can have for your current cluster
      configuration

      1. Apply your new configuration by running:

        ```
        tanzu package installed update image-policy-webhook \
          --package-name image-policy-webhook.signing.run.tanzu.vmware.com \
          --version 1.0.0-beta.2 \
          --namespace tap-install \
          --values-file scst-sign-values.yaml
        ```

      1. It might take a few minutes until your configuration takes effect in the cluster.

Another solution is to increase your cluster's resources.
Node pressure might be caused by not enough nodes or not enough resources on nodes for deploying the
workloads you have. In this case, follow your cloud provider instructions for how to scale out or
scale up your cluster.

#### Tanzu CLI apps plug-in  

- **`tanzu apps workload get`**
Passing in `--output json` with the `--export` flag returns YAML rather than JSON.
Support for honoring the `--output json` with `--export` is planned for the next release.
- **`tanzu apps workload create/update/apply`**
  - `--image` is not supported by the default supply chain in Tanzu Application Platform v0.3.
  - `--wait` functions as expected when a workload is created for the first time but might return
  prematurely on subsequent updates when passed with `workload update/apply` for existing workloads.
  When the `--wait` flag is included and you decline the "Do you want to create this workload?"
  prompt, the command continues to wait and must be cancelled manually.

#### Supply Chain Security Tools – Scan

- **Failing Blob source scans:** Blob Source Scans have an edge case where, when a compressed file
without a `.git` directory is provided, sending results to the Supply Chain Security Tools - Store
fails and the scanned revision value is not set.
The current workaround is to add the `.git` directory to the compressed file.
- **Events show `SaveScanResultsSuccess` incorrectly:** `SaveScanResultsSuccess` appears in the
events when the Supply Chain Security Tools - Store is not configured.
The `.status.conditions` output, however, correctly reflects `SendingResults=False`.
- **Scan Phase indicates `Scanning` incorrectly:** Scans have an edge case where, when an error has
occurred during scanning, the Scan Phase field does not get updated to `Error` and instead remains
in the `Scanning` phase. Read the scan Pod logs to verify that there was an error.

### Known limitations with Grype scanner

**Supply Chain Security Tools – Scan:** Scanning Java source code may not reveal vulnerabilities.
Source Code Scanning only scans files present in the source code repository. No network calls are
made to fetch dependencies.

For languages that make use of dependency lock files, such as Golang and Node.js, Grype uses the lock
files to check the dependencies for vulnerabilities.
In the case of Java, dependency lock files are not guaranteed, so Grype instead uses the dependencies
present in the built binaries (`.jar` or `.war` files).

Because best practices do not include committing binaries to source code repositories, Grype fails to
find vulnerabilities during a Source Scan. The vulnerabilities are still found during the Image Scan,
after the binaries are built and packaged as images.  

### Issue fix

#### Tanzu Dev Tools for VSCode

Added a "wait" service which prevents user from using the live update and debug capabilities until
the deployment is up and running on the cluster. This fixes a known issue from
Tanzu Application Platform v0.2.0 and v0.3.0.
