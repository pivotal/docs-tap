# ACME Challenges

cert-manager.io provides APIs for managing certificates on Kubernetes. It is
one of the most popular extensions for Kubernetes and has found ubiquitous
adoption. ACME - _Automatic Certificate Management Environment_ - is a protocol
for automatically obtaining certificates from certificate authorities.
LetsEncrypt has designed and pioneered ACME and is one of the most-popular
ACME-style, public CA.

ACME can be used with either an HTTP01 or a DNS01 challenge. In both cases the
certificate requester has to prove ownership of the domain either by answering
a plain HTTP request or by setting a DNS record.

When using cert-manager’s `(Cluster)Issuer` with an ACME HTTP01 challenge
solver,  a `Pod` is run and exposed to the network via ingress. The `Pod`
receives the challenge from the CA and responds. If the challenge is solved
successfully, the certificate will be issued.

When using cert-manager’s `(Cluster)Issuer` with an ACME DNS01 challenge
solver, the owner of the domain answers the challenge by setting a `TXT` record
under the domain name. If the challenge is solved successfully, the certificate
will be issued.

Working with DNS01 challenges is harder than with HTTP01 challenges, but can work in
situations where HTTP01 can't.

## HTTP01 challenges can fail

All of TAP's components' images are relocated to and pulled from a private
registry. This applies for `cert-manager.tanzu.vmware.com` as well, including
the ACME HTTP01 solver `Pod`'s image.

Due to the design of cert-manager’s `(Cluster)Issuer` resources, it is not easy
to provide them with credentials to your private registry in a way that works
consistently across all namespaces in your cluster.

It is possible to deeply integrate a cluster with a private registry such that
image pull secrets don't have to be provided explicitely. This is a common
practice with popular cloud-based Kubernetes providers like GKE, AKS and EKS.

As a result, ACME HTTP01 challenges can fail when your cluster is not deeply
integrated with your private registry. In that case we recommend the following
workarounds:

* Use [DNS01
  challenges](https://cert-manager.io/docs/configuration/acme/dns01/)
  _(recommended)_

* Provide your `(Cluster)Issuer` with a `ServiceAccount` through its [pod
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

   The complexity here is that - in case of `ClusterIssuer` - you will have to
   make the same `ServiceAccount` available in every namespace which obtains
   `Certificates` from this `ClusterIssuer`.
