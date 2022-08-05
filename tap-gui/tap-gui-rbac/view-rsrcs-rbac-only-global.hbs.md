# View runtime resources on authorization-enabled clusters

To visualize runtime resources on authorization-enabled clusters in Tanzu Application Platform GUI,
proceed to the software catalog **Component** of choice and click the **Runtime Resources** tab
at the top of the ribbon.

![Screenshot of Runtime Resources](../images/tap-gui-multiple-clusters.png)

After you click **Runtime Resources**, Tanzu Application Platform GUI uses your credentials to
query the clusters for the respective runtime resources.
The system checks if you are authenticated with the OIDC providers configured for the remote clusters.
If you are not authenticated, the system prompts you for your OIDC credentials.

Remote clusters that are not restricted by authorization are made visible by using the
general service account of Tanzu Application Platform GUI. The visibility is not restricted for users.
For more information about how to set up unrestricted remote cluster visibility, see
[Viewing resources on multiple clusters in Tanzu Application Platform GUI](../cluster-view-setup.md).

When you access **Runtime Resources**, Tanzu Application Platform GUI queries all Kubernetes
namespaces for runtime resources that have a matching `kubernetes-label-selector`. This usually
has a `part-Of` prefix.
