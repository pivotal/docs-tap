# Custom resources

It is possible deploy workshop images directly to a container runtime, but, for managing
deployments into a Kubernetes cluster,
the Learning Center Operator is provided. The operation of the Learning Center Operator is controlled
by using a set of Kubernetes custom resource definitions (CRDs).

Not all possible fields are shown in the examples of each custom resource type that follow.
Later documentation is expected to go in-depth on all the possible fields that can be set and what
they do.

## <a id="workshop-def-resource"></a> Workshop definition resource

The `Workshop` custom resource defines a workshop. It specifies the title and description of the
workshop, the location of the workshop content or container image to be deployed, any resources to
be pre-created in the workshop environment or for each instance of the workshop.

You can also define environment variables to be set for the workshop image when deployed, the amount
of CPU and memory resources for the workshop instance, and any overall quota to be applied to
namespaces created for the user and as well as what the workshop uses.

A minimal example of the `Workshop` custom resource is:

```
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: Workshop
metadata:
  name: lab-markdown-sample
spec:
  title: Markdown Sample
  description: A sample workshop using Markdown
  content:
    files: github.com/eduk8s/lab-markdown-sample
  session:
    namespaces:
      budget: small
    applications:
      console:
        enabled: true
      editor:
        enabled: true
```

When an instance of the `Workshop` custom resource is created it does not cause any immediate
action by the Learning Center Operator. This custom resource exists only to define the workshop.

The `Workshop` custom resource is created at cluster scope.

## <a id="workshop-env-resource"></a> Workshop environment resource

To deploy instances of a workshop, first you must create a workshop environment.
The configuration for the workshop environment and which workshop definition specifies the
details of the workshop to be deployed are defined the by the `WorkshopEnvironment` custom resource.

A minimal example of the `WorkshopEnvironment` custom resource is:

```
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: WorkshopEnvironment
metadata:
  name: lab-markdown-sample
spec:
  workshop:
    name: lab-markdown-sample
  request:
    token: lab-markdown-sample
  session:
    username: learningcenter
```

When an instance of the `WorkshopEnvironment` custom resource is created, the Learning Center Operator
responds by creating a namespace for hosting the workshop instances defined by the `Workshop` resource
specified by the `spec.workshop.name` field. The namespace created uses the same name as specified by
the `metadata.name` field of the `WorkshopEnvironment` resource.

The `spec.request.token` field defines a token which must be supplied with a request to create an
instance of a workshop in this workshop environment.
If necessary, the namespaces from which a request for a workshop instance can be initiated can also
be specified.

If the `Workshop` definition for the workshop to be deployed in this workshop environment defines
a set of common resources which must exist for the workshop, these are created by the
Learning Center Operator after the namespace for the workshop environment is created.
Where such resources are namespaced, they are created in the namespace for the workshop environment.
If necessary, these resources can include creation of separate namespaces with specific resources
created in those namespaces instead.

The `WorkshopEnvironment` custom resource is created at cluster scope.

## <a id="workshop-request-resource"></a> Workshop request resource

To create an instance of the workshop under the workshop environment which was created, the typical
path is to create an instance of the `WorkshopRequest` custom resource.

The `WorkshopRequest` custom resource is namespaced to allow who can create it and request a
workshop instance to be created, to be controlled by using Role-based access control (RBAC). This means you can allow
non-privileged users to create workshops, although the deployment of the workshop instance might
require elevated privileges.

A minimal example of the `WorkshopRequest` custom resource is:

```
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: WorkshopRequest
metadata:
  name: lab-markdown-sample
spec:
  environment:
    name: lab-markdown-sample
    token: lab-markdown-sample
```

Apart from needing to have appropriate access from RBAC, the only information that the user
requesting a workshop instance must know is the name of the workshop environment for the
workshop and the secret token that permits workshop requests against that specific workshop
environment.

The `WorkshopRequest` resource is not used when you use the `TrainingPortal` resource to provide a
web interface for accessing workshops. The `WorkshopRequest` resource is only used where you create
the `WorkshopEnvironment` resource manually and do not use the training portal.

## <a id="workshop-session-resource"></a> Workshop session resource

Although `WorkshopRequest` is the typical way that workshop instances are requested, upon
the request being granted, the Learning Center Operator itself creates an instance of a
`WorkshopSession` custom resource.

The `WorkshopSession` custom resource is the expanded definition of what the workshop instance is.
It combines details from `Workshop` and `WorkshopEnvironment`, and also
links back to the `WorkshopRequest` resource object that triggered the request.
The Learning Center Operator reacts to an instance of `WorkshopSession` and creates the workshop
instance based on that definition.

The `WorkshopSession` custom resource is created at the cluster scope.

## <a id="training-portal-resource"></a> Training portal resource

The `TrainingPortal` custom resource provides a high-level mechanism for creating a set of
workshop environments and populating them with workshop instances.

A minimal example of the `TrainingPortal` custom resource is:

```
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: TrainingPortal
metadata:
  name: lab-markdown-sample
spec:
  workshops:
  - name: lab-markdown-sample
    capacity: 1
```

You can set the capacity of the training room, which dictates how many workshop instances
are created for each workshop.

The `TrainingPortal` custom resource is created at cluster scope.

## <a id="system-profile-resource"></a> System profile resource

The `SystemProfile` custom resources provides a mechanism for configuring the Learning Center
Operator. This provides additional features above using using environment variables to configure the
operator.

A minimal example of the `SystemProfile` custom resource is:

```
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: SystemProfile
metadata:
  name: default-system-profile
spec:
  ingress:
    domain: learningcenter.tanzu.vmware.com
    secret: learningcenter-tanzu-vmware-com-tls
    class: nginx
  environment:
    secrets:
      pull:
      - cluster-image-registry-pull
```

The operator, by default, looks for a default system profile called `default-system-profile`.
The name of the default can be overridden globally by setting the `SYSTEM_PROFILE` environment
variable on the deployment for the operator or for specific deployments by using the `system.profile`
setting on `TrainingPortal`, `WorkshopEnvironment`, or `WorkshopSession` custom resources.

As only a global deployment of the operator is supported, the `SystemProfile` custom resource
is created at cluster scope.

You can make changes to instances of the `SystemProfile` custom resource.
The Learning Center Operator uses these changes without needing to redeploy the custom resource.

The `SystemProfile` custom resource is created at cluster scope.

## <a id="loading-workshop-crds"></a> Loading the workshop CRDs

The custom resource definitions for the custom resource described earlier are created in the
Kubernetes cluster when you deploy the Learning Center operator using the Tanzu CLI.

This is because `v1` versions of CRDs are only supported from Kubernetes v1.17.
If for some reason you need to use the `v1` versions of the CRDs at this time, you must create a copy
of the Learning Center operator deployment resources and override the configuration so that the `v1`
versions are used.
