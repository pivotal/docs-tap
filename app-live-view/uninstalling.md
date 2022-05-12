# Uninstalling Application Live View for VMware Tanzu

This topic describes how to uninstall Application Live View for VMware Tanzu in Tanzu Application Platform.

To uninstall the Application Live View Backend, Application Live View Connector and Application Live View Convention Server, run:

```
tanzu package installed delete appliveview -n tap-install
tanzu package installed delete appliveview-connector -n tap-install
tanzu package installed delete appliveview-conventions -n tap-install
```
