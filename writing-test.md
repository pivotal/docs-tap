# Writing test

# WorkshopSession Resource

The WorkshopSession custom resource defines a workshop session.

## Specifying the session identity

When running training for multiple people, it would be more typical to use the TrainingPortal custom resource to setup a training environment. Alternatively you would set up a Workshop environment using the WorkshopEnvironment custom Resource, then create requests for Workshop instances using the WorkshopRequest Custom Resource. If doing the latter and you need more control over how the workshop instances are setup, you may use WorkshopSession custom resource instead of WorkshopRequest.

Note that to specify the workshop environment the workshop instance is created against, set the environment.name field of the specification for the workshop session. At the same time, you must specify the session ID for the Workshop instance.

```yaml
<strong>apiVersion</strong>: learningcenter.tanzu.vmware.com/v1beta1
kind: WorkshopSession
metadata:
  name: lab-markdown-sample-user1
spec:
  environment:
    name: lab-markdown-sample
  session:
    id: user1
```

The name of the workshop specified in the metadata of the training environment needs to be globally unique for the workshop instance being created. You actually need to create a separate WorkshopSession custom resource for each workshop instance you want.

The session ID needs to be unique within the workshop environment the workshop instance is being created against. Also, it's important to note that user access to each workshop instance can be controlled through login credentials. This is so that a workshop attendee cannot interfere with another.

# <a id='cluster-context'></a> Set the Kubernetes cluster context

Next, if you haven't already done so, you need to set the Kubernetes cluster context. Here are the steps you need to follow:

1. List the existing contexts by running the following command:
```console
kubectl config get-contexts
```
For example:
```console
$ kubectl config get-contexts
CURRENT   NAME                                CLUSTER           AUTHINFO                                NAMESPACE
        aks-repo-trial                      aks-repo-trial    clusterUser_aks-rg-01_aks-repo-trial
*       aks-tap-cluster                     aks-tap-cluster   clusterUser_aks-rg-01_aks-tap-cluster
```
1. Set the context to the cluster that you want to use for the TAP packages installation. For example, set the context to the `aks-tap-cluster` context by running this command:
```console
kubectl config use-context aks-tap-cluster
```
For example:
```console
$ kubectl config use-context aks-tap-cluster
Switched to context "aks-tap-cluster".
```
