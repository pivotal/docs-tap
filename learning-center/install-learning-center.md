# Install Learning Center

This document describes how to install Learning Center
from the Tanzu Application Platform package repository.

>**Note:** Use the instructions on this page if you do not want to use the full profile to install packages.
Only the full profile includes Learning Center.
For more information about profiles, see [About Tanzu Application Platform components and profiles](../about-package-profiles.md).

To install Tanzu Learning Center, see the following sections.

For general information about Learning Center, see [Learning Center](about.md). For information about deploying Learning Center operator, see [Learning Center operator](getting-started/learning-center-operator.md).

## <a id='prereqs'></a>Prerequisites

Before installing Learning Center:

- Complete all prerequisites to install Tanzu Application Platform. For more information, see [Prerequisites](../prerequisites.md).

- The cluster must have an ingress router configured. If you have installed the Tanzu Application Platform package through the full profile or light profile, it already deploys a contour ingress controller.

- The operator, when deploying instances of the workshop environments, must be able to expose them through an external URL for access. For the custom domain you are using, DNS must have been configured with a wildcard domain to forward all requests for sub-domains of the custom domain to the ingress router of the Kubernetes cluster.

- By default, the workshop portal and workshop sessions are accessible over HTTP connections. If you wish to use secure HTTPS connections, you must have access to a wildcard SSL certificate for the domain under which you want to host the workshops. You cannot use a self-signed certificate.

- Any ingress routes created use the default ingress class if you have multiple ingress class types available and you must override which is used.

### <a id='install'></a>Install

To install Learning Center:

1. List version information for the package by running:

    ```console
    tanzu package available list learningcenter.tanzu.vmware.com --namespace tap-install
    ```

    Example output:

    ```console
     NAME                             VERSION        RELEASED-AT
     learningcenter.tanzu.vmware.com  0.1.0          2021-12-01 08:18:48 -0500 EDT
    ```

1. (Optional) See all the configurable parameters on this package by running:

    **Remember to change the 0.x.x version**

    ```console
    tanzu package available get learningcenter.tanzu.vmware.com/0.x.x --values-schema --namespace tap-install
    ```

1. Create a config file named `learning-center-config.yaml`.

1. To override the `shared.ingress_domain` in the values file of Tanzu Application Platform, add the parameter `ingressDomain` to `learning-center-config.yaml`. For example:

    ```yaml
    ingressDomain: YOUR-INGRESS-DOMAIN
    ```

    Where `YOUR-INGRESS-DOMAIN` is the domain name for your Kubernetes cluster.

    When deploying workshop environment instances, the operator must be able to expose the instances through an external URL. You need this access to discover the domain name that can be used as a suffix to host names for instances.

    For the custom domain you are using, DNS must have been configured with a wildcard domain to
    forward all requests for sub-domains of the custom domain to the ingress router of the
    Kubernetes cluster.

    If you are running Kubernetes on your local machine using a system such as `minikube` and you
    don't have a custom domain name that maps to the IP address for the cluster, you can use a `nip.io`
    address. For example, if `minikube ip` returns `192.168.64.1`, you can use the `192.168.64.1.nip.io` domain. You cannot use an address of form `127.0.0.1.nip.io` or `subdomain.localhost`. This causes a failure. Internal services needing to connect to each other connect to themselves instead, because the address resolves to the host loopback address of `127.0.0.1`.

1. Add the `ingressSecret` to `learning-center-config.yaml`, as in this example:

    ```yaml
      ingressSecret:
      certificate: |
        -----BEGIN CERTIFICATE-----
        MIIFLTCCBBWgAwIBAgaSAys/V2NCTG9uXa9aAiYt7WJ3MA0GCSqGaIb3DQEBCwUA
                                        ...
        dHa6Ly9yMy5vamxlbmNyLm9yZzAiBggrBgEFBQawAoYWaHR0cDoaL3IzLmkubGVu
        -----END CERTIFICATE-----
      privateKey: |
        -----BEGIN PRIVATE KEY-----
        MIIEvQIBADAaBgkqhkiG9waBAQEFAASCBKcwggSjAgEAAoIBAaCx4nyc2xwaVOzf
                                        ...
        IY/9SatMcJZivH3F1a7SXL98PawPIOSR7986P7rLFHzNjaQQ0DWTaXBRt+oUDxpN
        -----END PRIVATE KEY-----
    ```

    If you already have a TLS secret, follow these steps **before deploying any workshop**:
    - Create the `learningcenter` namespace manually or the one you defined
    - Copy the TLS secret to the `learningcenter` namespace or the one you
    defined and use the `secretName` property as in this example:

    ```yaml
    ingressSecret:
     secretName: workshops.example.com-tls
    ```

    By default, the workshop portal and workshop sessions are accessible over HTTP connections.

    To use secure HTTPS connections, you must have access to a wildcard SSL certificate for the
    domain under which you want to host the workshops. You cannot use a self-signed certificate.

    You can create wildcard certificates by using letsencrypt <https://letsencrypt.org/>_.
    After you have the certificate, you can define the `certificate` and `privateKey` properties
    under the `ingressSecret` property to specify the certificate on the configuration YAML.

