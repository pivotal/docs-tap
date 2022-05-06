# Learning Center Workshops

Workshops are where you create your content. You can create a workshop for individual use or group multiple workshops
together with a [Training Portal](training-portal.md). The following helps you get started with workshops. For more
detailed instructions, go to [Working with Learning Center Workshops](../workshop-content/about.md)

## <a id="create-workshop-env"></a>Creating the workshop environment

With the definition of a workshop already in existence, the first step to deploying a workshop is to
create the workshop environment.

To create the workshop environment run:

```console
kubectl apply -f {YOUR-GIT-REPO-URL}/lab-k8s-fundamentals/master/resources/workshop-environment.yaml
```

This results in a custom resource being created called `WorkshopEnvironment`:

```console
workshopenvironment.learningcenter.tanzu.vmware.com/lab-k8s-fundamentals created
```

The custom resource created is cluster-scoped, and the command needs to be run as a cluster admin or other appropriate
user with permission to create the resource.

The Learning Center Operator reacts to the creation of this custom resource and initializes the workshop environment.

For each distinct workshop environment, a separate namespace is created. This namespace is used to hold the
workshop instances. The namespace may also be used to provision any shared application services the workshop definition
describes which would be used across all workshop instances. Such shared application services are automatically
provisioned by the Learning Center Operator when the workshop environment is created.

You can list the workshop environments which have been created by running:

```console
kubectl get workshopenvironments
```

This results in the output:

```console
NAME                   NAMESPACE              WORKSHOP               IMAGE                                             URL
lab-k8s-fundamentals   lab-k8s-fundamentals   lab-k8s-fundamentals   {YOUR-REGISTRY-URL}/lab-k8s-fundamentals:master   {YOUR-GIT-REPO-URL}/lab-k8s-fundamentals
```

Additional fields give the name of the workshop environment, the namespace created for the workshop environment, and
the name of the workshop the environment was created from.

## <a id="request-workshop-instance"></a> Requesting a workshop instance

To request a workshop instance, a custom resource of type `WorkshopRequest` needs to be created.

This is a namespaced resource allowing who can create them to be delegated using role-based access controls.
Further, in order to be able to request an instance of a specific workshop, you need to know the secret token specified
in the description of the workshop environment. If necessary, raising requests against a specific workshop
environment can also be constrained to a specific set of namespaces on top of any defined role-based access control (RBAC) rules.

In the context of an appropriate namespace, run:

```console
kubectl apply -f {YOUR-GIT-REPO-URL}/lab-k8s-fundamentals/master/resources/workshop-request.yaml
```

This should result in the output:

```console
workshoprequest.learningcenter.tanzu.vmware.com/lab-k8s-fundamentals created
```

You can list the workshop requests in a namespace by running:

```console
kubectl get workshoprequests
```

This displays output similar to:

```console
NAME                   URL                                      USERNAME   PASSWORD
lab-k8s-fundamentals   http://lab-k8s-fundamentals-cvh51.test   learningcenter     buQOgZvfHM7m
```

The additional fields provide the URL where the workshop instance can be accessed and the username and password for you to
provide when prompted by your web browser.

The user name and password only come into play when you use the lower-level resources to set up workshops. If
you use the `TrainingPortal` custom resource, you will see that these fields are empty. This is because, for that case,
the workshop instances are deployed so that they rely on user registration and access mediated by the web-based
training portal. Visiting the URL for a workshop instance directly when using `TrainingPortal`, redirects you back
to the web portal in order to log in if necessary.

You can monitor the progress of this workshop deployment by listing the deployments in the namespace created for the
workshop environment:

```console
kubectl get all -n lab-k8s-fundamentals
```

For each workshop instance a separate namespace is created for the session. This is linked to the workshop instance, and
is where any applications are deployed as part of the workshop. If the definition of the workshop includes a
set of resources that should be automatically created for each session namespace, they are created by the Learning
Center Operator. It is therefore possible to pre-deploy applications for each session.

In this case, we used `WorkshopRequest`; whereas when using `TrainingPortal`, we created a `WorkshopSession`.
The workshop request does result in creating a `WorkshopSession`, but `TrainingPortal` skips the
workshop request and directly creates a `WorkshopSession`.

The purpose of having `WorkshopRequest` as a separate custom resource is to allow RBAC and other controls to be used
to allow non-cluster administrators to create workshop instances.

## <a id="delete-workshop-instance"></a> Deleting the workshop instance

When you have finished with the workshop instance, you can delete it by deleting the custom resource for the workshop
request:

```console
kubectl delete workshoprequest/lab-k8s-fundamentals
```

## <a id="delete-workshop-env"></a>Deleting the workshop environment

If you want to delete the whole workshop environment, it is recommended to first delete all workshop instances. Once
this has been done, you can then delete the custom resource for the workshop environment:

```console
kubectl delete workshopenvironment/lab-k8s-fundamentals
```

If you don't delete the custom resources for the workshop requests, the workshop instances are still cleaned up and
removed when the workshop environment is removed. The custom resources for the workshop requests still remain, however,  
and need to be deleted separately.
