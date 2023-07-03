# View resources on remote GKE clusters

This topic tells you about two supported options to add access-controlled visibility for a remote GKE
cluster:

- [Leverage an external OIDC provider](#external-oidc-provider)
- [Leveraging Google's OIDC provider](#google-oidc-provider)

After the authorization is enabled, you can view your runtime resources on a remote cluster in
Tanzu Developer Portal. For more information, see
[View runtime resources on remote clusters](view-resources-rbac.md).

## <a id="external-oidc-provider"></a> Leverage an external OIDC provider

To leverage an external OIDC provider, such as Auth0:

1. Set up the OIDC provider
1. Configure the GKE cluster with the OIDC provider
1. Configure the Tanzu Developer Portal to view the remote GKE cluster
1. Upgrade the Tanzu Developer Portal package

### <a id="set-up-oidc-provider"></a> Set up the OIDC provider

You must set up the OIDC provider to enable RBAC visibility of remote clusters.
You can see the list of supported OIDC providers in
[Setting up a Tanzu Developer Portal authentication provider](../auth.md).

Tanzu Developer Portal supports multiple OIDC providers.
Auth0 is used here as an example.

1. Log in to the Auth0 dashboard.
1. Go to **Applications**.
1. Create an application of the type `Single Page Web Application` named `TAP-GUI` or a name of your
choice.
1. Click the **Settings** tab.
1. Under **Application URIs** > **Allowed Callback URLs**, add

    ```url
    https://tap-gui.INGRESS-DOMAIN/api/auth/auth0/handler/frame
    ```

    Where `INGRESS-DOMAIN` is the domain you chose for your Tanzu Developer Portal in
    [Installing the Tanzu Application Platform package and profiles](../../install-online/profile.hbs.md).

1. Click **Save Changes**.

After creating an application with your OIDC provider, you receive the following credentials for
setting up RBAC for your remote cluster:

- **Domain**, which is used as `issuerURL` in the following sections
- **Client ID**, which is used as `CLIENT-ID` in the following sections
- **Client Secret**, which is used as `CLIENT-SECRET` in the following sections

For more information, see [Auth0 Setup Walkthrough](https://backstage.io/docs/auth/auth0/provider) in
the Backstage documentation.
To configure other OIDC providers, see [Authentication in Backstage](https://backstage.io/docs/auth/)
in the Backstage documentation.

### <a id="configure-cluster"></a> Configure the GKE cluster with the OIDC provider

Add redirect configuration on the OIDC side by following the
[Google Cloud documentation](https://cloud.google.com/kubernetes-engine/docs/how-to/oidc).

### <a id="configure-tap-gui"></a> Configure the Tanzu Developer Portal

Configure visibility of the remote cluster in Tanzu Developer Portal:

1. Obtain your cluster's URL by running:

    ```console
    CLUSTER_URL=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')

    echo CLUSTER-URL: $CLUSTER_URL
    ```

    This command returns the URL of the first configured cluster in your `kubeconfig` file.
    To view other clusters one by one, edit the number in `.clusters[0].cluster.server` or edit the
    command to view all the configured clusters.

1. Ensure you have an `auth` section in the `app_config` section that Tanzu Developer Portal
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
    - `ISSUER-URL` is the Issuer URL you obtained while setting up the OIDC provider

1. Add a `kubernetes` section to the `app_config` section that Tanzu Developer Portal
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

    - `CLUSTER-NAME-UNCONSTRAINED` is the cluster name of your choice for your GKE cluster
    - `CLUSTER-URL` is the URL for the remote cluster you are connecting to
    Tanzu Developer Portal. You obtained this earlier in the procedure.

    If there are any other clusters that you want to make visible in Tanzu Developer Portal,
    add their entries to `clusters` as well.

### <a id="upgrade-tap-gui"></a> Upgrade the Tanzu Developer Portal package

After the new configuration file is ready, update the `tap` package:

1. Run:

    ```console
    tanzu package installed update tap --values-file tap-values.yaml
    ```

1. Wait a moment for the `tap-gui` package to update and then verify that `STATUS` is
`Reconcile succeeded` by running:

    ```console
    tanzu package installed get tap-gui -n tap-install
    ```

## <a id="google-oidc-provider"></a> Leverage Google's OIDC provider

When leveraging Google's OIDC provider, fewer steps are needed to enable authorization:

1. Add redirect configuration on the OIDC side.
1. Configure the Tanzu Developer Portal to view the remote GKE cluster
1. Upgrade the Tanzu Developer Portal package

### <a id="add-redirect-config"></a> Add redirect configuration on the OIDC side

Add redirect configuration on the OIDC side by following the
[Google Cloud documentation](https://cloud.google.com/kubernetes-engine/docs/how-to/oidc).

### <a id="configure-tap-gui"></a> Configure the Tanzu Developer Portal

Configure visibility of the remote GKE cluster in Tanzu Developer Portal:

1. Obtain your cluster's URL by running:

    ```console
    CLUSTER_URL=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')

    echo CLUSTER-URL: $CLUSTER_URL
    ```

    This command returns the URL of the first configured cluster in your `kubeconfig` file.
    To view other clusters one by one, edit the number in `.clusters[0].cluster.server` or edit the
    command to view all the configured clusters.
    <!-- Ideally insert step below for how to obtain CA data -->

1. Ensure you have an `auth` section in the `app_config` section that Tanzu Developer Portal
uses. In the example for Auth0, copy this YAML content into `tap-values.yaml`:

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

1. Add a `kubernetes` section to the `app_config` section that Tanzu Developer Portal
uses. This section must have an entry for each cluster that has resources to view.
To do so, copy this YAML content into `tap-values.yaml`:

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

    - `CLUSTER-NAME-UNCONSTRAINED` is the cluster name of your choice for your GKE cluster.
    - `CLUSTER-URL` is the URL for the remote cluster you are connecting to
    Tanzu Developer Portal. You obtained this earlier in the procedure.
    - `CA-DATA` is the CA certificate data.

    If there are any other clusters that you want to make visible in Tanzu Developer Portal,
    add their entries to `clusters` as well.

### <a id="upgrade-tap-gui"></a> Upgrade the Tanzu Developer Portal package

After the new configuration file is ready, update the `tap` package:

1. Run:

    ```console
    tanzu package installed update tap --values-file tap-values.yaml
    ```

1. Wait a moment for the `tap-gui` package to update and then verify that `STATUS` is
`Reconcile succeeded` by running:

    ```console
    tanzu package installed get tap-gui -n tap-install
    ```
