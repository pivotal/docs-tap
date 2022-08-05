# Installing on Minikube

Minikube enables local deployment of Kubernetes for developing workshop content or for self-learning when deploying other people's workshops.

Because you are deploying to a local machine, you are unlikely to have access to your own custom domain name and certificate you can use with the cluster. You must take extra steps over a standard install of Minikube to ensure you can run certain types of workshops.

Also, because Minikube generally has limited memory resources available and is only a single-node cluster, you might be restricted from running workshops that have large memory requirements or that demonstrate the use of third-party applications requiring a multinode cluster.

Requirements and setup instructions specific to Minikube are detailed in this document. Otherwise, you can follow normal installation instructions for the Learning Center operator.

## <a id="trust-insecure-registries"></a> Trusting insecure registries

Workshops can optionally deploy a container image registry for a workshop session. This image registry is secured with a password specific to the workshop session and is exposed through a Kubernetes ingress so it can be accessed from the workshop session.

In a typical scenario, Minikube uses insecure ingress routes. Even were you to generate a self-signed certificate to use for ingress, it is not trusted by `dockerd` that runs within Minikube. You must tell Minikube to trust any insecure registry running inside of Minikube.

You must configure Minikube to trust insecure registries the first time you start a new cluster with it. That is, you must supply the details to `minikube start`, which means you must know the IP subnet Minikube uses.

If you already have a cluster running using Minikube, run `minikube ip` to discover the IP address it uses. From that you can discover the trusted subnet. For example, if `minikube ip` returned `192.168.64.1`, the trusted subnet is `192.168.64.0/24`.

With this information, when you start a new cluster with Minikube, run:

```console
minikube start --insecure-registry=192.168.64.0/24
```

If you already have a cluster started with Minikube, you cannot stop it and then provide this option when it is restarted. You can only use this option for a completely new cluster.

>**Note:** You must be using `dockerd`, not `containerd`, in the Minikube cluster. `containerd` does not accept an IP subnet when defining insecure registries to be trusted. It allows only specific hosts or IP addresses. Because you don't know what IP address Minikube will use in advance, you can't provide the IP address on the command line when starting Minikube to create the cluster.

## <a id="prerequisites"></a> Prerequisites

You must complete the following installation prerequisites as a user prior to installation:

  - Create a tanzunet account and have access to your tanzunet credentials.  
  - Install miniKube on your local machine.  
  - Install tanzuCLI on your local machine.  
  - Install kubectlCLI on your local machine.

## <a id="ingress-ctrl-with-dns"></a> Ingress controller with DNS

After the Minikube cluster is running, you must enable the `ingress` and `ingress-dns` add-ons for Minikube. These deploy the nginx ingress controller along with support for integrating into DNS.

To enable these after the cluster has been created, run:

```console
minikube addons enable ingress
minikube addons enable ingress-dns
```

You are now ready to install the Learning Center package.

>**Note:** The ingress add-ons for Minikube do not work when using Minikube on top of Docker for Mac or Docker for Windows. On macOS you must use the Hyperkit VM driver. On Windows you must use the Hyper-V VM driver.

## <a id="install-carvel-tools"></a> Install carvel tools

You must install the kapp controller and secret-gen controller carvel tools in order to properly install VMware tanzu packages.

 To install kapp controller, run:

```console
kapp deploy -a kc -f https://github.com/vmware-tanzu/carvel-kapp-controller/releases/latest/download/release.yml
```

To install secret-gen controller, run:

```console
kapp deploy -a sg -f https://github.com/vmware-tanzu/carvel-secretgen-controller/releases/latest/download/release.yml
```

>**Note:** Type "y" and enter to continue when prompted during installation of both kapp and secret-gen controllers.

## <a id="install-tanzu-pkg-repo"></a> Install Tanzu package repository

Follow these steps to install the Tanzu package repository:

1. To create a namespace, run:

    ```console
    kubectl create ns tap-install
    ```

1. Create a registry secret:

    ```console
    tanzu secret registry add tap-registry \
      --username "TANZU-NET-USER" --password "TANZU-NET-PASSWORD" \
      --server registry.tanzu.vmware.com \
      --export-to-all-namespaces --yes --namespace tap-install
    ```

    Where:

    - `TANZU-NET-USER` and `TANZU-NET-PASSWORD` are your credentials for Tanzu Network.

1. Add a package repository to your cluster:

    ```console
    tanzu package repository add tanzu-tap-repository \
      --url registry.tanzu.vmware.com/tanzu-application-platform/tap-packages:VERSION-NUMBER \
      --namespace tap-install
    ```

    Where `VERSION-NUMBER` is your Tanzu Application Platform version. For example, `{{ vars.tap_version }}`.

    >**Note:** We are currently on build 7; if this changes, we need to update the command with the correct build version after the --url flag.

1. To check the package repository install status, run:

    ```console
    tanzu package repository get tanzu-tap-repository --namespace tap-install
    ```

Wait for a reconciled sucessful status before attempting to install any other packages.

