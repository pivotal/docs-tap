# Upgrading Eventing

This topic tells you how to upgrade Eventing for TAP to the latest version.

New versions of Eventing are available from the Tanzu Application Platform package repository, and can be upgraded to as part of [upgrading Tanzu Application Platform as a whole](https://docs.vmware.com/en/Tanzu-Application-Platform/1.7/tap/upgrading.html).

## <a id='prerecs'></a> Prerequisites

The following prerequisites are required to upgrade Eventing:

- An updated Tanzu Application Platform package repository with the version of Cloud Native Runtimes you wish to upgrade to. For more information, see the [documentation on adding a new package repository](https://docs.vmware.com/en/Tanzu-Application-Platform/1.7/tap/upgrading.html#add-new-package-repository-1).

## <a id='upgrade-eventing'></a> Upgrade Eventing

>**Note** If you previously installed Cloud Native Runtimes v1.3 or prior and, you wish to upgrade to the latest version,
you must first upgrade to Cloud Native Runtimes v2.0.1 and Eventing v2.0.1 separately. You can do so by following the [Upgrade from a previous version to Cloud Native Runtimes v2.0.1](https://docs.vmware.com/en/Cloud-Native-Runtimes-for-VMware-Tanzu/2.0/tanzu-cloud-native-runtimes/GUID-upgrade.html#upgrade-from-a-previous-version-to-cloud-native-runtimes-v201-1)
instructions.

>**Note** If you have previously installed Cloud Native Runtimes v1.3 or an earlier version (which Eventing was formerly bundled in) and wish to upgrade to the latest version,
please be aware that the Tanzu Application Platform now includes a shared ingress issuer by default. If you are currently using a single
certificate (for example, if you have set `cnrs.default_tls_secret` in your tap-values.yaml file) and want to opt out of the default
shared ingress issuer, it is important to deactivate it.

<!-- To learn how to opt out and deactivate the automatic TLS feature, please refer to the documentation: [Opt out from any ingress issuer and deactivate automatic TLS feature](tls-guides-deactivate-autotls.hbs.md). -->

To upgrade the Eventing PackageInstall specifically, run:

```sh
tanzu package installed update eventing -p eventing.tanzu.vmware.com -v EVENTING_VERSION --values-file eventing-values.yaml -n tap-install
```

Where `EVENTING_VERSION` is the latest version of Eventing available as part of the new Tanzu Application Platform package repository.
