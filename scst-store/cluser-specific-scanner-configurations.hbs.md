# Connecting Vulnerability scanning to SCST - Store 
This page summarizes how to configure and connect your scanner with Supply Chain Security Tools - Store and provides links to more detailed explanations of individual topics.

## Metadata Store
 - Single cluster - Scanners will use `app-tls-cert` to communicate with SCST - Store
 - Multicluster … Sacnners will use `ingress-cert` of SCST - Store in view cluster. Please refer [MultiCluster Setup](multicluster-setup.hbs.md)


## Grype and other supported scanner configuration
The configuration to connect the Grype scanner or another supported scanner to SCST - Store lies in the scanner configuration. 

### Option 1: Single cluster configuration
In a single cluster configuration, the connection between the scanning pod and the metadata store exists inside the cluster and does not pass through ingress. An ingress connection to the store is not needed.

The default values automatically configure the connection between the Grype scanner or another supported scanner to SCST - Store. You do not need to make any changes to the `grype` section of the `tap-values.yaml` provided in the [full profile installation](../install.hbs.md#install-profile).   

```console
grype:
  namespace: "MY-DEV-NAMESPACE"
  targetImagePullSecret: "TARGET-REGISTRY-CREDENTIALS-SECRET"
```

**Note**: To view the default values see [Install Supply Chain Security Tools - Scan](../scst-scan/install-scst-scan.hbs.md#-configure-properties).

### Option 2: Multicluster configuration
In a multicluster configuration, you need to provide the scanner with the ingress URL of SCST - Store which is deployed in the View cluster. Scanners must use `ingress-cert` to make any communication to SCST-Store (deployed in view cluster).
A sample Build profile yaml file sample can be viewed [here](../multicluster/reference/tap-values-build-sample.hbs.md) 
For more details see [More information about how Build profile uses the configuration](multicluster-setup.hbs.md#install-build-profile)  

```console
grype:
  namespace: "MY-DEV-NAMESPACE" # (Optional) Defaults to default namespace.
  targetImagePullSecret: "TARGET-REGISTRY-CREDENTIALS-SECRET"
  metadataStore:
    url: METADATA-STORE-URL-ON-VIEW-CLUSTER # Url with http / https
    caSecret:
        name: store-ca-cert # Must match with `ingress-cert.data."ca.crt"` of store on view cluster
        importFromNamespace: metadata-store-secrets
    authSecret:
        name: store-auth-token # Must match with valid store token of metadata-store on view cluster
        importFromNamespace: metadata-store-secrets
```