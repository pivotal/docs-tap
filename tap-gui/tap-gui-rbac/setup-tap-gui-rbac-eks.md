# Enable Authorization on Remote EKS Clusters in Tanzu Application Platform GUI

The process for adding access-controlled visibility for a remote EKS cluster is the following:

1. Set up the OIDC provider (pre-requisite)
2. Configure the EKS cluster with the OIDC provider
3. Configure the Tanzu Application Platform GUI to view the remote EKS cluster
4. Upgrade the Tanzu Application GUI package

Once these steps are complete, you can view your runtime resources on a remote EKS cluster in Tanzu Application Platform GUI. For more detail, please refer to [View Runtime Resources on Remote Clusters in Tanzu Application Platform GUI](./view-resouces-rbac.md).

## <a id="set-up-oidc-provider"></a> Set up the OIDC provider

To enable RBAC visibility of remote EKS clusters, you need to set up the OIDC provider. You can see the list of supported OIDC providers in the [Setting up a Tanzu Application Platform GUI authentication provider](./../auth.md) section.

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

## <a id="configure-cluster"></a> Configure the Kubernetes cluster with the OIDC provider

These steps will help you to configure the cluster with the OIDC provider's credentials.

1. Create a file with the contents below and name it `rbac-setup.yaml`. The following example applies to EKS clusters.

```yaml
apiVersion: eksctl.10/vialpha5
kind: ClusterConfig
metadata:
  name: "CLUSTER-NAME"
  region: "AWS-REGION"
identityProviders:
  - name: auth0
    type: oidc
    issuerUrl: "ISSUER-URL"
    clientId: "CLIENT-ID"
    usernameClaim: email
```
Where:
   - `CLUSTER-NAME` is the cluster name for your EKS cluster as an AWS identifier
   - `AWS-REGION` is the AWS region of the EKS cluster
   - `CLIENT-ID` is the Client ID you obtained while setting up the OIDC provider
   - `ISSUER-URL` is the Issuer URL you obtained while setting up the OIDC provider


2. Using `eksctl`, execute the following command:

```console
eksctl associate identityprovider -f rbac-setup.yaml
```

3. To check if the association of the OIDC provider with the EKS cluster was successful, run the following command

```console
eksctl get identityprovider --cluster CLUSTER-NAME
```
Where:
   - `CLUSTER-NAME` is the cluster name for your EKS cluster as an AWS identifier

The output should state `ACTIVE` in the STATUS column.


## <a id="configure-tap-gui"></a> Configure the Tanzu Application Platform GUI

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

   - `CLUSTER-NAME-UNCONSTRAINED` is the cluster name of your choice for your EKS cluster
   - `CLUSTER-URL` is the URL for the remote cluster you are connecting to Tanzu Application Platform GUI. To obtain your cluster's URL, execute the following command:

```console
CLUSTER_URL=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')

echo CLUSTER-URL: $CLUSTER_URL
```

**Note:** The command above shall return the URL of the first configured cluster in your kubeconfig file. To view other clusters one by one, modify the number in `.clusters[0].cluster.server` or modify the command to view all the configured clusters.

If there are any other clusters that you would like to make visible through Tanzu Application Platform GUI, add their entries to `clusters` as well.

## <a id="upgrade-tap-gui"></a> Upgrade the Tanzu Application Platform GUI package

Once the new configuration file is ready, update the `tap` package by running this command:

```console
tanzu package installed update tap --values-file tap-values.yml
```

Wait a moment for the `tap-gui` package to update and then verify that `STATUS` is
`Reconcile succeeded` by running:

```console
tanzu package installed get tap-gui -n tap-install
```