# Get Started with Application Single Sign-On

This topic tells you about concepts important to getting started with Application
Single Sign-On (commonly called AppSSO).

Use this topic to learn how to:

1. [Set up your first simplistic authorization server](#provision-an-authserver).
1. [Claim credentials](#claim-credentials).
1. [Deploy your workload](#deploy).

After completing these steps, you can proceed with securing a workload.
For more information, see [Secure a workload with Application Single Sign-On](app-operators/secure-spring-boot-workload.hbs.md).

## <a id='prereqs'></a> Prerequisites

To get start with Application Single Sign-On, you must: 

- Install Application Single Sign-On on your Tanzu Application Platform cluster.
For more information, see [Install Application Single Sign-On](platform-operators/installation.hbs.md).
- Install the [Tanzu CLI](../../install-tanzu-cli.hbs.md) on your machine 
and connect to a Tanzu cluster.

## <a id='concepts'></a>Key concepts

At the core of Application Single Sign-On is the concept of the Authorization Server, 
outlined by the [AuthServer custom resource](../reference/api/authserver.hbs.md).
Service Operators create those resources to provision running Authorization Servers,
which are [OpenID Connect](https://openid.net/specs/openid-connect-core-1_0.html)
Providers. They issue [ID Tokens](https://openid.net/specs/openid-connect-core-1_0.html#IDToken)
to the client applications, which contain identity information about the end user, 
such as email, first name, last name and so on.

![Diagram of Application Single Sign-On components and how they interact with the end-users and client applications](../../images/app-sso/appsso-concepts.png)

The following steps outline how a client application uses an `AuthServer` to authenticate an end-user:

1. The end-user visits the client application.
2. The client application redirects the end-user to the `AuthServer`, with an OAuth2 request.
3. The end-user logs in with the `AuthServer` by using an external identity provider, for example, Google or Azure AD.
    1. The identity providers are set up by Service Operators.
    2. `AuthServer`s use various protocols to obtain identity information about the user, such as OpenID Connect, SAML, or LDAP, which might require additional redirects.
4. The `AuthServer` redirects the end-user to the client application with an authorization code.
5. The client application communicates with the `AuthServer` to receive an `id_token`.
    1. The client application does not know how the `AuthServer` collected identity information. It only receives the identity information as an `id_token`.

[ID Tokens](https://openid.net/specs/openid-connect-core-1_0.html#IDToken) are JSON Web Tokens containing standard claims about the identity of the user, for example, name or email, and standard claims about the token itself, for example, "expires at" or "audience". Here is an example of an `id_token` issued by an Authorization Server:

```json
{
	"iss": "https://appsso.example.com",
	"sub": "213435498y",
	"aud": "my-client",
	"nonce": "fkg0-90_mg",
	"exp": 1656929172,
	"iat": 1656928872,
	"name": "Jane Doe",
	"given_name": "Jane",
	"family_name": "Doe",
	"email": "jane.doe@example.com",
	"roles": [
		"developer",
		"org-user"
	]
}
```

`roles` claim is included in an `id_token` only if user roles are mapped and the 
`roles` scope is requested.
For more information about mapping for OpenID Connect, LDAP and SAML, see:

- [OpenID external groups mapping](service-operators/identity-providers.hbs.md#openid-external-groups-mapping)
- [LDAP external groups mapping](service-operators/identity-providers.hbs.md#ldap-external-groups-mapping)
- [SAML (experimental) external groups mapping](service-operators/identity-providers.hbs.md#saml-external-groups-mapping)

ID Tokens are signed by the `AuthServer` by using [Token signature keys](service-operators/configure-token-signature.hbs.md). 
Client applications can verify their validity by using the `AuthServer`'s public keys.

## <a id="provision-an-authserver"></a> Provision an `AuthServer`

This section tells you how to provision an `AuthServer` for Application Single
Sign-On. Use this topic to learn how to:

1. [Discover the existing Application Single Sign-On service offerings in your cluster](#discover).
1. [Set up your first `ClusterUnsafeTestLogin`](#set-up).
1. [Ensure the `AuthServer` is running and users can log in](#verify).

### <a id="prereqs"></a> Prerequisites

You must install and correctly configure Application Single Sign-On on your 
Tanzu Application Platform cluster.

Application Single Sign-On is installed with the `run`, `iterate`, and `full` profiles.
No extra steps are required.

To verify Application Single Sign-On is installed on your cluster, run:

```shell
tanzu package installed list -A | grep "sso.apps.tanzu.vmware.com"
```

For more information about the Application Single Sign-On installation,
see [Install Application Single Sign-On](./platform-operators/installation.md).

### <a id="discover"></a> Discover the existing Application Single Sign-On service offerings

The Application Single Sign-On login servers are a consumable service offering in 
Tanzu Application Platform. The `ClusterWorkloadRegistrationClass` represents
these service offerings.

In your Kubernetes cluster, run the following command:

```bash
tanzu service class list
```

If there is not a login offering you want to connect to, you must create your own.

> **Caution** The `AuthServer` example uses an unsafe testing-only identity provider. Never use it in
production environments. For more information about the identity providers, see [Identity providers](./service-operators/identity-providers.hbs.md).

### <a id="set-up"></a> Set up your first `ClusterUnsafeTestLogin`

In a non-poduction environment, [`ClusterUnsafeTestLogin`](../reference/api/clusterunsafetestlogin.hbs.md) is the recommended way to get started with Application Single Sign-On.

```bash
cat <<EOF | kubectl apply -f -
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: ClusterUnsafeTestLogin
metadata:
  name: my-login
EOF
```

### <a id="verify"></a> Verify that your `AuthServer` is running

To see the service offering, run:

```shell
tanzu service class list
```

Expect to see the following output:

```shell
NAME                          DESCRIPTION
my-login  Login by AppSSO - user:password - UNSAFE FOR PRODUCTION!
```

>**Caution** This login offering is not safe for production because it hard codes 
the user and password.

You can wait for the `ClusterUnsafeTestLogin` to be ready by running:

```shell
kubectl wait --for=condition=Ready clusterUnsafeTestLogin my-login
```

Alternatively, you can inspect your `ClusterUnsafeTestLogin` like any other resource:

```shell
kubectl get clusterunsafetestlogin.sso.apps.tanzu.vmware.com --all-namespaces
```

Expect to see the following output:

```shell
NAME       ISSUER URI                           STATUS
my-login   http://unsafe-my-login.appsso.<...>  Ready
```

You can visit the login page by using the `ISSUER URI`.

## <a id="claim-credentials"></a> Claim credentials

Now that you have an Application Single Sign-On service offering. 
The next step is to create a `ClassClaim`, which creates consumable credentials 
for your workload, and allows your workload to connect to the login service
offering by using the credentials.

![Diagram of the Connection between your Workload, the ClassClaim, and Application Single Sign-On.](../../images/app-sso/appsso-flow.png)

Select your preferred login offering from the available options:

```bash
tanzu service class list
```

If there are none available, [you can create one yourself](#provision-an-authserver):

```bash
tanzu service class-claim create my-workload \
  --class my-login \
  --parameter workloadRef.name=appsso-starter-java \
  --parameter redirectPaths='["/login/oauth2/code/appsso-starter-java"]'
```

The `redirectPaths` is the login redirect within your application. This example 
deploys a minimal Spring application, so you can use the Spring Security path.

Verify the status of your `ClassClaim` by running:

```bash
tanzu service class-claim list
```

## <a id="deploy"></a> Deploy an application with Application Single Sign-On

This section tells you how to deploy a minimal Kubernetes application that is protected
by Application Single Sign-On (commonly called AppSSO) by using the credentials
that [tanzu service class-claim](#claim-credentials) creates.

For more information about how a Client application uses an AuthServer to
authenticate an end user, see the [Overview of Application Single Sign-On](../about.hbs.md).

### <a id="deploy-prereqs"></a>Prerequisites

You must complete the steps in [Claim credentials](#claim-credentials).

### <a id="deploy-min-app"></a>Deploy a minimal application

Follow these steps to deploy a minimal Spring Boot application:

1. List the available accelerators by running:

    ```bash
    tanzu accelerator list
    ```

    Expect to see an accelerator named `appsso-starter-java`. 
    This is the accelerator to use.

1. Create a project by running:

    ```bash
    tanzu accelerator generate appsso-starter-java --server-url YOUR-TAP-SERVER-URI --options '{"appssoOfferingName": "my-login"}'
    ```

    This command creates a zip file.

1. Unzip the file by running:

    ```bash
    unzip appsso-starter-java.zip
    ```

1. Make the following changes in `config/workload.yaml`:

    1. The reference to the `serviceClaims` is the `ServiceClaim` you generated in the previous step. Replace `appsso-starter-java` in the `serviceClaims` section with `my-workload`.
    1. There is a reference to a remote version of your repository.
       You can push this repository to your preferred Git repository and provide 
       the reference here.

    The following code sample claimes the `ServiceClaim` from your appliction:

    ```yaml
    ---
    spec:
      serviceClaims:
        - name: YOUR-SERVICE-CLAIM
          ref:
            apiVersion: services.apps.tanzu.vmware.com/v1alpha1
            kind: ClassClaim
            name: YOUR-SERVICE-CLAIM
    ```

1. Deploy the workload by running:

    ```bash
    kubectl apply -f config/workload.yaml
    ```

The `ServiceClaim` connects your application to the `AppSSO AuthServer`.

See the workload section of the Tanzu Application Platform Portal where you can 
find the URL for your workload at `https://tap-gui.YOUR-TAP-CLUSTER-DOMAIN`.
