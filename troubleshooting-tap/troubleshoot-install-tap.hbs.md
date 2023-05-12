# Troubleshoot installing Tanzu Application Platform

This topic tells you how to troubleshoot installing Tanzu Application Platform (commonly known as TAP).

## <a id='macos-unverified-developer'></a> Developer cannot be verified when installing Tanzu CLI on macOS

You see the following error when you run Tanzu CLI commands, for example `tanzu version`, on macOS:

```console
"tanzu" cannot be opened because the developer cannot be verified
```

**Explanation**

Security settings are preventing installation.

**Solution**

To resolve this issue:

1. Click **Cancel** in the macOS prompt window.

2. Open **System Preferences** > **Security & Privacy**.

3. Click **General**.

4. Next to the warning message for the Tanzu binary, click **Allow Anyway**.

5. Enter your system username and password in the macOS prompt window to confirm the changes.

6. In the terminal window, run:

    ```console
    tanzu version
    ```

7. In the macOS prompt window, click **Open**.


## <a id='access-error-details'></a> Access `.status.usefulErrorMessage` details

When installing Tanzu Application Platform, you receive an error message that includes the following:

```console
(message: Error (see .status.usefulErrorMessage for details))
```

**Explanation**

A package fails to reconcile and you must access the details in `.status.usefulErrorMessage`.

**Solution**

Access the details in `.status.usefulErrorMessage` by running:

```console
kubectl get packageinstall PACKAGE-NAME -n tap-install -o yaml
```

Where `PACKAGE-NAME` is the name of the package to target.

## <a id='unauthorized'></a> "Unauthorized to access" error

When running the `tanzu package install` command, you receive an error message that includes the error:

```console
UNAUTHORIZED: unauthorized to access repository
```

Example:

  ```console
  $ tanzu package install app-live-view -p appliveview.tanzu.vmware.com -v 0.1.0 -n tap-install -f ./app-live-view.yml

  Error: package reconciliation failed: vendir: Error: Syncing directory '0':
    Syncing directory '.' with imgpkgBundle contents:
      Imgpkg: exit status 1 (stderr: Error: Checking if image is bundle: Collecting images: Working with registry.tanzu.vmware.com/app-live-view/application-live-view-install-bundle@sha256:b13b9ba81bcc985d76607cfc04bcbb8829b4cc2820e64a99e0af840681da12aa: GET https://registry.tanzu.vmware.com/v2/app-live-view/application-live-view-install-bundle/manifests/sha256:b13b9ba81bcc985d76607cfc04bcbb8829b4cc2820e64a99e0af840681da12aa: UNAUTHORIZED: unauthorized to access repository: app-live-view/application-live-view-install-bundle, action: pull: unauthorized to access repository: app-live-view/application-live-view-install-bundle, action: pull
  ```

>**Note** This example shows an error received when with Application Live View as the package. This error can also occur with other packages.

**Explanation**

The Tanzu Network credentials needed to access the package may be missing or incorrect.

**Solution**

To resolve this issue:

