# Troubleshooting Tanzu Application Platform

This topic describes troubleshooting information for problems with installing Tanzu Application Platform.

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

1. Repeat the step to create a secret for the namespace, see [Add the Tanzu Application Platform Package Repository](install.md#add-package-repositories).
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

>**Note:** The sample above shows App Accelerator as the package, however, this error can occur
>with other packages as well.

### Cause

A common cause of this error is that the `tanzu package install` command is being executed again after it has failed once.

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

After creating a workload, there are no logs.

### Symptom

You issue the `tanzu package install` command but one or more packages fails to install.
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

- Some infrastructure providers take longer than the timeout value allows to perform tasks.
- A race-condition between components exists.
  For example, a package that uses `Ingress` completes before the shared Tanzu ingress controller is available.

The VMWare Carvel tools kapp-controller continues to try in a reconciliation loop.

### Solution

Verify if the installation is still continuing by running:

  ```
  tanzu package installed list -A
  ```

If it is still running, it is likely to finish successfully and produce output similar to this:

  ```
  \ Retrieving installed packages...
    NAME                      PACKAGE-NAME                                       PACKAGE-VERSION  STATUS               NAMESPACE
    accelerator               accelerator.apps.tanzu.vmware.com                  0.5.1            Reconcile succeeded  tap-install
    api-portal                api-portal.tanzu.vmware.com                        1.0.6            Reconcile succeeded  tap-install
    appliveview               run.appliveview.tanzu.vmware.com                   1.0.0-build.3    Reconciling          tap-install
    appliveview-conventions   build.appliveview.tanzu.vmware.com                 1.0.0-build.3    Reconcile succeeded  tap-install
    buildservice              buildservice.tanzu.vmware.com                      1.4.0-build.1    Reconciling          tap-install
    cartographer              cartographer.tanzu.vmware.com                      0.0.8-rc.7       Reconcile succeeded  tap-install
    cert-manager              cert-manager.tanzu.vmware.com                      1.5.3+tap.1      Reconcile succeeded  tap-install
    cnrs                      cnrs.tanzu.vmware.com                              1.1.0            Reconcile succeeded  tap-install
    contour                   contour.tanzu.vmware.com                           1.18.2+tap.1     Reconcile succeeded  tap-install
    conventions-controller    controller.conventions.apps.tanzu.vmware.com       0.4.2            Reconcile succeeded  tap-install
    developer-conventions     developer-conventions.tanzu.vmware.com             0.4.0-build1     Reconcile succeeded  tap-install
    fluxcd-source-controller  fluxcd.source.controller.tanzu.vmware.com          0.16.0           Reconcile succeeded  tap-install
    grype                     scst-grype.apps.tanzu.vmware.com                   1.0.0            Reconcile succeeded  tap-install
    image-policy-webhook      image-policy-webhook.signing.run.tanzu.vmware.com  1.0.0-beta.2     Reconcile succeeded  tap-install
    learningcenter            learningcenter.tanzu.vmware.com                    0.1.0-build.6    Reconcile succeeded  tap-install
    learningcenter-workshops  workshops.learningcenter.tanzu.vmware.com          0.1.0-build.7    Reconcile succeeded  tap-install
    ootb-delivery-basic       ootb-delivery-basic.tanzu.vmware.com               0.4.0-build.2    Reconcile succeeded  tap-install
    ootb-supply-chain-basic   ootb-supply-chain-basic.tanzu.vmware.com           0.4.0-build.2    Reconcile succeeded  tap-install
    ootb-templates            ootb-templates.tanzu.vmware.com                    0.4.0-build.2    Reconcile succeeded  tap-install
    scanning                  scst-scan.apps.tanzu.vmware.com                    1.0.0            Reconcile succeeded  tap-install
    scst-store                scst-store.tanzu.vmware.com                        1.0.0-beta.2     Reconcile succeeded  tap-install
    service-bindings          service-bindings.labs.vmware.com                   0.6.0            Reconcile succeeded  tap-install
    services-toolkit          services-toolkit.tanzu.vmware.com                  0.5.0-rc.3       Reconcile succeeded  tap-install
    source-controller         controller.source.apps.tanzu.vmware.com            0.2.0            Reconcile succeeded  tap-install
    spring-boot-conventions   spring-boot-conventions.tanzu.vmware.com           0.2.0            Reconcile succeeded  tap-install
    tap                       tap.tanzu.vmware.com                               0.4.0-build.12   Reconciling          tap-install
    tap-gui                   tap-gui.tanzu.vmware.com                           1.0.0-rc.72      Reconcile succeeded  tap-install
    tap-telemetry             tap-telemetry.tanzu.vmware.com                     0.1.0            Reconcile succeeded  tap-install
    tekton-pipelines          tekton.tanzu.vmware.com                            0.30.0           Reconcile succeeded  tap-install
  ```
