# Learning Center operator

Before deploying workshops, install a Kubernetes operator for Learning Center.
The operator manages the setup of the environment for each workshop and deploys instances of a workshop for each person.

For basic information about installing the operator, see [Install Learning Center](../install-learning-center.md).

## <a id="install-set-up"></a>Installing and setting up Learning Center operator

The following is additional information about installing and setting up the Learning Center operator.

You can deploy the Learning Center operator to any Kubernetes cluster supporting custom
resource definitions and the concept of operators.
The cluster must have an ingress router configured, though only a basic deployment of the ingress controller
is usually required. You do not need to configure the ingress controller to handle cluster wide edge
termination of secure HTTP connections. Learning Center creates Kubernetes Ingress resources and
supplies any secret for use with secure HTTP connections for each ingress.

For the ingress controller, VMware recommends the use of Contour over alternatives such as nginx.
An nginx-based ingress controller has a less than optimal design. Every time a new ingress is
created or deleted, the nginx config is reloaded. This causes websocket connections to terminate
after a period of time. Learning Center terminals reconnect automatically in the case
of the websocket connection being lost. However, not all applications you might use with specific workshops can
handle loss of websocket connections so gracefully, and they might be impacted due to the use of an nginx
ingress controller. This problem is not specific to Learning Center. It can impact any application when
an nginx ingress controller is used frequently and ingresses are created or deleted frequently.

You can use a hosted Kubernetes solution from an IaaS provider such as Google, AWS, or Azure. If you do, as needed, increase any HTTP request timeout specified on the inbound load balancer for the ingress controller so that you can use long-lived websocket connections. In some cases, load balancers of hosted Kubernetes solutions only have a 30-second timeout. If possible, configure the timeout applying to websockets to be 1 hour.

If you deploy the web-based training portal, the cluster must have available persistent volumes of type `ReadWriteOnce (RWO)`.
A default storage class must be defined so that persistent volume claims do not need to specify a storage class.
For some Kubernetes distributions, including from IBM, you must configure Learning Center as to
what user and group must be used for persistent volumes. If no default storage class is specified, or a specified
storage class is required, you can configure Learning Center with the name of the storage class.

To install the Learning Center operator, you must have cluster admin access.

## <a id="cluster-pod-security-pol"></a>Cluster pod security policies

The Learning Center operator defines pod security policies to limit what users can do from workshops when
deploying workloads to the cluster. The default policy prohibits running of images as the `root` user or using
a privileged pod. Specified workshops can relax these restrictions and apply a policy that enables additional
privileges required by the workshop.

VMware recommends that the pod security policy admission controller be enabled for the cluster to ensure
that the pod security policies are applied. If the admission controller is not enabled, users can
deploy workloads that run as the `root` user in a container, or run privileged pods.

If you are unable to enable the pod security policy admission controller, you should only provide access to workshops
deployed using the Learning Center operator to users you trust.

Whether the absence of the pod security policy admission controller causes issues with access to persistent volumes
depends on the cluster. Although minikube does not enable the pod security policy admission controller, it
works as persistent volumes when mounted to give write permissions to all users.

No matter whether pod security policies are enabled, individual workshops must be reviewed as to what
added privileges they grant before allowing their use in a cluster.

## <a id="ingress-domain"></a>Specifying the ingress domain

When deploying instances of workshop environments, the operator must expose the instances
by using an external URL for access to define the domain name that is used as a suffix to host names for instances.

>**Note:** For the custom domain you are using, configure your DNS with a wildcard domain to forward all requests for subdomains of the custom domain to the ingress router of the Kubernetes cluster.

VMware recommends that you avoid using a `.dev` or `.app` domain name, because such domain names require
browsers to use HTTPS and not HTTP. Although you can provide a certificate for secure
connections under the domain name for use by Learning Center, this doesn't extend to what a workshop
may do. If workshop instructions require that you create ingresses in Kubernetes
using HTTP only, a `.dev` or `.app` domain name cannot work in the browser.

>**Note:** If you are running Kubernetes on your local machine using a system such as `minikube` and you don't have a custom domain name that maps to the IP address for the cluster, you can use a `nip.io` address. For example, if `minikube ip` returned `192.168.64.1`, you can use the 192.168.64.1.nip.io domain. You cannot use an address of form `127.0.0.1.nip.io` or `subdomain.localhost`. This causes a failure as internal services needing to connect to each other end up connecting to themselves instead, because the address resolves to the host loopback address of `127.0.0.1`.

If needed, you can override the `shared.ingress_domain` in the values file of Tanzu Application Platform with the `ingressDomain` parameter of learning center:

```console
ingressDomain: learningcenter.my-domain.com
```

### <a id="set-ingress-domain"></a>Set the environment variable manually

Set the `INGRESS_DOMAIN` environment variable on the operator deployment. To set the `INGRESS_DOMAIN`
environment variable, run:

```console
kubectl set env deployment/learningcenter-operator -n learningcenter INGRESS_DOMAIN=test
```

Where `test` is the domain name for your Kubernetes cluster.

Or if using a `nip.io` address:

```console
kubectl set env deployment/learningcenter-operator -n learningcenter INGRESS_DOMAIN=192.168.64.1.nip.io
```

