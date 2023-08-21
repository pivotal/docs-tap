# Uninstalling Cloud Native Runtimes

This topic tells you how to uninstall Cloud Native Runtimes.

## Overview

Cloud Native Runtimes is part of the Tanzu Application Platform package repository. For information on uninstalling the entire Tanzu Application Platform package repository, see the [Tanzu Application Platform uninstall documentation](https://docs.vmware.com/en/Tanzu-Application-Platform/1.5/tap/uninstall.html).

## Uninstall

To uninstall Cloud Native Runtimes specifically:

1. Delete the installed package:
    ```sh
    tanzu package installed delete cloud-native-runtimes --namespace tap-install
    ```
