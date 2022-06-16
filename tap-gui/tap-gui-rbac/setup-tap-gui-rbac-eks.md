# Enable Authorization on Remote EKS Clusters in Tanzu Application Platform GUI

To add access-controlled visibility for a remote EKS cluster:

1. Set up the OIDC provider
1. Configure the EKS cluster with the OIDC provider
1. Configure the Tanzu Application Platform GUI to view the remote EKS cluster
1. Upgrade the Tanzu Application Platform GUI package

After these steps are complete, you can view your runtime resources on a remote EKS cluster in
Tanzu Application Platform GUI. For more information, see
[View Runtime Resources on Remote Clusters in Tanzu Application Platform GUI](view-resouces-rbac.html).


## <a id="set-up-oidc-provider"></a> Set up the OIDC provider

You must set up the OIDC provider to enable RBAC visibility of remote EKS clusters.
You can see the list of supported OIDC providers in
[Setting up a Tanzu Application Platform GUI authentication provider](../auth.html).

Tanzu Application Platform GUI supports multiple OIDC providers.
Auth0 is used here as an example.

1. Log in to the Auth0 dashboard.
1. Go to **Applications**.
1. Create an application of the type `Single Page Web Application` named `TAP-GUI` or a name of your choice.
1. Click the **Settings** tab.
1. Under **Application URIs > Allowed Callback URLs**, add

    ```
    http://tap-gui.INGRESS-DOMAIN/api/auth/auth0/handler/frame
    ```

    Where `INGRESS-DOMAIN` is the domain you chose for your Tanzu Application Platform GUI in
    [Installing the Tanzu Application Platform package and profiles](../../install.md.hbs).

1. Click **Save Changes**.

After creating an application with your OIDC provider, you receive the following credentials for setting
up RBAC for your remote cluster:

* **Domain**, which is used as `issuerURL` in the following sections. *Note:* for Auth0, the format of the `issuerURL` is `https://${AUTH0_DOMAIN}/` 
* **Client ID**, which is used as `CLIENT-ID` in the following sections
* **Client Secret**, which is used as `CLIENT-SECRET` in the following sections

For more information, see [Auth0 Setup Walkthrough](https://backstage.io/docs/auth/auth0/provider) in
the Backstage documentation.
To configure other OIDC providers, see [Authentication in Backstage](https://backstage.io/docs/auth/)
in the Backstage documentation.


## <a id="configure-cluster"></a> Configure the Kubernetes cluster with the OIDC provider

To configure the cluster with the OIDC provider's credentials:

1. Create a file with the following content and name it `rbac-setup.yaml`.
This content applies to EKS clusters.

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
    - `ISSUER-URL` is the Issuer URL you obtained while setting up the OIDC provider. *Note:* for Auth0, the format of the `ISSUER-URL` is `https://${AUTH0_DOMAIN}/`


1. Using `eksctl`, run:

    ```console
    eksctl associate identityprovider -f rbac-setup.yaml
    ```

1. Verify that the association of the OIDC provider with the EKS cluster was successful by running:

    ```console
    eksctl get identityprovider --cluster CLUSTER-NAME
    ```

    Where `CLUSTER-NAME` is the cluster name for your EKS cluster as an AWS identifier

    Verify that the output shows `ACTIVE` in the `STATUS` column.


## <a id="configure-tap-gui"></a> Configure the Tanzu Application Platform GUI

Configure visibility of the remote cluster in Tanzu Application Platform GUI:

1. Obtain your cluster's URL by running:

    ```console
    CLUSTER_URL=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')

    echo CLUSTER-URL: $CLUSTER_URL
    ```

    This command returns the URL of the first configured cluster in your `kubeconfig` file.
    To view other clusters one by one, edit the number in `.clusters[0].cluster.server` or edit the
    command to view all the configured clusters.

1. Ensure you have an `auth` section in the `app_config` section that Tanzu Application Platform GUI
uses. In the example for Auth0, copy this YAML content into `tap-values.yaml`:

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
    - `CLIENT-SECRET` is the Client Secret you obtained while setting up the OIDC provider
    - `ISSUER-URL` is the Issuer URL you obtained while setting up the OIDC provider. *Note:* for Auth0, the format of the `ISSUER-URL` is `https://${AUTH0_DOMAIN}/`

1. Add a `kubernetes` section to the `app_config` section that Tanzu Application Platform GUI
uses. This section must have an entry for each cluster that has resources to view.
To do so, copy this YAML content into `tap-values.yaml`:

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
    - `CLUSTER-URL` is the URL for the remote cluster you are connecting to Tanzu Application Platform GUI. You obtained this earlier in the procedure.

    If there are any other clusters that you want to make visible in Tanzu Application Platform GUI, add
    their entries to `clusters` as well.


## <a id="upgrade-tap-gui"></a> Upgrade the Tanzu Application Platform GUI package

After the new configuration file is ready update the `tap` package:

1. Run:

    ```console
    tanzu package installed update tap --values-file tap-values.yaml
    ```

1. Wait a moment for the `tap-gui` package to update and then verify that `STATUS` is
`Reconcile succeeded` by running:

    ```console
    tanzu package installed get tap-gui -n tap-install
    ```
