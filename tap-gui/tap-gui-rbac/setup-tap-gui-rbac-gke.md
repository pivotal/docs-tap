# Enable Authorization on Remote GKE Clusters in Tanzu Application Platform GUI

This section describes two supported options to add access-controlled visibility for a remote GKE cluster:

* [Leveraging an external OIDC provider](#-leveraging-external-oidc-provider)
* [Leveraging Google's OIDC provider](#-leveraging-googles-oidc-provider)

Once the Authorization is enabled, you can view your runtime resources on a remote cluster in Tanzu Application Platform GUI. For more detail, please refer to [View Runtime Resources on Remote Clusters in Tanzu Application Platform GUI](./view-resouces-rbac.md).

## <a id="external-oidc-provider"></a> Leveraging external OIDC provider

When levearging an external OIDC provider (e.g., Auth0), the process of enabling Authorization is similar to that for [EKS](./setup-tap-gui-rbac-eks.md):

1. Set up the OIDC provider (pre-requisite)
2. Configure the GKE cluster with the OIDC provider
3. Configure the Tanzu Application Platform GUI to view the remote GKE cluster
4. Upgrade the Tanzu Application Platform GUI package

### <a id="set-up-oidc-provider"></a> Set up the OIDC provider

To enable RBAC visibility of remote clusters, you need to set up the OIDC provider. You can see the list of supported OIDC providers in the [Setting up a Tanzu Application Platform GUI authentication provider](./../auth.md) section.

Tanzu Application Platform GUI supports multiple OIDC providers. For the purposes of this guide, we shall use Auth0 as an example.

1. Log in to the Auth0 dashboard
1. Navigate to Applications
1. Create an Application
   - Name: `TAP-GUI` (or your custom app name)
   - Application type: `Single Page Web Application`
1. Click on the `Settings` tab
1. Add under Application URIs > Allowed Callback URLs : `http://tap-gui.INGRESS-DOMAIN/api/auth/auth0/handler/frame`
   
    Where:

    - `INGRESS-DOMAIN` is the domain you have chosen for your Tanzu Application Platform GUI in [Installing the Tanzu Application Platform package and profiles](install.md.hbs).


1. Click `Save Changes`

After creating an Application with your OIDC provider, you will get the following credentials for setting up RBAC for your remote cluster:

* Domain - to be used as `issuerURL` in the sections below
* Client ID - to be used as `CLIENT-ID` in the sections below
* Client Secret - to be used as `CLIENT-SECRET` in the sections below

For more details, please refer to [Auth0 Setup Walkthrough](https://backstage.io/docs/auth/auth0/provider) in the Backstage documentation. To configure other OIDC providers, please refer to [Authentication in Backstage](https://backstage.io/docs/auth/).

### <a id="configure-cluster"></a> Configure the GKE cluster with the OIDC provider

These steps will help you to configure the GKE cluster with the OIDC provider's credentials.

(SECTION TO BE ADDED)

### <a id="configure-tap-gui"></a> Configure the Tanzu Application Platform GUI

The next step is to configure visibility of the remote cluster in Tanzu Application Platform GUI. 

1. Make sure you added an `auth` section to the `app_config` stanza that Tanzu Application Platform GUI uses. In the example for Auth0, copy this YAML content into `tap-values.yml`:


```yaml
auth:
  environment: development
  providers:
    auth0:
      development:
        clientId: "CLIENT-ID"
        clientSecret: "CLIENT-SECRET"
        domain: "ISSUER-URL"
```
Where:

   - `CLIENT-ID` is the Client ID you obtained while setting up the OIDC provider
   - `ISSUER-URL` is the Issuer URL you obtained while setting up the OIDC provider
   - `CLIENT-SECRET` is the Client Secret you obtained while setting up the OIDC provider


2. You must also add a `kubernetes` section to the `app_config` stanza that Tanzu Application Platform GUI uses. This section must have an entry for each cluster that has resources to view.

To do so, copy this YAML content into `tap-values.yml`:


```yaml
kubernetes:
  serviceLocatorMethod:
    type: 'multiTenant'
  clusterLocatorMethods:
    - type: 'config'
      clusters:
        - name: "CLUSTER-NAME-UNCONSTRAINED"
          url: "CLUSTER-URL"
          authProvider: oidc
          oidcTokenProvider: auth0
          skipTLSVerify: true
          skipMetricsLookup: true
```
Where:

   - `CLUSTER-NAME-UNCONSTRAINED` is the cluster name of your choice for your GKE cluster
   - `CLUSTER_URL` is the URL for the remote cluster you are connecting to Tanzu Application Platform GUI. To obtain your cluster's URL, execute the following command:

```console
CLUSTER_URL=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')

echo CLUSTER-URL: $CLUSTER_URL
```
**Note:** The command above shall return the URL of the first configured cluster in your kubeconfig file. To view other clusters one by one, modify the number in `.clusters[0].cluster.server` or modify the command to view all the configured clusters.

If there are any other clusters that you would like to make visible through Tanzu Application Platform GUI, add their entries to `clusters` as well.

### <a id="upgrade-tap-gui"></a> Upgrade the Tanzu Application Platform GUI package

Once the new configuration file is ready, update the `tap` package by running this command:

```console
tanzu package installed update tap --values-file tap-values.yml
```

Wait a moment for the `tap-gui` package to update and then verify that `STATUS` is
`Reconcile succeeded` by running:

```console
tanzu package installed get tap-gui -n tap-install
```

## <a id="googles-oidc-provider"></a> Leveraging Google's OIDC provider

When levearging Google's OIDC provider, the process of enabling Authorization requires fewer steps:

1. Add a redirect config on the OIDC side
2. Configure the Tanzu Application Platform GUI to view the remote GKE cluster
3. Upgrade the Tanzu Application GUI package

### <a id="add-redirect-configr"></a> Add a redirect config on the OIDC side

On this step, you need to add a redirect config on the OIDC side 

(SECTION TO BE ADDED)

### <a id="configure-tap-gui"></a> Configure the Tanzu Application Platform GUI

The next step is to configure visibility of the remote GKE cluster in Tanzu Application Platform GUI. 

1. Make sure you added an `auth` section to the `app_config` stanza that Tanzu Application Platform GUI uses. In the example for Auth0, copy this YAML content into `tap-values.yml`:


```yaml
auth:
  environment: development
  providers:
    google:
      development:
        clientId: "CLIENT-ID"
        clientSecret: "CLIENT-SECRET"
```
Where:

   - `CLIENT-ID` is the Client ID you obtained while setting up the OIDC provider
   - `CLIENT-SECRET` is the Client Secret you obtained while setting up the OIDC provider


1. You must also add a `kubernetes` section to the `app_config` stanza that Tanzu Application Platform GUI uses. This section must have an entry for each cluster that has resources to view.

To do so, copy this YAML content into `tap-values.yml`:

```yaml
kubernetes:
  clusterLocatorMethods:
    - type: 'config'
      clusters:
        - name: "CLUSTER-NAME-UNCONSTRAINED"
          url: "CLUSTER-URL"
          authProvider: google
          caData: "CA-DATA"
```
Where:

   - `CLUSTER-NAME-UNCONSTRAINED` is the cluster name of your choice for your GKE cluster
   - `CLUSTER_URL` is the URL for the remote cluster you are connecting to Tanzu Application Platform GUI. To obtain your cluster's URL, execute the following command:

```console
CLUSTER_URL=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')

echo CLUSTER-URL: $CLUSTER_URL
```
- `CA-DATA` is the CA certificate data.

(HOW TO OBTAIN CA-DATA)

If there are any other clusters that you would like to make visible through Tanzu Application Platform GUI, add their entries to `clusters` as well.

### <a id="upgrade-tap-gui"></a> Upgrade the Tanzu Application Platform GUI package

Once the new configuration file is ready, update the `tap-gui` package by running this command:

```console
tanzu package installed update tap-gui --values-file tap-gui-values.yaml
```    

Or, if you were updating the `tap-values.yml` file, run the following command: 

```console
tanzu package installed update tap --values-file tap-values.yml
```

Wait a moment for the `tap-gui` package to update and then verify that `STATUS` is
`Reconcile succeeded` by running:

```console
tanzu package installed get tap-gui -n tap-install
```
