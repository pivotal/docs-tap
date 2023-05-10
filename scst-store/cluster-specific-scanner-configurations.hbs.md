# Cluster specific scanner configurations

This topic describes how to configure clusters for specific scanners, such as
vulnerability scanning, single cluster configuration, and multicluster
configuration.

## Connecting vulnerability scanning to Supply Chain Security Tools - Store

You can use the scanner configuration to connect the Grype scanner or another
supported scanner to SCST - Store.

For single cluster configurations, scanners use `app-tls-cert` to communicate
with SCST - Store. See [Full profile Setup](../install-online/profile.hbs.md#install-profile).

For multicluster configurations, scanners use `ingress-cert` of SCST - Store in
the view cluster. See [MultiCluster Setup](multicluster-setup.hbs.md).

### Single cluster configuration

In a single cluster configuration, the connection between the scanning pod and
the SCST - Store exists inside the cluster and does not pass through ingress. An
ingress connection to the store is not needed.

The default values automatically configure the connection between a supported
scanner, such as Grype, and SCST - Store. Scanners use `app-tls-cert` by default
from SCST-Store. You do not need to make changes to the `grype` section of the
`tap-values.yaml` provided in the full profile installation. See [Install Tanzu Application Platform package and profiles](../install-online/profile.hbs.md#install-profile).

To view the default values, see [Install Supply Chain Security Tools - Scan](../scst-scan/install-scst-scan.hbs.md#-configure-properties).

### Multicluster configuration

In a multicluster configuration, you must provide the scanner configured on the
build cluster, with the ingress URL of SCST - Store which is deployed in the
view cluster. Scanners must use `ingress-cert` to communicate with SCST-Store.
To view a sample Build profile YAML file, see [Build
profile](../multicluster/reference/tap-values-build-sample.hbs.md). For
information about how Build profile uses the configuration, see [Multicluster
setup](multicluster-setup.hbs.md#install-build-profile).