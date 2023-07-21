# Add App Scanning to default Test and Scan supply chains

This topic describes how to enable Supply Chain Security Tools (SCST) - Scan 2.0
and the included Grype scanner with the out of the box test and scan supply
chain. The default configuration for Out of the Box Supply Chain - Testing and
Scanning uses SCST - Scan 1.0. 

## <a id="prerequisites"></a> Prerequisites

Before you can integrate SCST - Scan 2.0 with the out of the box supply chain:

- Installed Scan 2.0. See [Install Supply Chain Security Tools - Scan 2.0 in a cluster](./install-app-scanning.hbs.md).

## <a id="integration-supply-chain"></a> Integrate with OOTB Supply Chain

To integrate App Scanning with an OOTB supply chain:

1. After completing the prerequisites, update your `tap-values.yaml` file to specify the Grype ClusterImageTemplate. For example:

    ```yaml
    ootb_supply_chain_testing_scanning:
      image_scanner_template_name: image-vulnerability-scan-grype
    ```

1. Update your Tanzu Application Platform installation by running:

  ```console
  tanzu package installed update tap -p tap.tanzu.vmware.com -v TAP-VERSION  --values-file tap-values.yaml -n tap-install
  ```

  Where `TAP-VERSION` is the version of Tanzu Application Platform installed.

1. Downstream Tanzu Application Platform services, such as Tanzu Developer Portal and Tanzu CLI, depend on scan results stored in the SCST - Store component to display them correctly. To do this, you must enable AMR (beta) and AMR Observer (alpha) components. See the [AMR documentation](../scst-store/amr/install-amr-observer.hbs.md).

2. In order to display scan results correctly in the Tanzu Developer Portal, you must give permission for the Tanzu Developer Portal to read ImageVulnerabilityScan CR's. See [Tanzu Developer Portal troubleshooting guide](../tap-gui/troubleshooting.hbs.md#supporting-imagevulnerabilityscans) for steps.

3. [Verify](./verify-app-scanning-supply-chain.hbs.md) the new scanner.
