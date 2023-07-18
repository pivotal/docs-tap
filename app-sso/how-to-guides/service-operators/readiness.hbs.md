# AuthServer readiness for AppSSO

This topic tells you how to use `AuthServer.status` as a reliable source to verify 
an `AuthServer`'s readiness for Application Single Sign-On (commonly called AppSSO). 

You can verify your `AuthServer` by ensuring:

- there is at least one token signing key configured.

    ```shell
    curl -X GET {spec.issuerURI}/oauth2/jwks
    ```

    The response body should yield at least one key in the list. If there are no keys,
    please [apply a token signing key](configure-token-signature.hbs.md)

- OpenID discovery endpoint is available.

    ```shell
    curl -X GET {spec.issuerURI}/.well-known/openid-configuration
    ```

    The response body should yield a valid JSON body containing information about the `AuthServer`.

## Client registration check

It is helpful to verify an `AuthServer` by running a test run with a test `ClientRegistration`. 
It ensures that app developers can register clients with the `AuthServer` successfully.

Follow the steps below to ensure that your installation can:

> 1. Add a test client.
> 2. Get an access token.
> 3. Invalidate/remove the test client.

### Prerequisites

Ensure that you have successfully [applied a token signing key](configure-token-signature.hbs.md) to your `AuthServer` before
proceeding.

### Define and apply a test client

Apply a `ClientRegistration` to your cluster in a Namespace that the `AuthServer` should allow clients from:

```yaml
---
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: ClientRegistration
metadata:
  name: test-client
  namespace: default
spec:
  authServerSelector:
    matchLabels:
    # appropriate labels for your `AuthServer`
  authorizationGrantTypes:
    - client_credentials
  clientAuthenticationMethod: client_secret_basic
```

See the [ClientRegistration API reference](../../reference/api/clientregistration.hbs.md) for more field definitions.

This defines a test `ClientRegistration` with the `client_credentials` OAuth grant type.

Apply the `ClientRegistration`:

```shell
kubectl apply -f appsso-test-client.yaml
```

Once the `ClientRegistration` is applied, inspects its status and verify it's ready.

### Get an access token

You should be able to get a token with the client credentials grant for example:

```shell
# Get client id (`base64` command has to be available on the command line)
export APPSSO_TEST_CLIENT_ID=$(kubectl get secret test-client -n default -o jsonpath="{.data['client-id']}" | base64 --decode)

# Get client secret (`base64` command has to be available on the command line)
export APPSSO_TEST_CLIENT_SECRET=$(kubectl get secret test-client -n default -o jsonpath="{.data['client-secret']}" | base64 --decode)

# Attempt to fetch access token
curl \
 --request POST \
 --location "{spec.issuerURI}/oauth2/token" \
 --header "Content-Type: application/x-www-form-urlencoded" \
 --header "Accept: application/json" \
 --data "grant_type=client_credentials" \
 --basic \
 --user $APPSSO_TEST_CLIENT_ID:$APPSSO_TEST_CLIENT_SECRET
```

You should see a response JSON containing populated field `access_token`. If so, the system is working as expected, and
client registration check is successful.

Make sure to delete the test `ClientRegistration` once you are done.
