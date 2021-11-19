# Installing on Minikube

Minikube makes for a simple local deployment of Kubernetes for developing workshop content or for self-learning when deploying other people's workshops.

As you are deploying to a local machine you are unlikely to have access to your own custom domain name and certificate you can use with the cluster, so some extra steps are required over a standard install of Minikube to ensure certain types of workshops can be run.

Also keep in mind that since Minikube generally has limited memory resources available, and is only a single node cluster, you may be prohibited from running workshops which have large memory requirements, or which demonstrate use of third party applications which require a multi node cluster.

Requirements and setup instructions specific to Minikube are detailed below, otherwise normal installation instructions for the Learning Center operator should be followed.

## Trusting insecure registries

Workshops may optionally deploy an image registry for a workshop session. This image registry is secured with a password specific to the workshop session and is exposed via a Kubernetes ingress so it can be accessed from the workshop session.

When using Minikube, the typical scenario will be that insecure ingress routes are always going to be used. Even if you were to generate a self signed certificate to use for ingress, it will not be trusted by the ``dockerd`` that runs within Minikube. This means you have to tell Minikube to trust any insecure registry running inside of Minikube.

Configuring Minikube to trust insecure registries must be done the first time you start a new cluster with it. That is, you must supply the details to ``minikube start``. To do this you need to know the IP subnet that Minikube uses.

If you already have a cluster running using Minikube, you can run ``minikube ip`` to determine the IP address it used, and from that determine what subnet you need to tell it to trust.

For example, if ``minikube ip`` returned ``192.168.64.1``, the subnet you need to trust is ``192.168.64.0/24``.

With this information, when you start a new cluster with Minikube, you would run:

```
minikube start --insecure-registry=192.168.64.0/24
```

If you already have a cluster started with Minikube, you cannot stop it, and then provide this option when it is restarted. The option is only used for a completely new cluster.

Note that you must be using ``dockerd``, and not ``containerd``, in the Minikube cluster. This is because ``containerd`` does not accept an IP subnet when defining insecure registries to be trusted, allowing only specific hosts or IP addresses. Because though you don't know what IP address will be used by Minikube in advance, you can't provide the IP on the command line when starting Minikube to create the cluster the first time.

## Prerequisites
The following installation prerequisites must be done prior to installation.

  As a user you currently have created a tanzunet account and have access to your tanzunet credentials.  
  As a user you currently have miniKube installed on your local machine.  
  As a user you currently have tanzuCLI installed on your local machine.  
  As a user you currently have kubectlCLI installed on your local machine.

## Ingress controller with DNS

Once the Minikube cluster is running, you must enable the ``ingress`` and ``ingress-dns`` addons for Minikube. These deploy the nginx ingress controller, along with support for integrating into DNS.

To enable these after the cluster has been created, run:

```
minikube addons enable ingress
minikube addons enable ingress-dns
```

You are ready now to install the Learning Center package.

Note that the ingress addons for Minikube do not work when using Minikube on top of Docker for Mac, or Docker for Windows. On macOS you must use the Hyperkit VM driver. On Windows you must use the Hyper-V VM driver.

## Installing carvel tools
You must install the kapp controller and secret-gen controller carvel tools in order to properly install our tanzu packages.

Install kapp controller using:
```
kapp deploy -a kc -f https://github.com/vmware-tanzu/carvel-kapp-controller/releases/latest/download/release.yml
```

Install secret-gen controller using:
```
kapp deploy -a sg -f https://github.com/vmware-tanzu/carvel-secretgen-controller/releases/latest/download/release.yml
```
Note* type y and enter to continue when prompted during installation of both kapp and secret-gen controller.

## Installing Tanzu package repository

Create a namespace using:
```
kubectl create ns tap-install
```
Create a registry secret:
```
tanzu package repository add tanzu-tap-repository \
  --url registry.tanzu.vmware.com/tanzu-application-platform/tap-packages:0.3.0-build.8 \
  --namespace tap-install
```
Where TANZU-NET-USER and TANZU-NET-PASSWORD are your credentials for Tanzu Network.
  
  Add package repository to your cluster:

```
tanzu package repository add tanzu-tap-repository \
  --url registry.tanzu.vmware.com/tanzu-application-platform/tap-packages:0.3.0 \
  --namespace tap-install
```
Note* We are currently on build 7, if this changes we need to update the command with the correct build version after the --url flag.

Please make sure to check the package repository install status by running:
```
tanzu package repository get tanzu-tap-repository --namespace tap-install
```
wait for a reconciled sucessful status before attempting to install any other packages

## Create a configuration yaml file for Learning Center Package

