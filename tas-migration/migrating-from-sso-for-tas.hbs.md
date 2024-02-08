# Migrating from Single Sign-On for VMware Tanzu Application Service

Application Single Sign-On for VMware Tanzu® (AppSSO) provides single-sign on services for VMware Tanzu Application
Platform (TAP).
A similar product exists for VMwate Tanzu Application Service (TAS):
[Single Sign-On for VMware Tanzu Application Service](https://docs.vmware.com/en/Single-Sign-On-for-VMware-Tanzu-Application-Service/1.14/sso/GUID-index.html)

This guide describes migration paths from TAS to TAP for single-sign on services.

## Concepts in both products

| SSO for TAS                                                                                                                                           | AppSSO for TAP                                                                                                                                                                 | Comments                                                                                                                                                                                                                                                                                                                                                                 |
|-------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [Service Plan](https://docs.vmware.com/en/Single-Sign-On-for-VMware-Tanzu-Application-Service/1.14/sso/GUID-manage-service-plans.html)                | `AuthServer` and `ClusterWorkloadRegistrationClass`                                                                                                                            | In TAS' UAA, this is an "Identity Zone". [AuthServer docs](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.7/tap/app-sso-how-to-guides-service-operators-index.html). [ClusterWorkloadRegistrationClass docs](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.7/tap/app-sso-how-to-guides-service-operators-curate-service-offering.html). |
| [System Plan](https://docs.vmware.com/en/Single-Sign-On-for-VMware-Tanzu-Application-Service/1.14/sso/GUID-system-plan.html)                          | n/a                                                                                                                                                                            | This is the special "tenant" in the UAA for platform access                                                                                                                                                                                                                                                                                                              |
| [Internal user store](https://docs.vmware.com/en/Single-Sign-On-for-VMware-Tanzu-Application-Service/1.14/sso/GUID-configure-internal-us.html)        | n/a                                                                                                                                                                            | AppSSO does not support internal users (see next section). Note that `AuthServer.spec.identityProviders.internalUnsafe` is for testing purposes                                                                                                                                                                                                                          |
| [External Identity Provider](https://docs.vmware.com/en/Single-Sign-On-for-VMware-Tanzu-Application-Service/1.14/sso/GUID-configure-external-id.html) | `AuthServer.spec.identityProviders`                                                                                                                                            | [spec.identityProviders docs](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.7/tap/app-sso-how-to-guides-service-operators-identity-providers.html)                                                                                                                                                                                                      |
| Operator dashboard                                                                                                                                    | `AuthServer` Custom Resource                                                                                                                                                   | Operators (or Service Operators) interact with AppSSO through the `AuthServer` custom resource                                                                                                                                                                                                                                                                           |
| [Developer dashboard](https://docs.vmware.com/en/Single-Sign-On-for-VMware-Tanzu-Application-Service/1.14/sso/GUID-config-apps.html)                  | `ClientRegistration` Custom Resource                                                                                                                                           | Developers (or App Operators) interact with AppSSO through the `ClientRegistration` resource ([docs](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.7/tap/app-sso-reference-api-clientregistration.html))                                                                                                                                                |
| [Resources](https://docs.vmware.com/en/Single-Sign-On-for-VMware-Tanzu-Application-Service/1.14/sso/GUID-manage-resources.html)                       | n/a                                                                                                                                                                            | "Resources" map to OAuth2 scopes, and are tied to a CF space. AppSSO does not support the concept or "resource" (see next section)                                                                                                                                                                                                                                       |
| Application                                                                                                                                           | Workload                                                                                                                                                                       | This is not AppSSO specific, but applicable to all of TAS and  TAP                                                                                                                                                                                                                                                                                                       |
| Service Instance                                                                                                                                      | n/a                                                                                                                                                                            | This is SSO for TAS' way of making a Service Plan visible in a Cloud Foundry Space. There are no direct equivalents in AppSSO                                                                                                                                                                                                                                            |
| [Service Binding](https://docs.vmware.com/en/Single-Sign-On-for-VMware-Tanzu-Application-Service/1.14/sso/GUID-config-apps.html)                      | [Service Claim](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.7/tap/app-sso-how-to-guides-app-operators-claim-credentials.html) through `ClassClaim` resource | Bind an "app" to a "service", creating credentials for this app and injecting those credentials. In TAS, this is done through the VCAP_SERVICES env var. In TAP, through k8s Service Bindings. AppSSO creates a `ClientRegistration` in the background, and a `Secret` holding the credentials.                                                                          |
| Service Key                                                                                                                                           | `ClientRegistration` resource                                                                                                                                                  | AppSSO generates a `Secret` for the given `ClientRegistration`                                                                                                                                                                                                                                                                                                           |
| UAA (one per CF foundation)                                                                                                                           | The running `AuthServer` Deployment. One per `AuthServer` resource == one per “Service Plan” == one per Identity Zone.                                                         | The UAA is multi-tenant. The AuthServer is single-tenant, and one AuthServer is used per UAA tenant                                                                                                                                                                                                                                                                      |

## Unsupported features in AppSSO for TAP

Some features from SSO for TAS are not supported in SSO for TAP:

- [UAA Internal user store](https://docs.vmware.com/en/Single-Sign-On-for-VMware-Tanzu-Application-Service/1.14/sso/GUID-configure-internal-us.html):
  AppSSO does not support creating and managing users in an internal user database.
- [SAML identity providers](https://docs.vmware.com/en/Single-Sign-On-for-VMware-Tanzu-Application-Service/1.14/sso/GUID-configure-external-id.html#add-a-saml-provider-1):
  AppSSO does not support SAML external identity providers. It only supports OpenID Connect and LDAP.
- [User management](https://docs.vmware.com/en/Single-Sign-On-for-VMware-Tanzu-Application-Service/1.14/sso/GUID-manage-users.html):
  AppSSO does not support managing individual users. In SSO for TAS, users from an external Identity Provider are synced
  to the user database when they first log in. Permissions (scopes) can be assigned to each user. This is not possible
  in AppSSO, all scopes come
  from [roles to scopes mapping](service-operators/configure-authorization.hbs.md#individual-roles).
  Users cannot manage their own accounts in AppSSO. When allowed, they can manage their account in the External Identity
  Provider.
- Single-log out: AppSSO does not support single-log out.
- OAuth2 grant types: as
  per [OAuth 2 Security best practices](https://datatracker.ietf.org/doc/html/draft-ietf-oauth-security-topics-24#name-best-practices),
  AppSSO does not support the `password` or `implicit` grant types. Consider migrating your
  application to the `authorization_code` grant type.
- Selective auto-approval of scopes: a Client may require consent, or not require it, but it applies to all scopes
  except `openid`.
- ["Resource" management](https://docs.vmware.com/en/Single-Sign-On-for-VMware-Tanzu-Application-Service/1.14/sso/GUID-manage-resources.html):
  there is no concept of "permissions" or "resources" in AppSSO, only OAuth2 scopes.
    - In SSO for TAS, operators manage which scopes are available for a given Service Plan in a given
      Space, [through the
      Developer Dashboard](https://docs.vmware.com/en/Single-Sign-On-for-VMware-Tanzu-Application-Service/1.14/sso/GUID-manage-resources.html).
      When an App is bound through a Service Binding, an OAuth2 Client is created for that App in
      UAA. The Client is only allowed to request scopes that match the “permissions” that were pre-configured by
      operators.
    - In AppSSO, when the Developer creates a `ClientRegistration` or a `ClassClaim`, they can specify any OAuth2 scope
      they want available. Note that roles to manage are aggregated in
      the [TAP well-known roles](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.7/tap/app-sso-reference-rbac.html)
- Unsecured LDAP. LDAP traffic must happen over TLS, using the `ldaps://` protocol.

## Migration pre-requisites

The migration scripts here use:

- [ytt](https://carvel.dev/ytt/) for templating kubernetes resources
- [uaac](https://github.com/cloudfoundry/cf-uaac) for extracting data from the UAA
- python 3.9+ for migrating data
- several utilities, such as kubectl, jq, etc

You will need to create
an [UAA Admin client](https://docs.vmware.com/en/Single-Sign-On-for-VMware-Tanzu-Application-Service/1.14/sso/GUID-manage-clients-api.html#creating)
first.

## Migrating Service Plans to AuthServer custom resources

First, locate your service plan. You may list all service plans by subdomain with:

```bash
uaac curl "/identity-zones" -b | jq -r ".[].subdomain"
export SUBDOMAIN=<your-subdomain>
```

### Identity-Zone level configuration

The only configurable entries that have an equivalent in the `AuthServer` spec are:

1. Token expiration times
2. CORS configuration

By default, they are configured in the UAA Service Plan, and can be overridden in each individual plan.

In the `AuthServer` definition, there are default values as well. Unless you wish to port the settings exactly as-is,
you may skip this section entirely.

### CORS configuration

CORS configuration can be found under `config.corsPolicy` in the UAA, like so:

```bash
uaac curl "/identity-zones" -b | jq ".[] | select(.subdomain == \"$SUBDOMAIN\") | .config.corsPolicy"
```

Values may be ported into AppSSO's AuthServer through `AuthServer.spec.cors`, see the [official
documentation](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.7/tap/app-sso-how-to-guides-service-operators-cors.html),
or the API docs with `kubectl explain AuthServer.spec.cors`.

### Token configuration

Token configuration can be found under `config.tokenPolicy` in the UAA, like so:

```bash
uaac curl "/identity-zones" -b | jq ".[] | select(.subdomain == \"$SUBDOMAIN\") | .config.tokenPolicy"
```

It is possible that the fields are null or equal to -1. This means they are configured at the UAA level. In that case
you can obtain the configuration with:

```bash
uaac curl "/identity-zones" -b | jq ".[] | select(.subdomain == \"\") | .config.tokenPolicy"
```

Values may be ported into AppSSO's AuthServer through `AuthServer.spec.token`, see the [official
documentation](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.7/tap/app-sso-how-to-guides-service-operators-token-settings.html),
or the API docs with `kubectl explain AuthServer.spec.token`.

### Migrating Identity Providers

Most of the configuration for identity providers of type OIDC or LDAP can be ported automatically.

First, using `uaac`, login into the UAA and get a token for the admin client.

Then, copy the UAA url and the access token. They can be found with `uaac context`:

```
$ uaac context

[1]*[➡️ UAA_URL]

  [0]*[...]
      client_id: ...
      access_token: ➡️ ACCESS_TOKEN
      token_type: ...
      expires_in: ...
      scope: ...
      jti: ...
```

Using those, and the `SUBDOMAIN` you captured earlier, you can run the script below. Save it to `migration.py`:

```python
#!/usr/bin/env python3

import getopt
import json
import sys
from urllib.request import Request, urlopen


def transform_ldap_providers(providers, external_group_mappings=[]):
    def to_ldap(provider):
        config = provider["config"]
        result = {
            "name": "ldap",
            "ldap": {
                "url": config["baseUrl"],
                "bind": {
                    "dn": config["bindUserDn"],
                    "passwordRef": {"name": "ldap-password"},
                },
                "user": {
                    "searchBase": config["userSearchBase"],
                    "searchFilter": config["userSearchFilter"],
                },
            },
        }

        roles_config = __extract_ldap_roles_config(config)
        if roles_config:
            result["ldap"]["roles"] = roles_config

        id_token_config = __extract_id_token_config(config)
        if id_token_config:
            result["ldap"]["idToken"] = id_token_config
        access_token_config = __extract_access_token_config(
            provider["originKey"], external_group_mappings
        )
        if access_token_config:
            result["ldap"]["accessToken"] = access_token_config

        return result

    return [to_ldap(provider) for provider in providers if provider["type"] == "ldap"]


def transform_openid_providers(providers, external_group_mappings=[]):
    """
    Transform UAA openID providers identity providers into
    AuthServer.spec.identityProviders.openID
    """

    def to_openid(provider):
        """
        Map an individual provider
        """
        config = provider["config"]
        result = {
            "name": provider["originKey"],
            "openID": {
                "clientID": config["relyingPartyId"],
                "scopes": config["scopes"],
                "displayName": config["providerDescription"],
                "clientSecretRef": {"name": provider["originKey"] + "-credentials"},
            },
        }
        openId = result["openID"]
        if config["discoveryUrl"] is not None:
            openId["configurationURI"] = config["discoveryUrl"]
        if config["authUrl"] is not None:
            openId["authorizationUri"] = config["authUrl"]
        if config["tokenUrl"] is not None:
            openId["tokenUri"] = config["tokenUrl"]
        if config["userInfoUrl"] is not None:
            openId["userinfoUri"] = config["userInfoUrl"]
        if config["tokenKeyUrl"] is not None:
            openId["jwksUri"] = config["tokenKeyUrl"]

        roles_config = __extract_openid_roles_config(config)
        if roles_config:
            openId["roles"] = roles_config

        id_token_config = __extract_id_token_config(config)
        if id_token_config:
            openId["idToken"] = id_token_config

        access_token_config = __extract_access_token_config(
            provider["originKey"], external_group_mappings
        )
        if access_token_config:
            openId["accessToken"] = access_token_config

        return result

    return [to_openid(p) for p in providers if p["type"] == "oidc1.0"]


def __extract_group_filters(config):
    def to_group_filter(group):
        """
        Helper function for filters
        """
        if "*" in group:
            return {"regex": group.replace("*", ".*")}
        else:
            return {"exactMatch": group}

    if (
        config["externalGroupsWhitelist"] == ["*"]
        or not config["externalGroupsWhitelist"]
    ):
        return None
    return [to_group_filter(group) for group in config["externalGroupsWhitelist"]]


def __extract_openid_roles_config(config):
    """
    Extracts the UAA external groups and filtering rules,
    and modify them to match AuthServer.spec.identityProviders.openID.roles
    """
    if "external_groups" not in config["attributeMappings"]:
        return None
    result = {"fromUpstream": {"claim": config["attributeMappings"]["external_groups"]}}
    group_filter = __extract_group_filters(config)
    if group_filter:
        result["filterBy"] = group_filter

    return result


def __extract_ldap_roles_config(config):
    if not config["groupSearchBase"]:
        return None
    if config["groupSearchBase"] == "memberOf":
        return {"fromUpstream": {"attribute": "memberOf"}}

    result = {
        "fromUpstream": {
            "search": {
                "base": config["groupSearchBase"],
                "filter": config["groupSearchFilter"],
            },
        }
    }
    group_filter = __extract_group_filters(config)
    if group_filter:
        result["filterBy"] = group_filter

    return result


def __extract_id_token_config(config):
    """
    Extracts the UAA attributes mapping, and modify them
    to match AuthServer.spec.identityProviders.*.idToken
    """
    claims_mapping = [
        {"toClaim": key.replace("user.attribute.", ""), "fromUpstream": value}
        for key, value in config["attributeMappings"].items()
        if key.startswith("user.attribute")
    ]
    if len(claims_mapping) == 0:
        return None

    return {"claims": claims_mapping}


def __extract_access_token_config(originKey, group_mappings):
    """
    Filter the UAA /Groups/External by Identity Provider "originKey",
    group them by "external group name", and merge them into
    AuthServer.spec.identityProviders.*.accessToken
    """
    roles_to_groups = {}
    for mapping in group_mappings:
        if mapping["origin"] != originKey:
            continue
        external_group = mapping["externalGroup"]
        if not external_group in roles_to_groups:
            roles_to_groups[external_group] = {
                "fromRole": external_group,
                "toScopes": [],
            }
        roles_to_groups[external_group]["toScopes"].append(mapping["displayName"])
    if len(roles_to_groups) == 0:
        return None
    return {"scope": {"rolesToScopes": list(roles_to_groups.values())}}


class UaaClient:
    def __init__(self, url, token, subdomain):
        self.url = url
        self.token = token
        self.subdomain = subdomain

    def get_idp(self):
        r = Request(
            f"{self.url}/identity-providers?rawConfig=true",
            headers={
                "Authorization": f"Bearer {self.token}",
                "X-Identity-Zone-Subdomain": self.subdomain,
            },
        )
        with urlopen(r) as response:
            return json.loads(response.read())

    def get_groups(self):
        r = Request(
            f"{self.url}/Groups/External?count=500",
            headers={
                "Authorization": f"Bearer {self.token}",
                "X-Identity-Zone-Subdomain": self.subdomain,
            },
        )
        with urlopen(r) as response:
            return json.loads(response.read())["resources"]


def extract_cli_args(argv):
    subdomain = None
    token = None
    url = None
    try:
        opts, _ = getopt.getopt(argv[1:], "hu:s:t:", ["url=", "subdomain=", "token="])
    except getopt.GetoptError:
        print("idzone-to-authserver.py -u <uaa url> -t <uaa token> -s <subdomain>")
        sys.exit(2)
    for opt, arg in opts:
        if opt == "-h":
            print("idzone-to-authserver.py -u <uaa url> -t <uaa token> -s <subdomain>")
            sys.exit()
        elif opt in ("-s", "--subdomain"):
            subdomain = arg
        elif opt in ("-t", "--token"):
            token = arg
        elif opt in ("-u", "--url"):
            url = arg
    return url, token, subdomain


if __name__ == "__main__":
    uaa = UaaClient(*extract_cli_args(sys.argv))
    uaa_idps = uaa.get_idp()
    uaa_groups = uaa.get_groups()
    idps = [
        *transform_openid_providers(uaa_idps, uaa_groups),
        *transform_ldap_providers(uaa_idps, uaa_groups),
    ]
    print(json.dumps(idps))
```

This command can be run with:

```bash
python3 migration.py -u $UAA_URL -t $TOKEN -s $SUBDOMAIN
```

This output is a JSON structure that can be templated into an AuthServer, for example using YTT. It is almost sufficient
to have a running authorization server with identity providers migrated. Given the following structure:

```yaml
#@ load("@ytt:data", "data")
---
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: AuthServer
metadata:
  name: MY-AUTH-SERVER
  namespace: MY-NAMESPACE
  labels:
    name: MY-AUTH-SERVER
spec:
  #! Token signature keys are a managed in the UAA Config, not accessible through
  #! the API. These are UAA-level config options, not id-zone level.
  #! The signing key is REQUIRED.
  tokenSignature:
    signAndVerifyKeyRef:
      name: my-token-signing-key
  identityProviders: #@ data.values.identityProviders

  #! All other properties omitted, they are not REQUIRED to function, but you MAY update them.

---
apiVersion: secretgen.k14s.io/v1alpha1
kind: RSAKey
metadata:
  name: my-token-signing-key
  namespace: MY-NAMESPACE
spec:
  secretTemplate:
    type: Opaque
    stringData:
      key.pem: $(privateKey)
      pub.pem: $(publicKey)
```

You can chain the migration script into YTT and obtain an `AuthServer` configuration, e.g. through:

```bash
ytt \
  --data-value-yaml identityProviders="$(python3 migration.py -u "$UAA_URL" -s "$SUBDOMAIN" -t "$ACCESS_TOKEN")" \
  --file authserver-template.yaml
```

There will be one piece of information missing: the credentials for connecting to the upstream identity providers (bind
password for LDAP, client_secret for OIDC). You will need to add those in manually, as the UAA does not expose those
secrets. You may need to re-create similar OIDC clients; or update your existing OIDC clients, to add the AuthServer
redirect uris. Please refer to the [official documentation]() to find out about configuration properties for AppSSO
identity providers. The Secrets have the following format:

```yaml
#! If there is an identity provider of type LDAP
---
apiVersion: v1
kind: Secret
metadata:
  name: ldap-password
  namespace: MY-NAMESPACE
stringData:
  password: MY-PASSWORD

#! One secret per openID identity provider ; must match clientSecretRef.name
---
apiVersion: v1
kind: Secret
metadata:
  name: MY-OIDC-IDENTITY-PROVIDER
  namespace: MY-NAMESPACE
stringData:
  clientSecret: MY-CLIENT-SECRET
```

## Migrating Service Bindings, Service Keys, and "SSO Applications"

Migrating OAuth2 Clients (Service Bindings, Service Keys, Applications created in the SSO dashboard) is more difficult
to automate, as the configuration model is quite different. It is likely that the domains in the clients `redirect_uri`s
will differ from platform to platform.

The recommended approach to use Service Bindings in TAP is to use an AppSSO `ClassClaim`, see
the [official documentation](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.7/tap/app-sso-how-to-guides-app-operators-claim-credentials.html).
The `ClassClaim` is bound to a workload, but a UAA client is not bound to anything the UAA, only through a layer in CF
itself.

For Service Keys or Applications created in the dashboard, the usual use-case is to copy the credentials returned in the
“create service key” call, and then use them elsewhere (either in CF apps or even off-platform). For those use-cases,
you may want to use a `ClientRegistration` instead of a `ClassClaim`,
see  [official documentation](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.7/tap/app-sso-reference-api-clientregistration.html)

This can be automated to some degree, but will require manual intervention. You can list all clients for your Identity
Zone using the following command:

```bash
uaac curl "/oauth/clients" -H"X-Identity-Zone-Subdomain: $SUBDOMAIN" -b |
  jq ".resources | map(
{
  apiVersion: \"services.apps.tanzu.vmware.com/v1alpha1\",
  kind: \"ClientRegistration\",
  metadata: {
    name: .name,
    namespace: \"PLACEHOLDER\",
  },
  spec: {
    authServerSelector: {
      matchLabels: {
        PLACEHOLDER: \"PLACEHOLDER\",
      },
    },
    redirectUris: .redirect_uri,
    scopes: .scope | map({name: .}),
    authorization_grant_types: .authorized_grant_types,
  }
})
"
```

Provided that you have stored this command in `get-clients.sh`, and you save the following
to `client-registration-template.yaml`:

```yaml
#@ load("@ytt:data", "data")
#@ load("@ytt:template", "template")

#@ for client in data.values.clients:
---
_: #@ template.replace(client)
#@ end
```

Then you can use YTT to convert clients into placeholders for `ClientRegistration`s like so:

```bash
ytt -f client-registration-template.yaml --data-value-yaml clients="$(./get-clients.sh)" 
```

### Service-to-Service flows

In SSO for TAS, some applications can be registered to use a Service-to-Service flow. This corresponds to the OAuth2
`client_credentials` grant, where no human interaction is required to obtain tokens.

In this case, you must use a `ClientRegistration` as showcased in the section above, with
`ClientRegistration.spec.authorizationGrantTypes=["client_credentials"]` . The resulting client id and client secret can
be used just like a Service-to-Service app would use them in TAP.

When creating a `ClientRegistration` name “example-cr”, a corresponding Kubernetes `Secret` will be created in the same
namespace, with name “example-cr”. Credentials are in this secret, in the fields `client-id` and `client-secret`.

### Spring Boot application

Spring Boot applications deployed to TAS likely use the [java-cfenv](https://github.com/pivotal-cf/java-cfenv) library
to read service bindings data from `VCAP_SERVICES`. In TAP, `java-cfenv` is not applicable. You may remove it from your
dependencies.

If your Spring Boot app is built using buildpacks, such as with Tanzu Build Service, TAP Supply Chains, or Spring Boot
maven or gradle plugins, [Spring Cloud Bindings](https://github.com/spring-cloud/spring-cloud-bindings/) will be added
to your path and should do the binding automatically -
see [official documentation](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.7/tap/app-sso-how-to-guides-app-operators-secure-spring-boot-workload.html).
For this to work, it is recommended your application uses Spring Boot 2.7, so
that `ClientRegistration.spec.client_authentication_method` maps to a value known to Spring Boot (`client_secret_basic`
or `client_secret_post`). Older versions of Spring Boot expect the value to be either `basic` or `post`.

If you cannot or do not wish to rely on Spring Cloud Bindings, please follow the guidance from
the [official documentation](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.7/tap/app-sso-how-to-guides-app-operators-secure-workload.html)
explaining how credentials are exposed to the underlying application.
