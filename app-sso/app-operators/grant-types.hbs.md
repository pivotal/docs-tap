# Configure grant types

This topic tells you how to configure grant types for Application Single Sign-On 
(commonly called AppSSO).

Apps use grant types or flows to get an access token on behalf of a user. 
If not included, the default grant type is `['client_credentials']`. 
You must include these grant types in the `authorizationGrantTypes` property list 
in the [Client Registration](../crds/clientregistration.hbs.md).

To register a client/application, apply the `yaml` with your specifications to your cluster
`kubectl apply -f <path-to-your-yaml>`.

## Topics

- [Client Credentials Grant](#client-credentials-grant-type)
- [Authorization Code Grant](#authorization-code-grant-type)

### Client Credentials Grant Type

This grant type allows an application to get an access token for resources about the client itself, rather than a user.

Dynamic Client Registration (via `ClientRegistration` custom resource):

```yaml
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: ClientRegistration
metadata:
  name: <your client name>
spec:
  authorizationGrantTypes:
    - client_credentials
  # ...
```

> Ensure that you are able to retrieve a token through your setup

1. Apply your [ClientRegistration](../crds/clientregistration.md#example)

   ```shell
   kubectl apply -f <path-to-the-clientregistration-yaml>
   ```

2. Verify your `ClientRegistration` was created

   ```shell
   kubectl get clientregistrations
   ```

   --> you should see a `ClientRegistration` with the name you provided
3. Verify your Secret was created

   ```shell
   kubectl get secrets
   ```

   --> you should see a Secret with that same name you provided for the `ClientRegistration`
4. Get the client secret and decode it

   ```shell
   kubectl get secret <your-client-registration-name> -o jsonpath="{.data.client-secret}" | base64 -d
   ```

5. Get the client id (or get it from your configuration)

   ```shell
   kubectl get secret <your-client-registration-name> -o jsonpath="{.data.client-id}" | base64 -d
   ```

6. Request token

   ```shell
   curl -X POST <AUTH-DOMAIN>/oauth2/token?grant_type=client_credentials -v -u "YOUR_CLIENT_ID:DECODED_CLIENT_SECRET"
   ```

### Authorization Code Grant Type

This grant type allows clients to exchange this code for access tokens.

Dynamic Client Registration (via `ClientRegistration` custom resource):

```yaml
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: ClientRegistration
metadata:
  name: <your client name>
spec:
  authorizationGrantTypes:
    - authorization_code
  scopes:
     - openid
  # ...
```

> Ensure that you are able to retrieve a token through your setup

Ensure there is an Identity Provider configured

1. Get your authserver's label name

   ```shell
   kubectl get authserver sso4k8s -o jsonpath="{.metadata.labels.name}"
   ```

2. Apply this sample ClientRegistration ([read more about ClientRegistrations](../crds/clientregistration.md)

   The following is an example ClientRegistration that will work in this setup. The required scopes are `openid, email,
profile, roles`. The redirect URI here has been set to match that of `oauth2-proxy`.

   ```yaml
   apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
   kind: ClientRegistration
   metadata:
     name: oauth2-proxy-client
     namespace: <your-namespace>
   spec:
     authServerSelector:
     matchLabels:
       name: <your-authserver-label-name>
     authorizationGrantTypes:
       - client_credentials
       - authorization_code
     requireUserConsent: false
     redirectURIs:
       - http://127.0.0.1:4180/oauth2/callback
     scopes:
       - name: openid
       - name: email
       - name: profile
       - name: roles
   ```

   ```shell
   kubectl apply -f <path-to-the-clientregistration-yaml>
   ```

3. Verify your `ClientRegistration` was created

   ```shell
   kubectl get clientregistrations
   ```

   --> you should see a `ClientRegistration` with the name you provided
4. Verify your Secret was created

   ```shell
   kubectl get secrets
   ```

   --> you should see a Secret with that same name you provided for the `ClientRegistration`
5. Get the client secret and decode it

   ```shell
   CLIENT_SECRET=$(kubectl get secret <your-client-registration-name> -o jsonpath="{.data.client-secret}" | base64 -d)
   ```

6. Get the client id (or get it from your configuration)

   ```shell
   CLIENT_ID=$(kubectl get secret <your-client-registration-name> -o jsonpath="{.data.client-id}" | base64 -d)
   ```

7. Get the issuer uri

   ```shell
   ISSUER_URI=$(kubectl get secret <your-client-registration-name> -o jsonpath="{.data.issuer-uri}" | base64 -d)
   ```

8. Use the [oauth2-proxy](https://oauth2-proxy.github.io/oauth2-proxy/) to spin up a quick trial run of the configured
Authserver and run it with docker.

   ```shell
   docker run -p 4180:4180 --name oauth2-proxy bitnami/oauth2-proxy:latest \
   --oidc-issuer-url "$ISSUER_URI" \
   --client-id "$CLIENT_ID" \
   --insecure-oidc-skip-issuer-verification true \
   --client-secret "$CLIENT_SECRET" \
   --cookie-secret "0000000000000000" \
   --http-address "http://:4180" \
   --provider oidc \
   --scope "openid email profile roles" \
   --email-domain='*' \
   --insecure-oidc-allow-unverified-email true \
   --upstream "static://202" \
   --oidc-groups-claim "roles" \
   --oidc-email-claim "sub" \
   --redirect-url "http://127.0.0.1:4180/oauth2/callback"
   ```

   >**Note** Ensure that your issuer URL does not resolve to `127.0.0.1`.

9. Check your browser at `127.0.0.1:4180` to see if your configuration allows you to sign in.

   You should see a message that says "Authenticated".
