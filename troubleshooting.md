# Troubleshooting Tanzu Application Platform

This topic is for troubleshooting the installation of Tanzu Application Platform.

## <a id="component-ts-links"></a> Component-level troubleshooting

For component-level troubleshooting, see these topics:

* [Troubleshooting Tanzu Application Platform GUI](tap-gui/troubleshooting.md)
* [Troubleshooting Convention Service](convention-service/troubleshooting.md)
* [Troubleshooting Learning Center](learning-center/troubleshooting/known-issues.md)
* [Troubleshooting Service Bindings](service-bindings/troubleshooting.md)
* [Troubleshooting Source Controller](source-controller/troubleshooting.md)
* [Troubleshooting Spring Boot Conventions](spring-boot-conventions/troubleshooting.md)
* [Troubleshooting Application Live View](https://docs.vmware.com/en/Application-Live-View-for-VMware-Tanzu/1.0/docs/GUID-troubleshooting.html)
* [Troubleshooting Cloud Native Runtimes for Tanzu](https://docs.vmware.com/en/Cloud-Native-Runtimes-for-VMware-Tanzu/1.0/tanzu-cloud-native-runtimes-1-0/GUID-troubleshooting.html)
* [Troubleshooting Tanzu Build Service - FAQ](https://docs.vmware.com/en/Tanzu-Build-Service/1.4/vmware-tanzu-build-service-v14/GUID-faq.html)

## <a id='macos-unverified-dev'></a> Developer cannot be verified when installing Tanzu CLI on macOS

### Symptom

If you see the following error when running `tanzu version` on macOS:

```
"tanzu" cannot be opened because the developer cannot be verified
```

### Cause

Your security settings are preventing installation.

### Solution

1. Click **Cancel** in the macOS prompt window.

2. Open the **Security & Privacy** control panel from **System Preferences**.

3. Click **General**.

4. Click **Allow Anyway** next to the warning message for the Tanzu binary.

5. Enter your system username and password in the macOS prompt window to confirm the changes.

6. Execute the `Tanzu version` command in the terminal window again.

7. Click **Open** in the macOS prompt window. After completing the steps above, there should be no
more security issues while running Tanzu CLI commands.

## <a id='error-details'></a> Access `.status.usefulErrorMessage` details

### Symptom

You get an error message that includes the following:

```
(message: Error (see .status.usefulErrorMessage for details))
```

### Cause

A package fails to reconcile and you need to access the details in `.status.usefulErrorMessage`.

### Solution

To access the details in `.status.usefulErrorMessage`, run:

`kubectl get PACKAGE-NAME grype -n tap-install -o yaml`

Where:
- `PACKAGE-NAME` is the package you want to target.

## <a id='unauthorized-to-access'></a> Unauthorized to access error

An authentication error when installing a package, reconciliation fails.

### Symptom

You run the `tanzu package install` command and receive an `UNAUTHORIZED: unauthorized to access repository:` error.

For example:

  ```
  $ tanzu package install app-live-view -p appliveview.tanzu.vmware.com -v 0.1.0 -n tap-install -f ./app-live-view.yml

  Error: package reconciliation failed: vendir: Error: Syncing directory '0':
    Syncing directory '.' with imgpkgBundle contents:
      Imgpkg: exit status 1 (stderr: Error: Checking if image is bundle: Collecting images: Working with registry.tanzu.vmware.com/app-live-view/application-live-view-install-bundle@sha256:b13b9ba81bcc985d76607cfc04bcbb8829b4cc2820e64a99e0af840681da12aa: GET https://registry.tanzu.vmware.com/v2/app-live-view/application-live-view-install-bundle/manifests/sha256:b13b9ba81bcc985d76607cfc04bcbb8829b4cc2820e64a99e0af840681da12aa: UNAUTHORIZED: unauthorized to access repository: app-live-view/application-live-view-install-bundle, action: pull: unauthorized to access repository: app-live-view/application-live-view-install-bundle, action: pull
  ```

>**Note:** The sample above shows Application Live View as the package; however, this error can
>occur with other packages as well.

### Cause

A common cause of this error is that the Tanzu Network credentials needed to access the package
are missing or incorrect.

### Solution

To fix this problem:

1. Repeat the step to create a secret for the namespace. See [Add the Tanzu Application Platform Package Repository](install.md#add-package-repositories).
   Ensure that you provide the correct credentials.

   When the secret has the correct credentials,
   the authentication error should resolve itself and the reconciliation succeed.
   Do not reinstall the package.

2. List the status of the installed packages to confirm that the reconcile has succeeded.
   For instructions, see [Verify the Installed Packages](install-components.md#verify).

## <a id='existing-service-account'></a> Already existing service account error

A service account error when installing a package, reconciliation fails.

### Symptom

You run the `tanzu package install` command and receive an `failed to create ServiceAccount resource: serviceaccounts already exists` error.

For example:

  ```
  $ tanzu package install app-accelerator -p accelerator.apps.tanzu.vmware.com -v 0.2.0 -n tap-install -f app-accelerator-values.yaml

  Error: failed to create ServiceAccount resource: serviceaccounts "app-accelerator-tap-install-sa" already exists
  ```

>**Note:** The sample above shows App Accelerator as the package; however, this error can occur
>with other packages as well.

### Cause

A common cause of this error is that the `tanzu package install` command is being executed again after failing.

### Solution

If you want to update the package, use `tanzu package installed update` command after the first use
of the `tanzu package install` command.

## <a id='workload-no-build'></a> After creating a workload, there are no build logs

After creating a workload, there are no logs.

### Symptom

You create a workload, but no logs appear when you check the logs with:

  ```
  tanzu apps workload tail workload-name --since 10m --timestamp
  ```

### Cause

Common causes include:

- Misconfigured repository
- Misconfigured service account
- Misconfigured registry credentials

### Solution

To fix this problem, run each of these commands to get the relevant error message:

- `kubectl get clusterbuilder.kpack.io -o yaml`
- `kubectl get image.kpack.io <workload-name> -o yaml`
- `kubectl get build.kpack.io -o yaml`

## <a id='failed-reconcile'></a> After package installation, one or more packages fails to reconcile

### Symptom

You run the `tanzu package install` command and one or more packages fail to install.
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

### Cause

Often, the cause is one of the following:

- Your infrastructure provider takes longer to perform tasks than the timeout value allows.
- A race-condition between components exists.
  For example, a package that uses `Ingress` completes before the shared Tanzu ingress controller
  becomes available.

The VMware Carvel tools kapp-controller continues to try in a reconciliation loop in these cases.
However, if the reconciliation status is `failed` then there might be a configuration issue
in the provided `tap-config.yml` file.

### Solution

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


## <a id='tap-telemetry-secret-error'></a> Telemetry component logs show errors fetching the "reg-creds" secret

An error message occurs continuously on the `tap-telemetry-controller` logs.

### Symptom

When you get the logs of the `tap-telemetry` controller with `kubectl logs -n
tap-telemetry <tap-telemetry-controller-<hash> -f`, you see the following error:

  ```
  "Error retrieving secret reg-creds on namespace tap-telemetry","error":"secrets \"reg-creds\" is forbidden: User \"system:serviceaccount:tap-telemetry:controller\" cannot get resource \"secrets\" in API group \"\" in the namespace \"tap-telemetry\""
  ```

### Cause

The `tap-telemetry` namespace misses a
[Role](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#role-and-clusterrole)
that allows the controller to list secrets in the `tap-telemetry` namespace.

### Solution

To fix this problem, run the following command:

```
kubectl patch roles -n tap-telemetry tap-telemetry-controller --type='json' -p='[{"op": "add", "path": "/rules/-", "value": {"apiGroups": [""],"resources": ["secrets"],"verbs": ["get", "list", "watch"]} }]'
```

## <a id='error-update'></a> Error message occurs after updating the workload

An error message occurs after applying the command to update the workload.

### Symptom

When you update the workload by running:

```
% tanzu apps workload create tanzu-java-web-app \
--git-repo https://github.com/dbuchko/tanzu-java-web-app \
--git-branch main \
--type web \
--label apps.tanzu.vmware.com/has-tests=true \
--yes
```

You see the following error:

```
Error: workload "default/tanzu-java-web-app" already exists
Error: exit status 1
```

### Cause

You have the app running before performing a live update using the same app name.

### Solution

To fix this problem, you can either delete the app or use a different name.


## <a id='eula-error'></a> Error from failure to accept an End User License Agreement

### Symptom

An error message appears as a result of not accepting a relevant End User License Agreement (EULA).

### Cause

You cannot access Tanzu Application Platform or one of its components from
VMware Tanzu Network before accepting the relevant EULA in VMware Tanzu Network.

### Solution

Follow the steps in [Accept the End User License Agreements](install-general.md#accept-eulas).
