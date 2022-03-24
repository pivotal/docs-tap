# Installing Pinniped on a single cluster

To support authentication on TAP we are installing [Pinniped](pinniped.dev). Inn this guide we install pinniped on a single cluster TAP setup. Pinniped consists of two components that we will deploy into our cluster.

The Pinniped Supervisor is an OIDC server which allows users to authenticate with an external identity provider (IDP), it hosts an API that the concierge component is using to fulfill authentication requests.

The Pinniped Concierge is a credential exchange API which takes as input a credential from an identity source (e.g., Pinniped Supervisor, proprietary IDP), authenticates the user via that credential, and returns another credential which is understood by the host Kubernetes cluster or by an impersonation proxy which acts on behalf of the user.


## Prerequisites

* installing pinniped with the proposed configuration requires the following packages to be installed:
    * certmanager
    * contour
* these packages are included in Tanzu Application Platform
* create a folder acting as your workspace `workspace`

## Install Pinniped supervisor

In order to install pinniped-supervisor you need to follow these steps:

1. create the necessary certificate files
1. create the ingress resources
1. create the pinniped-supervisor configuration
1. apply those resources to the cluster

### Create necessary Certificates (letsencrypt/cert-manager)

Create a ClusterIssuer for letsencrypt, a CA certificate and tls certificate for pinniped supervisor.

You can do it by creating the following resources and save it into `workspace/pinniped-supervisor/certificates.yaml`.

```yaml
---
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-staging
  namespace: cert-manager
spec:
  acme:
    email: your-mail@example.com
    privateKeySecretRef:
      name: letsencrypt-staging
    server: https://acme-staging-v02.api.letsencrypt.org/directory
    solvers:
    - http01:
        ingress:
        class: contour

---
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: pinniped-supervisor-ca-cert
  namespace: pinniped-supervisor
spec:
  isCA: true
  secretName: pinniped-supervisor-ca-cert
  commonName:  ca.supervisor.example.com
  dnsNames:
  - ca.supervisor.example.com
  issuerRef:
    name: letsencrypt-staging
    kind: ClusterIssuer

---
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: pinniped-supervisor-cert
  namespace: pinniped-supervisor
spec:
  secretName: pinniped-supervisor-tls-cert
  dnsNames:
  - pinniped.supervisor.example.com
  issuerRef:
    name: letsencrypt-staging
    kind: ClusterIssuer
```

### Create Ingress resources

Create a Service and Ingress resource to make the pinniped-supervisor accessible from outside the cluster.

You can do it by creating the following resources and save it into `workspace/pinniped-supervisor/ingress.yaml`.

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
    fqdn: pinniped.supervisor.example.com
    tls:
      secretName: pinniped-supervisor-tls-cert
  routes:
  - services:
    - name: pinniped-supervisor
      port: 8443
```

### Create Pinniped-Supervisor configuration

Create a FederationDomain to link the concierge to the supervisor instance and configure an OIDCIdentityProvider to connect the supervisor to your OIDC Provider. In the example below we use auth0. See the [pinniped how-to guides](https://pinniped.dev/docs/howto/) to learn how to configure different identity providers, including OKTA, GitLab, OpenLDAP, Dex, Microsoft AD and more.

You can do it by creating the following resources and save it into `workspace/pinniped-supervisor/oidc_identity_provider.yaml`.

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
  issuer: https://pinniped.supervisor.example.com
  tls:
    secretName: pinniped-supervisor-tls-cert
```

### Apply the resources

After creating the resource files we are now installing them into the cluster. We will deploy them as a [kapp application](https://carvel.dev/kapp/). 

1. Install the supervisor.
    ```
    kapp deploy -y --app pinniped-supervisor --into-ns pinniped-supervisor -f pinniped-supervisor -f https://get.pinniped.dev/v0.12.0/install-pinniped-supervisor.yaml
    ```
1. Get the external IP address of Ingress.
    ```
    kubectl -n tanzu-system-ingress get svc/envoy -o jsonpath='{.status.loadBalancer.ingress[0].ip}'
    ```
1. Bind the Ingress DNS to the IP address.
    ```
    *.supervisor.example.com A 35.222.xxx.yyy
    ```

## Install Pinniped Concierge

1. Deploy the pinniped concierge.
    ```
    kapp deploy -y --app pinniped-concierge \
      -f https://get.pinniped.dev/v0.12.0/install-pinniped-concierge-crds.yaml \
      -f https://get.pinniped.dev/v0.12.0/install-pinniped-concierge.yaml 
    ```
1. get the CA certificate of the supervisor.
    ```
    kubectl get secret pinniped-supervisor-ca-cert -n pinniped-supervisor  -o 'go-template={{index .data "tls.crt"}}'
    ```
1.  create the following resource to `workspace/pinniped-concierge/jwt_authenticator.yaml` and deploy it with:
    ```sh
    kapp deploy -y --app pinniped-concierge-jwt --into-ns pinniped-concierge -f pinniped-concierge/jwt_authenticator.yaml
    ```
    ```yaml
    ---
    apiVersion: authentication.concierge.pinniped.dev/v1alpha1
    kind: JWTAuthenticator
    metadata:
      name: pinniped-jwt-authenticator
    spec:
      issuer: https://pinniped.supervisor.example.com
      audience: concierge
      tls:
        certificateAuthorityData: # insert the CA certificate data here
    ```

## Login to the Cluster

1. get the kubeconfig from concierge.
    ```
    pinniped get kubeconfig --oidc-skip-listen --oidc-skip-browser --kubeconfig-context <your-kubeconfig-context>  > /tmp/concierge-kubeconfig
    ...
    "level"=0 "msg"="validated connection to the cluster"
    ```
1. Request resource and authenticate via OIDC. Run:
    ```
    k --kubeconfig /tmp/concierge-kubeconfig get pods
    ```
1. After this command pinniped prints a URL which you need to visit with your browser, log in, copy the auth code and paste it back to the terminal.
1. After a successful login you will either see the resources or a message that informs you that your user has no permission to access the resources. In this case you need to use the `kubectl` or the [`tanzu rbac`](binding.md) plugin to bind the user to a role.