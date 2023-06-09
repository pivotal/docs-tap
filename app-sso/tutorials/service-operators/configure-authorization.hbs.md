# Configure authorization for AppSSO

This topic tells you how to configure authorization for Application Single Sign-On 
(commonly called AppSSO). 

> **Note** This topic is applicable to Internal, OpenID, LDAP, and SAML (experimental) identity provider
> `AuthServer` configurations. For more information, see [AuthServer](../../reference/api/authserver.hbs.md).

## Overview

An application or `Workload` can protect certain resources based on user's level 
of authorization. Within OAuth 2, the application with protected resources, the 
Resource Server, verifies if the access token provided contains the scopes to perform
an action on a protected resource.

The following excerpt is from a Spring Boot application, OAuth2 Resource Server, 
protecting its message API endpoints `/message/**`:

```java
http.authorizeExchange(exchanges -> exchanges
			.pathMatchers("/message/**").hasAuthority("SCOPE_message.read")
			.anyExchange().authenticated()
        )
```

The access token to access any endpoint under `/message/` path must have `message.read` 
scope within its access token.

For full example, see [Spring Security documentation](https://docs.spring.io/spring-security/reference/servlet/oauth2/resource-server/jwt.html#oauth2resourceserver-jwt-sansboot).

The following sections describe how to configure the mapping of user roles to 
authorization scopes at `AuthServer` identity provider and `ClientRegistration` levels.

## <a id="external-groups-roles"></a> Retrieving external groups or roles

> **Important** Skip this section if you work with an internal unsafe provider. 
> External groups mapping is not required because roles are defined in the specifications.

To configure authorization for an identity provider, you must define from which claim or attribute the
upstream identity provider supplies the groups or roles that a user is part of:

- [OpenID external groups mapping](identity-providers.md#openid-external-groups-mapping)
- [LDAP external groups mapping](identity-providers.md#ldap-external-groups-mapping)
- [SAML (experimental) external groups mapping](identity-providers.md#openid-external-groups-mapping)

After external groups mapping is complete, and groups or roles are retrievable, you can optionally
filter the roles that are appended to an identity token. 
For more information about how to filter roles, see [Roles claim filtering](./identity-providers.md#roles-filtering).

## <a id="individual-roles"></a> Mapping individual roles into authorization scopes

After external groups or roles are mapped to AppSSO's `roles` claim, 
and optionally filtered for the desired set of retrieved roles, 
you can map each role to the desired authorization scopes.

For example, given a retrieved role "hr", any client authorizing by using `my-openid-provider` can request scopes
`hr.read` or `hr.write`, provided that the client registered the scopes in `ClientRegistration.spec.scopes`:

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
              - fromRole: "hr" # -> Role "hr" is mapped to the "hr.read" and "hr.write" scopes.
                toScopes:      #    Only users with the "hr" role can be issued access token with these scopes.
                  - "hr.read"  # ^^
                  - "hr.write" # ^^
```

For example, given that a `ClientRegistration` is applied to include `hr.read` or `hr.write`:

```yaml
kind: ClientRegistration
# ...
spec:
    scopes:
    - name: "roles" # Must request special 'roles' scope.
    - name: "hr.read"
    - name: "hr.write"
```

Any client can request an access token with the scopes, but an access token can 
be issued with those scopes only if the user that is being authorized has the role `hr` in the upstream identity provider.

If the user has the role `hr`, he or she must consent to allow the application to request the scopes.
After the consent is provided, the user can access resources limited to the `hr.read` and `hr.write` scopes within
the application by using their access token.

## <a id='default-scopes'></a> Default authorization scopes

You can define authorization scopes that are automatically granted to all users within an identity provider, regardless
of user role.

For example, given an `AuthServer` with an OpenID provider, with defined authorization scope defaults:

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

For example, given that a `ClientRegistration` is applied to include any of the default scopes:

```yaml
kind: ClientRegistration
# ...
spec:
    scopes:
    - name: "roles" # Must request special 'roles' scope.
    - name: "developer.read"
```

When an application or `Workload` is registered by using the `ClientRegistration`, 
that application, on behalf of the user, can request and be granted with the scope 
`developer.read` automatically within the issued access token. 
The user must consent to allow the application to request the scope. 
After the consent is provided, the user can access resources limited to the 
`developer.read` scope within the application by using their access token.

The following is a full sample of authorization configurations and the accompanying 
`ClientRegistration` configurations to allow clients to request the scopes:

```yaml
kind: AuthServer
# ...
spec:
  identityProviders:
    - name: my-openid-provider
      openid:
        roles:
          fromUpstream:
            claim: "groups"            # -> Map the upstream identity provider's external groups or roles claim.
          filterBy:                    # -> Optionally filter the groups or roles retrieved from identity provider.
            - exactMatch: "finance"    # ^^
            - exactMatch: "hr"         # ^^
            - exactMatch: "marketing"  # ^^
        accessToken:
          scope:
            defaults:                  # -> Optional default scopes granted to any user within the identity provider.
              - "developer.read"       # ^^
              - "developer.write"      # ^^
              - "developer.delete"     # ^^
            rolesToScopes:
            - fromRole: "hr"           # -> Role "hr" is mapped to "hr.read", "hr.write" scopes.
              toScopes:                #    Only users with "hr" role can be issued access token with these scopes.
                - "hr.read"            # ^^
                - "hr.write"           # ^^
            - fromRole: "finance"      # -> Role "finance" is mapped to "finance" scope.
              toScopes:                #    Only users with "finance" role can be issued an access token with this scope.
                - "finance"            # ^^
            - fromRole: "marketing"    # -> Role "marketing" is mapped to "marketing-reader", "marketing-writer" scopes.
              toScopes:                #    Only users with "marketing" role can be issued an access token with these scopes.
                - "marketing-reader"   # ^^
                - "marketing-writer"   # ^^
```

```yaml
kind: ClientRegistration
# ...
spec:
  scopes:
    - name: "roles" # Must request special 'roles' scope.
    - name: "developer.read"
    - name: "developer.write"
    - name: "developer.delete"
    - name: "hr.read"
    - name: "hr.write"
    - name: "finance"
    - name: "marketing-reader"
    - name: "marketing-writer"
```
