
### <a id="azure-active-directory">Azure Active Directory Integration</a>

#### <a id="azure-without-pinniped" />Azure Active Directory with a new or existing AKS without pinniped:

##### <a id="azure-prerequisites" /> Prerequisites
1) Download and install the [`az cli`](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
1) Download and install the [`Tanzu CLI`](../install-tanzu-cli.md#-install-or-update-the-tanzu-cli-and-plug-ins)
1) Download and install the [`Tanzu CLI RBAC plugin`](./binding.md)
 
##### <a id="azure-platform-setup" /> Platform Operator Setup:

1) Navigate to the Azure Active Directory Overview Page

1) Select `Groups` under the `Manage` side menu

1) Identify or create an admin group for the AKS cluster

1) Retrieve the `object id` of the admin group

1) Create an AKS Cluster with  Azure Active Directory enabled

	```
	az group create --name <resource-group> --location <location>
	az aks create -g <resource-group> -n <managed-cluster> --enable-aad --aad-admin-group-object-ids <object-id>
	```

	or

	Enable Azure AD integration on the existing cluster
	```
	az aks update -g <resource-group> -n <managed-cluster> --enable-aad --aad-admin-group-object-ids <object-id>
	```

1) Add `Platform Operators` to the admin group

1) Log on to the AKS cluster:

	```
	az aks get-credentials --resource-group <resource-group> --name <managed-cluster> --admin
	```

Replace the `<resource-group>`, `<managed-cluster>`, `<location>`, and`<object-id>` fields

##### <a id="azure-default-role" />TAP Default Role Group Setup:

1) Navigate to the Azure Active Directory Overview Page

1) Select `Groups` under the `Manage` side menu

1) Identify or create a list of groups in the Azure Active Directory for each of the TAP Default Roles (app-operator, app-viewer, app-editor)

1) Retrieve the corresponding `object ids` for each group

1) Add users to the groups accordingly

1) For each `object id` retrieved in step 4, use the Tanzu CLI RBAC plugin to bind `object id` group to a role
	```
	tanzu rbac binding add -g <object-id> -r <tap-role> -n <namespace>
	```
	Replace the `<object-id>`, `<tap-role>`, `<namespace>` fields
	
##### <a id="azure-kubeconfig" /> KUBECONFIG Setup
1) Setup the `kubeconfig` to point to the AKS cluster
	```
	az aks get-credentials --resource-group <resource-group> --name <managed-cluster>
	```
	Replace the `<resource-group>` and `<managed-cluster>` fields
	
1) Run any `kubectl` command to trigger a browser login
Example
	```
	kubectl get pods
	```
	
#### <a id="azure-ad-pinniped" /> Azure Active Directory with Pinniped:

##### <a id="azure-pinniped" /> Prerequisites
1) Download and install the [`Tanzu CLI`](../install-tanzu-cli.md#-install-or-update-the-tanzu-cli-and-plug-ins)
1) Download and install the [`Tanzu CLI RBAC plugin`](./binding.md)
1) Install [`pinniped supervisor and concierge`](./pinniped-install-guide.md) on the cluster without setting up the [`OIDCIdentityProvider` and `secret`](./pinniped-install-guide.md#create-pinniped-supervisor-configuration) yet.

##### <a id="azure-ad-app-setup" /> Azure Active Directory App Setup
1) Navigate to the Azure Active Directory Overview Page

1) Select `App registrations` under the `Manage` side menu

1) Select `New Registration`

1) Enter the name of the application
	Example: `gke-pinniped-supervisor-app`
	
1) Under `Supported account types`, choose `Accounts in this organizational directory only (VMware, Inc. only - Single tenant)`

1) Under `Redirect URI`, choose `Web` as the platform and enter the call URI to the supervisor

   Example: `https://pinniped-supervisor.example.com/callback`
	
1) Select `Register` to create the app

1) If not already redirected, navigate to the app settings page

1) Select `Token configuration` under the `Manage` menu

1) Select `Add groups claim`

1) Select `All groups (includes distribution lists but not groups assigned to the application)`

1) Select `Add` to create the group claim

1) Return to the app settings page by clicking on the `app name` in the breadcrumb navigation

1) Select the `Endpoints` tab and take note of the `OpenID Connect metadata document` Field

	**Note**: Remove the trailing `/.well-known/openid-configuration` from the url and replace the `<issuer-url>` tag with the modified `OpenID Connect metadata document` url in the yaml below

1) Go back to the app settings page


1) Copy the `Application (client) ID` and replace the `<azure-ad-client-id>` tag with `Application (client) ID` in the yaml below

1) Select `Certificates & secrets` under the `Manage` menu

1) Create a `New client secret`, copy the `Value` and replace the `<azure-ad-client-secret>` tag with `Value` in the yaml below

1) 
	```yaml
	---
	apiVersion: idp.supervisor.pinniped.dev/v1alpha1
	kind: OIDCIdentityProvider
	metadata:
	  namespace: pinniped-supervisor
	  name: azure-ad
	spec:
	  # Specify the upstream issuer URL.
	  issuer: <issuer-url>

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
	  clientID: "<azure-ad-client-id>"
	  clientSecret: "<azure-ad-client-secret>"
	```

1) kubectl apply the yaml above

##### <a id="pinniped-default-role" /> TAP Default Role Group Setup:
Follow the same steps in the [Azure Active Directory](#azure-default-role) section

##### <a id="pinniped-kubeconfig" /> KUBECONFIG Setup
1) Setup the `kubeconfig` using the pinniped cli
	```
	pinniped  get kubeconfig --kubeconfig-context <your-kubeconfig-context> > /tmp/concierge-kubeconfig
	```
	
1) Run any `kubectl` command to trigger a browser login
Example
	```
	export KUBECONFIG="/tmp/concierge-kubeconfig"
	kubectl get pods
	```
