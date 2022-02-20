# Install Learning Center

This document describes how to install Learning Center
from the Tanzu Application Platform package repository.

>**Note:** Use the instructions on this page if you do not want to use the full profile to install packages.
Only the full profile includes Learning Center.
For more information about profiles, see [Installing the Tanzu Application Platform Package and Profiles](../install.md).

To install Tanzu Learning Center, see the following sections.

For general information about Learning Center, see [Learning Center](about.md). For information about deploying Learning Center operator, see [Learning Center operator](../learning-center/getting-started/learningcenter-operator.md).

## <a id='prereqs'></a>Prerequisites

Before installing Learning Center:

- Complete all prerequisites to install Tanzu Application Platform. For more information, see [Prerequisites](../prerequisites.md).

- The cluster must have an ingress router configured. If you have installed the TAP package through
the full profile or light profile, it already deploys a contour ingress controller.

- The operator, when deploying instances of the workshop environments, needs to be able to expose them through an external URL for access. For the custom domain you are using, DNS must have been configured with a wildcard domain to forward all requests for sub-domains of the custom domain to the ingress router of the Kubernetes cluster.

- By default, the workshop portal and workshop sessions are accessible over HTTP connections. If you wish to use secure HTTPS connections, you must have access to a wildcard SSL certificate for the domain under which you wish to host the workshops. You cannot use a self-signed certificate.

- Any ingress routes created use the default ingress class if you have multiple ingress class types available and you need to override which is used.

### <a id='install'></a>Install

To install Learning Center:

1. List version information for the package by running:

    ```
    tanzu package available list learningcenter.tanzu.vmware.com --namespace tap-install
    ```

    Example output:

    ```
     NAME                             VERSION        RELEASED-AT
     learningcenter.tanzu.vmware.com  0.1.0          2021-12-01 08:18:48 -0500 EDT
    ```

1. (Optional) See all the configurable parameters on this package by running:

    **Remember to change the 0.x.x version**
    ```
    tanzu package available get learningcenter.tanzu.vmware.com/0.x.x --values-schema --namespace tap-install
    ```

1. Create a config file named `learning-center-config.yaml`.

1. Add the parameter `ingressDomain` to `learning-center-config.yaml`, as in this example:

    ```
    ingressDomain: YOUR-INGRESS-DOMAIN
    ```

    Where `YOUR-INGRESS-DOMAIN` is the domain name for your Kubernetes cluster.

    When deploying workshop environment instances, the operator must be able to expose the instances
    through an external URL. This access is needed to discover the domain name that can be used as a
    suffix to hostnames for instances.

    For the custom domain you are using, DNS must have been configured with a wildcard domain to
    forward all requests for sub-domains of the custom domain to the ingress router of the
    Kubernetes cluster.

    If you are running Kubernetes on your local machine using a system such as `minikube` and you
    don't have a custom domain name that maps to the IP for the cluster, you can use a `nip.io`
    address.
    For example, if `minikube ip` returns `192.168.64.1`, you can use the `192.168.64.1.nip.io`
    domain.
    You cannot use an address of form `127.0.0.1.nip.io` or `subdomain.localhost`. This will cause a
    failure. Internal services needing to connect to each other will connect to themselves instead
    because the address would resolve to the host loopback address of `127.0.0.1`.

1. Add the `ingressSecret` to `learning-center-config.yaml`, as in this example:

    ```
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
    - Copy the tls secret to the `learningcenter` namespace or the one you
    defined and use the `secretName` property as in this example:

    ```
    ingressSecret:
     secretName: workshops.example.com-tls
    ```

    By default, the workshop portal and workshop sessions are accessible over HTTP connections.

    To use secure HTTPS connections, you must have access to a wildcard SSL certificate for the
    domain under which you want to host the workshops. You cannot use a self-signed certificate.

    Wildcard certificates can be created using letsencrypt <https://letsencrypt.org/>_.
    After you have the certificate, you can define the `certificate` and `privateKey` properties
    under the `ingressSecret` property to specify the certificate on the configuration yaml.

1. Any ingress routes created use the default ingress class.
If you have multiple ingress class types available, and you need to override which is used, define
the `ingressClass` property in `learning-center-config.yaml` **before deploying any workshop**:

    ```
    ingressClass: contour
    ```

1. Install Learning Center operator by running:

    **Remember to change the 0.x.x version**
    ```
    tanzu package install learning-center --package-name learningcenter.tanzu.vmware.com --version 0.x.x -f learning-center-config.yaml
    ```

    The command above will create a default namespace in your Kubernetes cluster called `learningcenter`,
    and the operator, along with any required namespaced resources, is created in it.
    A set of custom resource definitions and a global cluster role binding are also created.

    You can check that the operator deployed successfully by running:

    ```
    kubectl get all -n learningcenter
    ```

    The pod for the operator should be marked as running.

## <a id='install-portal-proc'></a> Procedure to install the Self-Guided Tour Training Portal and Workshop

To install the Self-Guided Tour Training Portal and Workshop:

1. Make sure you have the workshop package installed by running:

    ```
    tanzu package available list workshops.learningcenter.tanzu.vmware.com --namespace tap-install
    ```

1. Install the Learning Center Training Portal with the Self-Guided Tour Workshop by running:

    **Remember to change the 0.x.x version**
    ```
    tanzu package install learning-center-workshop --package-name workshops.learningcenter.tanzu.vmware.com --version 0.x.x -n tap-install
    ```

1. Check the Training Portals available in your environment by running:

    ```
    kubectl get trainingportals
    ```

    Example output:

    ```
    NAME                       URL                                           ADMINUSERNAME         ADMINPASSWORD                      STATUS
    learningcenter-tutorials   http://learningcenter-tutorials.example.com   learningcenter        QGBaM4CF01toPiZLW5NrXTcIYSpw2UJK   Running
    ```
