# Configuring TLS Certificate for Tanzu Application Platform GUI Leveraging Cert-Manager and an External ClusterIssuer

### Introduction

In the below procedure, we'll use `cert-manager` to create a certificate issuer and then generate a certificate for Tanzu Application Platform GUI to use based off that. In this tutorial we'll use the free certificate issuers [Let's Encrypt](https://letsencrypt.org) but other `cert-manager` compatible certificate issuers can be used in a very similar manner.

### Prerequisites

- Installation of Tanzu Application Platform profile that includes cert-manager. You can check for this by looking for the presence of the `cert-manager` namespace:

    ```console
    kubectl get ns
    ```

- You'll need a domain name that you're in control of and can prove ownership/control. This should be the domain name you use for the `INGRESS-DOMAIN` values in your Tanzu Application Platform installation (and GUI)
- You'll need to [validate your domain](https://letsencrypt.org/how-it-works/) via one of the processes outlined on [Let's Encrypt's](https://letsencrypt.org/getting-started/) site

### Procedure

To configure a self-signed TLS certificate for Tanzu Application Platform GUI:

1. Create a `certificate.yaml` file that defines an Issuer and a Certificate. For example:

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
   - `EMAIL-ADDRESS` is the email address Let's Encrpt will show as reponsible for this certificate
   - `INGRESS-DOMAIN` is your domain value that matches the values you used when you did the profile installation.

1. Add the Issuer and Certificate to your cluster by running:

   ```console
   kubectl apply -f certificate.yaml
   ```

1. Validate the certificate was created and is Ready. You may need to wait a few moments for this to take place:
   ```console
   kubectl get certs -n cert-manager
   ```

1. Now we need to configure Tanzu Application Platform GUI to use to the newly created certificate. Update the `tap-values.yaml` used during the installation process to include the following under the `tap-gui` section:

   - a top-level `tls` key with subkeys for `namespace` and `secretName`
   - a namespace referring to the namespace containing the above `Certificate` object
   - a secret name referring to the `secretName` value defined in your `Certificate` resource earlier

   Example:

   ```yaml
   tap_gui:
     tls:
       namespace: cert-manager
       secretName: tap-gui
    # Additional configuration below this line as needed
   ```

1. Update the Tanzu Application Platform package with the new values in the `tap-values.yaml`:

    ```console
    tanzu package installed update tap -p tap.tanzu.vmware.com -v TAP_VERSION  --values-file tap-values.yaml -n tap-install
    ```

   Where `TAP-VERSION` is the version that matches the values you used when you did the profile installation.
