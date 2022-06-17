# View Runtime Resources on Authorization-Enabled Clusters in Tanzu Application Platform GUI

To visualize runtime resources on Authorization-enabled clusters in Tanzu Application Platform GUI, you will need to proceed to the Software Catalog `Component` of choice and click on the `Runtime Resources` tab on the top of ribbon.

![Screenshot of Runtime Resources](./../images/tap-gui-multiple-clusters.png)

Once you click on `Runtime Resources`, Tanzu Application Platform GUI will use your credentials to query the clusters for the respective Runtime Resources. The system will check if you are authenticated with the OIDC providers configured for the remote clusters. If you are not authenticated, the system shall prompt for your OIDC credentials.

Visibility of remote clusters that are not restricted by Authorization, is done through the general Service Account of Tanzu Application Platform GUI and is not restricted for users. For more information on how to set up unrestrictred remote cluster visibility, please refer to [Viewing resources on multiple clusters in Tanzu Application Platform GUI](./../cluster-view-setup.md).

When you access `Runtime Resources`, Tanzu Application Platform GUI will query all Kubernetes namespaces for runtime resources that with a matching `kubernetes-label-selector` (usually with a `part-Of` prefix).