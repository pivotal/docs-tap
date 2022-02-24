# Troubleshooting Tanzu Application Platform

This topic provides troubleshooting information to help resolve issues with Tanzu Application Platform (TAP).

## <a id="component-ts-links"></a> Component-Level Troubleshooting

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

## <a id='macos-unverified-developer'></a> Developer Cannot Be Verified When Installing Tanzu CLI on macOS

### Symptom

You see the following error when you run Tanzu CLI commands, for example `tanzu version`, on macOS:

```
"tanzu" cannot be opened because the developer cannot be verified
```

### Cause

Security settings are preventing installation.

### Solution

To resolve this issue:

1. Click **Cancel** in the macOS prompt window.

2. Open **System Preferences** > **Security & Privacy**.

3. Click **General**.

4. Next to the warning message for the Tanzu binary, click **Allow Anyway**.

5. Enter your system username and password in the macOS prompt window to confirm the changes.

6. In the terminal window, run `tanzu version`.

7. In the macOS prompt window, click **Open**.


## <a id='access-error-details'></a> Access `.status.usefulErrorMessage` Details

### Symptom

When installing TAP, you receive an error message that includes the following:

```
(message: Error (see .status.usefulErrorMessage for details))
```

### Cause

A package fails to reconcile and you must access the details in `.status.usefulErrorMessage`.

### Solution

Access the details in `.status.usefulErrorMessage` by running:

`kubectl get PACKAGE-NAME grype -n tap-install -o yaml`

Where `PACKAGE-NAME` is the name of the package to target.

## <a id='unauthorized'></a> Unauthorized to Access Error

### Symptom

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

### Cause

The Tanzu Network credentials needed to access the package may be missing or incorrect.

### Solution

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

## <a id='existing-service-account'></a> Already Existing Service Account Error

### Symptom

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

### Cause

The `tanzu package install` command may be executed again after failing.

### Solution

To update the package, run the following command after the first use of the `tanzu package install` command

```
tanzu package installed update 
```

## <a id='missing-build-logs'></a> Missing Build Logs after Creating a Workload

### Symptom

You create a workload, but no logs appear when you check for logs by running the following command:

  ```
  tanzu apps workload tail workload-name --since 10m --timestamp
  ```

### Cause

Common causes include:

- Misconfigured repository
- Misconfigured service account
- Misconfigured registry credentials

### Solution

To resolve this issue, run each of the following commands to receive the relevant error message:

- `kubectl get clusterbuilder.kpack.io -o yaml`
- `kubectl get image.kpack.io <workload-name> -o yaml`
- `kubectl get build.kpack.io -o yaml`

## <a id='failed-reconcile'></a> Packages Fail to Reconcile after Package Installation

### Symptom

When running `tanzu package install`, one or more packages fail to install.

Example:

  ```
  tanzu package install tap -p tap.tanzu.vmware.com -v 1.0.1 --values-file tap-values.yaml -n tap-install
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

Common causes include:

- Some infrastructure providers take longer than the timeout value allows to perform tasks.
- A race-condition between components exists. For example, a package that uses `Ingress` completes
  before the shared Tanzu ingress controller is available.

The VMware Carvel tools kapp-controller continues to try in a reconciliation loop.

### Solution

Check if the installation is continuing by running:

  ```
  tanzu package installed list -A
  ```

If the installation is still running, it is likely to finish successfully and produce output similar to this:

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
    services-toolkit          services-toolkit.tanzu.vmware.com                  0.5.0-rc.3       Reconcile succeeded  tap-install
    source-controller         controller.source.apps.tanzu.vmware.com            0.2.0            Reconcile succeeded  tap-install
    spring-boot-conventions   spring-boot-conventions.tanzu.vmware.com           0.2.0            Reconcile succeeded  tap-install
    tap                       tap.tanzu.vmware.com                               1.0.1            Reconciling          tap-install
    tap-gui                   tap-gui.tanzu.vmware.com                           1.0.0-rc.72      Reconcile succeeded  tap-install
    tap-telemetry             tap-telemetry.tanzu.vmware.com                     0.1.0            Reconcile succeeded  tap-install
    tekton-pipelines          tekton.tanzu.vmware.com                            0.30.0           Reconcile succeeded  tap-install
  ```

## <a id='telemetry-fails-fetching-secret'></a> Telemetry Component Logs Show Errors Fetching the "reg-creds" Secret

An error message occurs continuously on the `tap-telemetry-controller` logs.

### Symptom

When you view the logs of the `tap-telemetry` controller by running `kubectl logs -n
tap-telemetry <tap-telemetry-controller-<hash> -f`, you see the following error:

  ```
  "Error retrieving secret reg-creds on namespace tap-telemetry","error":"secrets \"reg-creds\" is forbidden: User \"system:serviceaccount:tap-telemetry:controller\" cannot get resource \"secrets\" in API group \"\" in the namespace \"tap-telemetry\""
  ```

### Cause

The `tap-telemetry` namespace misses a Role that allows the controller to list secrets in the
`tap-telemetry` namespace. For more information about Roles, see
[Role and ClusterRole](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#role-and-clusterrole)
in _Using RBAC Authorization_ in the Kubernetes documentation.

### Solution

To resolve this issue, run:

```
kubectl patch roles -n tap-telemetry tap-telemetry-controller --type='json' -p='[{"op": "add", "path": "/rules/-", "value": {"apiGroups": [""],"resources": ["secrets"],"verbs": ["get", "list", "watch"]} }]'
```

## <a id='error-update'></a> Workload Already Exists Error after Updating the Workload

### Symptom

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

### Cause

The app is running before performing a live update using the same app name.

### Solution

To resolve this issue, either delete the app or use a different name for the app.


## <a id='eula-error'></a> Failure to Accept an End User License Agreement Error

### Symptom

You cannot access Tanzu Application Platform or one of its components from
VMware Tanzu Network.

### Cause

You cannot access Tanzu Application Platform or one of its components from
VMware Tanzu Network before accepting the relevant EULA in VMware Tanzu Network.

### Solution

Follow the steps in [Accept the End User License Agreements](install-general.html#accept-eulas) in
_Installing the Tanzu CLI_.

## <a id='debug-convention'></a> Debug Convention May Not Apply

### Symptom

If you upgrade from TAP v0.4, the debug convention may not apply to the app run image.

### Cause

The TAP v0.4 lacks SBOM data.

### Solution

Delete existing app images that were built using TAP v0.4.

## <a id='build-scripts-lack-execute-bit'></a> Execute Bit Not Set for App Accelerator Build Scripts

### Symptom

You cannot execute a build script provided as part of an accelerator.

### Cause

Build scripts provided as part of an accelerator do not have the execute bit set when a new
project is generated from the accelerator.


### Solution

Explicitly set the execute bit by running the `chmod` command:

```
chmod +x BUILD-SCRIPT-NAME
```
Where `BUILD-SCRIPT-NAME` is the name of the build script.

For example, for a project generated from the "Spring PetClinic" accelerator, run:

```
chmod +x ./mvnw
```

