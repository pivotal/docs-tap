# Upgrading Cloud Native Runtimes

This topic tells you how to upgrade Cloud Native Runtimes for Tanzu to the latest version.

## <a id='overview'></a> Overview

New versions of Cloud Native Runtimes are available from the Tanzu Application Platform package repository, and you can upgrade as part of [upgrading Tanzu Application Platform](../../../upgrading.hbs.md).

## <a id='prerecs'></a> Prerequisites

The following prerequisites are required to upgrade Cloud Native Runtimes:

- An updated Tanzu Application Platform package repository with the version of Cloud Native Runtimes you want to upgrade to. For more information, see [Upgrade your Tanzu Application Platform](../../../upgrading.hbs.md).

## <a id='upgrade-cnrs'></a> Upgrade Cloud Native Runtimes

>**Important** If you previously installed Cloud Native Runtimes v1.3 or earlier, and you want to upgrade to the latest version,
you must first upgrade to Cloud Native Runtimes v2.0.1.

If you have previously installed Cloud Native Runtimes v1.3 or an earlier version and want to upgrade to the latest version,
the Tanzu Application Platform now includes a shared ingress issuer by default. If you are using a single
certificate, such as `cnrs.contour.default_tls_secret` set in your tap-values.yaml file, and want to opt out of the default
shared ingress issuer, deactivate it. For information about opting out and deactivating the automatic TLS feature, see [Opt out from any ingress issuer and deactivate automatic TLS feature](../auto-tls/tls-guides-deactivate-autotls.hbs.md).

To upgrade the Cloud Native Runtimes PackageInstall specifically, run:

```console
tanzu package installed update cloud-native-runtimes -p cnrs.tanzu.vmware.com -v CNR-VERSION --values-file cnr-values.yaml -n tap-install
```

Where `CNR-VERSION` is the latest version of Cloud Native Runtimes available as part of the new Tanzu Application Platform package repository.
