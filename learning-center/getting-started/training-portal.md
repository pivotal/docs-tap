# TrainingPortal

## <a id="work-with-workshops"></a>Working with multiple workshops

The quickest way to deploy a set of workshops to use in a training session is to deploy a `TrainingPortal`.
This deploys a set of workshops, with one instance of each workshop for each attendee.
A web-based portal is provided for registering attendees and allocating them to workshops.

The `TrainingPortal` custom resource provides a high-level mechanism for creating a set of workshop environments and
populating it with workshop instances. When the Learning Center Operator processes this custom resource, it creates other custom resources to trigger the creation of the workshop environment and the workshop instances.
If you want more control, you can use these latter custom resources directly instead.

## <a id="loading-ws-definition"></a>Loading the workshop definition

A custom resource of type `Workshop` describes each workshop. Before a workshop environment can be created, you must load the
definition of the workshop.

The example `Workshop` custom resource we are using is:

```
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: Workshop
metadata:
  name: lab-k8s-fundamentals
spec:
  title: Kubernetes Fundamentals
  description: Workshop on getting started with Kubernetes
  url: https://github.com/eduk8s-labs/lab-k8s-fundamentals
  vendor: eduk8s.io
  authors:
  - Graham Dumpleton
  difficulty: intermediate
  duration: 1h
  tags:
  - kubernetes
  content:
    image: projects.registry.vmware.com/learningcenter/lab-k8s-fundamentals:latest
  session:
    namespaces:
      budget: medium
    applications:
      terminal:
        enabled: true
        layout: split
      console:
        enabled: true
      editor:
        enabled: true
```

To load the definition of the workshop, run:

```
kubectl apply -f https://raw.githubusercontent.com/eduk8s-labs/lab-k8s-fundamentals/master/resources/workshop.yaml
```

The custom resource created is cluster-scoped, and the command needs to be run as a cluster admin or other appropriate
user with permission to create the resource.

If successfully loaded, the command outputs:

```
workshop.learningcenter.tanzu.vmware.com/lab-k8s-fundamentals created
```

You can list the workshop definitions that have been loaded, and which can be deployed by running:

```
kubectl get workshops
```

For this workshop, this outputs:

```
NAME                  IMAGE                                            FILES  URL
lab-k8s-fundamentals  quay.io/eduk8s-labs/lab-k8s-fundamentals:master         https://github.com/eduk8s-labs/lab-k8s-fundamentals
```

The additional fields in this case give the name of the custom workshop container image deployed for the
workshop and a URL where you can find out more information about the workshop.

The definition of a workshop is loaded as a step of its own, rather than referring to a remotely hosted definition. This allows a cluster admin to audit the workshop definition to ensure it isn't doing something the cluster admin doesn't want to
allow. Once the cluster admin approves the workshop definition, it can be used to create instances of the workshop.

## <a id="create-ws-training-portal"></a>Creating the workshop training portal

To deploy a workshop for one or more users, use the `TrainingPortal` custom resource. This custom resource specifies
a set of workshops to be deployed and the number of people taking the workshops.

The `TrainingPortal` custom resource we use in this example is:

```
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: TrainingPortal
metadata:
  name: lab-k8s-fundamentals
spec:
  workshops:
  - name: lab-k8s-fundamentals
    capacity: 3
    reserved: 1
    expires: 1h
    orphaned: 5m
```

To create the custom resource, run:

```
kubectl apply -f https://raw.githubusercontent.com/eduk8s-labs/lab-k8s-fundamentals/master/resources/training-portal.yaml
```

The custom resource created is cluster-scoped, and the command needs to be run as a cluster admin or other appropriate
user with permission to create the resource.

This results in the output:

```
trainingportal.learningcenter.tanzu.vmware.com/lab-k8s-fundamentals created
```

But there is a lot more going on than this. To see all the resources created, run:

```
kubectl get learningcenter-training -o name
```

You should see:

```
workshop.learningcenter.tanzu.vmware.com/lab-k8s-fundamentals
trainingportal.learningcenter.tanzu.vmware.com/lab-k8s-fundamentals
workshopenvironment.learningcenter.tanzu.vmware.comlab-k8s-fundamentals-w01
workshopsession.learningcenter.tanzu.vmware.com/lab-k8s-fundamentals-w01-s001
```

In addition to the original `Workshop` custom resource providing the definition of the workshop, and the `TrainingPortal` custom resource you just created, `WorkshopEnvironment` and `WorkshopSession` custom resources
are also created.

The `WorkshopEnvironment` custom resource sets up the environment for a workshop, including deploying any application
services that must exist and are shared by all workshop instances.

The `WorkshopSession` custom resource results in the creation of a single workshop instance.

You can see a list of the workshop instances created, and access details, by running:

```
kubectl get workshopsessions
```

This should yield output similar to:

```
NAME                            URL                                         USERNAME   PASSWORD
lab-k8s-fundamentals-w01-s001   http://lab-k8s-fundamentals-w01-s001.test
```

Only one workshop instance was created as, although the maximum capacity was set to 3, the reserved number of
instances (hot spares) was defined as 1. Additional workshops instances are only created as workshop sessions
are allocated to users, with 1 reserved instance always being maintained so long as capacity hasn't been reached.

If you need a different number of workshop instances, set the `portal.capacity` field of the `TrainingPortal` custom
resource YAML input file before creating the resource. Changing the values after the resource has been created has
no effect.

In this case only one workshop was listed to be hosted by the training portal. You can deploy more than one
workshop at the same time by adding the names of other workshops to `workshops`.

Because this is the first time you have deployed the workshop, it can take a few moments to pull down the workshop
image and start.

To access the workshops, attendees of a training session need to visit the web-based portal for the training session.
Find the URL for the web portal by running:

```
kubectl get trainingportals
```

This should yield output similar to:

```
NAME                  URL                                   ADMINUSERNAME  ADMINPASSWORD
lab-k8s-fundamentals  https://lab-k8s-fundamentals-ui.test  learningcenter         mGI2C1TkHEBoFgKiZetxMnwAldRU80aN
```

Attendees should only be given the URL. The password listed is only for use by the instructor of the training
session if required.

## <a id="access-ws-via-web-portal"></a>Accessing workshops via the web portal

An attendee visiting the web-based portal for the training session is presented with a login page. However,
the attendee must register for an account. From the initial login page, click on the link to
the registration page.

![Portal Registration](images/portal-registration.png)

Registration is required so that, if the attendee's web browser exits or the attendee needs to switch web browsers, the attendee can
log in again and get access to the same workshop instance allocated.

Upon registering, the attendee is presented with a list of workshops available for the training session.

![Portal Catalog](images/portal-catalog.png)

The orange dot against the description of a workshop indicates that no instance for that workshop has been allocated
to the user as yet, but that some are still available. A red dot indicates there are no more workshop instances
available and capacity for the training session has been reached. A green dot indicates a workshop instance has
already been reserved by the attendee.

Clicking on the "Start workshop" button allocates a workshop instance if one hasn't yet been reserved and redirects
the attendee to that workshop instance.

![Dashboard Terminal](../about-learning-center/images/dashboard-terminal.png)

## <a id="delete-ws-training-portal"></a>Deleting the workshop training portal

The workshop training portal is intended for running workshops with a fixed time period where all workshop instances
are deleted when complete.

To delete all the workshop instances and the web-based portal, run:

```
kubectl delete trainingportal/lab-k8s-fundamentals
```
