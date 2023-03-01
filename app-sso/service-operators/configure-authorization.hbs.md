# Configure authorization

> **Note** This section is applicable to **Internal**, **OpenID**, **LDAP**, and **SAML** identity provider
> [`AuthServer`](../crds/authserver.md) configurations.

An application or `Workload` may protect certain resources based on user's level of authorization. Within OAuth 2, the application
with protected resources (_the Resource Server_) verifies if the access token provided contains the scope(s) to perform
an action on a given protected resource.

_Example_: excerpt from a Spring Boot application that is an OAuth2 Resource Server, protecting its _message_ 
API endpoints `/message/**`:

```java
http.authorizeExchange(exchanges -> exchanges
			.pathMatchers("/message/**").hasAuthority("SCOPE_message.read")
			.anyExchange().authenticated()
        )
```

The access token used to access any endpoint under `/message/` path **must** have `message.read` scope within its access
token.

For more information, see [Spring Security documentation](https://docs.spring.io/spring-security/reference/servlet/oauth2/resource-server/jwt.html#oauth2resourceserver-jwt-sansboot).

To configure the mapping of user roles to authorization scopes at `AuthServer` identity provider and `ClientRegistration` levels,
read more below.

## Retrieving external groups or roles

To configure authorization for an identity provider, you **must** first define from which claim or attribute the
upstream identity provider will supply the groups or roles that a user is part of. 

Find more information about how to do this, navigate to:

- [OpenID - external groups mapping](./identity-providers.md#openid-external-groups-mapping)
- [LDAP - external groups mapping](./identity-providers.md#ldap-external-groups-mapping)
- [SAML - external groups mapping](./identity-providers.md#openid-external-groups-mapping)

You may skip this section if working with an internal (unsafe) provider, there is no external groups mapping to be done since
roles are defined in the spec itself.

Once external groups mapping is done, and groups or roles are retrievable, you may optionally
filter the roles that are appended to an identity token.

Learn more about [how to filter roles here](./identity-providers.md#roles-filtering)

## Mapping individual roles into authorization scopes

Once external groups or roles are mapped to AppSSO's `roles` claim, and optionally filtered for the desired set of retrieved
roles, each role may be mapped to the desired authorization scopes.

_Example_: given a retrieved role "hr", any client authorizing via `my-openid-provider` may request scopes
`hr.read` and/or `hr.write`, provided that the client has the scopes registered in `ClientRegistration.spec.scopes`.

```yaml
kind: AuthServer
# ...
spec:
  identityProviders:
    - name: my-openid-provider
      openid:
        accessToken:
          scope:
            rolesToScopes:
              - fromRole: "hr"           # -> role "hr" is mapped to "hr.read", "hr.write" scopes
                toScopes:                #    only users with "hr" role may be issued access token with these scopes
                  - "hr.read"            # ^^
                  - "hr.write"           # ^^
```

Given that a `ClientRegistration` has been applied to include `hr.read` and/or `hr.write`:

```yaml
kind: ClientRegistration
# ...
spec:
    scopes:
    - "hr.read"
    - "hr.write" 
```

Any client may request an access token with the above scopes, but an access token may be issued with those scopes **only**
if the user that is being authorized has the role `hr` in the upstream identity provider.

If the user has role `hr`, then they will be prompted for consent in allowing the application to request the scopes.
After consent has been provided, the user can access resources limited to the `hr.read` and `hr.write` scopes within
the application using their access token.

## <a id='default-scopes'></a> Default authorization scopes

You may define authorization scopes that are automatically granted to all users within an identity provider, regardless
of user role.

_Example_: An `AuthServer` with an OpenID provider, with defined authorization scope defaults

```yaml
kind: AuthServer
# ...
spec:
    identityProviders:
    - name: my-openid-provider
      openid:
        accessToken:
            scope:
                defaults:
                - "developer.read"
                - "developer.write"
                - "developer.delete"
```

Given that a `ClientRegistration` has been applied to include any of the above default scopes:

```yaml
kind: ClientRegistration
# ...
spec:
    scopes:
    - "developer.read"
```

When an application or `Workload` is registered via the above `ClientRegistration`, that application, on behalf of the user,
may request and be granted the scope `developer.read` automatically within the issued access token. The user will be prompted for
consent in allowing the application to request the scope. After consent has been provided, the user can access resources
limited to the `developer.read` scope within the application using their access token.

## Full authorization configuration example

```yaml
kind: AuthServer
# ...
spec:
  identityProviders:
    - name: my-openid-provider
      openid:
        roles:
          fromUpstream:
            claim: "groups"            # -> map the upstream identity provider's external groups / roles claim
          filterBy:                    # -> optionally filter the groups/roles retrieved from identity provider
            - exactMatch: "finance"    # ^^
            - exactMatch: "hr"         # ^^
            - exactMatch: "marketing"  # ^^
        accessToken:
          scope:
            defaults:                  # -> optional default scopes granted to any user within identity provider
              - "developer.read"       # ^^
              - "developer.write"      # ^^
              - "developer.delete"     # ^^
          rolesToScopes:
            - fromRole: "hr"           # -> role "hr" is mapped to "hr.read", "hr.write" scopes
              toScopes:                #    only users with "hr" role may be issued access token with these scopes
                - "hr.read"            # ^^
                - "hr.write"           # ^^
            - fromRole: "finance"      # -> role "finance" is mapped to "finance" scope
              toScopes:                #    only users with "finance" role may be issued an access token with this scope
                - "finance"            # ^^
            - fromRole: "marketing"    # -> role "marketing" is mapped to "marketing-reader", "marketing-writer" scopes
              toScopes:                #    only users with "marketing" role may be issued an access token with these scopes
                - "marketing-reader"   # ^^
                - "marketing-writer"   # ^^
```

Accompanying `ClientRegistration` configured to have clients allowed to request the above scopes:

```yaml
kind: ClientRegistration
# ...
spec:
  scopes:
    - "developer.read"
    - "developer.write"
    - "developer.delete"
    - "hr.read"
    - "hr.write"
    - "finance"
    - "marketing-reader"
    - "marketing-writer"
```
