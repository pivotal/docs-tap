# Learning Center operator

Before deploying workshops, install a Kubernetes Operator for Learning Center.
The operator manages the setup of the environment for each workshop and deploys instances of a workshop for each person.

For information about installing the operator, see basic instructions for [Installing the Learning Center operator](../../install-components.md#install-learning-center).


Additional information about installing and setting up Learning Center operator.

##<a id="cluster"></a>Kubernetes cluster requirements

Learning Center operator is deployed to any Kubernetes cluster that supports custom
resource definitions and the concept of operators.

The cluster must have an Ingress router configured. Only a basic deployment of the Ingress controller
is usually required. You do not need to configure the Ingress controller to handle cluster-wide edge termination of secure HTTP connections. Learning Center creates Kubernetes Ingress resources and
supplies any secret for use with secure HTTP connections for each ingress.

For the Ingress controller, it is a best practice to use Contour over alternatives, such as NGINX.
An NGINX-based ingress controller has a design that is less than optimal. Every time a new Ingress is
created or deleted, the nginx config is reloaded. This causes the termination of websocket connections after a period of time. Learning Center terminals are implemented to reconnect automatically when the websocket connection is lost. But some applications used with some workshops might be ineffective at handling loss of websocket connections. This problem is not unique to Learning Center. It can impact any application when
an NGINX Ingress controller is used frequently and Ingresses are created/deleted frequently.

When using a hosted Kubernetes solution from an IaaS provider ensure that any HTTP request timeout specified on the inbound load balancer for the Ingress controller is increased, such that established websocket connections are accommodated. Load balancers of hosted Kubernetes solutions sometimes have only have a 30-second timeout. Configure the timeout applied to websockets to an hour.

When deploying the web-based training portal, the cluster must have available persistent volumes of type ``ReadWriteOnce (RWO)``.
A default storage class must be defined so that persistent volume claims are not required to specify a storage class.
For some Kubernetes distributions, including those from IBM, it might be necessary to configure Learning Center to respond to the user and group to be used for persistent volumes. If no default storage class is specified, or a specified storage class is required, configure Learning Center with the name of the storage class.

You must have cluster admin access to install the Learning Center operator.

##<a id="pod-security"></a> Cluster Pod security policies

The Learning Center operator defines Pod security policies to limit what users can do from workshops when
deploying workloads to the cluster. The default policy prohibits the running of images as the ``root`` user or using
a privileged Pod. Specified workshops can relax these restrictions and apply a policy which enables additional
privileges required by the workshop.

It is recommended that the Pod security policy admission controller be enabled for the cluster to ensure
that the Pod security policies are applied. If the admission controller is not enabled, users can
deploy workloads that run as the ``root`` user in a container, or run privileged Pods.

If you are unable to enable the Pod security policy admission controller, provide access to workshops
deployed using the Learning Center operator to users you trust.
>**Note:** Where the Pod security policy admission controller is not enabled, any workshops that require users to create persistent volumes might not work, as the user the Pod runs might not have access to the volume. The Pod security policy enables access by ensuring that the security context of a Pod is modified to give access.

Whether the absence of the Pod security policy admission controller causes issues with access to persistent volumes
depends on the cluster. Although minikube does not enable the Pod security policy admission controller, it
works as persistent volumes when mounted to give write permissions to all users.

No matter whether Pod security policies are enabled or not, individual workshops must be reviewed as to what
additional privileges they grant before allowing their use in a cluster.

##<a id="ingress-domain"></a>Specifying the ingress domain

When deploying instances of workshop environments, the operator must expose the instances
by using an external URL for access to define the domain name that is used as a suffix to host names for instances.

>**Note:** For the custom domain you are using, configure your DNS with a wildcard domain to forward all requests for sub domains of the custom domain to the ingress router of the Kubernetes cluster.

VMware recommends that you avoid using a ``.dev`` domain name. These domain names have a requirement to use HTTPS. Although you can provide a certificate for secure connections under the domain name for use by Learning Center, this does not extend to what a workshop can do. By using a ``.dev`` domain name, if workshop instructions require you to create ingresses in Kubernetes
using HTTP only, they do not work.

>**Note:** If you are running Kubernetes on your local machine using a system such as ``minikube`` and you do not have a custom domain name which maps to the IP address for the cluster, you can use a ``nip.io`` address. For example, if ``minikube ip`` returned ``192.168.64.1``, you can use the 192.16 8.64.1.nip.io domain. Note that you cannot use an address of form ``127.0.0.1.nip.io``, or ``subdomain.localhost``. This causes a failure as internal services, when needing to connect to each other, connect to themselves instead, because the address resolves to the host loopback address of ``127.0.0.1``.

###<a id="config-yaml"></a>Configuration YAML
Define the ``ingressDomain`` property on the configuration YAML passed to Tanzu CLI.

>**Note:** This property is required to install Learning Center using Tanzu CLI

```
ingressDomain: learningcenter.my-domain.com
```

### <a id="NAME"></a>Set the environment variable manually
Set the ``INGRESS_DOMAIN`` environment variable on the operator deployment. To set the ``INGRESS_DOMAIN``
environment variable, run:

```
kubectl set env deployment/learningcenter-operator -n learningcenter INGRESS_DOMAIN=test
``` <!-- Define any non-obvious placeholders present in the code snippet in the style of |Where PLACEHOLDER is...| -->
Replace ``test`` with the domain name for your Kubernetes cluster.

or if using a ``nip.io`` address
```
kubectl set env deployment/learningcenter-operator -n learningcenter INGRESS_DOMAIN=192.168.64.1.nip.io

>**Note:** Use of environment variables to configure the operator is a short cut to cater for the
simple use case. The recommended way is to use Tanzu CLI or for more complicated scenarios the
``SystemProfile`` custom resource can be<!-- Consider switching to active voice. --> used.


##<a id="connections"></a>Enforcing secure connections

By default, the workshop portal and workshop sessions is accessible over HTTP connections. If you
want to use secure HTTPS connections, you must have access to a wildcard SSL certificate for the domain
under which you want to host the workshops. You cannot use a self signed certificate.

Wildcard certificates can be<!-- Consider switching to active voice. --> created using `letsencrypt <https://letsencrypt.org/>`_. After you have the certificate, you can:

###<a id="NAME"></a>Configuration YAML

The easiest way to define the certificate is with the configuration passed to Tanzu CLI. So define
the ``certificate`` and ``privateKey`` properties under the ``ingressSecret`` property to specify the
certificate on the configuration yaml passed to Tanzu CLI

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
  defined, and use the `secretName` property as in this example:

  ```
  ingressSecret:
    secretName: workshops.example.com-tls
  ```

###<a id="TLS"></a>Create the TLS secret manually

To add the certificate as a secret in the ``learningcenter`` namespace or that one you defined, the
secret must be of type ``tls``. You can create it using the ``kubectl create secret tls`` command.

```
kubectl create secret tls -n learningcenter workshops.example.com-tls --cert=workshops.example.com/fullchain.pem --key=workshops.example.com/privkey.pem
```

Having created the secret, if it is the secret corresponding to the default ingress domain you specified, set the ``INGRESS_SECRET`` environment variable (if you don't want to use the configuration passed to Tanzu CLI)
on the operator deployment. This will ensure that it is applied automatically to any ingress created.

```
kubectl set env deployment/learningcenter-operator -n learningcenter INGRESS_SECRET=workshops.example.com-tls
```

If the certificate is not that of the default ingress domain, you can supply the domain name and name of the
secret when creating a workshop environment or training portal. In either case, secrets for the wildcard
certificates must be created in the ``learningcenter`` namespace or that one you defined.

##<a id="class"></a>Specifying the ingress class

Any ingress routes created uses the default ingress class. If you have multiple ingress class
types available, and you must override which is used, you can:

###<a id="yaml"></a>Configuration YAML
Define the ``ingressClass`` property on the configuration YAML passed to Tanzu CLI
```
ingressClass: contour
```

###<a id="NAME"></a>Set the environment variable manually
Set the ``INGRESS_CLASS`` environment variable for the learningcenter operator.
```
kubectl set env deployment/learningcenter-operator -n learningcenter INGRESS_CLASS=contour
```

This applies only to the ingress created for the training portal and workshop sessions. It does not apply
to the any ingress created from a workshop as part of the workshop instructions.

This can be necessary where a specific ingress provider is not as reliable in maintaining websocket connections,
as explained earlier is the case for the nginx ingress controller when there are frequent creation or deletions
of ingresses occurring in the cluster.

##<a id="registries"></a>Trusting unsecured registries

One of the options available for workshops is automatically to deploy a container image registry per workshop session.
When the Learning Center operator is configured to use a secure ingress with valid wildcard certificate, the registry works out of the box.

If the Learning Center operator is not setup to use secure ingress, the registry is accessed over
HTTP and is regarded as an unsecured registry.

When using the optional support for building container images using ``docker<!-- |Docker| is preferred. -->``, the Docker daemon deployed for the workshop session is configured in this case so it recognizes the registry is unsecured, and pushing images to the registry still works.

In this case of an unsecured registry, deployment of images from the registry to the Kubernetes
cluster does not work unless the Kubernetes cluster is configured to trust the unsecured registry.

How you configure a Kubernetes cluster to trust an unsecured registry is different based on how the Kubernetes
cluster is deployed and what container runtime it uses.

If you are using ``minikube`` with ``dockerd``, to ensure that the registry is trusted, you must set up the trust the very first time you create the minikube instance.

To do this, determine which IP address subnet minikube uses for the inbound ingress router of the cluster. If you
already have a minikube instance running, you can determine this by running ``minikube ip``. If reported ``192.168.64.1``, the subnet used is ``129.168.64.0/24``.

With this information, when you create a fresh ``minikube`` instance you must supply the ``--insecure<!-- |not secure| is preferred. -->-registry`` option with the subnet.

```
minikube start --insecure-registry="129.168.64.0/24"
```

What this option does is tell ``dockerd`` to regard any registryas unsecured, which is deployed in the
Kubernetes cluster, and which is accessed using a URL exposed using an ingress route of the cluster itself.

>**Note:** At this time, there is no known way to configure ``containerd`` to treat image registries matching a
wildcard subdomain, or which reside in a subnet, as unsecured. It is therefore not possible to run workshops which
must deploy images from the per session registry when using ``containerd`` as the underlying Kubernetes
cluster container runtime. This is a limitation of ``containerd`` and there are no known plans for ``containerd``
to support this ability. This limits your ability to use Kubernetes clusters deployed with a tool such as ``kind``,
which relies on using ``containerd``.
