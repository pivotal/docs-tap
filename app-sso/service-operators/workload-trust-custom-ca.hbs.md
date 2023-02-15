# Configuring Workloads to trust a custom Certificate Authority (CA)

If your `ClientRegistration` selects an `AuthServer` which serves a certificate from a custom CA, then your `Workload`
will not trust it by default, as the certificate is not issued by a trusted certificate authority from the `Workload`'s
perspective. 

**To establish trust between a `Workload` and an `AuthServer`, the following steps are involved**:

1. Service Operator exports the custom CA certificate `Secret` resource from the namespace in which it is issued.
2. Service Operator imports the custom CA certificate `Secret` to the namespace in which the `Workload` is created.
3. The `Workload` being deployed is appended a service resource claim, denoting the custom CA certificate `Secret` in the workload namespace.

> **Note** Steps below are mandatory if TAP is installed with the default self-signed `ClusterIssuer` resource, in which the CA is custom.

## Step 1: Exporting custom CA certificate Secret

A `ca-certificates` service binding `Secret` allows to configure trust for custom CAs.

For detailed information on exporting CA certificate Secrets, see [Allow `Workloads` to trust a custom CA `AuthServer`](./issuer-uri-and-tls.md#trust-custom-ca).

_Example_: create a `ca-certificates`-type ServiceBinding Secret from template and offer TAP's default self-signed CA
certificate Secret to workloads namespace

```yaml
---
apiVersion: secretgen.carvel.dev/v1alpha1
kind: SecretTemplate
metadata:
  name: tap-ca-cert
  namespace: cert-manager                     # the namespace in which your custom CA Secret resides
spec:
  inputResources:
    - name: tap-ingress-selfsigned-root-ca
      ref:
        apiVersion: v1                        # the custom CA certificate Secret
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
  name: tap-ca-cert           # the name of the SecretTemplate that created the "ca-certificates" Secret
  namespace: cert-manager     # the namespace in which TAP's self-signed ClusterIssuer stores its CA cert Secret
spec:
  toNamespace: my-apps        # the namespace in which Workloads are deployed
```

## Step 2: Importing custom CA certificate Secret

Once the custom CA certificate Secret has been exported from its original namespace, we can import it into the
workloads' namespace.

_Example_: accept TAP's default self-signed CA certificate Secret offer

```yaml
---
apiVersion: secretgen.carvel.dev/v1alpha1
kind: SecretImport
metadata:
  name: tap-ca-cert
  namespace: my-apps            # the namespace in which Workloads are deployed
spec:
  fromNamespace: cert-manager   # the namespace in which your custom CA certificate Secret resides
```

## Step 3: Appending custom CA certificate Secret reference to Workload

With custom CA certificate available in the workloads' namespace, we can now append it to the Workload as a service 
resource claim:

_Example_: appending custom CA certificate Secret as a resource claim

```yaml

---
apiVersion: carto.run/v1alpha1
kind: Workload
# ...
spec:
  serviceClaims:
    - name: ca-cert
      ref:
        apiVersion: v1    # The custom CA Secret template that is imported into the workloads' namespace
        kind: Secret      # ^^
        name: tap-ca-cert # ^^
    # ...
```

Alternatively, you can provide the workload with a `--service-ref` parameter for the same effect:

```shell
--service-ref "ca-cert=v1:Secret:tap-ca-cert"
```

For more information about secretgen-controller and its APIs, see [secretgen-controller documentation](https://github.com/vmware-tanzu/carvel-secretgen-controller) in GitHub.
