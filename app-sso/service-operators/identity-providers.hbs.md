# Identity providers

An `AuthServer` does not manage users internally. Instead, users log in through external identity providers (IdPs).
Currently, `AuthServer` supports OpenID Connect providers, LDAP providers and a list of static hard-coded
users for development purposes only. `AuthServer` also has limited beta support for SAML providers.

Identity providers are configured under `spec.identityProviders`, learn more
from [the API reference](../crds/authserver.md).

>**Caution** Changes to `spec.identityProviders` do not take effect immediately because the operator will roll out a new deployment
of the authorization server.

End-users will be able to log in with these providers when they go to `{spec.issuerURI}` in their browser.

Learn how to configure identity providers for an `AuthServer`:

- [OpenID](#openid)
- [LDAP](#ldap)
- [SAML (experimental)](#saml-experimental)
- [Internal, static user](#internal-users)
- [Roles claim filtering](#roles-filtering)
- [Roles claim mapping and filtering explained](#roles-claim-mapping-and-filtering-explained)
- [Configure authorization](./configure-authorization.md)
- [Restrictions](#restrictions)

## <a id='openid'></a> OpenID Connect providers

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
        roles:
          fromUpstream:
            claim: "my-oidc-provider-groups"
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
- `jwksUri` (optional) is the JSON Web Key Set (JWKS) endpoint for obtaining the JSON Web Keys to verify token
  signatures.
- `roles.fromUpstream.claim` (optional) selects which claim in the `id_token` contains the `roles` of
  the user. `roles` is a non-standard OpenID Connect claim. When `ClientRegistrations` has a `roles` scope,
  it is used to populate the `roles` claim in the `id_token` issued by the `AuthServer`. 
  For more information, see [OpenID external groups mapping](#openid-external-groups-mapping).
  - `my-oidc-provider-groups` claim from the ID token issued by `my-oidc-provider` is mapped into the `roles` claim in id tokens issued by AppSSO.

Verify the configuration by visiting the `AuthServer`'s issuer URI in your browser and select `my-oidc-provider`.

### <a id='openid-external-groups-mapping'></a> OpenID external groups mapping

Service operators may map the identity provider's "groups" (or equivalent) claim to the `roles` claim within
an `AuthServer`'s identity token.

> **Note** [Read more about roles claim mapping and filtering here](#roles-claim-mapping-filtering-explained)

App Operators may configure their ClientRegistration to have the `roles` claim included in the `id_token`.

Configure `AuthServer` with OpenID Connect groups mapping:

```yaml
spec:
  identityProviders:
    - name: "openid-idp"
      openid:
        scopes:
          - upstream-identity-providers-groups-claim # optional, based on identity provider
        roles:
          fromUpstream:
            claim: "upstream-identity-providers-groups-claim"
```

> **Caution** Some OpenID providers, such as Okta OpenID, may require requesting the roles/groups scope from the
> identity provider, and so it must be listed within `.openid.scopes` list.

For every [ClientRegistration](../crds/clientregistration.hbs.md) that has the `roles` scope listed, the identity
token will be populated with the `roles` claim:

```yaml
kind: ClientRegistration
metadata:
  name: my-client-registration
spec:
  scopes:
    - name: openid
    - name: roles
  # ...
```

When groups are mapped (as described above), all the groups provided by the identity provider are
retrieved, and the relevant groups that the logged-in user is part of are appended to the `roles` claim of
an `id_token`. To filter the available roles within an `id_token`, see [Roles claim filtering section](#roles-filtering).

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
        roles:
          fromUpstream:
            attribute: cn
            search:
              filter: member={0}
              base: ou=Users,dc=example,dc=com
              searchSubTree: true
              depth: 10
          filterBy:
            - exactMatch: "users"
            - regex: "^admin"
        group: # DEPRECATED, use 'roles' instead
          search:
            filter: member={0}
            base: ou=Users,dc=example,dc=com
            searchSubTree: true
            depth: 10
          roleAttribute: cn
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
- `roles` (optional) defaults to unset. It configures how LDAP groups are mapped to user roles in the `id_token` claims.
  If not set, the user has no roles.
    - `fromUpstream.attribute` selects which attribute of the group entry are mapped to a user role. If an attribute has
      multiple
      values, the first value is selected.
    - `fromUpstream.search`  (optional) toggles "OpenLDAP"-style group search, optionally uses recursive search to find
      groups for a given user.
    - `filterBy` (optional) - applied roles claim filters. See [Roles claim filtering section](#roles-filtering) for
      more details.
- `group` (DEPRECATED, , use `role` instead, optional) defaults to unset. It configures how LDAP groups are mapped to user roles in
  the `id_token` claims. If not set, the user has no roles.
  - `group.roleAttribute` selects which attribute of the group entry are mapped to a user role. If an attribute has multiple
    values, the first value is selected.
  - `group.search` (optional) toggles "Active Directory" search and uses recursive search to find groups for a given user.

Verify the configuration by visiting the `AuthServer`'s issuer URI in your browser and log in with the username and password from LDAP.

### <a id='ldap-external-groups-mapping'></a> LDAP external groups mapping

Service operators may map the identity provider's "groups" (or equivalent) attribute to the `roles` claim within
an `AuthServer`'s identity token.

> **Note** [Read more about roles claim mapping and filtering here](#roles-claim-mapping-filtering-explained)

Configure `AuthServer` with LDAP groups attribute mapping:

```yaml
spec:
  identityProviders:
    - name: "ldap-idp"
      ldap:
        roles:
          fromUpstream:
            attribute: "upstream-identity-providers-groups-attribute" # e.g. "cn" or "dn"
```

For every [ClientRegistration](../crds/clientregistration.hbs.md) that has the `roles` scope listed, the identity
token will be populated with the `roles` claim:

```yaml
kind: ClientRegistration
metadata:
  name: my-client-registration
spec:
  scopes:
    - name: openid
    - name: roles
  # ...
```

When groups are mapped (as described above), all the groups provided by the identity provider are
retrieved, and the relevant groups that the logged-in user is part of are appended to the `roles` claim of
an `id_token`. To filter the available roles within an `id_token`, see [Roles claim filtering section](#roles-filtering).

### ActiveDirectory group search

In ActiveDirectory groups, user entries have a multi-value `memberOf` attribute, which contains the DNs pointing to the
groups of a particular user. To enable this search mode, make sure `roles.fromUpstream.attribute` is set and
`roles.fromUpstream.search` is not set.

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
        roles:
          fromUpstream:
            attribute: sAMAccountName
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
        roles:
          fromUpstream:
            attribute: description
            search:
              base: ou=Users,dc=example,dc=com
              filter: member={0}
              depth: 10
              searchSubTree: true
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
        roles:
          fromUpstream:
            attribute: description
            search:
              base: ou=Users,dc=example,dc=com
              filter: member={0}
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
`roles.fromUpstream.search.searchSubTree` is explicitly set to `true`. For example:

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
        roles:
          fromUpstream:
            attribute: description
            search:
              base: ou=Users,dc=example,dc=com
              filter: member={0}
              searchSubTree: true
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
of a group, and so on. This is enabled by setting `roles.fromUpstream.search.depth` to greater than `1`. 
`roles.fromUpstream.search.depth` controls the number of "levels" that AppSSO fetches to get the groups of a user. 

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
        # ...
        user:
          searchBase: ou=Users,dc=example,dc=com
          searchFilter: uid={0}
        roles:
          fromUpstream:
            attribute: description
            search:
              base: ou=Users,dc=example,dc=com
              filter: member={0}
              depth: 2
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

## <a id='saml-experimental'></a> SAML (experimental)

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
        givenName: FirstName
        familyName: LastName
        emailAddress: email
```

### <a id='saml-external-groups-mapping'></a> SAML external groups mapping

Service operators may map the identity provider's "groups" (or equivalent) attribute to the `roles` claim within
an `AuthServer`'s identity token.

> **Note** [Read more about roles claim mapping and filtering here](#roles-claim-mapping-filtering-explained)

Configure `AuthServer` with SAML role attribute:

```yaml
spec:
  identityProviders:
    - name: "saml-idp"
      saml:
        roles:
          fromUpstream:
            attribute: "saml-group-attribute"
```

For every [ClientRegistration](../crds/clientregistration.hbs.md) that has the `roles` scope listed, the identity
token will be populated with the `roles` claim:

```yaml
kind: ClientRegistration
metadata:
  name: my-client-registration
spec:
  scopes:
    - name: openid
    - name: roles
  # ...
```

When groups are mapped (as described above), all the groups provided by the identity provider are
retrieved, and the relevant groups that the logged-in user is part of are appended to the `roles` claim of
an `id_token`. To filter the available roles within an `id_token`, see [Roles claim filtering section](#roles-filtering).

### Note for registering a client with the identity provider

The `AuthServer` will set up SSO and metadata URLs based on the provider name in the configuration.
For example, for a SAML provider with `name: my-provider`, the SSO URL will be
`{spec.issuerURI}/login/saml2/sso/my-provider`. The metadata URL will be
`{spec.issuerURI}/saml2/service-provider-metadata/my-provider`. `spec.issuerURI` is the externally
accessible issuer URI for an `AuthServer`, including scheme and port. If the `AuthServer` is accessible on
`https://appsso.company.example.com:1234/`, the SSO URL registered with the identity
provider should be `https://appsso.company.example.com:1234/login/saml2/sso/my-provider`.

## <a id='internal-users'></a> Internal users

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

## <a id='roles-filtering'></a> Roles claim filtering

> **Note** This section is applicable to **OpenID**, **LDAP**, and **SAML** identity provider configurations

Once an external groups mapping has been applied (as described per identity provider above), AppSSO is able to retrieve
all the groups from an identity provider. An identity provider may have hundreds of groups, and any
particular user may be part of a large subset of those groups. When a user logs in, those groups will be appended to
their `id_token`'s `roles` claim. This section describes how to filter the `roles` claim.

To filter groups, for a supported identity provider, apply:

```yaml
spec:
  identityProviders:
    - name: my-provider
      <idp>:
        roles:
          filterBy:
            - exactMatch: ""
            - regex: ""
```

where `<idp>` may be `openid`, `ldap`, or `saml`.

Filters are disjunctive ("OR" operator), so each filter is applied to the entire set of groups, and merged into a set of
unique filtered groups values. See [filter examples](#roles-filter-examples) for more information.

### <a id='roles-filters'></a> Roles claim filters

Available filters are:

- `exactMatch` - match the groups exactly. This filter is **case-sensitive**. e.g. `exactMatch: "developer"` will match
  only the group named "developer" and no other.
- `regex` - match groups according to the defined regular expression pattern. , and 
  This filter is **case-insensitive**. e.g. `regex: ^admin` will match groups starting with the word "admin".
  - The regular expression pattern syntax used is [RE2](https://golang.org/s/re2syntax)
  - Expressions should not be surrounded by forward slashes (`/`) and should only contain the pattern (e.g. `.*`, `^dev`, `\\w+`).

### <a id='roles-filter-examples'></a> Roles claim filter examples

Given an example set of groups retrieved from a hypothetical identity provider:

```
it-admin
it-developer
devops-user
devops-admin
devops-developer
product-user
product-developer
org-user
hr-user
hr-admin
```

**Basic exact match filters**

```yaml
- exactMatch: "product-user"
- exactMatch: "org-user"
```

returns:

```
product-user
org-user
```

**Basic regular expression (RegEx) filters**

```yaml
- regex: ".*-developer"
```

returns:

```
it-developer
devops-developer
product-developer
```

**Multiple regular expression (RegEx) filters**

```yaml
- regex: ".*-developer"
- regex: "^it"    # starts with "it"
- regex: "admin$" # ends with "admin"
- regex: "\w+"    # at least one word or more
```

returns:

```
it-admin
it-developer
devops-admin
devops-developer
product-developer
hr-admin
```

> **Note** filters are disjunctive and so multiple filters can filter down the same values, but the resulting set will
> always have unique values.

**Exact match and regular expression (RegEx) filters**

```yaml
- exact-match: "hr-admin"
- exact-match: "org-user"
- regex: "developer$"    # ends with "developer"
```

returns:

```
it-developer
devops-developer
product-developer
org-user
hr-admin
```

## <a id="roles-claim-mapping-filtering-explained"></a> Roles claim mapping and filtering explained

When issuing an `id_token`, OpenID providers may include a (non-standard) claim describing the "groups" the user belongs
to, the "roles" of the user, or something similar. This claim is identity provider specific. For example, Azure AD uses
the "group" claim by default, and allows administrators to select the name of the claim.

Service Operators may choose to make these "groups", "roles", or equivalent, available in the id_token issued by an AppSSO
`AuthServer`, in the `roles` claim, with [filtering rules](#roles-filtering) applied.

![identity provider roles claim filtering and mapping diagram](../../images/app-sso/idp-roles-mapping-filtering.png)

## <a id='restrictions'></a> Restrictions

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
