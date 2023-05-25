# Configuring a TLS certificate by using cert-manager and an external ClusterIssuer

This topic tells you how to use cert-manager to create a certificate issuer and then generate a
certificate for Tanzu Application Platform GUI (commonly called TAP GUI) to use based on that issuer.

This topic uses the free certificate issuer [Let's Encrypt](https://letsencrypt.org).
You can use other certificate issuers compatible with cert-manager in a similar fashion.

![TLS diagram showing the relationships between Tanzu Application Platform GUI, cert dash manager, and Contour Shared Ingress.](images/TAP-GUI-TLS-CERT.png)

## <a id="prereqs"></a> Prerequisites

Fulfil these prerequisites:

- Install a Tanzu Application Platform profile that includes cert-manager.
  Verify you did this by running the following command to detect the cert-manager namespace:

    ```console
    kubectl get ns
    ```

- Obtain a domain name that you control or own and have proof that you control or own it.
  In most cases, this domain name is the one you used for the `INGRESS-DOMAIN` values when you
  installed Tanzu Application Platform and Tanzu Application Platform GUI.
- If cert-manager cannot perform the challenge to verify your domain's compatibility, you must do so
  manually. For more information, see [How It Works](https://letsencrypt.org/how-it-works/) and
  [Getting Started](https://letsencrypt.org/getting-started/) in the Let's Encrypt documentation.
- Ensure that your domain name is pointed at the shared Contour ingress for the installation.
  Find the IP address by running:

    ```console
    kubectl -n tanzu-system-ingress get services envoy -o jsonpath='{.status.loadBalancer.ingress[0].ip}'
    ```

## <a id="procedure"></a> Procedure

To configure a self-signed TLS certificate for Tanzu Application Platform GUI:

1. Create a `certificate.yaml` file that defines an issuer and a certificate. For example:

    ```yaml
    apiVersion: cert-manager.io/v1
    kind: ClusterIssuer
    metadata:
      name: letsencrypt-http01-issuer
      namespace: cert-manager
    spec:
      acme:
        server: https://acme-v02.api.letsencrypt.org/directory
        email: EMAIL-ADDRESS
        privateKeySecretRef:
          name: letsencrypt-http01-issuer
        solvers:
        - http01:
            ingress:
              class: contour
    ---
    apiVersion: cert-manager.io/v1
    kind: Certificate
    metadata:
      namespace: cert-manager
      name: tap-gui
    spec:
      commonName: tap-gui.INGRESS-DOMAIN
      dnsNames:
        - tap-gui.INGRESS-DOMAIN
      issuerRef:
        name: letsencrypt-http01-issuer
        kind: ClusterIssuer
      secretName: tap-gui
   ```

   Where:

   - `EMAIL-ADDRESS` is the email address that Let's Encrypt shows as responsible for this certificate
   - `INGRESS-DOMAIN` is your domain value that matches the values you used when you installed the
     profile

1. Add the issuer and certificate to your cluster by running:

   ```console
   kubectl apply -f certificate.yaml
   ```

   By applying the certificate, cert-manager attempts to perform an HTTP01 challenge by creating an
   Ingress resource specifically for the challenge. This is automatically removed from your cluster
   after the challenge is completed. For more information about how this works, and when it might not,
   see the [cert-manager documentation](https://cert-manager.io/docs/configuration/acme/http01/).

1. Validate the certificate was created and is ready by running:

   ```console
   kubectl get certs -n cert-manager
   ```

   Wait a few moments for this to take place, if need be.

1. Configure Tanzu Application Platform GUI to use the newly created certificate.
   To do so, update the `tap-values.yaml` file that you used during installation to include the
   following items under the `tap-gui` section:

   - A top-level `tls` key with subkeys for `namespace` and `secretName`
   - A namespace referring to the namespace containing the `Certificate` object from earlier
   - A secret name referring to the `secretName` value defined in your `Certificate` resource earlier

   Example:

   ```yaml
   tap_gui:
     tls:
       namespace: cert-manager
       secretName: tap-gui
    # Additional configuration below this line as needed
   ```

1. Update the Tanzu Application Platform package with the new values in `tap-values.yaml` by running:

    ```console
    tanzu package installed update tap -p tap.tanzu.vmware.com -v TAP-VERSION  --values-file tap-values.yaml -n tap-install
    ```

    Where `TAP-VERSION` is the version that matches the values you used when you installed the profile.