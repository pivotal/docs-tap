# Configuring TLS Certificate for Tanzu Application Platform GUI with an Existing Certificate

### Introduction

In the below procedure, we'll use the certificate information provided to you by your external certificate authority to encrypt inbound traffic to hte GUI. 

### Prerequisites

- Your certificate authority will provide you a certificate file (similar to `FILE-NAME.crt`) as well as a signing key (similar to `FILE-NAME.key`). These files must be present on the host your execute the CLI commands from.

![Tanzu Application Platform TLS Diagram](./images/TAP-GUI-TLS.jpg)
### Procedure

To configure Tanzu Application Platform GUI with an existing certificate:

1. Create the Kubernetes secret:

    ```console
    kubectl create secret tls tap-gui-cert --key="FILE-NAME.key" --cert="FILE-NAME.crt" -n tap-gui
    ```

   Where `FILE-NAME`s are the files `FILE-NAME.crt` and `FILE-NAME.key` provided to you by your certificate issuer.

1. Now we need to configure Tanzu Application Platform GUI to use to the newly created secret. Update the `tap-values.yaml` used during the installation process to include the following under the `tap-gui` section:

   - a top-level `tls` key with subkeys for `namespace` and `secretName`
   - a namespace referring to the namespace we used above
   - a secret name referring to the `secretName` value defined above

   Example:

   ```yaml
   tap_gui:
     tls:
       namespace: tap-gui
       secretName: tap-gui-cert
    # Additional configuration below this line as needed
   ```

1. Update the Tanzu Application Platform package with the new values in the `tap-values.yaml`:

```console
tanzu package installed update tap -p tap.tanzu.vmware.com -v TAP_VERSION  --values-file tap-values.yaml -n tap-install
```

   Where `TAP-VERSION` is the version that matches the values you used when you did the profile installation.
