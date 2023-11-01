# Runtime configuration options for Tanzu Application Platform GUI

You can provide a series of options to the Tanzu Application Platform GUI (commonly called TAP GUI)
package to configure it and do some basic [runtime customization](customize/customize-portal.hbs.md).

## <a id="identify"></a> Identify the Tanzu Application Platform GUI version you have available

From the Tanzu CLI, discover the Tanzu Application Platform GUI package version that is available to
configure by running:

```console
tanzu package available get tap-gui.tanzu.vmware.com -n INSTALL-NAMESPACE
```

Where `INSTALL-NAMESPACE` is the namespace in which you configured the Tanzu Application Platform
installation. In most cases the namespace is `tap-install`.

For example:

```console
$ tanzu package available get tap-gui.tanzu.vmware.com -n tap-install

NAME:                   tap-gui.tanzu.vmware.com
DISPLAY-NAME:           Tanzu Application Platform GUI
CATEGORIES:
SHORT-DESCRIPTION:      web app graphical user interface for Tanzu Application Platform
LONG-DESCRIPTION:       web app graphical user interface for Tanzu Application Platform
PROVIDER:               VMware
MAINTAINERS:            - name: VMware
SUPPORT-DESCRIPTION:    https://tanzu.vmware.com/support

  VERSION  RELEASED-AT
  1.7.6    2023-10-17 00:25:21 +0000 UTC
```

## <a id="values-schema"></a> Display the possible values options for Tanzu Application Platform GUI

From the Tanzu CLI, identify possible values options for Tanzu Application Platform GUI by running:

```console
tanzu package available get tap-gui.tanzu.vmware.com/VERSION --values-schema -n INSTALL-NAMESPACE
```

Where:

- `VERSION` is the Tanzu Application Platform GUI package version you learned earlier
- `INSTALL-NAMESPACE` is the namespace in which you configured the Tanzu Application Platform
  installation. In most cases the namespace is `tap-install`.

For example:

```console
$ tanzu package available get tap-gui.tanzu.vmware.com/1.7.6 --values-schema -n tap-install

  KEY                                                                 DEFAULT   TYPE     DESCRIPTION
  #Details of all the possible configuration values
  ...
```