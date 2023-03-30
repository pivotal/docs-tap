# Uninstall Tanzu Application Platform by using Tanzu CLI

This document describes how to uninstall Tanzu Application Platform packages from the
Tanzu Application Platform package repository by using Tanzu CLI.

To uninstall Tanzu Application Platform:

- [Delete the Packages](#del-packages)
- [Delete the Tanzu Application Platform Package Repository](#del-repo)
- [Remove Tanzu CLI, plug-ins, and associated files](#remove-tanzu-cli)
- [Remove Cluster Essentials](#remove-ce)

## <a id='del-packages'></a> Delete the packages

- If you installed Tanzu Application Platform through predefined profiles, 
delete the `tap` metadata package by running:

    ```console
    tanzu package installed delete tap --namespace tap-install
    ```

- If you installed any additional packages that were not in the predefined profiles, 
delete the individual packages by running:

    1. List the installed packages by running:

        ```console
        tanzu package installed list --namespace tap-install
        ```

    2. Remove a package by running:

        ```console
        tanzu package installed delete PACKAGE-NAME --namespace tap-install
        ```

        For example:

        ```console
        $ tanzu package installed delete cloud-native-runtimes --namespace tap-install
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
        ```

        Where `PACKAGE-NAME` is the name of a package listed in step 1.

    3. Repeat step 2 for each individual package installed.

## <a id='del-repo'></a>Delete the Tanzu Application Platform package repository

To delete the Tanzu Application Platform package repository:

1. Retrieve the name of the Tanzu Application Platform package repository by running:

    ```console
    tanzu package repository list --namespace tap-install
    ```

    For example:

    ```console
    $ tanzu package repository list --namespace tap-install
    - Retrieving repositories...
      NAME                  REPOSITORY                                                         STATUS               DETAILS
      tanzu-tap-repository  registry.tanzu.vmware.com/tanzu-application-platform/tap-packages:0.2.0  Reconcile succeeded
    ```

2. Remove the Tanzu Application Platform package repository by running:

    ```console
    tanzu package repository delete PACKAGE-REPO-NAME --namespace tap-install
    ```

    Where `PACKAGE-REPO-NAME` is the name of the packageRepository from the earlier step.

    For example:

    ```console
    $ tanzu package repository delete tanzu-tap-repository --namespace tap-install
    - Deleting package repository 'tanzu-tap-repository'...
     Deleted package repository 'tanzu-tap-repository' in namespace 'tap-install'
    ```

## <a id='remove-tanzu-cli'></a> Remove Tanzu CLI, plug-ins, and associated files

To completely remove the Tanzu CLI, plug-ins, and associated files, run the script for your OS:

+ For Linux or MacOS, run:

    ```console
    #!/bin/zsh
    rm -rf $HOME/tanzu/cli        # Remove previously downloaded cli files
    sudo rm /usr/local/bin/tanzu  # Remove CLI binary (executable)
    rm -rf ~/.config/tanzu/       # current location # Remove config directory
    rm -rf ~/.tanzu/              # old location # Remove config directory
    rm -rf ~/.cache/tanzu         # remove cached catalog.yaml
    rm -rf ~/Library/Application\ Support/tanzu-cli/* # Remove plug-ins
    ```

## <a id='remove-ce'></a> Remove Cluster Essentials

To completely remove Cluster Essentials, see [Cluster Essentials documentation](https://docs.vmware.com/en/Cluster-Essentials-for-VMware-Tanzu/{{ vars.url_version }}/cluster-essentials/deploy.html#uninstall).
