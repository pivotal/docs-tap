# <a id='uninstalling'></a> Uninstalling Tanzu Application Platform

This document describes how to uninstall Tanzu Application Platform packages from the TAP package repository.

The process for uninstalling Tanzu Application Platform is made up of two tasks:

+ [Delete the Packages](#del-packages)

+ [Delete the TAP Package Repository](#del-repo)

## <a id='del-packages'></a> Delete the Packages

To delete the installed packages:

1. List the installed packages.
   See [Verify the Installed Packages](./install.html#verify).

2. Remove a package by running:

    ```
    tanzu package installed delete PACKAGE-NAME -n tap-install
    ```
    For example:
    <pre class="pre codeblock vm-code-block prettyprint">
    $ tanzu package installed delete cloud-native-runtimes -n tap-install
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

    Where `PACKAGE-NAME` is the name of a package listed in step 1 above.

3. Repeat step 2 for each package installed.


## <a id='del-repo'></a>Delete the TAP Package Repository

To delete the TAP package repository:

1. Retrieve the name of the TAP package repository by running the command:
    ```
    tanzu package repository list -n tap-install
    ```
    For example:
    <pre class="pre codeblock vm-code-block prettyprint">
    $ tanzu package repository list -n tap-install
    / Retrieving repositories...
      NAME                                           REPOSITORY                                                         STATUS               DETAILS  
      tanzu-application-platform-package-repository  registry.pivotal.io/tanzu-application-platform/tap-packages:0.1.0  Reconcile succeeded
    </pre>

2. Remove the TAP package repository by running:

    ```
    tanzu package repository delete PACKAGE-REPO-NAME -n tap-install
    ```

    Where `PACKAGE-REPO-NAME` is the name of the packageRepository from step 1 above.

    For example:
    <pre class="pre codeblock vm-code-block prettyprint">
    $ tanzu package repository delete tanzu-application-platform-package-repository -n tap-install
    - Deleting package repository 'tanzu-application-platform-package-repository'...
     Deleted package repository 'tanzu-application-platform-package-repository' in namespace 'tap-install'
    </pre>
