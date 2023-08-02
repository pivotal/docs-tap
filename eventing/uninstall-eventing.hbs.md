# Uninstalling Eventing

This topic tells you how to uninstall Eventing.

## Overview

Eventing is part of the Tanzu Application Platform package repository. For information on uninstalling the entire Tanzu Application Platform package repository, see the [Tanzu Application Platform uninstall documentation](https://docs.vmware.com/en/Tanzu-Application-Platform/1.7/tap/uninstall.html).

## Uninstall

To uninstall Eventing specifically:

1. Delete the installed package:
    ```sh
    tanzu package installed delete eventing --namespace tap-install
    ```
