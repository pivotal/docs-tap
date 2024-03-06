# Migrate from Single Sign-On for VMware Tanzu Application Service

This topic tells you how to migrate single-sign on services from Tanzu Application Service (TAS) to Tanzu Application
Platform (TAP).

Application Single Sign-On for VMware Tanzu provides single sign-on services for VMware Tanzu Application
Platform. There is a comparable offering available for VMwate Tanzu Application Service. 
For more information, see the [Single Sign-On for VMware Tanzu Application Service documentation](https://docs.vmware.com/en/Single-Sign-On-for-VMware-Tanzu-Application-Service/1.14/sso/GUID-index.html).

## <a id="concept"></a> Concept comparison

The following table outlines the essential concepts, highlighting the key differences between Single Sign-On for VMware Tanzu Application Service (SSO for TAS) and Application Single Sign-On for VMware Tanzu Application
Platform (AppSSO for TAP).

| SSO for TAS                                                                                                                                           | AppSSO for TAP                                                                                                                                                                 | Notes                                                                                                                                                                                                                                                                                                                                                                 |
|-------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [Service Plan](https://docs.vmware.com/en/Single-Sign-On-for-VMware-Tanzu-Application-Service/1.14/sso/GUID-manage-service-plans.html)                | `AuthServer` and `ClusterWorkloadRegistrationClass`                                                                                                                            | In TAS User Account and Authentication (UAA), this corresponds to an Identity Zone. For more information, see [Curate a service offering](../app-sso/how-to-guides/service-operators/curate-service-offering.hbs.md). |
| [System Plan](https://docs.vmware.com/en/Single-Sign-On-for-VMware-Tanzu-Application-Service/1.14/sso/GUID-system-plan.html)                          | n/a                                                                                                                                                                            | This represents the special tenant in the UAA for platform access.                                                                                                                                                                                                                                                                                                              |
| [Internal user store](https://docs.vmware.com/en/Single-Sign-On-for-VMware-Tanzu-Application-Service/1.14/sso/GUID-configure-internal-us.html)        | n/a                                                                                                                                                                            | AppSSO does not support internal users. For more information, see [Unsupported features](#unsupported). `AuthServer.spec.identityProviders.internalUnsafe` is for testing purposes.                                                                                                                                                                                                                          |
| [External Identity Provider](https://docs.vmware.com/en/Single-Sign-On-for-VMware-Tanzu-Application-Service/1.14/sso/GUID-configure-external-id.html) | `AuthServer.spec.identityProviders`                                                                                                                                            | For more information, see [Identity providers for AppSSO](../app-sso/how-to-guides/service-operators/identity-providers.hbs.md).                                                                                                                                                                                                      |
| Operator dashboard                                                                                                                                    | `AuthServer` Custom Resource                                                                                                                                                   | Operators or Service Operators interact with AppSSO by using the `AuthServer` custom resource.                                                                                                                                                                                                                                                                           |
| [Developer dashboard](https://docs.vmware.com/en/Single-Sign-On-for-VMware-Tanzu-Application-Service/1.14/sso/GUID-config-apps.html)                  | `ClientRegistration` Custom Resource                                                                                                                                           | Developers or App Operators interact with AppSSO by using the `ClientRegistration` resource. For more information, see [ClientRegistration API for AppSSO](../app-sso/reference/api/clientregistration.hbs.md).                                                                                                                                               |
| [Resources](https://docs.vmware.com/en/Single-Sign-On-for-VMware-Tanzu-Application-Service/1.14/sso/GUID-manage-resources.html)                       | n/a                                                                                                                                                                            | Resources map to OAuth2 scopes and are tied to a Cloud Foundry space. AppSSO does not support the concept of resource. For more information, see [Unsupported features](#unsupported).                                                                                                                                                                                                                                       |
| Application                                                                                                                                           | Workload                                                                                                                                                                       | This is not AppSSO specific but applicable to both TAS and  TAP                                                                                                                                                                                                                                                                                                       |
| Service Instance                                                                                                                                      | n/a                                                                                                                                                                            | In SSO for TAS, this is the way of making a Service Plan visible in a Cloud Foundry Space. There are no direct equivalents in AppSSO.                                                                                                                                                                                                                                            |
| [Service Binding](https://docs.vmware.com/en/Single-Sign-On-for-VMware-Tanzu-Application-Service/1.14/sso/GUID-config-apps.html)                      | [Service Claim](../app-sso/how-to-guides/app-operators/claim-credentials.hbs.md) by using the `ClassClaim` resource | Service Binding binds an app to a service, creating credentials for this app and injecting those credentials. In Tanzu Application Service, this is done by using the `VCAP_SERVICES` environment variable. In Tanzu Application Platform, this is done by using Kubernetes Service Bindings. AppSSO creates a `ClientRegistration` in the background and a `Secret` holding the credentials.                                                                          |
| Service Key                                                                                                                                           | `ClientRegistration` resource                                                                                                                                                  | AppSSO generates a `Secret` for the given `ClientRegistration`.                                                                                                                                                                                                                                                                                                           |
| UAA (one per Cloud Foundry foundation)                                                                                                                           | The running `AuthServer` Deployment. One per `AuthServer` resource means one per “Service Plan” or one per Identity Zone.                                                         | The UAA is multi-tenant. The `AuthServer` is single-tenant, and one `AuthServer` is used per UAA tenant.                                                                                                                                                                                                                                                                   |

## <a id="unsupported"></a> Unsupported features

The following features available in Single Sign-On for VMware Tanzu Application Service (SSO for TAS) are not supported in Application Single Sign-On for VMware Tanzu Application Platform (AppSSO for TAP):

- [UAA Internal user store](https://docs.vmware.com/en/Single-Sign-On-for-VMware-Tanzu-Application-Service/1.14/sso/GUID-configure-internal-us.html):

    AppSSO does not support creating and managing users in an internal user database.

- [Security Assertion Markup Language (SAML) identity providers](https://docs.vmware.com/en/Single-Sign-On-for-VMware-Tanzu-Application-Service/1.14/sso/GUID-configure-external-id.html#add-a-saml-provider-1):

    AppSSO does not support SAML external identity providers. It only supports OpenID Connect and Lightweight Directory Access Protocol (LDAP).

- [User management](https://docs.vmware.com/en/Single-Sign-On-for-VMware-Tanzu-Application-Service/1.14/sso/GUID-manage-users.html):

    AppSSO does not support managing individual users. In SSO for TAS, users from an external Identity Provider are synchronized to the user database when they first log in. Permissions or scopes can be assigned to each user. This is not supported in AppSSO, all scopes come from roles to scopes mapping. For more information, see [Mapping individual roles into authorization scopes](../app-sso/how-to-guides/service-operators/configure-authorization.hbs.md#individual-roles).

    Users cannot manage their own accounts in AppSSO. When allowed, they can manage their accounts in the External Identity Provider.

- Single logout: 

    AppSSO does not support single logout.

- OAuth2 grant types: 

    According to [OAuth 2 Security best practices](https://datatracker.ietf.org/doc/html/draft-ietf-oauth-security-topics-24#name-best-practices), AppSSO does not support the `password` or `implicit` grant types. You can migrate  your application to the `authorization_code` grant type.

- Selective auto-approval of scopes: 

    Consent is optional for all scopes except `openid`.

- [Resource management](https://docs.vmware.com/en/Single-Sign-On-for-VMware-Tanzu-Application-Service/1.14/sso/GUID-manage-resources.html):

    AppSSO operates solely on OAuth2 scopes, without using the concepts of permissions or resources.

    - In SSO for TAS, Operators control the availability of scopes for a specific Service Plan in a space using the Developer Dashboard. For more information, see the [Single Sign-On for VMware Tanzu Application Service documentation](https://docs.vmware.com/en/Single-Sign-On-for-VMware-Tanzu-Application-Service/1.14/sso/GUID-manage-resources.html). 

        When an app is bound by using a Service Binding, an OAuth2 Client is created for that app in User Account and Authentication (UAA). The client can only request scopes that match the permissions pre-configured by operators.
      
    - In AppSSO, Developers can specify OAuth2 scopes when creating a `ClientRegistration` or a `ClassClaim`, with role management aggregated in the well-known roles of the Tanzu Application Platform. For more information, see [RBAC for AppSSO](../app-sso/reference/rbac.hbs.md).

- Unsecured Lightweight Directory Access Protocol (LDAP): 

    LDAP traffic must be secured with TLS by using the `ldaps://` protocol.

## <a id="prereqs"></a> Migration pre-requisites

The migration scripts use:

- [ytt](https://carvel.dev/ytt/) for templating Kubernetes resources.
- [uaac](https://github.com/cloudfoundry/cf-uaac) for extracting data from the UAA.
- python v3.9 and later for migrating data.
- several utilities, such as kubectl and jq.

If you do not already have an admin client for your UAA Identity Zone, you must create an UAA Admin client first. 
For more information, see the [Single Sign-On for VMware Tanzu Application Service documentation](https://docs.vmware.com/en/Single-Sign-On-for-VMware-Tanzu-Application-Service/1.14/sso/GUID-manage-clients-api.html#creating)

## <a id="service-plans"></a> Migrate Service Plans to AuthServer custom resources

List all service plans by subdomain:

```bash
uaac curl "/identity-zones" -b | jq -r ".[].subdomain"
export SUBDOMAIN=<your-subdomain>
```

### <a id="identity-zone-config"></a> Identity-zone level configuration

The `AuthServer` specification only includes equivalents for the following configurable entries:

- Token expiration times.
- Cross-origin resource sharing (CORS) configuration.

By default, they are configured in the UAA Service Plan, and can be overridden in each individual plan.

The AuthServer definition includes default values. You can skip this section if you don't want to replicate the exact  settings.

### <a id="cors-config"></a> Cross-origin resource sharing (CORS) configuration

Cross-origin resource sharing (CORS) configuration is available under `config.corsPolicy` in the UAA as follows:

```bash
uaac curl "/identity-zones" -b | jq ".[] | select(.subdomain == \"$SUBDOMAIN\") | .config.corsPolicy"
```

You can port the values into AppSSO's `AuthServer` by using `AuthServer.spec.cors`. 
For more information, see [Public clients and CORS for AppSSO](../app-sso/how-to-guides/service-operators/cors.hbs.md),
or the `kubectl explain AuthServer.spec.cors` API documentation.

### <a id="token-config"></a> Token configuration

Token configuration is available under `config.tokenPolicy` in the UAA as follows:

```bash
uaac curl "/identity-zones" -b | jq ".[] | select(.subdomain == \"$SUBDOMAIN\") | .config.tokenPolicy"
```

Fields can be `null` or equal to `-1`, indicating configuration at the UAA level. In such cases, you can retrieve the configuration by using:

```bash
uaac curl "/identity-zones" -b | jq ".[] | select(.subdomain == \"\") | .config.tokenPolicy"
```

You can port the values into AppSSO's `AuthServer` by using `AuthServer.spec.token`. 
For more information, see [Token settings for Application Single Sign-On](../app-sso/how-to-guides/service-operators/token-settings.hbs.md), or the `kubectl explain AuthServer.spec.token` API documentation.

### <a id="identity-providers"></a> Migrate Identity Providers

Most of the configuration for OpenID Connect (OIDC) or LDAP-type identity providers can be ported automatically.

1. Log into the UAA and get a token for the admin client by using `uaac`.

1. Copy the UAA URL and the access token from `uaac context`:

    ```console
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

1. Save the following script as `migration.py`. 

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

1. Run the script with the UAA URL, access token, and the previously captured `SUBDOMAIN`.

    ```bash
    python3 migration.py -u $UAA_URL -t $TOKEN -s $SUBDOMAIN
    ```

    The following JSON output can be templated into an `AuthServer` by using tools such as YTT. This structure is nearly complete for establishing a functioning authorization server with migrated identity providers.

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
      #! Token signature keys are managed in the UAA Config and not accessible through
      #! the API. These are UAA-level, not id-zone level config options.
      #! The signing key is required.
      tokenSignature:
        signAndVerifyKeyRef:
          name: my-token-signing-key
      identityProviders: #@ data.values.identityProviders

      #! All other properties are omitted, because they are optional. You can update them as needed.

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

1. Chain the migration script into YTT and obtain an `AuthServer` configuration.

    ```bash
    ytt \
      --data-value-yaml identityProviders="$(python3 migration.py -u "$UAA_URL" -s "$SUBDOMAIN" -t "$ACCESS_TOKEN")" \
      --file authserver-template.yaml
    ```

    You must manually input the credentials for connecting to the upstream identity providers, including the bind password for LDAP and the client secret for OIDC, because the UAA does not expose such secrets. You can either create new OIDC clients or edit existing ones to include the `AuthServer` redirect URIs. For more information about configuring properties for AppSSO identity providers, see [Identity providers for AppSSO](../app-sso/how-to-guides/service-operators/identity-providers.hbs.md). The secrets adhere to the following format:

    ```yaml
    #! For LDAP-type identity provider:
    ---
    apiVersion: v1
    kind: Secret
    metadata:
      name: ldap-password
      namespace: MY-NAMESPACE
    stringData:
      password: MY-PASSWORD

    #! One secret per openID identity provider and it must match clientSecretRef.name:
    ---
    apiVersion: v1
    kind: Secret
    metadata:
      name: MY-OIDC-IDENTITY-PROVIDER
      namespace: MY-NAMESPACE
    stringData:
      clientSecret: MY-CLIENT-SECRET
    ```

## <a id="migrate-misc"></a> Migrate OAuth2 Clients

Migrating OAuth2 Clients, including Service Bindings, Service Keys, Applications created in the SSO dashboard, are more difficult to automate, because the configuration model is very different. It is likely that the domains in the clients `redirect_uri`s differ from platform to platform.

The recommended approach to use Service Bindings in Tanzu Application Platform is to use an AppSSO `ClassClaim`. For more information, see [Claim credentials for an Application Single Sign-On service offering](../app-sso/how-to-guides/app-operators/claim-credentials.hbs.md). The `ClassClaim` is bound to a workload, but a UAA client lacks a direct binding to the UAA. The connection is established solely through a layer in Cloud Foundry.

For Service Keys or Applications created in the dashboard, the common use case is to copy the credentials returned in the create service key call, and then use them either in Cloud Foundry apps or off-platform. For those use cases, you can use a `ClientRegistration` instead of a `ClassClaim`. For more information, see [ClientRegistration API for AppSSO](../app-sso/reference/api/clientregistration.hbs.md).

Automation is possible to a certain extent, but manual intervention is required. The following script retrieves a list of all clients for your Identity Zone. You can save the script as `get-clients.sh`:

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

Store the following content in `client-registration-template.yaml`:

```yaml
#@ load("@ytt:data", "data")
#@ load("@ytt:template", "template")

#@ for client in data.values.clients:
---
_: #@ template.replace(client)
#@ end
```

Use YTT to convert clients into placeholders for `ClientRegistration`s:

```bash
ytt -f client-registration-template.yaml --data-value-yaml clients="$(./get-clients.sh)" 
```

### <a id="service-to-service"></a> Service-to-Service flows

In SSO for TAS, you can register some applications to use a Service-to-Service flow. This corresponds to the OAuth2
`client_credentials` grant, where no human interaction is required to obtain tokens.

In this case, you must use a `ClientRegistration` described in [Migrate OAuth2 Clients](#migrate-misc), with
`ClientRegistration.spec.authorizationGrantTypes=["client_credentials"]`. You can use the resulting client id and client secret such as a Service-to-Service app uses them in Tanzu Application Platform.

When creating a `ClientRegistration` name “example-cr”, a corresponding Kubernetes `Secret` is created in the same
namespace, with the name “example-cr”. The credentials are available in this secret under the fields `client-id` and `client-secret`.

### <a id="spring-boot-app"></a> Spring Boot application

With Spring Cloud Bindings
: Spring Boot applications deployed to Tanzu Application Service likely use the [java-cfenv](https://github.com/pivotal-cf/java-cfenv) library to read service bindings data from `VCAP_SERVICES`. In Tanzu Application Platform, `java-cfenv` is not applicable. You can remove it from your dependencies.

    If you build your Spring Boot app by using buildpacks, such as Tanzu Build Service, Tanzu Application Platform Supply Chains, Spring Boot maven, or gradle plugins, [Spring Cloud Bindings](https://github.com/spring-cloud/spring-cloud-bindings/) are added to your path and perform the binding automatically. For more information, see [Secure a Spring Boot workload](../app-sso/how-to-guides/app-operators/secure-spring-boot-workload.hbs.md). VMware recommends that your application uses Spring Boot v2.7, so that `ClientRegistration.spec.client_authentication_method` maps to a value known to Spring Boot, such as `client_secret_basic` or `client_secret_post`. Older versions of Spring Boot expect the value to be either `basic` or `post`.

    Spring Cloud Bindings is not intended to work with existing configuration values in `spring.security.oauth2.client`. Instead, it serves as an alternative mechanism for automatic population of these values. The recommended approach is to create a `local` or similar profile for local development, tailored to the authorization server used in the development environment. In your standard application.yaml, refrain from populating `spring.security.oauth2.client`. Including default values in your `application.yaml` might cause inconsistent behavior, because Spring Cloud Bindings can override some of the values. For more information, see the [appsso-starter-java accelerator documentation](https://github.com/vmware-tanzu/application-accelerator-samples/tree/209d88570e3be6045e2633dfdd1c2ccda1fe441e/appsso-starter-java) in GitHub.

Without Spring Cloud Bindings
: If you are unable or prefer not to depend on Spring Cloud Bindings, see [Secure a workload with Application Single Sign-On](../app-sso/how-to-guides/app-operators/secure-workload.hbs.md), which explains how credentials are exposed to the underlying application.

    To use multiple `ClientRegistration`s in a single app, or a `ClientRegistration` with multiple grant types, such as `authorization_code` and `client_credentials`, you can turn off the Spring Cloud Bindings integration by setting the following configuration property: `org.springframework.cloud.bindings.boot.oauth2.enable=false`. To access the bindings, you can either load the Secret values in environment variables, or read the files populated by the Secret in the pod. You can still use the Spring Cloud Bindings library to access the files as follows:

    ```java
    class Example {

       public void exampleMethod() {
           // ...
           var binding = new Bindings().findBinding("MY-BINDING-NAME");
           String issuerUri = binding.get("issuer-uri");
           String clientId = binding.get("client-id");

           // or
           var binding = new Bindings().filterBindings("oauth2");
           // ...
       }

    }
    ```

<br>
