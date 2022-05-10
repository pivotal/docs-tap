# Uninstalling Application Live View for VMware Tanzu

This topic describes how to uninstall Application Live View for VMware Tanzu.

To uninstall the Application Live View and Application Live View Convention Server, run:

```
kapp list -A    ## Lists all the applications
kapp delete -n app-live-view -a application-live-view
kapp delete -n alv-convention -a application-live-view-conventions
kubectl delete ns app-live-view
kubectl delete ns alv-convention
```
