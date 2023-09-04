# Uninstall Cloud Native Runtimes

This topic tells you how to uninstall Cloud Native Runtimes.

## <a id='overview'></a> Overview

Cloud Native Runtimes is part of the Tanzu Application Platform package repository. For information about uninstalling the entire Tanzu Application Platform package repository, see [Uninstall your Tanzu Application Platform by using Tanzu CLI](../../../uninstall.hbs.md).

## <a id='uninstall'></a> Uninstall

To uninstall Cloud Native Runtimes:

1. Delete the installed package:
    
    ```console
    tanzu package installed delete cloud-native-runtimes --namespace tap-install
    ```
