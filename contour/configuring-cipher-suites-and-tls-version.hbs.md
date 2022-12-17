# Configuring Cipher Suites and TLS Version in Contour

Contour provides some configuration options for TLS Version and Cipher Suites, though they are not directly exposed via a top level key in the Pacakge. They fall into the category of advanced Contour configurations that are configured via the `contour.configFileContents` key.

For reference on these configuration options, see [Contour's Configuration Reference Documentation](https://projectcontour.io/docs/v1.23.1/configuration/). For this guide, we care about the TLS Configuration section.

To configure TLS options for Contour in TAP, edit the `contour` section of your TAP values file to look like this:

```yaml
contour:
  # ... there maybe some configuration already here
  contour:
    configFileContents:
      tls:
        minimum-protocol-version: "1.2"
        cipher-suites:
        - '[ECDHE-ECDSA-AES128-GCM-SHA256|ECDHE-ECDSA-CHACHA20-POLY1305]'
        - '[ECDHE-RSA-AES128-GCM-SHA256|ECDHE-RSA-CHACHA20-POLY1305]'
        - 'ECDHE-ECDSA-AES256-GCM-SHA384'
        - 'ECDHE-RSA-AES256-GCM-SHA384'
```

Once you deploy, you should see that data show up in the contour configmap:

```console
$ kubectl -n tanzu-system-ingress get configmap contour -oyaml
apiVersion: v1
data:
  contour.yaml: |
    tls:
      minimum-protocol-version: "1.2"
      cipher-suites:
      - '[ECDHE-ECDSA-AES128-GCM-SHA256|ECDHE-ECDSA-CHACHA20-POLY1305]'
      - '[ECDHE-RSA-AES128-GCM-SHA256|ECDHE-RSA-CHACHA20-POLY1305]'
      - ECDHE-ECDSA-AES256-GCM-SHA384
      - ECDHE-RSA-AES256-GCM-SHA384
kind: ConfigMap
metadata:
...
```

If you ever want to update that configmap, you always have to do it through tap-values. If you change it directly, kapp-controller will revert anything you added in there.