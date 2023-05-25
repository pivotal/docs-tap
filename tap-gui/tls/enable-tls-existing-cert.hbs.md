# Configuring a TLS certificate by using an existing certificate

This topic tells you how to use the certificate information from your external certificate authority
to encrypt inbound traffic to Tanzu Application Platform GUI (commonly called TAP GUI).

## <a id="prereqs"></a> Prerequisites

Your certificate authority gave you a certificate file, of the form `CERTIFICATE-FILE-NAME.crt`, and
a signing key, of the form `KEY-FILE-NAME.key`.
Ensure that these files are present on the host from which you run the CLI commands.

![TLS diagram showing the relationships between Tanzu Application Platform GUI, the certificate, and Contour Shared Ingress.](images/TAP-GUI-TLS.png)

## <a id="procedure"></a> Procedure

To configure Tanzu Application Platform GUI with an existing certificate:

1. Create the Kubernetes secret by running:

    ```console
    kubectl create secret tls tap-gui-cert --key="KEY-FILE-NAME.key" --cert="CERTIFICATE-FILE-NAME.crt" -n tap-gui
    ```

    Where:

    - `KEY-FILE-NAME` is the name of the `key` file that your certificate issuer gave you
    - `CERTIFICATE-FILE-NAME` is the name of the `crt` file that your certificate issuer gave you

2. Configure Tanzu Application Platform GUI to use the newly created secret.
   Do so by editing the `tap-values.yaml` file that you used during installation to include the
   following under the `tap-gui` section:

   - A top-level `tls` key with subkeys for `namespace` and `secretName`
   - A namespace referring to the namespace used earlier
   - A secret name referring to the `secretName` value defined earlier

   Example:

   ```yaml
   tap_gui:
     tls:
       namespace: tap-gui
       secretName: tap-gui-cert
    # Additional configuration below this line as needed
   ```

3. Update the Tanzu Application Platform package with the new values in `tap-values.yaml` by running:

   ```console
   tanzu package installed update tap -p tap.tanzu.vmware.com -v TAP-VERSION  --values-file tap-values.yaml -n tap-install
   ```

   Where `TAP-VERSION` is the version number that matches the values you used when you installed your
   profile.