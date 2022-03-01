# Installing on Kind

Kind was developed as a means to support development and testing of Kubernetes. Despite that it exists primarily for that purpose, Kind clusters are often used for local development of user applications as well. For Learning Center, you can use a local Kind cluster to develop workshop content or self-learning when deploying other people's workshops.

As you are deploying to a local machine you are unlikely to have access to your own custom domain name and certificate you can use with the cluster. If you don't, you may be restricted as to the sorts of workshops you can develop or run using the Learning Center in Kind. This is because Kind uses `containerd` which lacks certain features that allow you to trust any image registries hosted within a subnet. This means you cannot run workshops that use a local image registry for each workshop session in an easy way. If you need the ability to run workshops on your local computer that uses an image registry for each session, we recommend you use minikube with `dockerd` instead. You can find more details about this issue below.

Also keep in mind that, since Kind generally has limited memory resources available, you may be prohibited from running workshops that have large memory requirements. Certain workshops which demonstrate the use of third-party applications requiring a multi-node cluster also will not work unless the Kind cluster is specifically configured to be multi-node rather than a single node.

Requirements and setup instructions specific to Kind are detailed below; otherwise, follow normal installation instructions for the Learning Center Operator.

## <a id="prerequisites"></a> Prerequisites

The following installation prerequisites must be done prior to installation:

  - As a user, you currently have created a tanzunet account and have access to your tanzunet credentials.  
  - As a user, you currently have kind installed on your local machine.  
  - As a user, you currently have tanzuCLI installed on your local machine.  
  - As a user, you currently have kubectlCLI installed on your local machine.

## <a id="kind-cluster-creation"></a> Kind cluster creation

