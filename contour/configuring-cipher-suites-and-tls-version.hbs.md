# Configure Cipher Suites and TLS version in Contour

Contour provides configuration options for TLS Version and Cipher Suites. Rather than directly exposed through a top level key in the pacakge, 
they fall into the category of advanced Contour configurations by using the `contour.configFileContents` key.

For more information about these configuration options, see [Contour documentation](https://projectcontour.io/docs/v1.23.1/configuration/). 
This topic is focused on the TLS Configuration section.

To configure TLS options for Contour in Tanzu Application Platform, edit the `contour` section of your Tanzu Application Platform values file as follows:

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

Expect to see the following Cipher Suites and TLS version data in the Contour configmap:

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

> **Important** To update the configmap, you must configure it through Tanzu Application Platform values file. 
If you change it directly in the configmap, kapp-controller reverts all the changes you made.
