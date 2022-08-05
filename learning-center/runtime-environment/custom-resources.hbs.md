# Custom resources

You can deploy workshop images directly to a container runtime. Learning Center Operator enables managing the deployments into a Kubernetes cluster. A set of Kubernetes custom resource definitions (CRDs) controls the operation of the Learning Center Operator.

>**Note:** The examples do not show all the possible fields of each custom resource type.
Later documentation will go in-depth on all the possible fields and their definitions.

## <a id="workshop-def-resource"></a> Workshop definition resource

The `Workshop` custom resource defines a workshop. It specifies the title and description of the
workshop, the location of the workshop content or container image that you deploy, any resources that you pre-create in the workshop environment or for each instance of the workshop.

You can also define environment variables for the workshop image, the amount
of CPU and memory resources for the workshop instance, any overall quota you will apply to
the created namespaces and what the workshop uses.

A minimal example of the `Workshop` custom resource looks like this:

```yaml
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: Workshop
metadata:
  name: lab-markdown-sample
spec:
  title: Markdown Sample
  description: A sample workshop using Markdown
  content:
    files: {YOUR-GIT-REPO-URL}/lab-markdown-sample
  session:
    namespaces:
      budget: small
    applications:
      console:
        enabled: true
      editor:
        enabled: true
```

When you create an instance of the `Workshop` custom resource, the Learning Center Operator does not take any immediate
action. This custom resource exists only to define the workshop.

>**Note:** You create the `Workshop` custom resource at the cluster scope.

## <a id="workshop-env-resource"></a> Workshop environment resource

You must create a workshop environment first to deploy the instances of a workshop.
The `WorkshopEnvironment` custom resource defines the configuration of the workshop environment and the
details of the workshop that you deploy.

A minimal example of the `WorkshopEnvironment` custom resource looks like this:

```yaml
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

When you create an instance of the `WorkshopEnvironment` custom resource, the Learning Center Operator
responds by creating a namespace to host the workshop instances. The `Workshop` resource defines the workshop instance and
the `spec.workshop.name` field specifies the name of the `Workshop` resource. The namespace you create uses the same name as that of
the `metadata.name` field in the `WorkshopEnvironment` resource.

The `spec.request.token` field defines a token with which you must supply a request to create an
instance of a workshop in this workshop environment.
If necessary, you can also specify the namespaces from which a request for a workshop instance to initiate.

The `Workshop` defines a set of common resources that must exist for the workshop. Learning Center Operator creates these common resources after you created the namespace for the workshop environment. If necessary, these resources can include creation of separate namespaces with specific resources that you create in those namespaces instead.

>**Note:** You create the `WorkshopEnvironment` custom resource at the cluster scope.

## <a id="workshop-request-resource"></a> Workshop request resource

To create an instance of the workshop under the workshop environment, the typical
path is to create an instance of the `WorkshopRequest` custom resource.

The `WorkshopRequest` custom resource is namespaced to allow who can create it. Role-based access control (RBAC) controls the request to create a
workshop instance. This means you can allow non-privileged users to create workshops, although the deployment of the workshop instance might
require elevated privileges.

A minimal example of the `WorkshopRequest` custom resource looks like this:

```yaml
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: WorkshopRequest
metadata:
  name: lab-markdown-sample
spec:
  environment:
    name: lab-markdown-sample
    token: lab-markdown-sample
```

Apart from appropriate access from RBAC, the user requesting a workshop instance must know the name of the workshop environment and the secret token that permits workshop requests against that specific workshop environment.

You do not need to create the `WorkshopRequest` resource when you use the `TrainingPortal` resource to provide a
web interface for accessing workshops. You only need to create the `WorkshopRequest` resource when you create
the `WorkshopEnvironment` resource manually and do not use the training portal.

## <a id="workshop-session-resource"></a> Workshop session resource

Although `WorkshopRequest` is the typical way to request workshop instances, the Learning Center Operator itself creates an instance of a
`WorkshopSession` custom resource when the request is granted.

The `WorkshopSession` custom resource is the expanded definition of what the workshop instance is.
It combines details from `Workshop` and `WorkshopEnvironment`, and also
links back to the `WorkshopRequest` resource object that triggered the request.
The Learning Center Operator reacts to an instance of `WorkshopSession` and creates the workshop
instance based on that definition.

>**Note:** You create the `WorkshopSession` custom resource at the cluster scope.

## <a id="training-portal-resource"></a> Training portal resource

The `TrainingPortal` custom resource provides a high-level mechanism for creating a set of
workshop environments and populating them with workshop instances.

A minimal example of the `TrainingPortal` custom resource looks like this:

```yaml
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

>**Note:** You create the `TrainingPortal` custom resource at the cluster scope.

## <a id="system-profile-resource"></a> System profile resource

The `SystemProfile` custom resource provides a mechanism for configuring the Learning Center
Operator. This provides additional features that use environment variables to configure the
operator.

A minimal example of the `SystemProfile` custom resource looks like this:

```yaml
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
Setting the `SYSTEM_PROFILE` environment variable on the deployment for the operator or using the `system.profile`
setting on `TrainingPortal`, `WorkshopEnvironment`, or `WorkshopSession` custom resources for specific deployments can override the default name globally.

As only a global deployment of the operator is supported, the `SystemProfile` custom resource
is created at cluster scope.

You can make changes to instances of the `SystemProfile` custom resource.
The Learning Center Operator uses these changes without needing to redeploy the custom resource.

>**Note:** You create the `SystemProfile` custom resource at the cluster scope.

## <a id="loading-workshop-crds"></a> Loading the workshop CRDs

The custom resource definitions for the custom resource described earlier are created in the
Kubernetes cluster when you deploy the Learning Center operator by using the Tanzu CLI.

This is because `v1` versions of CRDs are only supported from Kubernetes v1.17.
If you want to use the `v1` versions of the CRDs, you must create a copy
of the Learning Center operator deployment resources and override the configuration.
