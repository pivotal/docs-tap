# Install Cloud Native Runtimes

This topic describes how you can install Cloud Native Runtimes, commonly known as CNRs, from the Tanzu Application Platform package repository.

>**Note** Use the instructions in this topic if you do not want to use a profile to install packages.
The full profile includes Cloud Native Runtimes.
For more information about profiles, see [Installing the Tanzu Application Platform Package and Profiles](../../../install-online/profile.hbs.md).

## <a id='cnr-prereqs'></a>Prerequisites

Before installing Cloud Native Runtimes:

- Complete all prerequisites to install Tanzu Application Platform. For more information, see [Prerequisites](../../../prerequisites.hbs.md).
- Contour is installed in the cluster. You can install Contour from the [Tanzu Application package repository](../../../contour/how-to-guides/install.hbs.md). If you have have an existing Contour installation, see [Installing Cloud Native Runtimes with an Existing Contour Installation](../contour.hbs.md).

- By default, Tanzu Application Platform installs and uses a self-signed certificate authority for issuing TLS certificates to components by using ingress issuer. For more information, see [Ingress Certificates](../../../security-and-compliance/about.hbs.md).
  To install Cloud Native Runtimes, you must set the `shared.ingress_domain` or `cnrs.domain_name` property when you set `ingress_issuer`. For example:

  ```console
  shared:
    ingress_domain: "foo.bar.com"
  ```

  or

  ```console
  cnrs:
    domain_name: "foo.bar.com"
  ```

  If the domain name is not available or not what you want, you can set the domain name to any valid value if no process relies on the domain name resolving to the envoy IP.
  VMware discourages this for production environments. Another alternative to bypass setting domain name is to deactivate auto-TLS. For more information, see [Disabling Automatic TLS Certificate Provisioning](../auto-tls/tls-guides-deactivate-autotls.hbs.md).

## <a id='cnr-install'></a> Install

To install Cloud Native Runtimes:

1. List version information for the package by running:

    ```console
    tanzu package available list cnrs.tanzu.vmware.com --namespace tap-install
    ```

     For example:

    ```console
    tanzu package available list cnrs.tanzu.vmware.com --namespace tap-install

      NAME                   VERSION  RELEASED-AT
      cnrs.tanzu.vmware.com  2.4.0    2023-06-05 19:00:00 -0500 -05
    ```

1. (Optional) Make changes to the default installation settings:

    1. Gather the values schema.

        ```console
        tanzu package available get cnrs.tanzu.vmware.com/2.4.0 --values-schema -n tap-install
        ```

    1. Create a `cnr-values.yaml` file by using the following example as a guide to configure Cloud Native Runtimes:

        >**Note** For most installations, you can leave the `cnr-values.yaml` empty, and use the default values.

        ```console
        ---
        # Configures the domain that Knative Services will use
        domain_name: "mydomain.com"
        ```

       **Configuration Notes**:

       - If you are using a single-node cluster, such as kind, set the `lite.enable: true`
        option to lower CPU and memory requests for resources. To deactivate pod disruption budgets
        on Knative Serving, if high availability is not indispensable in your development environment, you can set `pbd.enable` to `false`.

        - Cloud Native Runtimes reuses the existing `tanzu-system-ingress` Contour installation for
        external and internal access when installed in the `full` profile.
        To use a separate Contour installation for system-internal traffic, set
        `cnrs.contour.internal.namespace` to the namespace of your separate Contour installation.

        - If you install Cloud Native Runtimes with the default value of `true` for the `allow_manual_configmap_update` configuration, you can only update some ConfigMaps manually. To update all ConfigMaps using overlays, change this value to `false`.

2. Install the package by running:

    ```console
    tanzu package install cloud-native-runtimes -p cnrs.tanzu.vmware.com -v 2.4.0 -n tap-install -f cnr-values.yaml --poll-timeout 30m
    ```

    For example:

    ```console
    tanzu package install cloud-native-runtimes -p cnrs.tanzu.vmware.com -v 2.4.0 -n tap-install -f cnr-values.yaml --poll-timeout 30m

    | Installing package 'cnrs.tanzu.vmware.com'
    | Getting package metadata for 'cnrs.tanzu.vmware.com'
    | Creating service account 'cloud-native-runtimes-tap-install-sa'
    | Creating cluster admin role 'cloud-native-runtimes-tap-install-cluster-role'
    | Creating cluster role binding 'cloud-native-runtimes-tap-install-cluster-rolebinding'
    - Creating package resource
    - Package install status: Reconciling

     Added installed package 'cloud-native-runtimes' in namespace 'tap-install'
    ```

3. Verify the package install by running:

    ```console
    tanzu package installed get cloud-native-runtimes -n tap-install
    ```

    For example:

    ```console
    tanzu package installed get cloud-native-runtimes -n tap-install

    Retrieving installation details for cloud-native-runtimes...
    NAME:                    cloud-native-runtimes
    PACKAGE-NAME:            cnrs.tanzu.vmware.com
    PACKAGE-VERSION:         2.4.0
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:
    ```

    Verify that `STATUS` is `Reconcile succeeded`.