Create a file called educates-value.yaml in your current directory with the data provided below.
```
#! The namespace in which to deploy Educates. For now must be "eduk8s" as
namespace: educates
#! DNS parent subdomain used for training portal and workshop ingresses.
ingressDomain: workshops.example.com
#! Ingress class for where multiple ingress controllers exist and need to
#! use that which is not marked as the default.
ingressClass: null
#! SSL certificate for secure ingress. Must be a wildcard certificate for
#! children of DNS parent ingress subdomain.
ingressSecret:
  certificate: null
  privateKey: null
  secretName: null
#! Configuration for persistent volumes. The default storage class specified
#! by the cluster will be used if not defined. Storage group may need to be
#! set where a cluster has pod security policies enabled, usually setting it
#! to one. Storage user and storage group can be set in exceptional case
#! where storage class used maps to NFS storage and storage server requires
#! specific user and group always be used.
storageClass: null
storageUser: null
storageGroup: null
#! Credentials for accessing training portal instances. If not specified then
#! random passwords are generated which can be obtained from the custom resource
#! for the training portal.
portalCredentials:
  systemAdmin:
    username: educates
    password: null
  clientAccess:
    username: robot@educates
    password: null
#! Primary image registry where Educates container images are stored. It
#! is only necessary to define the host and credentials when that image
#! registry requires authentication to access images. This principally
#! exists to allow relocation of images through Carvel image bundles.
imageRegistry:
  host: null
  username: null
  password: null
#! Container image versions for various components of Educates. The Educates
#! operator will need to be modified to read names of images for the registry
#! and docker in docker from config map to enable disconnected install.
#!   https://github.com/eduk8s/eduk8s-operator/issues/112
#! Prepull images to nodes in cluster. Should be empty list if no images
#! should be prepulled. Normally you would only want to prepull workshop
#! images. This is done to reduce start up times for sessions.
prepullImages: ["base-environment"]
#! Docker daemon settings when building docker images in a workshop is
#! enabled. Proxy cache provides a way of partially getting around image
#! pull limits for Docker Hub image registry, with the remote URL being
#! set to "https://registry-1.docker.io".
dockerDaemon:
  networkMTU: 1500
  proxyCache:
    remoteURL: null
    username: null
    password: null
#! Override operator image. Only used during development of Educates.
operatorImage: null
```
Change the ingressDomain in the educates-values.yaml with ``<your-local-ip>.nip.io`` if you are using a ``nip.io`` DNS address. Details on what this are provided below.
In the above example you would replace ``workshops.example.com`` with ``<your-local-ip>.nip.io``

## Using a ``nip.io`` DNS address


Once the Learning Center operator is installed, before you can start deploying workshops, you need to configure the operator to tell it what domain name can be used to access anything deployed by the operator.

Being a local cluster which isn't exposed to the internet with its own custom domain name, you can use a [nip.io](
https://nip.io/). address.

To calculate the ``nip.io`` address to use, first work out the IP address of the cluster created by Minikube by running ``minikube ip``. This is then added as a prefix to the domain name ``nip.io``.

For example, if ``minikube ip`` returns ``192.168.64.1``, use the domain name of ``192.168.64.1.nip.io``.

To configure the Learning Center operator with this cluster domain, run:

```
kubectl set env deployment/eduk8s-operator -n eduk8s INGRESS_DOMAIN=192.168.64.1.nip.io
```

This will cause the Learning Center operator to automatically be re-deployed with the new configuration.

You should now be able to start deploying workshops.

Note that some home internet gateways implement what is called rebind protection. That is, they will not let DNS names from the public internet bind to local IP address ranges inside of the home network. If your home internet gateway has such a feature and it is enabled, it will block ``nip.io`` addresses from working. In this case you will need to configure your home internet gateway to allow ``*.nip.io`` names to be bound to local addresses.

## Install Learning Center package onto a minikube cluster

```
tanzu package install educates --package-name learningcenter.tanzu.vmware.com --version 1.0.14-build.1 -f ./educates-value.yaml --namespace tap-install
```
This package installation uses the installed Package repository along with a configuration educates-value.yaml to install our Learning Center Package.

## Install Workshop tutorial package onto a minikube cluster

```
tanzu package install educates-tutorials --package-name workshops.learningcenter.tanzu.vmware.com --version 1.0.7-build.1 --namespace tap-install
```
Make sure you install the workshop package after the learning center package has reconcilled and sucessfuly installed onto your cluster. In case of new versioning you may obtain package version numbers using 
```
kubectl get packages -n tap-install
```

## Run workshop

Use the following command to get our portal url:
```
kubectl get trainingportals
```
Here we will get a url that we can then paste into our browser

Congratualtions, you are now running our tutorial workshop using our Learning Center operator.

## Working with large images

If you are creating or running workshops which work with the image registry created for a workshop session, and you are going to be pushing images to that image registry which have very large layers in them, you will need to configure the version of nginx deployed for the ingress controller and increase the allowed size of request data for a HTTP request.

To do this run:

```
kubectl edit configmap nginx-load-balancer-conf -n kube-system
```

To the config map resource add the following property under ``data``:

```
proxy-body-size: 1g
```

If you don't increase this you will find ``docker push`` failing when trying to push container images with very large layers.

## Limited resource availability

By default Minikube when deploying a cluster only configures support for 2Gi of memory. This isn't usually enough to do much.

You can view how much memory is available when a custom amount may have been set as a default by running:

```
minikube config get memory
```

It is strongly recommended you configure Minikube to use 4Gi or more. This must be specified when the cluster is first created. This can be done by using the ``--memory`` option to ``minikube start``, or by specifying a default memory value beforehand using ``minikube config set memory``.

In addition to increasing the memory available, you may also want to look at increasing the disk size as fat container images can chew up disk space within the cluster pretty quickly.

## Storage provisioner bug

Version 1.12.3 of Minikube introduced a [bug](https://github.com/kubernetes/minikube/issues/8987) in the storage provisioner which causes potential corruption of data in persistent volumes where the same persistent volume claim name is used in two different namespaces. This will affect Learning Center where you deploy multiple training portals at the same time, where you run multiple workshops at the same time which have docker or image registry support enabled, or where the workshop session itself is backed by persistent storage and multiple sessions are run at the same time.

This issue is supposed to be fixed in Minikube version 1.13.0, however you can still encounter issues where deleting a training portal instance and then recreating it immediately with the same name. This is because reclaiming of the persistent volume by the Minikube storage provisioner can be slow and the new instance can grab the same original directory on disk with old data in it. As a result, always ensure you leave a bit of time between deleting a training portal instance and recreating it with the same name to allow the storage provisioner to delete the old persistent volume.