## <a id="create-yaml-for-lc-pkg"></a> Create a configuration YAML file for the Learning Center package

Create a file called learningcenter-value.yaml in your current directory with the following data:

See [Supported yaml file configurations](../install-learning-center.md#support-lc-values) to see a list of configurations you can provide to Learning Center.

```yaml
ingressDomain: workshops.example.com
```

Where:

- `ingressDomain` is `<your-local-ip>.nip.io` if you are using a `nip.io` DNS address. Details about this are provided in the following section.
- `workshops.example.com` is `<your-local-ip>.nip.io`

## <a id="use-nip-io-dns-address"></a> Using a `nip.io` DNS address

After the Learning Center operator is installed, before you can start deploying workshops, you must configure the operator to tell it what domain name can be used to access anything deployed by the operator.

Being a local cluster that isn't exposed to the Internet with its own custom domain name, you can use a [nip.io](
https://nip.io/). address.

To calculate the `nip.io` address to use, first work out the IP address of the cluster created by Minikube by running `minikube ip`. Add this as a prefix to the domain name `nip.io`. For example, if `minikube ip` returns `192.168.64.1`, use the domain name of `192.168.64.1.nip.io`.

To configure the Learning Center operator with this cluster domain, run:

```console
kubectl set env deployment/learningcenter-operator -n learningcenter INGRESS_DOMAIN=192.168.64.1.nip.io
```

This causes the Learning Center operator to redeploy with the new configuration. You should now be able to start deploying workshops.

>**Note:** Some home Internet gateways implement what is called rebind protection. These gateways do not let DNS names from the public Internet bind to local IP address ranges inside the home network. If your home Internet gateway has such a feature and it is enabled, it blocks `nip.io` addresses from working. In this case, you must configure your home Internet gateway to allow `*.nip.io` names to be bound to local addresses.

## <a id="install-lc-pkg-mk-cluster"></a> Install Learning Center package onto a minikube cluster

To install the Learning Center package onto a minikube cluster, run:

```console
tanzu package install learningcenter --package-name learningcenter.tanzu.vmware.com --version 0.1.0 -f ./learningcenter-value.yaml --namespace tap-install
```

This package installation uses the installed Package repository with a configuration learningcenter-value.yaml to install the Learning Center package.

## <a id="ws-tutor-pkg-mk-cluster"></a> Install workshop tutorial package onto a minikube cluster

To install the workshop tutorial package onto a minikube cluster, run:

```console
tanzu package install learningcenter-tutorials --package-name workshops.learningcenter.tanzu.vmware.com --version 0.1.0 --namespace tap-install
```

Make sure you install the workshop package after the Learning Center package has reconciled and successfully installed onto your cluster. In case of new versioning, to obtain package version numbers, run:

```console
kubectl get packages -n tap-install
```

## <a id="run-the-workshop"></a> Run the workshop

To get the training portal URL, run:

```console
kubectl get trainingportals
```

You get a URL that you can paste into your browser.

Congratulations, you are now running the tutorial workshop using the Learning Center operator.

## <a id="work-with-large-images"></a> Working with large images

If you create or run workshops that work with the image registry created for a workshop session, and you push images to that image registry that have large layers, you must configure the version of nginx deployed for the ingress controller and increase the allowed size of request data for a HTTP request.

To do this, run:

```console
kubectl edit configmap nginx-load-balancer-conf -n kube-system
```

To the config map resource, add the following property under `data`:

```console
proxy-body-size: 1g
```

If you don't increase this, `docker push` fails when trying to push container images with large layers.

## <a id="limit-rsrc-availability"></a> Limited resource availability

When deploying a cluster, by default Minikube only configures support for 2Gi of memory. This usually isn't adequate.

To view how much memory is available when a custom amount has been set as a default, run:

```console
minikube config get memory
```

VMware recommends you configure Minikube to use 4Gi or more. This must be specified when the cluster is first created. Do this by using the `--memory` option to `minikube start` or by specifying a default memory value beforehand by using `minikube config set memory`.

In addition to increasing the memory available, you can increase the disk size, because fat container images can quickly use disk space within the cluster.

## <a id="storage-provisioner-issue"></a> Storage provisioner issue

v1.12.3 of Minikube introduced a [bug](https://github.com/kubernetes/minikube/issues/8987) in the storage provisioner that causes potential corruption of data in persistent volumes where the same persistent volume claim name is used in two different namespaces. This affects Learning Center when:

- You deploy multiple training portals at the same time.
- You run multiple workshops at the same time that have docker or image registry support enabled.
- The workshop session itself is backed by persistent storage and multiple sessions run at the same time.

This issue is supposed to be fixed in Minikube v1.13.0; however, you can still encounter issues when deleting a training portal instance and recreating it immediately with the same name. This occurs because reclaiming of the persistent volume by the Minikube storage provisioner can be slow, and the new instance can grab the same original directory on disk with old data in it. After deleting a training portal instance, wait before recreating one with the same name to allow the storage provisioner to delete the old persistent volume.
