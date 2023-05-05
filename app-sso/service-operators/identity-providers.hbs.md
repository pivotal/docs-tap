# Identity providers

Users can log in by using external identity providers (IdPs). 
OpenID Connect and LDAP providers are supported. 
SAML providers have limited experimental support. 
An `AuthServer` does not manage users internally.
Developers can get started quickly without needing to connect to an IdP by using 
static hard-coded users, which is for development purposes only. 

Identity providers are configured under `spec.identityProviders`, learn more
from [the API reference](../crds/authserver.md).

>**Caution** Changes to `spec.identityProviders` does not take effect immediately because the operator will roll out a new deployment
of the authorization server.

End-users will be able to log in with these providers when they go to `{spec.issuerURI}` in their browser.

Learn how to configure identity providers for an `AuthServer`:

- [OpenID Connect providers](#openid-connect-providers)
- [LDAP](#ldap)
- [SAML (experimental)](#saml-experimental)
- [Internal, static user](#internal-users)
- [Restrictions](#restrictions)

## OpenID Connect providers

To set up an OpenID Connect provider, provide the following information for your `AuthServer`:

```yaml
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: AuthServer
metadata:
# ...
spec:
  identityProviders:
    - name: my-oidc-provider
      openID:
        issuerURI: https://openid.example.com
        clientID: my-client-abcdef
        clientSecretRef:
          name: my-openid-client-secret
        scopes:
          - "openid"
          - "other-scope"
        authorizationUri: https://example.com/oauth2/authorize
        tokenUri: https://example.com/oauth2/token
        jwksUri: https://example.com/oauth2/jwks
        claimMappings:
          roles: my-oidc-provider-groups
  # ...
---
apiVersion: v1
kind: Secret
metadata:
  name: my-openid-client-secret
  # ...
stringData:
  clientSecret: very-secr3t
```

Where:

- `openID` is the issuer identifier. You can define as many OpenID providers as you like. If the provider supports OpenID Connect Discovery, 
the value of `openID` is used to auto-configure the provider by using information from `https://openid.example.com/.well-known/openid-configuration`.
- The value of `issuerURI` must not contain `.well-known/openid-configuration` and must match 
the value of the `issuer` field. See OpenID Connect documentation at `https://openid.example.com/.well-known/openid-configuration` for more information.
    >**Note** You can retrieve the values of `issuerURI` and `clientID` when registering a client with the provider, which in most cases, is by using a web UI. 
- `scopes` is used in the authorization request. Its value must contain `"openid"`. 
Other common `OpenID` values include `"profile"` and `"email"`.
You can also run `curl -s "https://openid.example.com/.well-known/openid-configuration" | jq -r ".issuer"` to retrieve the correct `issuerURI` value.
- The value of `clientSecretRef` must be a `Secret` with the entry `clientSecret`.
- `authorizationUri` (optional) is the URI for performing an authorization request and obtaining an `authorization_code`.
- `tokenUri` (optional) is the URI for performing a token request and obtaining a token.
- `jwksUri` (optional) is the JSON Web Key Set (JWKS) endpoint for obtaining the JSON Web Keys to verify token signatures.
- `claimMappings` (optional) selects which claim in the `id_token` contains the `roles` of the user. 
`roles` is a non-standard OpenID Connect claim. When `ClientRegistrations` has a `roles` scope, 
it is used to populate the `roles` claim in the `id_token` issued by the `AuthServer`.
- `my-oidc-provider-groups` claim from the ID token issued by `my-oidc-provider` is mapped into the `roles` claim in tokens issued by AppSSO.

Verify the configuration by visiting the `AuthServer`'s issuer URI in your browser and select `my-oidc-provider`.

### Note for registering a client with the identity provider

The `AuthServer` will set up redirect URIs based on the provider name in the configuration. For example, for a provider
with `name: my-provider`, the redirect URI will be `{spec.issuerURI}/login/oauth2/code/my-provider`. The externally
accessible user URI for the `AuthServer`, including scheme and port is `spec.issuerURI`. If the `AuthServer` is
accessible on `https://appsso.company.example.com:1234/`, the redirect URI registered with the identity provider should
be `https://appsso.company.example.com:1234/login/oauth2/code/my-provider`.

### Supported token signing algorithms

AppSSO only supports the `RS256` algorithm for token signature. For more information, see [OpenID Connect documentation](https://openid.net/specs/openid-connect-core-1_0.html#IDTokenValidation).

You can find out the signing algorithms your OpenID provider supports by referring to the `id_token_signing_alg_values_supported` response parameter in the [OpenID Connect documentation](https://openid.net/specs/openid-connect-discovery-1_0.html#ProviderConfig) at `.well-known/openid-configuration`. 

For example, you can run:

```shell
curl -s "ISSUER-URI/.well-known/openid-configuration" | jq ".id_token_signing_alg_values_supported"
```

## <a id='ldap'></a>LDAP

>**Important** You can not configure more than one `ldap` identity provider.

For example:

```yaml
---
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: AuthServer
metadata:
# ...
spec:
  identityProviders:
    - name: ldap
      ldap:
        url: "ldaps://example.com:636"
        bind:
          dn: uid=binduser,ou=Users,dc=example,dc=com
          passwordRef:
            name: ldap-password
        user:
          searchBase: ou=Users,dc=example,dc=com
          searchFilter: cn={0}
        group:
          search:
            filter: member={0}
            base: ou=Users,dc=example,dc=com
            searchSubTree: true
            depth: 10
          roleAttribute: description
  # ...
---
apiVersion: v1
kind: Secret
metadata:
  name: ldap-password
  namespace: default
stringData:
  password: confidential-password-value
```

Where:

- `url` is the URL of the LDAP server. It must be `ldaps` and must contain a port.
- `bind.dn` is the DN to perform the bind.
- `bind.passwordRef` must be a secret with the entry `password`. That entry is the password to perform the bind.
- `user.searchBase` is the branch of tree where the users are located at. Search is performed in nested entries.
- `user.seachFilter` is the filter for LDAP search. It must contain the string `{0}`, which is replaced
  by the `dn` of the user when performing a search. For example, when logging in with the username `marie`, the filter for LDAP
  search is `cn=marie`.
- `group` (optional) defaults to unset. It configures how LDAP groups are mapped to user roles in the `id_token` claims.
  If not set, the user has no roles.
  - `group.roleAttriubte` selects which attribute of the group entry are mapped to a user role. If an attribute has multiple
    values, the first value is selected.
  - `group.search` (optional) toggles "Active Directory" search and uses recursive search to find groups for a given user.

Verify the configuration by visiting the `AuthServer`'s issuer URI in your browser and log in with the username and password from LDAP.

### ActiveDirectory group search

In ActiveDirectory groups, user entries have a multi-value `memberOf` attribute, which contains the DNs pointing to the
groups of a particular user. To enable this search mode, make sure `group.roleAttribute` is set and `group.search` is not set.

For example:

```yaml
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: AuthServer
metadata:
# ...
spec:
  identityProviders:
    - name: ldap
      ldap:
        # ...
        user:
          searchBase: OU=Cloud,DC=ad,DC=example,DC=com
          searchFilter: cn={0}
        group:
          roleAttribute: sAMAccountName
```

The LDIF definition is as follows:

```ldif
dn: CN=appsso-user,OU=Cloud,DC=ad,DC=example,DC=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: user
cn: appsso user
sn: user
givenName: appsso
distinguishedName: CN=appsso user,OU=Cloud,DC=ad,DC=example,DC=com
displayName: appsso user
memberOf: CN=ssogroup,OU=Cloud,DC=ad,DC=example,DC=com
memberOf: CN=developers,OU=Cloud,DC=ad,DC=example,DC=com
sAMAccountName: appssouser
userPrincipalName: appssouser@ad.example.com
objectCategory: CN=Person,CN=Schema,CN=Configuration,DC=ad,DC=example,DC=com
# ...

# Groups
dn: CN=ssogroup,OU=Cloud,DC=ad,DC=example,DC=com
objectClass: top
objectClass: group
cn: ssogroup
member: CN=appsso-user,OU=Cloud,DC=ad,DC=example,DC=com
sAMAccountName: SSO Group
# ...

dn: CN=developers,OU=Cloud,DC=ad,DC=example,DC=com
objectClass: top
objectClass: group
cn: developers
sAMAccountName: Developers
# ...
```

The user `appsso-user` has two values for `memberOf`, pointing to two groups. Given the configuration earlier,
`sAMAccountName` is used for the role, so the user has `SSO Group` and `Developers` as roles. 
The group is not required to have `member` attribute point to the user for the role to be mapped.


### "Classic" group search

In non-ActiveDirectory LDAP, users generally do not have a `memberOf` attribute. Group search is performed by looking
up groups in a base branch and filtering based on the groups `member` attribute.

An AuthServer can optionally perform: 

- group search in sub-branches.
- nested group search, that is, find a hierarchy of groups, in which a group
is a member of another group.

The complete configuration is as follows:

```yaml
---
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: AuthServer
metadata:
# ...
spec:
  identityProviders:
    - name: ldap
      ldap:
        # ...
        group:
          search:
            base: ou=Users,dc=example,dc=com
            filter: member={0}
            depth: 10
            searchSubTree: true
          roleAttribute: description
  # ...
```

Where:

- `search.base` is the base for running an LDAP search for groups.
- `search.filter` is the filter for running an LDAP search for groups. It must contain the string `{0}`, which
  is replaced by the `dn` of the user when performing group search. For example, `member=cn=marie,ou=Users,dc=example,dc=org`.
- `search.depth` (optional) is the depth at which to perform nested group search. It defaults to unset if left empty.
- `search.searchSubTree` (optional) controls whether to look for groups in sub-trees of the `search.base`. It defaults to unset if left empty.


#### Direct group search only

Given the following minimal configuration:

```yaml
---
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: AuthServer
metadata:
# ...
spec:
  identityProviders:
    - name: ldap
      ldap:
        # ...
        user:
          searchBase: ou=Users,dc=example,dc=com
          searchFilter: uid={0}
        group:
          search:
            base: ou=Users,dc=example,dc=com
            filter: member={0}
          roleAttribute: description
  # ...
```

The LDIF definition is as follows:

```ldif
######################
## Users
######################
## User Marie Curie
## Marie Salomea Skłodowska Curie ; https://en.wikipedia.org/wiki/Marie_Curie
dn: cn=marie,ou=Users,dc=example,dc=org
cn: Marie
sn: Skłodowska Curie
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: shadowAccount
uid: marie

######################
## Groups
######################
dn: cn=nobels,ou=Users,dc=example,dc=org
objectClass: groupOfNames
description: Nobel Prizes
member: cn=marie,ou=Users,dc=example,dc=org
```

User `marie` has roles `Nobel Prizes`.

#### Groups in sub-trees

AppSSO can perform group search in sub-trees of the base for group search. This is enabled when
`group.search.searchSubTree` is explicitly set to `true`. For example:

```yaml
---
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: AuthServer
metadata:
# ...
spec:
  identityProviders:
    - name: ldap
      ldap:
        # ...
        group:
          search:
            base: ou=Users,dc=example,dc=com
            filter: member={0}
            searchSubTree: true
          roleAttribute: description
  # ...
```

The LDIF definition is as follows:

```ldif
######################
## Users
######################
## User Corazon
## Maria Corazon Sumulong Cojuangco Aquino; https://en.wikipedia.org/wiki/Corazon_Aquino
dn: cn=corazon,ou=Users,dc=example,dc=com
cn: Maria Corazon
sn: Sumulong Cojuangco Aquino
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: shadowAccount
uid: corazon


######################
## Groups
######################
dn: cn=presidents,ou=Users,dc=example,dc=com
objectClass: groupOfNames
description: Presidents
member: cn=corazon,ou=Users,dc=example,dc=com

dn: cn=chief-commanders,ou=LegionHonor,ou=Users,dc=example,dc=com
objectClass: groupOfNames
description: Chief Commanders
member: cn=corazon,ou=Users,dc=example,dc=com
```

User `corazon` has roles `Presidents` and `Chief Commanders`, which are retrieved from `ou=LegionHonor,ou=Users,dc=example,dc=com`,
a subtree of the search base.

#### Nested group search

AppSSO can perform nested group search by going up a chain where a user is a member of a group, which is itself a member
of a group, and so on. This is enabled by setting `group.search.depth` to greater than `1`. `group.search.depth` controls 
the number of "levels" that AppSSO fetches to get the groups of a user. For example:

```yaml
---
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: AuthServer
metadata:
# ...
spec:
  identityProviders:
    - name: ldap
      ldap:
        # ...
        user:
          searchBase: ou=Users,dc=example,dc=com
          searchFilter: uid={0}
        group:
          search:
            base: ou=Users,dc=example,dc=com
            filter: member={0}
            depth: 2
          roleAttribute: description
  # ...
```

The LDIF definition is as follows:

```ldif
######################
## Users
######################
## User Corazon
## Maria Corazon Sumulong Cojuangco Aquino; https://en.wikipedia.org/wiki/Corazon_Aquino
dn: cn=corazon,ou=Users,dc=example,dc=com
cn: Maria Corazon
sn: Sumulong Cojuangco Aquino
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: shadowAccount
uid: corazon


######################
## Groups
######################
# Citizen > Politicians > Presidents > corazon (depth = 3)
dn: cn=citizens,ou=Users,dc=example,dc=com
objectClass: groupOfNames
description: Citizens
member: cn=politicians,ou=Users,dc=example,dc=com

# Politicians > Presidents > corazon (depth = 2)
dn: cn=politicians,ou=Users,dc=example,dc=com
objectClass: groupOfNames
description: Politicians
member: cn=presidents,ou=Users,dc=example,dc=com

# Presidents > corazon (depth = 1, direct group)
dn: cn=presidents,ou=Users,dc=example,dc=com
objectClass: groupOfNames
description: Presidents
member: cn=corazon,ou=Users,dc=example,dc=com
```


User `corazon` has roles `Presidents` and `Politicians`. However, the search stops at depth 2, so they
do not have the role `Citizens`, which requires a depth greater or equal to 3.


## SAML (experimental)

>**Caution** Support for SAML providers is experimental.

For SAML providers only autoconfiguration through `metadataURI` is supported.

```yaml
---
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: AuthServer
metadata:
# ...
spec:
  - name: my-saml-provider
    saml:
      metadataURI: https://saml.example.com/sso/saml/metadata # required
      claimMappings: # optional
        # Map SAML attributes into claims in id_tokens issued by AppSSO. The key
        # on the left represents the claim, the value on the right the attribute.
        # For example:
        # The "saml-groups" attribute from the assertion issued by "my-saml-provider"
        # will be mapped into the "roles" claim in id_tokens issued by AppSSO
        roles: saml-groups
        givenName: FirstName
        familyName: LastName
        emailAddress: email
```

### Note for registering a client with the identity provider

The `AuthServer` will set up SSO and metadata URLs based on the provider name in the configuration.
For example, for a SAML provider with `name: my-provider`, the SSO URL will be
`{spec.issuerURI}/login/saml2/sso/my-provider`. The metadata URL will be
`{spec.issuerURI}/saml2/service-provider-metadata/my-provider`. `spec.issuerURI` is the externally
accessible issuer URI for an `AuthServer`, including scheme and port. If the `AuthServer` is accessible on
`https://appsso.company.example.com:1234/`, the SSO URL registered with the identity
provider should be `https://appsso.company.example.com:1234/login/saml2/sso/my-provider`.

## Internal users

>**Caution** `InternalUnsafe` is unsafe and not recommended for production.

During development, static users can be useful for testing purposes. 
You can not configure more than one `internalUnsafe` identity provider.

For example:

```yaml
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: AuthServer
metadata:
  annotations:
    sso.apps.tanzu.vmware.com/allow-unsafe-identity-provider: ""
  # ...
spec:
  identityProviders:
    - name: test-users
      internalUnsafe:
        users:
          - username: ernie
            password: "password" # plain text
            roles:
              - "silly"
          - username: bert
            password: "{bcrypt}$2a$10$201z9o/tHlocFsHFTo0plukh03ApBYe4dRiXcqeyRQH6CNNtS8jWK" # bcrypt-hashed "password"
            roles:
              - "grumpy"
  # ...
```

`InternalUnsafe` needs to be explicitly allowed by setting the
annotation `sso.apps.tanzu.vmware.com/allow-unsafe-identity-provider: ""`.

The passwords can be plain text or bcrypt-hashed. When bcrypt-hashing passwords they have to be prefixed with `{bcrypt}`
. Learn how to bcrypt-hash string below.

Verify the configuration by visiting the `AuthServer`'s issuer URI in your browser and logging in as `ernie/password`
or `bert/password`.

### Generating a bcrypt hash from a plain-text password

There are multiple options for generating bcrypt hashes:

1. Use an [online bcrypt generator](https://bcrypt-generator.com/)
2. On Unix platforms, use `htpasswd`. Note, you may need to install it, for example on Ubuntu by
   running `apt install apache2-utils`

  ```shell
  htpasswd -bnBC 12 "" your-password-here | tr -d ':\n'
  ```

## Restrictions

Each identity provider has a declared `name`. The following conditions apply:

- the names must be unique
- the names must not be blank
- the names must
  follow [Kubernetes' DNS Subdomain Names guidelines](https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#dns-subdomain-names)
    - contain no more than 253 characters
    - contain only lowercase alphanumeric characters, '-' or '.'
    - start with an alphanumeric character
    - end with an alphanumeric character
- the names may not start with `client` or `unknown`

There can be at most one of each `internalUnsafe` and `ldap`.
