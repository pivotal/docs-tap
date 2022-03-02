# Troubleshooting Tanzu Application Platform

This topic provides troubleshooting information to help resolve issues with Tanzu Application Platform.

## <a id="component-troubleshooting-links"></a> Component-level troubleshooting

For component-level troubleshooting, see these topics:

* [Troubleshooting Tanzu Application Platform GUI](tap-gui/troubleshooting.html)
* [Troubleshooting Convention Service](convention-service/troubleshooting.html)
* [Learning Center Known Issues](learning-center/troubleshooting/known-issues.html)
* [Service Bindings Troubleshooting](service-bindings/troubleshooting.html)
* [Source Controller Troubleshooting ](source-controller/troubleshooting.html)
* [Spring Boot Conventions Troubleshooting ](spring-boot-conventions/troubleshooting.html)
* [Application Live View for VMware Tanzu Troubleshooting](https://docs.vmware.com/en/Application-Live-View-for-VMware-Tanzu/1.0/docs/GUID-troubleshooting.html)
* [Troubleshooting Cloud Native Runtimes for Tanzu](https://docs.vmware.com/en/Cloud-Native-Runtimes-for-VMware-Tanzu/1.0/tanzu-cloud-native-runtimes-1-0/GUID-troubleshooting.html)
* [Tanzu Build Service Frequently Asked Questions](https://docs.vmware.com/en/Tanzu-Build-Service/1.4/vmware-tanzu-build-service-v14/GUID-faq.html)

## <a id="troubleshoot-tap-install"></a>Issues installing Tanzu Application Platform

### <a id='macos-unverified-developer'></a> Developer cannot be verified when installing Tanzu CLI on macOS

You see the following error when you run Tanzu CLI commands, for example `tanzu version`, on macOS:

```
"tanzu" cannot be opened because the developer cannot be verified
```

#### Explanation

Security settings are preventing installation.

#### Solution

To resolve this issue:

1. Click **Cancel** in the macOS prompt window.

2. Open **System Preferences** > **Security & Privacy**.

3. Click **General**.

4. Next to the warning message for the Tanzu binary, click **Allow Anyway**.

5. Enter your system username and password in the macOS prompt window to confirm the changes.

6. In the terminal window, run:
    ```
    tanzu version
    ```

7. In the macOS prompt window, click **Open**.


### <a id='access-error-details'></a> Access `.status.usefulErrorMessage` details

When installing Tanzu Application Platform, you receive an error message that includes the following:

```
(message: Error (see .status.usefulErrorMessage for details))
```

#### Explanation

A package fails to reconcile and you must access the details in `.status.usefulErrorMessage`.

#### Solution

Access the details in `.status.usefulErrorMessage` by running:

```
kubectl get PACKAGE-NAME grype -n tap-install -o yaml
```

Where `PACKAGE-NAME` is the name of the package to target.

### <a id='unauthorized'></a> "Unauthorized to access" error

When running the `tanzu package install` command, you receive an error message that includes the error:

```
UNAUTHORIZED: unauthorized to access repository
```

Example:

  ```
  $ tanzu package install app-live-view -p appliveview.tanzu.vmware.com -v 0.1.0 -n tap-install -f ./app-live-view.yml

  Error: package reconciliation failed: vendir: Error: Syncing directory '0':
    Syncing directory '.' with imgpkgBundle contents:
      Imgpkg: exit status 1 (stderr: Error: Checking if image is bundle: Collecting images: Working with registry.tanzu.vmware.com/app-live-view/application-live-view-install-bundle@sha256:b13b9ba81bcc985d76607cfc04bcbb8829b4cc2820e64a99e0af840681da12aa: GET https://registry.tanzu.vmware.com/v2/app-live-view/application-live-view-install-bundle/manifests/sha256:b13b9ba81bcc985d76607cfc04bcbb8829b4cc2820e64a99e0af840681da12aa: UNAUTHORIZED: unauthorized to access repository: app-live-view/application-live-view-install-bundle, action: pull: unauthorized to access repository: app-live-view/application-live-view-install-bundle, action: pull
  ```

>**Note:** This example shows an error received when with Application Live View as the package. This error can also occur with other packages.

#### Explanation

The Tanzu Network credentials needed to access the package may be missing or incorrect.

#### Solution

To resolve this issue:

1. Repeat the step to create a secret for the namespace. For instructions, see
  [Add the Tanzu Application Platform Package Repository](install.html#add-package-repositories) in _Installing the Tanzu Application Platform Package and Profiles_.
  Ensure that you provide the correct credentials.

  When the secret has the correct credentials,
  the authentication error should resolve itself and the reconciliation succeed.
  Do not reinstall the package.

2. List the status of the installed packages to confirm that the reconcile has succeeded.
  For instructions, see
	[Verify the Installed Packages](install-components.html#verify) in _Installing Individual Packages_.

### <a id='existing-service-account'></a> "Serviceaccounts already exists" error

When running the `tanzu package install` command, you receive the following error:

```
failed to create ServiceAccount resource: serviceaccounts already exists
```

Example:

  ```
  $ tanzu package install app-accelerator -p accelerator.apps.tanzu.vmware.com -v 0.2.0 -n tap-install -f app-accelerator-values.yaml

  Error: failed to create ServiceAccount resource: serviceaccounts "app-accelerator-tap-install-sa" already exists
  ```

>**Note:** This example shows an error received with App Accelerator as the package. This error can also occur with other packages.

#### Explanation

The `tanzu package install` command may be executed again after failing.

#### Solution

To update the package, run the following command after the first use of the `tanzu package install` command

```
tanzu package installed update
```

### <a id='failed-reconcile'></a> After package installation, one or more packages fails to reconcile

You run the `tanzu package install` command and one or more packages fails to install.
For example:

  ```
  tanzu package install tap -p tap.tanzu.vmware.com -v 0.4.0 --values-file tap-values.yaml -n tap-install
  - Installing package 'tap.tanzu.vmware.com'
  \ Getting package metadata for 'tap.tanzu.vmware.com'
  | Creating service account 'tap-tap-install-sa'
  / Creating cluster admin role 'tap-tap-install-cluster-role'
  | Creating cluster role binding 'tap-tap-install-cluster-rolebinding'
  | Creating secret 'tap-tap-install-values'
  | Creating package resource
  - Waiting for 'PackageInstall' reconciliation for 'tap'
  / 'PackageInstall' resource install status: Reconciling
  | 'PackageInstall' resource install status: ReconcileFailed

  Please consider using 'tanzu package installed update' to update the installed package with correct settings


  Error: resource reconciliation failed: kapp: Error: waiting on reconcile packageinstall/tap-gui (packaging.carvel.dev/v1alpha1) namespace: tap-install:
    Finished unsuccessfully (Reconcile failed:  (message: Error (see .status.usefulErrorMessage for details))). Reconcile failed: Error (see .status.usefulErrorMessage for details)
  Error: exit status 1
  ```

#### Explanation

Often, the cause is one of the following:

- Your infrastructure provider takes longer to perform tasks than the timeout value allows.
- A race-condition between components exists.
  For example, a package that uses `Ingress` completes before the shared Tanzu ingress controller
  becomes available.

The VMware Carvel tools kapp-controller continues to try in a reconciliation loop in these cases.
However, if the reconciliation status is `failed` then there might be a configuration issue
in the provided `tap-config.yml` file.

#### Solution

1. Verify if the installation is still in progress by running:

    ```
    tanzu package installed list -A
    ```

    If the installation is still in progress, the command produces output similar to the following
    example, and the installation is likely to finish successfully.

    ```
    \ Retrieving installed packages...
      NAME                      PACKAGE-NAME                                       PACKAGE-VERSION  STATUS               NAMESPACE
      accelerator               accelerator.apps.tanzu.vmware.com                  1.0.0            Reconcile succeeded  tap-install
      api-portal                api-portal.tanzu.vmware.com                        1.0.6            Reconcile succeeded  tap-install
      appliveview               run.appliveview.tanzu.vmware.com                   1.0.0-build.3    Reconciling          tap-install
      appliveview-conventions   build.appliveview.tanzu.vmware.com                 1.0.0-build.3    Reconcile succeeded  tap-install
      buildservice              buildservice.tanzu.vmware.com                      1.4.0-build.1    Reconciling          tap-install
      cartographer              cartographer.tanzu.vmware.com                      0.1.0            Reconcile succeeded  tap-install
      cert-manager              cert-manager.tanzu.vmware.com                      1.5.3+tap.1      Reconcile succeeded  tap-install
      cnrs                      cnrs.tanzu.vmware.com                              1.1.0            Reconcile succeeded  tap-install
      contour                   contour.tanzu.vmware.com                           1.18.2+tap.1     Reconcile succeeded  tap-install
      conventions-controller    controller.conventions.apps.tanzu.vmware.com       0.4.2            Reconcile succeeded  tap-install
      developer-conventions     developer-conventions.tanzu.vmware.com             0.4.0-build1     Reconcile succeeded  tap-install
      fluxcd-source-controller  fluxcd.source.controller.tanzu.vmware.com          0.16.0           Reconcile succeeded  tap-install
      grype                     grype.scanning.apps.tanzu.vmware.com               1.0.0            Reconcile succeeded  tap-install
      image-policy-webhook      image-policy-webhook.signing.apps.tanzu.vmware.com 1.0.0-beta.3     Reconcile succeeded  tap-install
      learningcenter            learningcenter.tanzu.vmware.com                    0.1.0-build.6    Reconcile succeeded  tap-install
      learningcenter-workshops  workshops.learningcenter.tanzu.vmware.com          0.1.0-build.7    Reconcile succeeded  tap-install
      ootb-delivery-basic       ootb-delivery-basic.tanzu.vmware.com               0.5.1            Reconcile succeeded  tap-install
      ootb-supply-chain-basic   ootb-supply-chain-basic.tanzu.vmware.com           0.5.1            Reconcile succeeded  tap-install
      ootb-templates            ootb-templates.tanzu.vmware.com                    0.5.1            Reconcile succeeded  tap-install
      scanning                  scanning.apps.tanzu.vmware.com                     1.0.0            Reconcile succeeded  tap-install
      metadata-store            metadata-store.apps.tanzu.vmware.com               1.0.2            Reconcile succeeded  tap-install
      service-bindings          service-bindings.labs.vmware.com                   0.6.0            Reconcile succeeded  tap-install
      services-toolkit          services-toolkit.tanzu.vmware.com                  0.5.1            Reconcile succeeded  tap-install
      source-controller         controller.source.apps.tanzu.vmware.com            0.2.0            Reconcile succeeded  tap-install
      spring-boot-conventions   spring-boot-conventions.tanzu.vmware.com           0.2.0            Reconcile succeeded  tap-install
      tap                       tap.tanzu.vmware.com                               0.4.0-build.12   Reconciling          tap-install
      tap-gui                   tap-gui.tanzu.vmware.com                           1.0.0-rc.72      Reconcile succeeded  tap-install
      tap-telemetry             tap-telemetry.tanzu.vmware.com                     0.1.0            Reconcile succeeded  tap-install
      tekton-pipelines          tekton.tanzu.vmware.com                            0.30.0           Reconcile succeeded  tap-install
    ```

    If the installation has stopped running, one or more reconciliations have likely failed, as seen
    in the following example:

    ```
    NAME                       PACKAGE NAME                                         PACKAGE VERSION   DESCRIPTION                                                            AGE
    accelerator                accelerator.apps.tanzu.vmware.com                    1.0.1             Reconcile succeeded                                                    109m
    api-portal                 api-portal.tanzu.vmware.com                          1.0.9             Reconcile succeeded                                                    119m
    appliveview                run.appliveview.tanzu.vmware.com                     1.0.2-build.2     Reconcile succeeded                                                    109m
    appliveview-conventions    build.appliveview.tanzu.vmware.com                   1.0.2-build.2     Reconcile succeeded                                                    109m
    buildservice               buildservice.tanzu.vmware.com                        1.4.2             Reconcile succeeded                                                    119m
    cartographer               cartographer.tanzu.vmware.com                        0.2.1             Reconcile succeeded                                                    117m
    cert-manager               cert-manager.tanzu.vmware.com                        1.5.3+tap.1       Reconcile succeeded                                                    119m
    cnrs                       cnrs.tanzu.vmware.com                                1.1.0             Reconcile succeeded                                                    109m
    contour                    contour.tanzu.vmware.com                             1.18.2+tap.1      Reconcile succeeded                                                    117m
    conventions-controller     controller.conventions.apps.tanzu.vmware.com         0.5.0             Reconcile succeeded                                                    117m
    developer-conventions      developer-conventions.tanzu.vmware.com               0.5.0             Reconcile succeeded                                                    109m
    fluxcd-source-controller   fluxcd.source.controller.tanzu.vmware.com            0.16.1            Reconcile succeeded                                                    119m
    grype                      grype.scanning.apps.tanzu.vmware.com                 1.0.0             Reconcile failed: Error (see .status.usefulErrorMessage for details)   109m
    image-policy-webhook       image-policy-webhook.signing.apps.tanzu.vmware.com   1.0.1             Reconcile succeeded                                                    117m
    learningcenter             learningcenter.tanzu.vmware.com                      0.1.0             Reconcile succeeded                                                    109m
    learningcenter-workshops   workshops.learningcenter.tanzu.vmware.com            0.1.0             Reconcile succeeded                                                    103m
    metadata-store             metadata-store.apps.tanzu.vmware.com                 1.0.2             Reconcile succeeded                                                    117m
    ootb-delivery-basic        ootb-delivery-basic.tanzu.vmware.com                 0.6.1             Reconcile succeeded                                                    103m
    ootb-supply-chain-basic    ootb-supply-chain-basic.tanzu.vmware.com             0.6.1             Reconcile succeeded                                                    103m
    ootb-templates             ootb-templates.tanzu.vmware.com                      0.6.1             Reconcile succeeded                                                    109m
    scanning                   scanning.apps.tanzu.vmware.com                       1.0.0             Reconcile succeeded                                                    119m
    service-bindings           service-bindings.labs.vmware.com                     0.6.0             Reconcile succeeded                                                    119m
    services-toolkit           services-toolkit.tanzu.vmware.com                    0.5.1             Reconcile succeeded                                                    119m
    source-controller          controller.source.apps.tanzu.vmware.com              0.2.0             Reconcile succeeded                                                    119m
    spring-boot-conventions    spring-boot-conventions.tanzu.vmware.com             0.3.0             Reconcile succeeded                                                    109m
    tap                        tap.tanzu.vmware.com                                 1.0.1             Reconcile failed: Error (see .status.usefulErrorMessage for details)   119m
    tap-gui                    tap-gui.tanzu.vmware.com                             1.0.2             Reconcile succeeded                                                    109m
    tap-telemetry              tap-telemetry.tanzu.vmware.com                       0.1.3             Reconcile succeeded                                                    119m
    tekton-pipelines           tekton.tanzu.vmware.com                              0.30.0            Reconcile succeeded                                                    119m
    ```

    In this example, `packageinstall/grype` and `packageinstall/tap` have reconciliation errors.

1. To get more details on the possible cause of a reconciliation failure, run:

    ```
    kubectl describe packageinstall/NAME -n tap-install
    ```

    Where `NAME` is the name of the failing package. For this example it would be `grype`.

1. Use the displayed information to search for a relevant troubleshooting issue in this topic.
If none exists, and you are unable to fix the described issue yourself, please contact
[support](https://tanzu.vmware.com/support).

1. Repeat these diagnosis steps for any other packages that failed to reconcile.

### <a id='eula-error'></a> Failure to accept an End User License Agreement error

You cannot access Tanzu Application Platform or one of its components from
VMware Tanzu Network.

#### Explanation

You cannot access Tanzu Application Platform or one of its components from
VMware Tanzu Network before accepting the relevant EULA in VMware Tanzu Network.

#### Solution

Follow the steps in [Accept the End User License Agreements](install-tanzu-cli.html#accept-eulas) in
_Installing the Tanzu CLI_.


## <a id="troubleshoot-tap-usage"></a>Issues using Tanzu Application Platform  

### <a id='missing-build-logs'></a> Missing build logs after creating a workload

You create a workload, but no logs appear when you check for logs by running the following command:

  ```
  tanzu apps workload tail workload-name --since 10m --timestamp
  ```

#### Explanation

Common causes include:

- Misconfigured repository
- Misconfigured service account
- Misconfigured registry credentials

#### Solution

To resolve this issue, run each of the following commands to receive the relevant error message:

- ```kubectl get clusterbuilder.kpack.io -o yaml```
- ```kubectl get image.kpack.io <workload-name> -o yaml```
- ```kubectl get build.kpack.io -o yaml```


### <a id='error-update'></a> "Workload already exists" error after updating the workload

When you update the workload, you receive the following error:

```
Error: workload "default/APP-NAME" already exists
Error: exit status 1
```
Where `APP-NAME` is the name of the app.

For example, when you run:

```
$ tanzu apps workload create tanzu-java-web-app \
--git-repo https://github.com/dbuchko/tanzu-java-web-app \
--git-branch main \
--type web \
--label apps.tanzu.vmware.com/has-tests=true \
--yes
```

You receive the following error

```
Error: workload "default/tanzu-java-web-app" already exists
Error: exit status 1
```

#### Explanation

The app is running before performing a live update using the same app name.

#### Solution

To resolve this issue, either delete the app or use a different name for the app.


### <a id='telemetry-fails-fetching-secret'></a> Telemetry component logs show errors fetching the "reg-creds" secret

When you view the logs of the `tap-telemetry` controller by running `kubectl logs -n
tap-telemetry <tap-telemetry-controller-<hash> -f`, you see the following error:

  ```
  "Error retrieving secret reg-creds on namespace tap-telemetry","error":"secrets \"reg-creds\" is forbidden: User \"system:serviceaccount:tap-telemetry:controller\" cannot get resource \"secrets\" in API group \"\" in the namespace \"tap-telemetry\""
  ```

#### Explanation

The `tap-telemetry` namespace misses a Role that allows the controller to list secrets in the
`tap-telemetry` namespace. For more information about Roles, see
[Role and ClusterRole](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#role-and-clusterrole)
in _Using RBAC Authorization_ in the Kubernetes documentation.

#### Solution

To resolve this issue, run:

```
kubectl patch roles -n tap-telemetry tap-telemetry-controller --type='json' -p='[{"op": "add", "path": "/rules/-", "value": {"apiGroups": [""],"resources": ["secrets"],"verbs": ["get", "list", "watch"]} }]'
```

### <a id='debug-convention'></a> Debug convention may not apply

If you upgrade from Tanzu Application Platform v0.4, the debug convention may not apply to the app run image.

#### Explanation

The Tanzu Application Platform v0.4 lacks SBOM data.

#### Solution

Delete existing app images that were built using Tanzu Application Platform v0.4.

### <a id='build-scripts-lack-execute-bit'></a> Execute bit not set for App Accelerator build scripts

You cannot execute a build script provided as part of an accelerator.

#### Explanation

Build scripts provided as part of an accelerator do not have the execute bit set when a new
project is generated from the accelerator.

#### Solution

Explicitly set the execute bit by running the `chmod` command:

```
chmod +x BUILD-SCRIPT-NAME
```
Where `BUILD-SCRIPT-NAME` is the name of the build script.

For example, for a project generated from the "Spring PetClinic" accelerator, run:

```
chmod +x ./mvnw
```

### <a id='no-live-information'></a> "No live information for pod with ID" error

After deploying Tanzu Application Platform workloads, the Tanzu Application Platform GUI shows a "No live information for pod with ID" error.

#### Explanation

The connector must discover the application instances and render the details in Tanzu Application Platform GUI.

#### Solution

Recreate the Application Live View Connector pod by running:

```
kubectl -n app-live-view delete pods -l=name=application-live-view-connector
```

This allows the connector to discover the application instances and render the details in Tanzu Application Platform GUI.

### <a id='image-policy-webhook-service-not-found'></a> "image-policy-webhook-service not found" error

When installing a Tanzu Application Platform profile, you receive the following error:

```
Internal error occurred: failed calling webhook "image-policy-webhook.signing.apps.tanzu.vmware.com": failed to call webhook: Post "https://image-policy-webhook-service.image-policy-system.svc:443/signing-policy-check?timeout=10s": service "image-policy-webhook-service" not found
```

#### Explanation

The "image-policy-webhook-service" service cannot be found.

#### Solution

Redeploy the `trainingPortal` resource.

### <a id='increase-cluster-resources'></a> Increase your cluster resources error

You receive an "Increase your cluster's resources" error.

#### Explanation

Node pressure may be caused by an insufficient number of nodes or a lack of resources on nodes
necessary to deploy the workloads that you have.

#### Solution

Follow instructions from your cloud provider to scale out or scale up your cluster.

### <a id='pod-admission-prevented'></a> MutatingWebhookConfiguration prevents pod admission

Admission of all pods is prevented when the `image-policy-controller-manager` deployment pods do not
start before the `MutatingWebhookConfiguration` is applied to the cluster.

#### Explanation

Pods can be prevented from starting if nodes in a cluster are scaled to zero and the webhook is
forced to restart at the same time as other system components. A deadlock can occur when some
components expect the webhook to verify their image signatures and the webhook is not yet running.

A known rare condition during Tanzu Application Platform profiles installation can cause this. If so,
you may see a message similar to one of the following in component statuses:

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

#### Solution

Delete the MutatingWebhookConfiguration resource to resolve the deadlock and enable the system to
restart. After the system is stable, restore the MutatingWebhookConfiguration resource to re-enable
image signing enforcement.

>**Important:** These steps temporarily disable signature verification in your cluster.

1. Back up `MutatingWebhookConfiguration` to a file by running:

    ```
    kubectl get MutatingWebhookConfiguration image-policy-mutating-webhook-configuration -o yaml > image-policy-mutating-webhook-configuration.yaml
    ```

1. Delete `MutatingWebhookConfiguration` by running:

    ```
    kubectl delete MutatingWebhookConfiguration image-policy-mutating-webhook-configuration
    ```

1. Wait until all components are up and running in your cluster, including the
`image-policy-controller-manager pods` (namespace `image-policy-system`).

1. Re-apply `MutatingWebhookConfiguration` by running:

    ```
    kubectl apply -f image-policy-mutating-webhook-configuration.yaml
    ```

### <a id='priority-class-preempts'></a> Priority class of webhook's pods preempts less privileged pods

When viewing the output of `kubectl get events`, you see events similar to the following:

```
$ kubectl get events
LAST SEEN   TYPE      REASON             OBJECT               MESSAGE
28s         Normal    Preempted          pod/testpod          Preempted by image-policy-system/image-policy-controller-manager-59dc669d99-frwcp on node test-node
```

#### Explanation

The Supply Chain Security Tools - Sign component uses a privileged `PriorityClass` to start its pods
to prevent node pressure from preempting its pods. This can cause less privileged components to have
their pods preempted or evicted instead.

#### Solution

- **Solution 1: Reduce the number of pods deployed by the Sign component:**
    If your deployment of the Sign component runs more pods than necessary, scale down the deployment
    down as follows:

    1. Create a values file named `scst-sign-values.yaml` with the following contents:
        ```
        ---
        replicas: N
        ```
        Where `N` is an integer indicating the lowest number of pods you necessary for your current
        cluster configuration.

    1. Apply the new configuration by running:
        ```
        tanzu package installed update image-policy-webhook \
          --package-name image-policy-webhook.signing.apps.tanzu.vmware.com \
          --version 1.0.0-beta.3 \
          --namespace tap-install \
          --values-file scst-sign-values.yaml
        ```

    1. Wait a few minutes for your configuration to take effect in the cluster.

- **Solution 2: Increase your cluster's resources:**
    Node pressure may be caused by an insufficient number of nodes or a lack of resources on nodes
    necessary to deploy the workloads that you have. Follow instructions from your cloud provider
    to scale out or scale up your cluster.

### <a id='password-authentication-fails'></a> CrashLoopBackOff from password authentication fails

Supply Chain Security Tools - Store does not start. You see the following error in the
`metadata-store-app` Pod logs:

    ```
    $ kubectl logs pod/metadata-store-app-* -n metadata-store -c metadata-store-app
    ...
    [error] failed to initialize database, got error failed to connect to `host=metadata-store-db user=metadata-store-user database=metadata-store`: server error (FATAL: password authentication failed for user "metadata-store-user" (SQLSTATE 28P01))
    ```

#### Explanation

The database password has been changed between deployments. This is not supported.

#### Solution

Redeploy the app either with the original database password or follow these steps below to erase the
data on the volume:

1. Deploy `metadata-store app` with kapp.

1. Verify that the `metadata-store-db-*` Pod fails.

1. Run:
    ```
    kubectl exec -it metadata-store-db-KUBERNETES-ID -n metadata-store /bin/bash
    ```
    Where `KUBERNETES-ID` is the ID generated by Kubernetes and appended to the Pod name.

1. To delete all database data, run:
    ```
    rm -rf /var/lib/postgresql/data/*
    ```
    This is the path found in `postgres-db-deployment.yaml`.

1. Delete the `metadata-store` app with kapp.

1. Deploy the `metadata-store` app with kapp.


### <a id='password-authentication-fails'></a> Password authentication fails

Supply Chain Security Tools - Store does not start. You see the following error in the
`metadata-store-app` Pod logs:

```
$ kubectl logs pod/metadata-store-app-* -n metadata-store -c metadata-store-app
...
[error] failed to initialize database, got error failed to connect to `host=metadata-store-db user=metadata-store-user database=metadata-store`: server error (FATAL: password authentication failed for user "metadata-store-user" (SQLSTATE 28P01))
```

#### Explanation

The database password has been changed between deployments. This is not supported.

#### Solution

Redeploy the app either with the original database password or follow these steps below to erase the
data on the volume:

1. Deploy `metadata-store app` with kapp.

1. Verify that the `metadata-store-db-*` Pod fails.

1. Run:
    ```
    kubectl exec -it metadata-store-db-KUBERNETES-ID -n metadata-store /bin/bash
    ```
    Where `KUBERNETES-ID` is the ID generated by Kubernetes and appended to the Pod name.

1. To delete all database data, run:
    ```
    rm -rf /var/lib/postgresql/data/*
    ```
    This is the path found in `postgres-db-deployment.yaml`.

1. Delete the `metadata-store` app with kapp.

1. Deploy the `metadata-store` app with kapp.


### <a id='metadata-store-db-fails-to-start'></a> `metadata-store-db` pod fails to start

When Supply Chain Security Tools - Store is deployed, deleted, and then redeployed, the `metadata-store-db`
Pod fails to start if the database password changed during redeployment.

#### Explanation

The persistent volume used by postgres retains old data, even though the retention policy is set to `DELETE`.

#### Solution

Redeploy the app either with the original database password or follow these steps below to erase the
data on the volume:

1. Deploy `metadata-store app` with kapp.

1. Verify that the `metadata-store-db-*` Pod fails.

1. Run:
    ```
    kubectl exec -it metadata-store-db-KUBERNETES-ID -n metadata-store /bin/bash
    ```
    Where `KUBERNETES-ID` is the ID generated by Kubernetes and appended to the Pod name.

1. To delete all database data, run:
    ```
    rm -rf /var/lib/postgresql/data/*
    ```
    This is the path found in `postgres-db-deployment.yaml`.

1. Delete the `metadata-store` app with kapp.

1. Deploy the `metadata-store` app with kapp.


### <a id='missing-persistent-volume'></a> Missing persistent volume

After Supply Chain Security Tools - Store is deployed, `metadata-store-db` Pod fails for missing volume
while `postgres-db-pv-claim` pvc is in the `PENDING` state.

#### Explanation

The cluster where Supply Chain Security Tools - Store is deployed does not have `storageclass`
defined. The provisioner of `storageclass` is responsible for creating the persistent volume after
`metadata-store-db` attaches `postgres-db-pv-claim`.

#### Solution

1. Verify that your cluster has `storageclass` by running:
    ```
    kubectl get storageclass
    ```

1. Create a `storageclass` in your cluster before deploying Supply Chain Security Tools - Store. For example:
    ```
    # This is the storageclass that Kind uses
    kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/master/deploy/local-path-storage.yaml

    # set the storage class as default
    kubectl patch storageclass local-path -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
     ```
