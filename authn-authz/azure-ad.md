# <a id="azure-active-directory"></a> Azure Active Directory Integration

This topic describes how to integrate the Azure Active Directory (AD).

## <a id="azure-without-pinniped"></a> Integrate Azure AD with a new or existing AKS without Pinniped

Perform the following procedures to integrate Azure AD with a new or existing AKS without Pinniped.

### <a id="azure-prerequisites"></a> Prerequisites

Meet these prerequisites:

* Download and install the [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli).
* Download and install the [Tanzu CLI](../install-tanzu-cli.html#-install-or-update-the-tanzu-cli-and-plug-ins).
* Download and install the [Tanzu CLI RBAC plug-in](binding.html).

### <a id="azure-platform-setup"></a> Set up a platform operator

To set up a platform operator:

1. Navigate to the **Azure Active Directory Overview** page.

1. Select **Groups** under the **Manage** side menu.

1. Identify or create an admin group for the AKS cluster.

1. Retrieve the object ID of the admin group.

1. Take one of the following actions:

  * Create an AKS Cluster with Azure AD enabled by running:

    ```console
    az group create --name RESOURCE-GROUP --location LOCATION
    az aks create -g RESOURCE-GROUP -n MANAGED-CLUSTER --enable-aad --aad-admin-group-object-ids OBJECT-ID
    ```

    Where:

    * `RESOURCE-GROUP` is your resource group
    * `LOCATION` is your location
    * `MANAGED-CLUSTER` is your managed cluster
    * `OBJECT-ID` is the object ID

  * Enable Azure AD integration on the existing cluster by running:

    ```console
    az aks update -g RESOURCE-GROUP -n MANAGED-CLUSTER --enable-aad --aad-admin-group-object-ids OBJECT-ID
    ```

    Where:

    * `RESOURCE-GROUP` is your resource group
    * `MANAGED-CLUSTER` is your managed cluster
    * `OBJECT-ID` is the object ID

1. Add `Platform Operators` to the admin group.

1. Log in to the AKS cluster by running:

    ```console
    az aks get-credentials --resource-group RESOURCE-GROUP --name MANAGED-CLUSTER --admin
    ```

    Where:

    * `RESOURCE-GROUP` is your resource group
    * `MANAGED-CLUSTER` is your managed cluster


### <a id="azure-default-role"></a> Set up a Tanzu Application Platform default role group

To set up a Tanzu Application Platform default role group:

1. Navigate to the **Azure Active Directory Overview** page.

1. Select **Groups** under the **Manage** side menu.

1. Identify or create a list of groups in the Azure Active Directory for each of the
Tanzu Application Platform default roles (`app-operator`, `app-viewer`, and `app-editor`).

1. Retrieve the corresponding object IDs for each group.

1. Add users to the groups accordingly.

1. For each object ID retrieved earlier, use the Tanzu CLI RBAC plug-in to bind the `object id` group to a role.

    ```console
    tanzu rbac binding add -g OBJECT-ID -r TAP-ROLE -n NAMESPACE
    ```

    Where:

    * `OBJECT-ID` is the object ID
    * `TAP-ROLE` is the Tanzu Application Platform role
    * `NAMESPACE` is the namespace


### <a id="azure-kubeconfig"></a> Set up kubeconfig

To set up kubeconfig:

1. Set up the `kubeconfig` to point to the AKS cluster

    ```console
    az aks get-credentials --resource-group RESOURCE-GROUP --name MANAGED-CLUSTER
    ```

    Where:

    * `RESOURCE-GROUP` is your resource group
    * `MANAGED-CLUSTER` is your managed cluster

1. Run any kubectl command to trigger a browser login. For example:

    ```console
    kubectl get pods
    ```


## <a id="azure-ad-pinniped"></a> Azure Active Directory with Pinniped

Perform the following procedures to set up Azure Active Directory with Pinniped.


### <a id="azure-pinniped"></a> Prerequisites

Meet these prerequisites:

* Download and install the [Tanzu CLI](../install-tanzu-cli.html#-install-or-update-the-tanzu-cli-and-plug-ins)
* Download and install the [Tanzu CLI RBAC plug-in](binding.html)
* Install [pinniped supervisor and concierge](pinniped-install-guide.md) on the cluster without
setting up the [`OIDCIdentityProvider` and `secret`](pinniped-install-guide.html#create-pinniped-supervisor-configuration) yet.


### <a id="azure-ad-app-setup"></a> Set up the Azure Active Directory app

To set up the Azure AD app:

1. Navigate to the **Azure Active Directory Overview** page.

1. Select **App registrations** under the **Manage** side menu.

1. Select **New Registration**.

1. Enter the name of the application. For example, `gke-pinniped-supervisor-app`.

1. Under **Supported account types**, select **Accounts in this organisational directory only (VMware, Inc. only - Single tenant)**.

1. Under **Redirect URI**, select **Web** as the platform.

1. Enter the call URI to the supervisor. For example, `https://pinniped-supervisor.example.com/callback`.

1. Select **Register** to create the app.

1. If not already redirected, navigate to the app settings page.

1. Select **Token configuration** under the **Manage** menu.

1. Select **Add groups claim**.

1. Select **All groups (includes distribution lists but not groups assigned to the application)**.

1. Select **Add** to create the group claim.

1. Return to the app settings page by clicking on the **app name** in the breadcrumb navigation.

1. Select the **Endpoints** tab and record the value in the **OpenID Connect metadata document** field.

1. Go back to the app settings page.

1. Record the **Application (client) ID**.

1. Select **Certificates & secrets** under the **Manage** menu.

1. Create a new client secret and record this value.

    ```yaml
    ---
    apiVersion: idp.supervisor.pinniped.dev/v1alpha1
    kind: OIDCIdentityProvider
    metadata:
      namespace: pinniped-supervisor
      name: azure-ad
    spec:
      # Specify the upstream issuer URL.
      issuer: ISSUER-URL

      authorizationConfig:
        additionalScopes: ["openid", "email"]
        allowPasswordGrant: false

      # Specify how claims are mapped to Kubernetes identities.
      claims:
        username: email
        groups: groups

      # Specify the name of the Kubernetes Secret that contains your
      # application's client credentials (created below).
      client:
        secretName: azure-ad-client-credentials
    ---
    apiVersion: v1
    kind: Secret
    metadata:
      namespace: pinniped-supervisor
      name: azure-ad-client-credentials
    type: secrets.pinniped.dev/oidc-client
    stringData:
      clientID: "AZURE-AD-CLIENT-ID"
      clientSecret: "AZURE-AD-CLIENT-SECRET"
    ```

    Where:

    * `ISSUER-URL` is the OpenID Connect metadata document URL you recorded earlier, but without the trailing `/.well-known/openid-configuration`
    * `AZURE-AD-CLIENT-ID` is the Azure Active Directory client ID you recorded earlier
    * `AZURE-AD-CLIENT-SECRET` is the Azure Active Directory client secret you recorded earlier

1. Use the kubectl CLI to apply this YAML.


### <a id="pinniped-default-role"></a> Set up the Tanzu Application Platform default role group

To set up a Tanzu Application Platform default role group:

1. Navigate to the **Azure Active Directory Overview** page.

1. Select **Groups** under the **Manage** side menu.

1. Identify or create a list of groups in the Azure Active Directory for each of the
Tanzu Application Platform default roles (`app-operator`, `app-viewer`, and `app-editor`).

1. Retrieve the corresponding object IDs for each group.

1. Add users to the groups accordingly.

1. For each object ID retrieved earlier, use the Tanzu CLI RBAC plug-in to bind the `object id` group to a role.

    ```console
    tanzu rbac binding add -g OBJECT-ID -r TAP-ROLE -n NAMESPACE
    ```

    Where:

    * `OBJECT-ID` is the object ID
    * `TAP-ROLE` is the Tanzu Application Platform role
    * `NAMESPACE` is the namespace


### <a id="pinniped-kubeconfig"></a> Set up kubeconfig

Follow these steps to set up kubeconfig:

1. Set up `kubeconfig` using the Pinniped CLI by running:

    ```console
    pinniped  get kubeconfig --kubeconfig-context <your-kubeconfig-context> > /tmp/concierge-kubeconfig
    ```
    <!--- Accidental double space? -->

1. Run any kubectl command to trigger a browser login. For example:

    ```console
    export KUBECONFIG="/tmp/concierge-kubeconfig"
    kubectl get pods
    ```
