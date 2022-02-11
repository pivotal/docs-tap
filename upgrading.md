# Upgrading Tanzu Application Platform

This document describes how to upgrade Tanzu Application Platform from 1.0 to 1.0.1.

You can perform a fresh install of Tanzu Application Platform `1.0.1` by following the instructions
[Installing Tanzu Application Platform](install-intro.html).

## Add new package repository

Add the `1.0.1` version of the Tanzu Application Platform package repository

```
tanzu package repository update tanzu-tap-repository \
    --url registry.tanzu.vmware.com/tanzu-application-platform/tap-packages:1.0.1  \
    --namespace tap-install
```

## Update version of the installed package

For example, a profile-based install:
```
tanzu package installed update tap -p tap.tanzu.vmware.com -v 1.0.1  --values-file tap-values.yaml -n tap-install
```

## Component-specific installation instructions

Please see additional information about [upgrading Tanzu Application Platform GUI](tap-gui/upgrades.html).

## Verify the upgrade

Verify the versions of packages have been updated by running:

```
tanzu package installed list --namespace tap-install
```
