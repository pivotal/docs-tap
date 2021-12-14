# Deleting Learning Center

If you ever want to uninstall the Learning Center operator, first delete all current workshop environments. 
You can do this by running:

```
kubectl delete workshops,trainingportals,workshoprequests,workshopsessions,workshopenvironments --all
```

The Learning Center operator must still be running when you do this.

To make sure everything is deleted, run:

```
kubectl get workshops,trainingportals,workshoprequests,workshopsessions,workshopenvironments --all-namespaces
```

To uninstall the Learning Center operator, then run:

```
kubectl delete -k "github.com/eduk8s/eduk8s?ref=master"
```

This will also remove the custom resource definitions which were added, and the learningcenter namespace.
