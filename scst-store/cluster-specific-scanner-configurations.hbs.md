## Connecting vulnerability scanning to Supply Chain Security Tools - Store
The configuration to connect the Grype scanner or another supported scanner to SCST - Store lies in the scanner configuration. 
 - Single cluster - Scanners will use `app-tls-cert` to communicate with SCST - Store. Please refer [Full profile Setup](../install.hbs.md#install-profile)
 - Multicluster … Sacnners will use `ingress-cert` of SCST - Store in view cluster. Please refer [MultiCluster Setup](multicluster-setup.hbs.md)

### Single cluster configuration
In a single cluster configuration, the connection between the scanning pod and the SCST - Store exists inside the cluster and does not pass through ingress. An ingress connection to the store is not needed.

The default values automatically configure the connection between the Grype scanner or another supported scanner to SCST - Store. Scanners will by default use use `app-tls-cert` from SCST-Store. You do not need to make any changes to the `grype` section of the `tap-values.yaml` provided in the [full profile installation](../install.hbs.md#install-profile).   

**Note**: To view the default values see [Install Supply Chain Security Tools - Scan](../scst-scan/install-scst-scan.hbs.md#-configure-properties).

### Multicluster configuration
In a multicluster configuration, you need to provide the scanner (configured on Build cluster) with the ingress URL of SCST - Store which is deployed in the View cluster. Scanners must use `ingress-cert` to make any communication to SCST-Store.
A sample Build profile yaml file sample can be viewed [here](../multicluster/reference/tap-values-build-sample.hbs.md) 
For more details see [More information about how Build profile uses the configuration](multicluster-setup.hbs.md#install-build-profile)