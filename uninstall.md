# <a id='uninstalling'></a> Uninstalling Tanzu Application Platform

This document describes how to uninstall Tanzu Application Platform packages from the TAP package repository.

The uninstall process is made up of two tasks:

+ [Delete the Packages](#del-packages)

+ [Delete the TAP Package Repository](#del-repo)

## <a id='del-packages'></a> Delete the Packages

<!---
What is the purpose of this procedure. Is like deleting the installer archive (DMG file)
on my laptop after I've successfully installed an app?
Or is it like a complete uninstall of the components, if I decide I don't want to use TAP afterall?
---->

To delete the installed packages:

1. Remove a package by running:

    ```
    tanzu package installed delete PACKAGE-NAME
    ```
    For example:
    <pre class='terminal'>
    tanzu package installed delete cloud-native-runtimes -n tap-install
    | Uninstalling package 'cloud-native-runtimes' from namespace 'tap-install'
    / Getting package install for 'cloud-native-runtimes'
    \ Deleting package install 'cloud-native-runtimes' from namespace 'tap-install'
    \ Package uninstall status: Reconciling
    / Package uninstall status: Deleting
    | Deleting admin role 'cloud-native-runtimes-tap-install-cluster-role'
    | Deleting role binding 'cloud-native-runtimes-tap-install-cluster-rolebinding'
    | Deleting secret 'cloud-native-runtimes-tap-install-values'
    / Deleting service account 'cloud-native-runtimes-tap-install-sa'    

     Uninstalled package 'cloud-native-runtimes' from namespace 'tap-install'
    </pre>

2. Repeat step 1 for each package installed.


## <a id='del-repo'></a>Delete the TAP Package Repository

To delete the TAP package repository:

1. Retrieve the name of the TAP package repository by running the command:

    ```
    tanzu package repository list -n tap-install
    / Retrieving repositories...
      NAME                                           REPOSITORY                                                         STATUS               DETAILS  
      tanzu-application-platform-package-repository  registry.pivotal.io/tanzu-application-platform/tap-packages:0.1.0  Reconcile succeeded
    ```

2. Remove the TAP package repository by running:

    ```
    tanzu package repository delete PACKAGE-REPO-NAME -n tap-install
    ```

    Where `PACKAGE-REPO-NAME` is the name of the packageRepository from step 1 above.

    For example:

    <pre class=terminal>
    tanzu package repository delete tanzu-application-platform-package-repository -n tap-install
    - Deleting package repository 'tanzu-application-platform-package-repository'...
     Deleted package repository 'tanzu-application-platform-package-repository' in namespace 'tap-install'
    </pre>
