# Install multicluster Tanzu Application Platform profiles

## <a id='prerequisites'></a> Prerequisites

Before installing multicluster Tanzu Application Platform profiles, you must meet the following prerequisites:

- All clusters must satisfy all the requirements to install Tanzu Application Platform. See [Prerequisites](../prerequisites.md).
- [Accept Tanzu Application Platform EULA and install Tanzu CLI](../install-tanzu-cli.hbs.md) with any required plug-ins.
- Install Tanzu Cluster Essentials on all clusters. For more information, see [Deploy Cluster Essentials](https://docs.vmware.com/en/Cluster-Essentials-for-VMware-Tanzu/{{ vars.url_version }}/cluster-essentials/deploy.html).

## <a id='order-of-operations'></a> Multicluster Installation Order of Operations

The installation order is flexible given the ability to update the installation with a modified values file using the `tanzu package installed update` command. The following is an example of the order of operations to be used:

  1. [Install View profile cluster](#install-view).
  2. [Install Build profile cluster](#install-build).
  3. [Install Run profile cluster](#install-run).
  4. [Install Iterate profile cluster](#install-iterate).
  5. [Add Build, Run and Iterate clusters to Tanzu Application Platform GUI](#add-view).
  6. Update the View cluster's installation values file with the previous information and run the following command to pass the updated config values to Tanzu Application Platform GUI:

    ```shell
    tanzu package installed update tap -p tap.tanzu.vmware.com -v TAP-VERSION --values-file tap-values.yaml -n tap-install
    ```

    Where `TAP-VERSION` is the Tanzu Application Platform version you've installed.

## <a id='install-view'></a> Install View cluster

Install the View profile cluster first, because some components must exist before installing the Run clusters. For example, the Application Live View back end must be present before installing the Run clusters. For more information about profiles, see [About Tanzu Application Platform package profiles](../overview.md#about-package-profiles).

To install the View cluster:

1. Follow the steps described in [Installing the Tanzu Application Platform package and profiles](../install.md) by using a reduced values file as shown in [View profile](reference/tap-values-view-sample.md).
2. Verify that you can access Tanzu Application Platform GUI by using the ingress that you set up. The address must follow this format: `https://tap-gui.INGRESS-DOMAIN`, where `INGRESS-DOMAIN` is the DNS domain you set in `shared.ingress_domain` which points to the shared Contour installation in the `tanzu-system-ingress` namespace with the service `envoy`.
3. Deploy Supply Chain Security Tools (SCST) - Store. See [Multicluster setup](../scst-store/multicluster-setup.hbs.md) for more information.

## <a id='install-build'></a> Install Build clusters

To install the Build profile cluster, follow the steps described in [Installing the Tanzu Application Platform package and profiles](../install.md) by using a reduced values file as shown in [Build profile](reference/tap-values-build-sample.md).

## <a id='install-run'></a> Install Run clusters

To install the Run profile cluster:

1. Follow the steps described in [Install the Tanzu Application Platform package and profiles](../install.md) by using a reduced values file as shown in [Run profile](reference/tap-values-run-sample.md).
2. To use Application Live View, set the `INGRESS-DOMAIN` for `appliveview_connector` to match the value you set on the View profile for the `appliveview` in the values file.

    >**Note** The default configuration of `shared.ingress_domain` points to the local Run cluster, rather than the View cluster, as a result, `shared.ingress_domain` must be set explicitly.

## <a id='install-iterate'></a> Install Iterate clusters

To install the Iterate profile cluster, follow the steps described in [Install the Tanzu Application Platform package and profiles](../install.md) by using a reduced values file as shown in [Iterate profile](reference/tap-values-iterate-sample.md).

## <a id='add-view'></a> Add Build, Run and Iterate clusters to Tanzu Application Platform GUI

1. After installing the Build, Run and Iterate clusters, create the `Service Accounts` that Tanzu Application Platform GUI uses to read objects from the clusters.
2. Follow the steps in [View resources on multiple clusters in Tanzu Application Platform GUI](../tap-gui/cluster-view-setup.md) to add a remote cluster. These steps create the necessary RBAC elements allowing you to pull the URL and token from the Build, Run and Iterate clusters that allows them come back and add to the View cluster's values file. You must add the Build, Run and Iterate clusters to the View cluster for all plug-ins to function as expected.

## Next steps

After setting up the four profiles, you're ready to run a workload by using the supply chain. See [Get started with multicluster Tanzu Application Platform](getting-started.md).