When initially creating the Kind cluster you will need to [configure](https://kind.sigs.k8s.io/docs/user/ingress#create-cluster) it so that the ingress controller will be exposed. The documentation provides the following command to do this, but check the documentation in case the details have changed.

```
cat <<EOF | kind create cluster --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  kubeadmConfigPatches:
  - |
    kind: InitConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-labels: "ingress-ready=true"
  extraPortMappings:
  - containerPort: 80
    hostPort: 80
    protocol: TCP
  - containerPort: 443
    hostPort: 443
    protocol: TCP
EOF
```

Once you have the Kind cluster up and running, you need to install an ingress controller.

## <a id="ingress-control-with-dns"></a> Ingress controller with DNS

The Kind documentation provides instructions for installing Ambassador, Contour, and Nginx-based ingress controllers.

It is recommended that [Contour](https://kind.sigs.k8s.io/docs/user/ingress#contour) be used rather than Nginx, as the latter will drop websocket connections whenever new ingresses are created. The Learning Center workshop environments do include a workaround to re-establish websocket connections for the workshop terminals without losing terminal state, but other applications used with workshops may not, such as terminals available through VS Code.

You should avoid using the Ambassador ingress controller as it requires all ingresses created to be annotated explicitly with an ingress class of "ambassador". The Learning Center Operator can be configured to do this automatically for ingresses created for the training portal and workshop sessions, however, any workshops which create ingresses as part of the workshop instructions will not work unless they are written to have the user manually add the ingress class when required due to the use of Ambassador.

If you have created a contour ingress controller, please verify all pods have a running status using:
```
kubectl get pods -n projectcontour -o wide
```

## <a id="install-carvel-tools"></a> Installing carvel tools

You must install the kapp controller and secret-gen controller carvel tools in order to properly install our tanzu packages.

Install kapp controller by running:
```
kapp deploy -a kc -f https://github.com/vmware-tanzu/carvel-kapp-controller/releases/latest/download/release.yml
```

Install secret-gen controller by running:
```
kapp deploy -a sg -f https://github.com/vmware-tanzu/carvel-secretgen-controller/releases/latest/download/release.yml
```
>**Note:** Type y and enter to continue when prompted during installation of both kapp and secret-gen controller.

## <a id="install-tanzu-pkg-repo"></a> Installing Tanzu package repository

To install the Tanzu package repository:

1. Create a namespace:

  ```
  kubectl create ns tap-install
  ```

1. Create a registry secret:

  ```
  tanzu secret registry add tap-registry \
    --username "TANZU-NET-USER" --password "TANZU-NET-PASSWORD" \
    --server registry.tanzu.vmware.com \
    --export-to-all-namespaces --yes --namespace tap-install
  ```

  Where `TANZU-NET-USER` and `TANZU-NET-PASSWORD` are your credentials for Tanzu Network.

1. Add package repository to your cluster:

  ```
  tanzu package repository add tanzu-tap-repository \
    --url registry.tanzu.vmware.com/tanzu-application-platform/tap-packages:1.0.0 \
    --namespace tap-install
  ```
  >**Note:** We are currently on build 7: if this changes, we need to update the command with the correct build version after the --url flag.

1. Please make sure to check the package repository install status by running:

  ```
  tanzu package repository get tanzu-tap-repository --namespace tap-install
  ```

  Wait for a reconciled successful status before attempting to install any other packages.

## <a id="create-config-yaml-lc-pkg"></a> Create a configuration YAML file for Learning Center package

To create a configuration YAML file:

1. Create a file called learningcenter-value.yaml in your current directory with the data provided below.
  ```
  #! The namespace in which to deploy Learning Center. For now this must be "learningcenter" as
  namespace: learningcenter
  #! DNS parent subdomain used for training portal and workshop ingresses.
  ingressDomain: workshops.example.com
  #! Ingress class for where multiple ingress controllers exist and need to
  #! use that which is not marked as the default.
  ingressClass: null
  #! SSL certificate for secure ingress. This must be a wildcard certificate for
  #! children of DNS parent ingress subdomain.
  ingressSecret:
    certificate: null
    privateKey: null
    secretName: null
  #! Configuration for persistent volumes. The default storage class specified
  #! by the cluster is used if not defined. You may need to set storage group
  #! where a cluster has pod security policies enabled, usually
  #! to one. Set storage user and storage group in exceptional cases
  #! where storage class uses maps to NFS storage and storage server requires
  #! that a specific user and group always be used.
  storageClass: null
  storageUser: null
  storageGroup: null
  #! Credentials for accessing training portal instances. If not specified, then
  #! random passwords are generated which you can obtain from the custom resource
  #! for the training portal.
  portalCredentials:
    systemAdmin:
      username: learningcenter
      password: null
    clientAccess:
      username: robot@learningcenter
      password: null
  #! Primary image registry where Learning Center container images are stored. It
  #! is only necessary to define the host and credentials when that image
  #! registry requires authentication to access images. This principally
  #! exists to allow relocation of images through Carvel image bundles.
  imageRegistry:
    host: null
    username: null
    password: null
  #! Container image versions for various components of Learning Center. The Learning Center
  #! Operator will need to be modified to read names of images for the registry
  #! and docker-in-docker from config map to enable disconnected install.
  #!   https://github.com/eduk8s/eduk8s-operator/issues/112
  #! Prepull images to nodes in cluster. Should be empty list if no images
  #! should be prepulled. Normally you would only want to prepull workshop
  #! images. This is done to reduce start-up times for sessions.
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
  #! Override operator image. Only used during development of Learning Center.
  operatorImage: null
  ```

Where:
- `ingressDomain` is `<your-local-ip>.nip.io` if you are using a `nip.io` DNS address. Details on what this is are provided below.
- `workshops.example.com with`  is `<your-local-ip>.nip.io`.

## <a id="use-nip-io-dns-address"></a> Using a `nip.io` DNS address

Before you can start deploying workshops, you need to configure the operator to tell it what domain name can be used to access anything deployed by the operator.

Being a local cluster which isn't exposed to the internet with its own custom domain name, you can use a [nip.io](
https://nip.io/). address.

To calculate the `nip.io` address to use, first work out the IP address for the ingress controller exposed by Kind. This is usually the IP address of the local machine itself, even where you may be using Docker for Mac.

How you get the IP address for your local machine depends on the operating system being used.

For example on a Mac, you can find your ip address by searching for network using spotlight and selecting the network option under system preferences. Here you will see your IP address under status.

Once you have the IP address, if, for example, it was `192.168.1.1`, use the domain name of `192.168.1.1.nip.io`.

To configure the Learning Center operator with this cluster domain, run:

```
kubectl set env deployment/eduk8s-operator -n eduk8s INGRESS_DOMAIN=192.168.1.1.nip.io
```

This will cause the Learning Center Operator to automatically be re-deployed with the new configuration.

You should now be able to start deploying workshops.

Note that some home internet gateways implement what is called rebind protection. That is, they will not let DNS names from the public internet bind to local IP address ranges inside the home network. If your home internet gateway has such a feature and it is enabled, it will block `nip.io` addresses from working. In this case you will need to configure your home internet gateway to allow `*.nip.io` names to be bound to local addresses.

Also note that you cannot use an address of form `127.0.0.1.nip.io`, or `subdomain.localhost`. This will cause a failure as internal services, when needing to connect to each other, end up connecting to themselves instead since the address would resolve to the host loopback address of `127.0.0.1`.

## <a id="install-lc-pkg-k8s-clust"></a> Install Learning Center package onto a Kubernetes cluster

To install Learning Center on a Kubernetes cluster:

```
tanzu package install learningcenter --package-name learningcenter.tanzu.vmware.com --version 0.1.0 -f ./learningcenter-value.yaml --namespace tap-install
```
This package installation uses the installed Package repository along with a configuration learningcenter-value.yaml to install our Learning Center Package.

## <a id="ws-tut-pkg-k8s-cluster"></a> Install Workshop tutorial package onto a Kubernetes cluster

To install a Workshop tutorial on a Kubernetes cluster:

```
tanzu package install learningcenter-tutorials --package-name workshops.learningcenter.tanzu.vmware.com --version 0.1.0 --namespace tap-install
```
Make sure you install the workshop package after the Learning Center package has reconciled and successfully installed onto your cluster. In case of new versioning, you may obtain package version numbers using
```
kubectl get packages -n tap-install
```

## <a id="run-the-workshop"></a> Run the workshop

To run a workshop:

Use the following command to get our portal URL:
```
kubectl get trainingportals
```
Here we get a URL that we can then paste into our browser.

Congratulations, you are now running our tutorial workshop using our Learning Center Operator.

## <a id="trust-insecure-registries"></a> Trusting insecure registries

Workshops may optionally deploy an image registry for a workshop session. This image registry is secured with a password specific to the workshop session and is exposed via a Kubernetes ingress so it can be accessed from the workshop session.

When using Kind, the typical scenario will be that insecure ingress routes are always going to be used. Even if you were to generate a self-signed certificate to use for ingress, it will not be trusted by `containerd` that runs within Kind. This means you have to tell Kind to trust any insecure registry running inside of Kind.

Configuring kind to trust insecure registries must be done when you first create the cluster. The problem with Kind, however, is that it uses `containerd` and not `dockerd`. The `containerd` runtime doesn't provide a way to trust any insecure registry hosted within the IP subnet used by the Kubernetes cluster. Instead, what `containerd` requires is that you enumerate every single hostname or IP address on which an insecure registry is hosted. Since each workshop session created by the Learning Center for a workshop uses a different hostname, this makes it much harder to handle this situation.

If you really must used Kind and need to handle this, what you need to do is work out what the image registry hostname for a workshop deployment and configure `containerd` to trust a set of hostnames corresponding to low-numbered sessions for that workshop. This will allow it to work, but, once the hostnames for sessions go beyond the range of hostnames you set up, you need to delete the training portal and recreate it so you go back to using the same hostnames again.

For example, if the hostname for the image registry were of the form:

```
lab-docker-testing-wMM-sNNN-registry.192.168.1.1.nip.io
```

where `NNN` changes per session, you would need to use a command to create the Kind cluster something like:

```
cat <<EOF | kind create cluster --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  kubeadmConfigPatches:
  - |
    kind: InitConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-labels: "ingress-ready=true"
  extraPortMappings:
  - containerPort: 80
    hostPort: 80
    protocol: TCP
  - containerPort: 443
    hostPort: 443
    protocol: TCP
containerdConfigPatches:
- |
  [plugins."io.containerd.grpc.v1.cri".registry.mirrors."lab-docker-testing-w01-s001-registry.192.168.1.1.nip.io"]
    endpoint = ["http://lab-docker-testing-w01-s001-registry.192.168.1.1.nip.io"]
  [plugins."io.containerd.grpc.v1.cri".registry.mirrors."lab-docker-testing-w01-s002-registry.192.168.1.1.nip.io"]
    endpoint = ["http://lab-docker-testing-w01-s002-registry.192.168.1.1.nip.io"]
  [plugins."io.containerd.grpc.v1.cri".registry.mirrors."lab-docker-testing-w01-s003-registry.192.168.1.1.nip.io"]
    endpoint = ["http://lab-docker-testing-w01-s003-registry.192.168.1.1.nip.io"]
  [plugins."io.containerd.grpc.v1.cri".registry.mirrors."lab-docker-testing-w01-s004-registry.192.168.1.1.nip.io"]
    endpoint = ["http://lab-docker-testing-w01-s004-registry.192.168.1.1.nip.io"]
  [plugins."io.containerd.grpc.v1.cri".registry.mirrors."lab-docker-testing-w01-s005-registry.192.168.1.1.nip.io"]
    endpoint = ["http://lab-docker-testing-w01-s005-registry.192.168.1.1.nip.io"]
EOF
```

This allows you to run five workshop sessions before you had to delete the training portal and recreate it.

Do note that if using this, you are able to use the feature of the training portal to automatically update when a workshop definition is changed. This is because the `wMM` value identifying the workshop environment changes any time you update the workshop definition.

There is no other known workaround for this limitation of `containerd`. As such, it is recommended to use minikube with `dockerd` instead.
