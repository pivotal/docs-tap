# Deleting Learning Center

If you ever want to uninstall the Learning Center operator, first delete all current workshop environments.
You can do this by running:

```
kubectl delete workshops,trainingportals,workshoprequests,workshopsessions,workshopenvironments --all
```

The Learning Center operator must still be running when you do this.

To make sure everything is deleted (Workshops on the workshops.learningcenter.tanzu.vmware.com package will not be deleted with this command), run:

```
kubectl get workshops,trainingportals,workshoprequests,workshopsessions,workshopenvironments --all-namespaces
```

To uninstall the Learning Center package, run:

```
tanzu package installed delete {NAME_OF_THE_PACKAGE} -n tap-install
```

This also removes the custom resource definitions that were added, and the learningcenter namespace.

<hr>

**Note:**

If you have installed the TAP package, Learning Center will be recreated again. In order to remove the Learning Center package you can add the following lines to your tap-values file.
```
excluded_packages:
- learningcenter.tanzu.vmware.com
- workshops.learningcenter.tanzu.vmware.com
```

