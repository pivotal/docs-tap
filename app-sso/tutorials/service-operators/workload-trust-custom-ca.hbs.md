# Configure workloads to trust a custom CA

This topic tells you how to configure workloads to trust a custom Certificate 
Authority (commonly called CA) for Application Single Sign-On (commonly called AppSSO).

## Overview

If your `ClientRegistration` selects an `AuthServer` that serves a certificate from a custom CA, your `Workload`
does not trust it by default. This is because the certificate is not issued by a trusted certificate authority from the `Workload`'s perspective. 

To establish trust between a `Workload` and an `AuthServer`:

|Step|Task|Link|
|----|----|----|
|1.| Service Operator exports the custom CA certificate `Secret` resource from the namespace in which it is issued. |[Exporting custom CA certificate Secret](#export-ca)|
|2.| Service Operator imports the custom CA certificate `Secret` to the namespace in which the `Workload` is created. |[Importing custom CA certificate Secret](#import-ca)|
|3.| Append the deployed `Workload` as a service resource claim, denoting the custom CA certificate `Secret` in the workload namespace. |[Appending custom CA certificate Secret reference to Workload](#append-ca)|

> **Important** These steps are mandatory if Tanzu Application Platform is installed with the default self-signed `ClusterIssuer` resource, in which the CA is custom.

## <a id="export-ca"></a> Exporting custom CA certificate Secret

A `ca-certificates` service binding `Secret` allows to configure trust for custom CAs.

For more information about exporting CA certificate Secrets, see [Allow Workloads to trust a custom CA AuthServer](./issuer-uri-and-tls.md#trust-custom-ca).

**Example:** Create a `ca-certificates`-type ServiceBinding Secret from template and offer Tanzu Application Platform's default self-signed CA
certificate Secret to workloads namespace.

```yaml
---
apiVersion: secretgen.carvel.dev/v1alpha1
kind: SecretTemplate
metadata:
  name: tap-ca-cert
  namespace: cert-manager                     # The namespace in which your custom CA Secret resides.
spec:
  inputResources:
    - name: tap-ingress-selfsigned-root-ca
      ref:
        apiVersion: v1                        # The custom CA certificate Secret.
        kind: Secret                          # ^^
        name: tap-ingress-selfsigned-root-ca  # ^^
  template:
    data:
      ca.crt: $(.tap-ingress-selfsigned-root-ca.data.tls\.crt)
    stringData:
      type: ca-certificates
---
apiVersion: secretgen.carvel.dev/v1alpha1
kind: SecretExport
metadata:
  name: tap-ca-cert           # The name of the SecretTemplate that created the "ca-certificates" Secret.
  namespace: cert-manager     # The namespace in which Tanzu Application Platform's self-signed ClusterIssuer stores its CA cert Secret.
spec:
  toNamespace: my-apps        # The namespace in which Workloads are deployed.
```

## <a id="import-ca"></a> Importing custom CA certificate Secret

After the custom CA certificate Secret is exported from its original namespace, you can import it into the
workloads' namespace.

**Example:** Accept Tanzu Application Platform's default self-signed CA certificate Secret offer.

```yaml
---
apiVersion: secretgen.carvel.dev/v1alpha1
kind: SecretImport
metadata:
  name: tap-ca-cert
  namespace: my-apps            # The namespace in which Workloads are deployed.
spec:
  fromNamespace: cert-manager   # The namespace in which your custom CA certificate Secret resides.
```

## <a id="append-ca"></a> Appending custom CA certificate Secret reference to Workload

With custom CA certificate available in the workloads' namespace, you can append it to the `Workload` as a service 
resource claim:

**Example:** Appending custom CA certificate Secret as a resource claim.

```yaml

---
apiVersion: carto.run/v1alpha1
kind: Workload
# ...
spec:
  serviceClaims:
    - name: ca-cert
      ref:
        apiVersion: v1    # The custom CA Secret template that is imported into the workloads' namespace.
        kind: Secret      # ^^
        name: tap-ca-cert # ^^
    # ...
```

Alternatively, you can provide the workload with a `--service-ref` parameter for the same effect:

```shell
--service-ref "ca-cert=v1:Secret:tap-ca-cert"
```

For more information about secretgen-controller and its APIs, see [secretgen-controller documentation](https://github.com/vmware-tanzu/carvel-secretgen-controller) in GitHub.
