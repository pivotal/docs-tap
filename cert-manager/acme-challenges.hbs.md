# ACME Challenges

cert-manager.io provides APIs for managing certificates on Kubernetes. It is
one of the most popular extensions for Kubernetes and has found ubiquitous
adoption. Automatic Certificate Management Environment (commonly called ACME) is 
a protocol for automatically obtaining certificates from certificate authorities.
LetsEncrypt has designed and pioneered ACME and is one of the most-popular
ACME-style, public CA.

You can use ACME with either an HTTP01 or a DNS01 challenge. In both cases the
certificate requester must prove ownership of the domain either by answering
a plain HTTP request or by setting a DNS record.

When using cert-manager’s `(Cluster)Issuer` with an ACME HTTP01 challenge
solver,  a `Pod` is run and exposed to the network by using ingress. The `Pod`
receives the challenge from the CA and responds. If the challenge is solved
successfully, the certificate is issued.

When using cert-manager’s `(Cluster)Issuer` with an ACME DNS01 challenge
solver, the owner of the domain answers the challenge by setting a `TXT` record
under the domain name. If the challenge is solved successfully, the certificate
is issued.

Working with DNS01 challenges is harder than with HTTP01 challenges, but can work 
in situations where HTTP01 can't.

## <a id="fail"></a>HTTP01 challenges can fail

All of components' images of Tanzu Application Platform are relocated to and pulled 
from a private registry. This also applies to `cert-manager.tanzu.vmware.com`, 
including the ACME HTTP01 solver `Pod`'s image.

Due to the design of cert-manager’s `(Cluster)Issuer` resources, it is not easy
to provide them with credentials to your private registry in a way that works
consistently across all namespaces in your cluster.

You can deeply integrate a cluster with a private registry so that image pull secrets 
don't have to be provided explicitely. This is a common practice with popular 
cloud-based Kubernetes providers such as GKE, AKS and EKS.

As a result, ACME HTTP01 challenges can fail when your cluster is not deeply
integrated with your private registry. In that case VMware recommends the following
workarounds:

- (Recommended) Use [DNS01
  challenges](https://cert-manager.io/docs/configuration/acme/dns01/)

- Provide your `(Cluster)Issuer` with a `ServiceAccount` by using its [pod
  template](https://cert-manager.io/docs/configuration/acme/http01/#podtemplate)
  so that it can pull from your registry. For example:

    ```yaml
    ---
    apiVersion: v1
    kind: ServiceAccount
    metadata:
     name: tap-acme-http01-solver
     namespace: #! ...
    imagePullSecrets:
     - registry-credentials

    ---
    apiVersion: cert-manager.io/v1
    kind: ClusterIssuer
    metadata: #! ...
    spec:
     #! ...
     acme:
       solvers:
         - http01:
             ingress:
               podTemplate:
                 spec:
                   serviceAccountName: tap-acme-http01-solver
    ```

    The challenge lies in ensuring that the same `ServiceAccount` is available in 
    every namespace that obtains `Certificates` from the `ClusterIssuer`.
