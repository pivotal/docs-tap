# Enable App Scanning for default Test and Scan supply chains

This topic tells you how to enable Supply Chain Security Tools (SCST) - Scan 2.0
and an included container image scanner with the out-of-box box test and scan supply
chain. The default out-of-box configuration for the `Testing and
Scanning` supply chain uses SCST - Scan 1.0 but you can switch to using SCST - Scan 2.0 by using this topic.

## <a id="overview"></a> Overview

SCST - Scan 2.0 includes two integrations for container image scanners:

- Anchore Grype
- Aqua Trivy

VMware recommends using Aqua Trivy scanner with Tanzu Application Platform for
container image scanning.  Anchore Grype is included as an open source
alternative and for users who want to remain consistent with the default scanner
in SCST - Scan 1.0.  Additionally, you can build an integration for additional
scanners by following the [Bring Your Own Scanner
guide](./bring-your-own-scanner.hbs.md).

| Container Image Scanner | Documentation | Template Name |  Status |
| --- | --- | --- | --- |
| Aqua Trivy | [Link](https://aquasecurity.github.io/trivy) | image-vulnerability-scan-trivy | Recommended out-of-box scanner for Scan 2.0 |
| Anchore Grype | [Link](https://github.com/anchore/grype) | image-vulnerability-scan-grype | Alternative to Trivy that is used in Scan 1.0 |

## <a id="prerequisites"></a> Prerequisites

Before you can integrate SCST - Scan 2.0 with the out of the box supply chain:

- Install the Scan 2.0 component as this component is not included in any of the installation profiles. See [Install Supply Chain Security Tools - Scan 2.0 in a cluster](./install-app-scanning.hbs.md).

## <a id="integration-supply-chain"></a> Integrate with OOTB supply chain

To integrate Scan 2.0 with an OOTB supply chain using the Trivy scanner:

1. After completing the prerequisites, update your `tap-values.yaml` file to specify the Trivy ClusterImageTemplate. For example:

    ```yaml
    ootb_supply_chain_testing_scanning:
      image_scanner_template_name: image-vulnerability-scan-trivy
    ```

    >**Note** In Tanzu Application Platform v1.7 there is a known issue that causes the default
    >Trivy scanner image to point to an inaccessible location.
    >You can resolve this by setting `ootb_supply_chain_testing_scanning.image_scanner_cli` to the correct
    >image, for example:
    >
    >```yaml
    >ootb_supply_chain_testing_scanning:
    >  image_scanner_template_name: image-vulnerability-scan-trivy
    >    image_scanner_cli:
    >      image: registry.tanzu.vmware.com/tanzu-application-platform/tap-packages@sha256:675673a6d495d6f6a688497b754cee304960d9ad56e194cf4f4ea6ab53ca71d6
    >```
    >
    > For more information, see [v1.7.0 Known issues: Supply Chain Security Tools (SCST) - Scan 2.0](../release-notes.hbs.md#1-7-0-scst-scan-ki).

1. Update your Tanzu Application Platform installation by running:

    ```console
    tanzu package installed update tap -p tap.tanzu.vmware.com -v TAP-VERSION  --values-file tap-values.yaml -n tap-install
    ```

    Where `TAP-VERSION` is the version of Tanzu Application Platform installed.

1. Enable AMR and AMR Observer. 

    Downstream Tanzu Application Platform services, such as Tanzu Developer Portal and Tanzu CLI, depend on scan results stored in SCST - Store to display correctly. For more information, see [Artifact Metadata Repository Observer for Supply Chain Security Tools - Store](../scst-store/amr/install-amr-observer.hbs.md).

1. Verify the scan capability is working as expected by creating a workload. See [Verify](./verify-app-scanning-supply-chain.hbs.md).
