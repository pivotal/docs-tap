# Runtime Configuration options

Platform Engineers can provide a series of options to the Tanzu Developer Portal package in order to configure it as well as do some basic [runtime customization](./customize/customize-portal.hbs.md).

## <a id="identify"></a> Identify version of Tanzu Developer Portal you have available

The Tanzu CLI can be used to identify the version of Tanzu Developer portal that is available to configure. Use the following command to show the package version:
```
tanzu package available get tap-gui.tanzu.vmware.com -n INSTALL-NAMESPACE
```

Where:

- `INSTALL-NAMESPACE` is the namespace in which you have configuraed the Tanzu Application Platform installation (most often `tap-install`)

For example:

```shell
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

## <a id="values-schema"></a> Display the possible values options for Tanzu Developer Portal

The Tanzu CLI can be used to identify the version of Tanzu Developer portal that is available to configure. Use the following command to show the package version:
```
tanzu package available get tap-gui.tanzu.vmware.com/VERSION --values-schema -n INSTALL-NAMESPACE
```

Where:

- `VERSION` is the version retrieved from the prior command
- `INSTALL-NAMESPACE` is the namespace in which you have configuraed the Tanzu Application Platform installation (most often `tap-install`)
For example:

```shell
$ tanzu package available get tap-gui.tanzu.vmware.com/1.7.6 --values-schema -n tap-install

  KEY                                                                 DEFAULT   TYPE     DESCRIPTION
  #Details of all the possible configuration values
  ...
```