Use of environment variables to configure the operator is a shortcut for a
simple use. VMware recommends using Tanzu CLI, or for more complicated scenarios, you can use the  `SystemProfile` custom resource.


##<a id="enforce-secure-connect"></a>Enforcing secure connections

By default, the workshop portal and workshop sessions are accessible over HTTP connections.
To use secure HTTPS connections, you must have access to a wildcard SSL certificate for the domain
under which you want to host the workshops. You cannot use a self-signed certificate.

You can create wildcard certificates by using `letsencrypt <https://letsencrypt.org/>`. After you have the
certificate, you can define it as follows.

###<a id="configuration-yaml"></a>Configuration YAML

The easiest way to define the certificate is with the configuration passed to Tanzu CLI. So define
the `certificate` and `privateKey` properties under the `ingressSecret` property to specify the
certificate on the configuration YAML passed to Tanzu CLI:

  ```console
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

If you already have a TLS secret, follow these steps **before deploying any workshops**:

1. Create the `learningcenter` namespace manually or the one you defined.
2. Copy the TLS secret to the `learningcenter` namespace or to the one you defined, and use the `secretName` property as in this example:

  ```console
  ingressSecret:
      secretName: workshops.example.com-tls
  ```

###<a id="tls"></a>Create the TLS secret manually

To add the certificate as a secret in the `learningcenter` namespace or in the one you defined, the
secret must be of type `tls`. You can create it using the `kubectl create secret tls` command:

```console
kubectl create secret tls -n learningcenter workshops.example.com-tls --cert=workshops.example.com/fullchain.pem --key=workshops.example.com/privkey.pem
```

Having created the secret, if it is the secret corresponding to the default ingress domain you specified
earlier, set the `INGRESS_SECRET` environment variable. This way you do not use the configuration passed to Tanzu CLI
on the operator deployment. This ensures the secret is applied automatically to any ingress created:

```console
kubectl set env deployment/learningcenter-operator -n learningcenter INGRESS_SECRET=workshops.example.com-tls
```

If the certificate isn't that of the default ingress domain, you can supply the domain name and name of the
secret when creating a workshop environment or training portal. In either case, you must create secrets for the wildcard
certificates in the `learningcenter` namespace or the one that you defined.

##<a id="class"></a>Specifying the ingress class

Any ingress routes created use the default ingress class. If you have multiple ingress class
types available, and you must override which is used, you can define the `ingressClass` property on the configuration YAML as follows.

###<a id="yaml"></a>Configuration YAML

Define the `ingressClass` property on the configuration YAML passed to Tanzu CLI:

```yaml
ingressClass: contour
```

###<a id="set-ingress-class"></a>Set the environment variable manually

Set the `INGRESS_CLASS` environment variable for the learningcenter operator:

```console
kubectl set env deployment/learningcenter-operator -n learningcenter INGRESS_CLASS=contour
```

This applies only to the ingress created for the training portal and workshop sessions. It does not apply
to any ingress created from a workshop as part of the workshop instructions.

This can be necessary when a specific ingress provider is not reliable in maintaining websocket connections.
For example, in the case of the nginx ingress controller when there are frequent creation or deletions
of ingresses occurring in the cluster. See the earlier section, [Installing and setting up Learning Center operator](#install-set-up).

##<a id="registries"></a>Trusting unsecured registries

One of the options available for workshops is to automatically deploy a container image registry each workshop session.
When the Learning Center operator is configured to use a secure ingress with a valid wildcard certificate, the
image registry works out of the box.

If the Learning Center operator is not set up to use secure ingress, the image registry is accessed over
HTTP and is regarded as not secure.

When using the optional support for building container images using `docker`, the docker daemon deployed for
the workshop session is configured for the image registry being not secure yet pushing
images to the image registry still works.

In this case of an image registry that is not secure, deploying images from the image registry to the Kubernetes
cluster does not work unless the Kubernetes cluster is configured to trust the registry that is not secure.

How you configure a Kubernetes cluster to trust an unsecured registry varies based on how the Kubernetes
cluster is deployed and what container runtime it uses.

If you are using `minikube` with `dockerd`, to ensure that the registry is trusted, you must set up the trust the first time you create the minikube instance.

To do this, first determine which IP subnet minikube uses for the inbound ingress router of the cluster. If you
already have a minikube instance running, you can determine this by running `minikube ip`. If, for example, this
reported `192.168.64.1`, the subnet used is `129.168.64.0/24`.

With this information, when you create a fresh `minikube` instance, you must supply the `--insecure-registry` option with the subnet:

```console
minikube start --insecure-registry="129.168.64.0/24"
```

This option tells `dockerd` to regard as not secure any image registry deployed in the
Kubernetes cluster and accessed through a URL exposed using an ingress route of the cluster itself.

Currently, there is no way to configure `containerd` to treat as not secure image registries that match a
wildcard subdomain or reside in a subnet. It is therefore not possible to run workshops that
must deploy images from the per session image registry when using `containerd` as the underlying Kubernetes
cluster container runtime. This is a limitation of `containerd`, and there are no known plans for `containerd`
to support this ability. This limits your ability to use Kubernetes clusters deployed with a tool such as `kind`, which relies on using `containerd`.
