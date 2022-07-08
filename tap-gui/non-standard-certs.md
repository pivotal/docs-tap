# Configuring Custom CAs for Tanzu Application Platform GUI

This section describes how you can configure Tanzu Application Platform GUI to trust unusual certificate authorities when making outbound connections. You will need to understand how to use overlays with PackageInstalls. There are two ways to implement this workaround:

## Turn off all SSL verification
To turn off SSL verification to allow for self signed certificates, set the Tanzu Application Platform GUI pod's environment variable NODE_TLS_REJECT_UNAUTHORIZED=0. If the value equals '0', certificate validation is disabled for TLS connections. This can be done by utilizing the `package_overlays` key in the TAP values-file. Instructions on how to do this are [here](../customize-package-installation.md).

The following is an example overlay to disable TLS. It assumes that your TAP GUI instance is deployed in the namespace: tap-gui. Please adjust accordingly.
```yaml
#@ load("@ytt:overlay", "overlay")

#@overlay/match by=overlay.subset({"kind":"Deployment", "metadata": {"name": "server", "namespace": "tap-gui"}}),expects="1+"
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

## Add a custom CA
If you would like to keep verifications on, you can add a custom CA and mount it to the Tanzu Application Platform GUI pod. Then set the pod's environment variable NODE_EXTRA_CA_CERTS=<path to mounted file>. To do so, follow these steps:

1. Encode your extra CA certs you would like to trust in base64. You can provide many certs in PEM format in the same file. For example with a file named cert-chain.pem
    ```
    cat cert-chain.pem | base64 -w0
    ``` 
    will give you the output you need for the next step

1. Copy the output from the previous command into the example field `tap-gui-certs.crt` in the example `secret.yaml` shown here:
    ```yaml
    ---
    apiVersion: v1
    kind: Secret
    metadata:
      name: tap-gui-extra-certs
      namespace: tap-gui
    type: Opaque
    data:
      tap-gui-certs.crt: "<encoded list of certs>"
    ```
    Please adjust metadata and naming from this example accordingly.

1. Apply the secret to your cluster
   ```
    kubectl apply -f secret.yaml
   ```

1. To set the environment variable NODE_EXTRA_CA_CERTS, you can utilize the `package_overlays` key in the TAP values-file. Instructions on how to do this are [here](../customize-package-installation.md).

    The following is an example overlay to add a custom CA. It assumes that your TAP GUI instance is deployed in the namespace: tap-gui. Please adjust all naming accordingly.
    ```yaml
    #@ load("@ytt:overlay", "overlay")

    #@overlay/match by=overlay.subset({"kind": "Deployment", "metadata": {"name": "server", "namespace": "tap-gui"}}), expects="1+"
    ---
    spec:
      template:
        spec:
          containers:
            #@overlay/match by=overlay.subset({"name": "backstage"}),expects="1+"
            #@overlay/match-child-defaults missing_ok=True
            - env:
                - name: NODE_EXTRA_CA_CERTS
                  value: /etc/tap-gui-certs/tap-gui-certs.crt
              volumeMounts:
                - name: tap-gui-extra-certs
                  mountPath: /etc/tap-gui-certs
                  readOnly: true
            volumes:
              - name: tap-gui-extra-certs
                secret:
                  secretName: tap-gui-extra-certs
    ```