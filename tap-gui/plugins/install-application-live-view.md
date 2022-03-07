# Install Application Live View

This document describes how to install Application Live View
from the Tanzu Application Platform package repository.

- Application Live View installs two packages for `full` and `light` profiles.

- Application Live View Package (`run.appliveview.tanzu.vmware.com`) contains Application Live View
back-end and connector components.

- Application Live View Conventions Package (`build.appliveview.tanzu.vmware.com`) contains
Application Live View Convention Service only.

>**Note:** Use the instructions on this page if you do not want to use a profile to install packages.
Both the full and light profiles include Application Live View.
For more information about profiles, see [Installing the Tanzu Application Platform Package and Profiles](../../install.md).

## <a id='prereqs'></a>Prerequisites

Before installing Application Live View:

- Complete all prerequisites to install Tanzu Application Platform. For more information, see [Prerequisites](../../prerequisites.md).

## <a id='install-app-live-view'></a> Install Application Live View

To install Application Live View:

1. List version information for both packages by running:

    ```
    tanzu package available list run.appliveview.tanzu.vmware.com --namespace tap-install
    tanzu package available list build.appliveview.tanzu.vmware.com --namespace tap-install
    ```

    For example:

    ```
    $ tanzu package available list run.appliveview.tanzu.vmware.com --namespace tap-install
    - Retrieving package versions for run.appliveview.tanzu.vmware.com...
      NAME                              VERSION        RELEASED-AT
      run.appliveview.tanzu.vmware.com  1.0.2          2022-02-07T00:00:00Z

    $ tanzu package available list build.appliveview.tanzu.vmware.com --namespace tap-install
    - Retrieving package versions for build.appliveview.tanzu.vmware.com...
      NAME                                VERSION        RELEASED-AT
      build.appliveview.tanzu.vmware.com  1.0.2          2022-02-07T00:00:00Z
    ```

1. Create `app-live-view-values.yaml` with the following details:

    ```
    ---
    ```
    >**Note:** The `app-live-view-values.yaml` section does not have any values schema for both
    >packages, therefore it is empty.

    The Application Live View back-end and connector are deployed in `app-live-view` namespace by default. The connector is deployed as a `DaemonSet`. There is one connector instance per node in the Kubernetes cluster. This instance observes all the apps running on that node.
    The Application Live View Convention Server is deployed in the `alv-convention` namespace by default. The convention server enhances PodIntents with metadata including labels, annotations, or application properties.

1. Install the Application Live View package by running:

    ```
    tanzu package install appliveview -p run.appliveview.tanzu.vmware.com -v 1.0.2 -n tap-install -f app-live-view-values.yaml
    ```

    For example:

    ```
    $ tanzu package install appliveview -p run.appliveview.tanzu.vmware.com -v 1.0.2 -n tap-install -f app-live-view-values.yaml
    - Installing package 'run.appliveview.tanzu.vmware.com'
    | Getting package metadata for 'run.appliveview.tanzu.vmware.com'
    | Creating service account 'app-live-view-tap-install-sa'
    | Creating cluster admin role 'app-live-view-tap-install-cluster-role'
    | Creating cluster role binding 'app-live-view-tap-install-cluster-role binding'
    | Creating secret 'app-live-view-tap-install-values'
    - Creating package resource
    - Package install status: Reconciling

     Added installed package 'appliveview' in namespace 'tap-install'
    ```

1. Install the Application Live View conventions package by running:

    ```
    tanzu package install appliveview-conventions -p build.appliveview.tanzu.vmware.com -v 1.0.2 -n tap-install -f app-live-view-values.yaml
    ```

    For example:

    ```
    $ tanzu package install appliveview-conventions -p build.appliveview.tanzu.vmware.com -v 1.0.2 -n tap-install -f app-live-view-values.yaml
    - Installing package 'build.appliveview.tanzu.vmware.com'
    | Getting package metadata for 'build.appliveview.tanzu.vmware.com'
    | Creating service account 'app-live-view-tap-install-sa'
    | Creating cluster admin role 'app-live-view-tap-install-cluster-role'
    | Creating cluster role binding 'app-live-view-tap-install-cluster-role binding'
    | Creating secret 'app-live-view-tap-install-values'
    - Creating package resource
    - Package install status: Reconciling

     Added installed package 'appliveview-conventions' in namespace 'tap-install'
    ```

    For more information about Application Live View,
    see the [Application Live View documentation](https://docs.vmware.com/en/Application-Live-View-for-VMware-Tanzu/1.0/docs/GUID-index.html).

1. Verify the `Application Live View` package installation by running:

    ```
    tanzu package installed get appliveview -n tap-install
    ```

    For example:

    ```
    tanzu package installed get appliveview -n tap-install
    | Retrieving installation details for cc...
    NAME:                    appliveview
    PACKAGE-NAME:            run.appliveview.tanzu.vmware.com
    PACKAGE-VERSION:         1.0.2
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:
    ```

    Verify that `STATUS` is `Reconcile succeeded`

1. Verify the package install for `Application Live View Conventions` package by running:

    ```
    tanzu package installed get appliveview-conventions -n tap-install
    ```

    For example:

    ```
    tanzu package installed get appliveview-conventions -n tap-install
    | Retrieving installation details for cc...
    NAME:                    appliveview-conventions
    PACKAGE-NAME:            build.appliveview.tanzu.vmware.com
    PACKAGE-VERSION:         1.0.2
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:
    ```

    Verify that `STATUS` is `Reconcile succeeded`

The Application Live View UI plug-in is part of Tanzu Application Platform GUI.
To access the Application Live View UI,
see [Application Live View in Tanzu Application Platform GUI](app-live-view.md).
