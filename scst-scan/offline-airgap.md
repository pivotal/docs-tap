# Using Grype in offline and air-gapped environments

The `grype` CLI attempts to perform two over the Internet calls: one to verify for newer versions of the CLI and another to update the vulnerability database before scanning.

You must deactivate both of these external calls. For the `grype` CLI to function in an offline or air-gapped environment, the vulnerability database must be hosted within the environment. You must configure the `grype` CLI with the internal URL.

The `grype` URL accepts environment variables to satisfy these needs.

For information about setting up an offline vulnerability database, see the [Anchore Grype README](https://github.com/anchore/grype#offline-and-air-gapped-environments) in GitHub.

## <a id="overview"></a> Overview

To enable Grype in offline air-gapped environments:

1. Create ConfigMap
2. Create Patch Secret
3. Configure tap-values.yaml to use `package_overlays`
4. Update Tanzu Application Platform

## <a id="use-grype"></a> Using Grype

To use Grype in offline and air-gapped environments:

1. Create a ConfigMap that contains the public ca.crt to the file server hosting the Grype database files. Apply this ConfigMap to your developer namespace.

2. Create a Secret that contains the ytt overlay to add the Grype environment variables to the ScanTemplates.

    ```yaml
    apiVersion: v1
    kind: Secret
    metadata:
      name: grype-airgap-overlay
      namespace: tap-install #! namespace where tap is installed
    stringData:
      patch.yaml: |
        #@ load("@ytt:overlay", "overlay")

        #@overlay/match by=overlay.subset({"kind":"ScanTemplate","metadata":{"namespace":"<DEV-NAMESPACE>"}}),expects="1+" #! developer namespace you are using
        ---
        spec:
          template:
            initContainers:
              #@overlay/match by=overlay.subset({"name": "scan-plugin"}), expects="1+"
              - name: scan-plugin
                #@overlay/match missing_ok=True
                env:
                  #@overlay/append
                  - name: GRYPE_CHECK_FOR_APP_UPDATE
                    value: "false"
                  - name: GRYPE_DB_AUTO_UPDATE
                    value: "true"
                  - name: GRYPE_DB_UPDATE_URL
                    value: <INTERNAL-VULN-DB-URL> #! url points to the internal file server
                  - name: GRYPE_DB_CA_CERT
                    value: "/etc/ssl/certs/custom-ca.crt"
                volumeMounts:
                  #@overlay/append
                  - name: ca-cert
                    mountPath: /etc/ssl/certs/custom-ca.crt
                    subPath: <INSERT-KEY-IN-CONFIGMAP> #! key pointing to ca certificate
            volumes:
            #@overlay/append
            - name: ca-cert
              configMap:
                name: <CONFIGMAP-NAME> #! name of the configmap created
    ``` 

    You can also add more certificates to the ConfigMap created earlier, to handle connections to a private registry for example, and mount them in the `volumeMounts` section if needed.

    For example:

    ```yaml
    #! ...
    volumeMounts:
      #@overlay/append
      #! ...
      - name: ca-cert
        mountPath: /etc/ssl/certs/another-ca.crt
        subPath: another-ca.cert #! key pointing to ca certificate
    ```

    >**Note:** If you have more than one developer namespace and you want to apply this change to all of them, change the `overlay match` on top of the patch.yaml to the following:
      
    ```yaml
    #@overlay/match by=overlay.subset({"kind":"ScanTemplate"}),expects="1+"
    ```

3. Configure tap-values.yaml to use `package_overlays`. Add the following to your tap-values.yaml:

  ```yaml
  package_overlays:
     - name: "grype"
       secrets:
          - name: "grype-airgap-overlay"
  ```

4. Update Tanzu Application Platform

  ```console
  tanzu package installed update tap -f tap-values.yaml -n tap-install
  ```

## <a id='next-steps'></a>Next steps

- [Setting up developer namespaces to use installed packages](../set-up-namespaces.html)
