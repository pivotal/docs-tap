# View resources on remote EKS clusters

This topic tells you how to view your runtime resources on a remote EKS cluster in
Tanzu Developer Portal (commonly called TAP GUI). For more information, see
[View runtime resources on remote clusters](view-resources-rbac.md).

## <a id="set-up-oidc-provider"></a> Set up the OIDC provider

You must set up the OIDC provider to enable RBAC visibility of remote EKS clusters.
You can see the list of supported OIDC providers in
[Setting up a Tanzu Developer Portal authentication provider](../auth.md).

Tanzu Developer Portal supports multiple OIDC providers.
Auth0 is used here as an example.

1. Log in to the Auth0 dashboard.
1. Go to **Applications**.
1. Create an application of the type `Single Page Web Application` named `TAP-GUI` or a name of your
choice.
1. Click the **Settings** tab.
1. Under **Application URIs > Allowed Callback URLs**, add

    ```console
    https://tap-gui.INGRESS-DOMAIN/api/auth/auth0/handler/frame
    ```

    Where `INGRESS-DOMAIN` is the domain you chose for your Tanzu Developer Portal in
    [Installing the Tanzu Application Platform package and profiles](../../install-online/profile.hbs.md).

1. Click **Save Changes**.

After creating an application with your OIDC provider, you receive the following credentials for setting
up RBAC for your remote cluster:

- **Domain**, which is used as `ISSUER-URL` in the following sections (`AUTH0_DOMAIN` for Auth0)
- **Client ID**, which is used as `CLIENT-ID` in the following sections
- **Client Secret**, which is used as `CLIENT-SECRET` in the following sections

For more information, see [Auth0 Setup Walkthrough](https://backstage.io/docs/auth/auth0/provider) in
the Backstage documentation.
To configure other OIDC providers, see [Authentication in Backstage](https://backstage.io/docs/auth/)
in the Backstage documentation.

## <a id="configure-cluster"></a> Configure the Kubernetes cluster with the OIDC provider

To configure the cluster with the OIDC provider's credentials:

1. Create a file with the following content and name it `rbac-setup.yaml`.
This content applies to EKS clusters.

    ```yaml
    apiVersion: eksctl.io/v1alpha5
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
    - `ISSUER-URL` is the Issuer URL you obtained while setting up the OIDC provider. For Auth0, this
    is `https://${AUTH0_DOMAIN}/`.

2. Using `eksctl`, run:

    ```console
    eksctl associate identityprovider -f rbac-setup.yaml
    ```

3. Verify that the association of the OIDC provider with the EKS cluster was successful by running:

    ```console
    eksctl get identityprovider --cluster CLUSTER-NAME
    ```

    Where `CLUSTER-NAME` is the cluster name for your EKS cluster as an AWS identifier

    Verify that the output shows `ACTIVE` in the `STATUS` column.

## <a id="configure-tap-gui"></a> Configure the Tanzu Developer Portal

Configure visibility of the remote cluster in Tanzu Developer Portal:

1. Obtain your cluster's URL by running:

    ```console
    CLUSTER_URL=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')

    echo CLUSTER-URL: $CLUSTER_URL
    ```

    This command returns the URL of the first configured cluster in your `kubeconfig` file.
    To view other clusters one by one, edit the number in `.clusters[0].cluster.server` or edit the
    command to view all the configured clusters.

2. Ensure you have an `auth` section in the `app_config` section that Tanzu Developer Portal
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

    - `CLIENT-ID` is the Client ID you obtained while setting up the OIDC provider.
    - `CLIENT-SECRET` is the Client Secret you obtained while setting up the OIDC provider.
    - `ISSUER-URL` is the Issuer URL you obtained while setting up the OIDC provider.
      For Auth0, it is only `AUTH0_DOMAIN`.

3. Add a `kubernetes` section to the `app_config` section that Tanzu Developer Portal
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
    - `CLUSTER-URL` is the URL for the remote cluster you are connecting to
    Tanzu Developer Portal. You obtained this earlier in the procedure.

    If there are any other clusters that you want to make visible in Tanzu Developer Portal,
    add their entries to `clusters` as well.

## <a id="upgrade-tap-gui"></a> Upgrade the Tanzu Developer Portal package

After the new configuration file is ready, update the `tap` package:

1. Run:

    ```console
    tanzu package installed update tap --values-file tap-values.yaml
    ```

2. Wait a moment for the `tap-gui` package to update and then verify that `STATUS` is
`Reconcile succeeded` by running:

    ```console
    tanzu package installed get tap-gui -n tap-install
    ```
