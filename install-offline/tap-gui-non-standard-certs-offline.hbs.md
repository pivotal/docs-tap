# Configure custom CAs for Tanzu Application Platform GUI

This topic describes how to configure Tanzu Application Platform GUI to trust unusual certificate
authorities (CA) when making outbound connections.
Tanzu Application Platform GUI might require custom certificates when connecting to persistent
databases or custom catalog locations that require SSL.
You use overlays with PackageInstalls to make this possible. There are two ways to implement this
workaround: you can add a custom CA or you can deactivate all SSL verification.

Add a custom CA
: The overlay previously available in this section is no longer necessary.
  As of Tanzu Application Platform v1.3, the value `ca_cert_data` is supported at the top level of
  its values file. Any number of newline-delimited CA certificates in PEM format are accepted.

  For example:

    ```yaml
    # tap-gui-values.yaml
    ca_cert_data: |
      -----BEGIN CERTIFICATE-----
      cert data here
      -----END CERTIFICATE-----

      -----BEGIN CERTIFICATE-----
      other cert data here
      -----END CERTIFICATE-----
    app_config:
      # ...
    ```

  Tanzu Application Platform GUI also inherits `shared.ca_cert_data` from your `tap-values.yaml` file.
  `shared.ca_cert_data` is newline-concatenated with `ca_certs` given directly to
  Tanzu Application Platform GUI.

    ```yaml
    shared:
      ca_cert_data: |
        -----BEGIN CERTIFICATE-----
        cert data here
        -----END CERTIFICATE-----

    tap_gui:
      ca_cert_data: |
        -----BEGIN CERTIFICATE-----
        other cert data here
        -----END CERTIFICATE-----
      app_config:
        # ...
    ```

  To verify that Tanzu Application Platform GUI has processed the custom CA certificates, check that
  the `ca-certs-data` volume with mount path `/etc/custom-ca-certs-data` is mounted in the
  Tanzu Application Platform GUI server pod.

Deactivate all SSL verification
: To deactivate SSL verification to allow for self-signed certificates, set the
  Tanzu Application Platform GUI pod's environment variable as `NODE_TLS_REJECT_UNAUTHORIZED=0`.
  When the value equals `0`, certificate validation is deactivated for TLS connections.

  To do this, use the `package_overlays` key in the Tanzu Application Platform values file.
  For instructions, see [Customize Package Installation](../customize-package-installation.hbs.md).

  The following YAML is an example `Secret` containing an overlay to deactivate TLS:

    ```yaml
    apiVersion: v1
    kind: Secret
    metadata:
      name: deactivate-tls-overlay
      namespace: tap-install
    stringData:
      deactivate-tls-overlay.yml: |
        #@ load("@ytt:overlay", "overlay")
        #@overlay/match by=overlay.subset({"kind":"Deployment", "metadata": {"name": "server", "namespace": "NAMESPACE"}}),expects="1+"
        ---
        spec:
          template:
            spec:
              containers:
                #@overlay/match by=overlay.all,expects="1+"
                #@overlay/match-child-defaults missing_ok=True
                - env:
                  - name: NODE_TLS_REJECT_UNAUTHORIZED
                    value: "0"
    ```

  Where `NAMESPACE` is the namespace in which your Tanzu Application Platform GUI instance is
  deployed. For example, `tap-gui`.

## <a id='next-steps'></a>Next steps

- [Configure Application Accelerator](./application-accelerator-configuration.hbs.md)
