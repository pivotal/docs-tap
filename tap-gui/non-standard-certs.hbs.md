# Configuring custom certificate authorities for Tanzu Application Platform GUI

This topic describes how to configure Tanzu Application Platform GUI to trust unusual certificate
authorities (CA) when making outbound connections.
You do this by using overlays with PackageInstalls. There are two ways to implement this workaround:

- [Add a custom CA](#add-custom-ca)
- [Deactivate all SSL verification](#deactivate-ssl)

## <a id='add-custom-ca'></a> Add a custom CA

note: The overlay previously available in this section is no longer necessary.

As of TAP 1.3 the TAP GUI team supports the value `ca_cert_data` at the top
level of its values file. Which takes any number of newline delimited certs in
PEM format.
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

TAP GUI will also inherit `shared.ca_cert_data` from your TAP values file.
`shared.ca_cert_data` will be newline concatenated with ca_certs given directly
to TAP GUI.

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

## <a id='deactivate-ssl'></a> Deactivate all SSL verification

To deactivate SSL verification to allow for self-signed certificates, set the
Tanzu Application Platform GUI pod's environment variable as `NODE_TLS_REJECT_UNAUTHORIZED=0`.
When the value equals `0`, certificate validation is deactivated for TLS connections.

To do this, use the `package_overlays` key in the Tanzu Application Platform values file.
For instructions, see [Customizing Package Installation](../customize-package-installation.md).

The following is an example overlay to deactivate TLS:

```yaml
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

Where `NAMESPACE` is the namespace in which your Tanzu Application Platform GUI instance is deployed.
For example, `tap-gui`.

## <a id='next-steps'></a>Next steps

- [Configuring Application Accelerator](../application-accelerator/configuration.html)