1. Repeat the step to create a secret for the namespace. For instructions, see
  [Add the Tanzu Application Platform Package Repository](../install-online/profile.hbs.md#add-tap-package-repo) in _Installing the Tanzu Application Platform Package and Profiles_.
  Ensure that you provide the correct credentials.

  When the secret has the correct credentials,
  the authentication error should resolve itself and the reconciliation succeed.
  Do not reinstall the package.

2. List the status of the installed packages to confirm that the reconcile has succeeded.
  For instructions, see
	[Verify the Installed Packages](../install-online/components.hbs.md#verify) in _Installing Individual Packages_.

## <a id='existing-service-account'></a> "Serviceaccounts already exists" error

When running the `tanzu package install` command, you receive the following error:

```console
failed to create ServiceAccount resource: serviceaccounts already exists
```

Example:

  ```console
  $ tanzu package install app-accelerator -p accelerator.apps.tanzu.vmware.com -v 0.2.0 -n tap-install -f app-accelerator-values.yaml

  Error: failed to create ServiceAccount resource: serviceaccounts "app-accelerator-tap-install-sa" already exists
  ```

>**Note** This example shows an error received with App Accelerator as the package. This error can also occur with other packages.

**Explanation**

The `tanzu package install` command may be executed again after failing.

**Solution**

To update the package, run the following command after the first use of the `tanzu package install` command

```console
tanzu package installed update
```

## <a id='failed-reconcile'></a> After package installation, one or more packages fails to reconcile

You run the `tanzu package install` command and one or more packages fails to install.
For example:

  ```console
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

**Explanation**

Often, the cause is one of the following:

- Your infrastructure provider takes longer to perform tasks than the timeout value allows.
- A race-condition between components exists.
  For example, a package that uses `Ingress` completes before the shared Tanzu ingress controller
  becomes available.

The VMware Carvel tools kapp-controller continues to try in a reconciliation loop in these cases.
However, if the reconciliation status is `failed` then there might be a configuration issue
in the provided `tap-config.yml` file.

**Solution**

1. Verify if the installation is still in progress by running:

    ```console
    tanzu package installed list -A
    ```

    If the installation is still in progress, the command produces output similar to the following
    example, and the installation is likely to finish successfully.

    ```console
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
      services-toolkit          services-toolkit.tanzu.vmware.com                  0.7.1            Reconcile succeeded  tap-install
      source-controller         controller.source.apps.tanzu.vmware.com            0.2.0            Reconcile succeeded  tap-install
      spring-boot-conventions   spring-boot-conventions.tanzu.vmware.com           0.2.0            Reconcile succeeded  tap-install
      tap                       tap.tanzu.vmware.com                               0.4.0-build.12   Reconciling          tap-install
      tap-gui                   tap-gui.tanzu.vmware.com                           1.0.0-rc.72      Reconcile succeeded  tap-install
      tap-telemetry             tap-telemetry.tanzu.vmware.com                     0.1.0            Reconcile succeeded  tap-install
      tekton-pipelines          tekton.tanzu.vmware.com                            0.30.0           Reconcile succeeded  tap-install
    ```

    If the installation has stopped running, one or more reconciliations have likely failed, as seen
    in the following example:

    ```console
    NAME                       PACKAGE NAME                                         PACKAGE VERSION   DESCRIPTION                                                            AGE
    accelerator                accelerator.apps.tanzu.vmware.com                    1.0.1             Reconcile succeeded                                                    109m
    api-portal                 api-portal.tanzu.vmware.com                          1.0.9             Reconcile succeeded                                                    119m
    appliveview                run.appliveview.tanzu.vmware.com                     1.0.2-build.2     Reconcile succeeded                                                    109m
    appliveview-conventions    build.appliveview.tanzu.vmware.com                   1.0.2-build.2     Reconcile succeeded                                                    109m
    buildservice               buildservice.tanzu.vmware.com                        1.5.0             Reconcile succeeded                                                    119m
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
    services-toolkit           services-toolkit.tanzu.vmware.com                    0.7.1             Reconcile succeeded                                                    119m
    source-controller          controller.source.apps.tanzu.vmware.com              0.2.0             Reconcile succeeded                                                    119m
    spring-boot-conventions    spring-boot-conventions.tanzu.vmware.com             0.3.0             Reconcile succeeded                                                    109m
    tap                        tap.tanzu.vmware.com                                 1.0.1             Reconcile failed: Error (see .status.usefulErrorMessage for details)   119m
    tap-gui                    tap-gui.tanzu.vmware.com                             1.0.2             Reconcile succeeded                                                    109m
    tap-telemetry              tap-telemetry.tanzu.vmware.com                       0.1.3             Reconcile succeeded                                                    119m
    tekton-pipelines           tekton.tanzu.vmware.com                              0.30.0            Reconcile succeeded                                                    119m
    ```

    In this example, `packageinstall/grype` and `packageinstall/tap` have reconciliation errors.

1. To get more details on the possible cause of a reconciliation failure, run:

    ```console
    kubectl describe packageinstall/NAME -n tap-install
    ```

    Where `NAME` is the name of the failing package. For this example it would be `grype`.

1. Use the displayed information to search for a relevant troubleshooting issue in this topic.
If none exists, and you are unable to fix the described issue yourself, please contact
[support](https://tanzu.vmware.com/support).

1. Repeat these diagnosis steps for any other packages that failed to reconcile.

## <a id='eula-error'></a> Failure to accept an End User License Agreement error

You cannot access Tanzu Application Platform or one of its components from
VMware Tanzu Network.

**Explanation**

You cannot access Tanzu Application Platform or one of its components from
VMware Tanzu Network before accepting the relevant EULA in VMware Tanzu Network.

**Solution**

Follow the steps in [Accept the End User License Agreements](../install-tanzu-cli.md#accept-eulas) in
_Installing the Tanzu CLI_.

## <a id='contour-error-kind'></a> Ingress is broken on Kind cluster

Your Contour installation cannot provide ingress to workloads when installed on a Kind cluster without a LoadBalancer solution.
Your Kind cluster was created with port mappings, as described in the [Kind install guide](../learning-center/local-install-guides/deploying-to-kind.hbs.md).

**Explanation**

In Tanzu Application Platform v{{ vars.tap_version }}, the default configuration for `contour.envoy.service.type`
is `LoadBalancer`. However, for the Envoy pods to be accessed by using the port mappings on your Kind cluster,
the service must be of type `NodePort`.

**Solution**

Configure `contour.evnoy.service.type` to be `NodePort`. Then, configure
`envoy.service.nodePorts.http` and `envoy.service.nodePorts.https` to the
corresponding port mappings on your Kind node. Otherwise, the NodePort service
is assigned random ports, which are not accessible through your Kind cluster.
