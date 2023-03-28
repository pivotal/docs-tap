# Install Pinniped on Tanzu Application Platform by using a Private Certificate Authority

[Pinniped](https://pinniped.dev/) is used to support authentication on Tanzu Application Platform.
This topic introduces how to install Pinniped on a single cluster of Tanzu Application Platform.
You will deploy two Pinniped components into the cluster.

The **Pinniped Supervisor** is an OIDC server which allows users to authenticate with an external
identity provider (IDP). It hosts an API for the concierge component to fulfill authentication requests.

The **Pinniped Concierge** is a credential exchange API that takes a credential from an identity
source, for example, Pinniped Supervisor, proprietary IDP, as input.
The **Pinniped Concierge** authenticates the user by using the credential, and returns another
credential that is parsable by the host Kubernetes cluster or by an impersonation proxy that acts
on behalf of the user.

## <a id="prereqs"></a> Prerequisites

Meet these prerequisites:

* Install the package `certmanager`. This is included in Tanzu Application Platform.
* Install the package `contour`. This is included in Tanzu Application Platform.
* Create a `workspace` directory to function as your workspace.

## <a id="env-plan"></a>Environment planning

If you are running Tanzu Application Platform on a single cluster, both components `Pinniped Supervisor` and `Pinniped Concierge` are installed to this cluster.

When running a multicluster setup you must decide which cluster to deploy the Supervisor onto. Furthermore, every cluster must have the Concierge deployed.
`Pinniped Supervisor` is supposed to run as a central component that is consumed by potentially multiple `Pinniped Concierge` instances. That means that a `Pinniped Supervisor` must be deployed to a single cluster that meets the [prerequisites](#prereqs). In the current Tanzu Application Platform, the `view cluster` is a good place for it, because it is defined as a central single instance cluster. For more information, see [Overview of multicluster Tanzu Application Platform](../multicluster/about.md).

In contrast, the `Pinniped Concierge` must be deployed to every cluster that you want to enable authentication for, including the `view cluster` itself.

See the following diagram showing a possible deployment model.
![Diagram showing the multicluster topology, where Pinniped Supervisor is deployed to View Cluster, and Pinniped Concierge instances are deployed across View, Build, and Run cluster.](../images/auth-pinniped-multi-cluster.jpg)

For more information about the Pinniped architecture and deployment model, see the [Pinniped Documentation](https://pinniped.dev/docs/background/architecture/).

## <a id="install-pinniped-super"></a>Install Pinniped Supervisor

Follow these steps to install `pinniped-supervisor`:

1. Switch tooling to the desired cluster.
1. Create the necessary certificate files.
1. Create the Ingress resources.
1. Create the `pinniped-supervisor` configuration.
1. Apply these resources to the cluster.

### <a id="create-certs"></a>Create Certificate Secret

Choose an fqdn that can resolve to the Contour instance running inside the `tanzu-system-ingress` namespace and create a certificate using a CA that clients will trust. This fqdn can be under the `ingress_domain` specified in the install yaml, or a dedicated DNS entry. In the following sections `pinniped-supervisor.example.com` will be used.

Once the certificates files are available they need to be encoded to base64 in single line format. Assuming a file `my.crt` that can be achieved with `cat my.crt | base64 -w 0`.

Create the following resource and save it into `workspace/pinniped-supervisor/ingress.yaml`, replacing the contents of `tls.crt` with the base64 encoded public key and `tls.key` with the base64 encoded private key.

```yaml
---
apiVersion: v1
kind: Secret
metadata:
  name: pinniped-supervisor-tls-cert
  namespace: pinniped-supervisor
type: kubernetes.io/tls
data:
  tls.crt: |
    LS0....
  tls.key: |
    LS0....
```

### <a id="create-ingress-resources"></a>Create Ingress resources

Create a Service and Ingress resource to make the `pinniped-supervisor` accessible from outside the
cluster.

To do so, create the following resources and save them into `workspace/pinniped-supervisor/ingress.yaml`.

```yaml
---
apiVersion: v1
kind: Service
metadata:
  name: pinniped-supervisor
  namespace: pinniped-supervisor
spec:
  ports:
  - name: pinniped-supervisor
    port: 8443
    protocol: TCP
    targetPort: 8080
  selector:
    app: pinniped-supervisor

---
apiVersion: projectcontour.io/v1
kind: HTTPProxy
metadata:
  name: pinniped-supervisor
spec:
  virtualhost:
    fqdn: pinniped-supervisor.example.com
    tls:
      secretName: pinniped-supervisor-tls-cert
  routes:
  - services:
    - name: pinniped-supervisor
      port: 8443
```

### <a id="create-pinniped-super-config"></a>Create Pinniped-Supervisor configuration

Create a FederationDomain to link the concierge to the supervisor instance and configure an
OIDCIdentityProvider to connect the supervisor to your OIDC Provider.
In the following example, you will use auth0.
See the [Pinniped documentation](https://pinniped.dev/docs/howto/) to learn how to configure different
identity providers, including OKTA, GitLab, OpenLDAP, Dex, Microsoft AD, and more.

To create Pinniped-Supervisor configuration, create the following resources and save them in
`workspace/pinniped-supervisor/oidc_identity_provider.yaml`.

```yaml
apiVersion: idp.supervisor.pinniped.dev/v1alpha1
kind: OIDCIdentityProvider
metadata:
  namespace: pinniped-supervisor
  name: auth0
spec:
  # Specify the upstream issuer URL.
  issuer: https://dev-xyz.us.auth0.com/

  # Specify how to form authorization requests to GitLab.
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
    secretName: auth0-client-credentials

---
apiVersion: v1
kind: Secret
metadata:
  namespace: pinniped-supervisor
  name: auth0-client-credentials
type: secrets.pinniped.dev/oidc-client
stringData:
  clientID: "<auth0-client-id>"
  clientSecret: "<auth0-client-secret>"

---
apiVersion: config.supervisor.pinniped.dev/v1alpha1
kind: FederationDomain
metadata:
  name: pinniped-supervisor-federation-domain
  namespace: pinniped-supervisor
spec:
  issuer: https://pinniped-supervisor.example.com
  tls:
    secretName: pinniped-supervisor-tls-cert
```

### <a id="apply-resources"></a>Apply the resources

After creating the resource files, you can install them into the cluster.
Follow these steps to deploy them as a [kapp application](https://carvel.dev/kapp/):

1. Install the supervisor by running:

    ```console
    kapp deploy -y --app pinniped-supervisor --into-ns pinniped-supervisor -f pinniped-supervisor -f https://get.pinniped.dev/v0.12.0/install-pinniped-supervisor.yaml
    ```
1. Get the external IP address of Ingress by running:

    ```console
    kubectl -n tanzu-system-ingress get svc/envoy -o jsonpath='{.status.loadBalancer.ingress[0].ip}'
    ```

1. If not already covered by a wildcard DNS entry, add and entry to the DNS system to bind the external IP address with the DNS entry.

## <a id="install-pinniped-concierge"></a>Install Pinniped Concierge

To install Pinniped Concierge:

1. Switch tooling to the desired cluster.
1. Deploy the Pinniped Concierge by running:

    ```console
    kapp deploy -y --app pinniped-concierge \
      -f https://get.pinniped.dev/v0.12.0/install-pinniped-concierge-crds.yaml \
      -f https://get.pinniped.dev/v0.12.0/install-pinniped-concierge.yaml
    ```

1. Get the CA certificate of the supervisor by running the following command against the cluster running `Pinniped Supervisor`:

    ```console
    kubectl get secret pinniped-supervisor-tls-cert -n pinniped-supervisor -o 'go-template=\{{index .data "tls.crt"}}'
    ```

    **Note** the `tls.crt` contains the entire certificate chain including the CA certificate for letsencrypt generated certificates

1. Create the following resource to `workspace/pinniped-concierge/jwt_authenticator.yaml`.

    ```yaml
    ---
    apiVersion: authentication.concierge.pinniped.dev/v1alpha1
    kind: JWTAuthenticator
    metadata:
      name: pinniped-jwt-authenticator
    spec:
      issuer: https://pinniped-supervisor.example.com
      audience: concierge
      tls:
        certificateAuthorityData: # insert the CA certificate data here
    ```

1. Deploy the resource by running:

    ```console
    kapp deploy -y --app pinniped-concierge-jwt --into-ns pinniped-concierge -f pinniped-concierge/jwt_authenticator.yaml
    ```

## <a id="log-in-cluster"></a>Log in to the cluster

See [Login using Pinniped](pinniped-login.md).