1. Any ingress routes created use the default ingress class.
If you have multiple ingress class types available, and you need to override which is used, define the `ingressClass` property in `learning-center-config.yaml` **before deploying any workshop**:

    ```yaml
    ingressClass: contour
    ```

1. Install Learning Center operator by running:

    **Remember to change the 0.x.x version**
    ```console
    tanzu package install learning-center --package-name learningcenter.tanzu.vmware.com --version 0.x.x -f learning-center-config.yaml
    ```

    The preceding command creates a default namespace in your Kubernetes cluster called `learningcenter`,
    and the operator, and any required namespaced resources, are created in it.
    A set of custom resource definitions and a global cluster role binding are also created.

    You can confirm that the operator deployed successfully by running:

    ```console
    kubectl get all -n learningcenter
    ```

    The pod for the operator should be marked as running.

## <a id='install-portal-proc'></a> Procedure to install the Self-Guided Tour Training Portal and Workshop

To install the Self-Guided Tour Training Portal and Workshop:

1. Confirm you have the workshop package installed by running:

    ```console
    tanzu package available list workshops.learningcenter.tanzu.vmware.com --namespace tap-install
    ```

1. Install the Learning Center Training Portal with the Self-Guided Tour Workshop by running:

    **Remember to change the 0.x.x version**
    ```console
    tanzu package install learning-center-workshop --package-name workshops.learningcenter.tanzu.vmware.com --version 0.x.x -n tap-install
    ```

1. Check for the Training Portals available in your environment by running:

    ```console
    kubectl get trainingportals
    ```

    Example output:

    ```console
    NAME                       URL                                           ADMINUSERNAME         ADMINPASSWORD                      STATUS
        learningcenter-tutorials   http://learningcenter-tutorials.example.com   learningcenter        QGBaM4CF01toPiZLW5NrXTcIYSpw2UJK   Running
    ```

## <a id='support-lc-values'></a> Supported Learning Center Values Configuration

Admins are provided the following sample learning-center-config.yaml file to see the possible configurations supported by Learning Center. These configurations are additional ones that admins can provide to the operator resource but are by no means necessary for Learning Center to work. It is enough to follow the previous instructions on this page for Learning Center to run.

It is important to note that Learning Center has default values in place for the learning-center-config.yaml file. Admins only need to provide the values they want to override. As in the example above, overriding the ingressDomain property is enough to get Learning Center to work.

```yaml
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
#! by the cluster is used if not defined. You might need to set storage group
#! where a cluster has pod security policies enabled, usually
#! to one. Set storage user and storage group in exceptional cases
#! where storage class uses maps to NFS storage and storage server requires
#! that a specific user and group always be used.
storageClass: null
storageUser: null
storageGroup: null
#! Credentials for accessing training portal instances. If not specified,
#! random passwords are generated that you can obtain from the custom resource
#! for the training portal.
portalCredentials:
  systemAdmin:
    username: learningcenter
    password: null
  clientAccess:
    username: robot@learningcenter
    password: null
#! Container image versions for various components of Learning Center. The Learning Center
#! operator needs to be modified to read names of images for the registry
#! and docker-in-docker from config map to enable disconnected install.
#! Prepull images to nodes in cluster. Should be an empty list if no images
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
#! Used to restrict access to IP addresses or IP subnets. This must be a CIDR block range corresponding to the subnet or a portion of a
#! subnet you want to block. A Kubernetes `NetworkPolicy` is used to enforce the restriction. So the
#! Kubernetes cluster must use a network layer supporting network policies, and the necessary Kubernetes
#! controllers supporting network policies must be enabled when the cluster is installed.
network:
  blockCIDRs:
  - 169.254.169.254/32
  - fd00:ec2::254/128
```

See [Restricting Network Access](./runtime-environment/system-profile.md#restrict-network-access) for more information on blocking CIDRs.
