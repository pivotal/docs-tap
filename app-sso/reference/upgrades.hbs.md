# Upgrade Application Single Sign-On

The `AppSSO` package is upgraded as part of your `TAP` package installation.

For help on migrating your resources in between versions, see the [migration
guides](#migration-guides).

If you installed the `AppSSO` package on its own, and not as part of `TAP`, you
can upgrade it individually by running:

```console
tanzu package installed update PACKAGE-INSTALLATION-NAME -p sso.apps.tanzu.vmware.com -v {{ vars.app-sso.version }} --values-file PATH-TO-YOUR-VALUES-YAML -n YOUR-INSTALL-NAMESPACE
```

>**Note** You can also upgrade AppSSO as part of upgrading Tanzu Application
>Platform as a whole. See [Upgrading Tanzu Application
>Platform](../../upgrading.hbs.md) for more information.

## <a id="migration-guides"></a>Migration guides

### <a id="v4-to-v5"> `v4.0.x` to `v5.0.x`

VMware recommends that you recreate your `AuthServers` after upgrading your
AppSSO to `v5.0.x` with the following changes:

- `AuthServer` resource definition
  - Migrate field `.spec.identityProviders[*].internalUnsafe.users[*].givenName` to `.spec.identityProviders[*].internalUnsafe.users[*].claims.given_name`
  - Migrate field `.spec.identityProviders[*].internalUnsafe.users[*].familyName` to `.spec.identityProviders[*].internalUnsafe.users[*].claims.family_name`
  - Migrate field `.spec.identityProviders[*].internalUnsafe.users[*].email` to `.spec.identityProviders[*].internalUnsafe.users[*].claims.email`
  - Migrate field `.spec.identityProviders[*].internalUnsafe.users[*].emailVerified` to `.spec.identityProviders[*].internalUnsafe.users[*].claims.email_verified`

### <a id="v3-to-v3_1"> `v3.0.0` to `v3.1.0`

VMware recommends that you recreate your `AuthServers` after upgrading your
AppSSO to `v3.1.0` with the following changes:

- Migrate field `.spec.identityProviders[*].openid.claimMappings["roles"]` to
  `.spec.identityProviders[*].openid.roles.fromUpstream.claim`.
- Migrate field `.spec.identityProviders[*].ldap.group.roleAttribute` to
  `.spec.identityProviders[*].ldap.roles.fromUpstream.attribute`.
- Migrate field `.spec.identityProviders[*].ldap.group.search` to
  `.spec.identityProviders[*].ldap.roles.fromUpstream.search`.
- Migrate field `.spec.identityProviders[*].saml.claimMappings["roles"]` to
  `.spec.identityProviders[*].saml.roles.fromUpstream.attribute`.

(Optional) If you plan to run Spring Boot 3 based `Workload`s, you must perform
the following migration tasks in your existing `ClientRegistration` resources:

- Migrate `.spec.clientAuthenticationMethod` values. 
- Migrate existing value `post` to `client_secret_post` or migrate existing
  value `basic` to `client_secret_basic`. 

### <a id="v2-to-v3">`v2.0.0` to `v3.0.0`

VMware recommends that you recreate your `AuthServers` after upgrading your
AppSSO to `v3.0.0` with the following changes:

- Migrate field `.spec.tls.disabled` to `.spec.tls.deactivated`.

### <a id="v1-to-v2">`v1.0.0` to `v2.0.0`

VMware recommends that you recreate your `AuthServers` after upgrading your
AppSSO to `v2.0.0` with the following changes:

- Migrate from `.spec.issuerURI` to `.spec.tls`:

    >**Note** AppSSO templates your issuer URI and enables TLS. When using the
    >newer `.spec.tls`, a custom `Service` and an ingress resource are no
    >longer required.

    >**Note** It is not recommended to continue using `.spec.issuerURI` in
    >AppSSO v2.0.0. To use `.spec.issuerURI` in AppSSO v2.0.0, you must provide
    >a `Service` and an ingress resource as in AppSSO v1.0.0.

    1. Configure one of `.spec.tls.{issuerRef, certificateRef, secretRef}`. See
       [Issuer URI & TLS](../tutorials/service-operators/issuer-uri-and-tls.md) for more
       information.
    1. (Optional) Disable TLS with `.spec.tls.disabled`.
    1. Remove `.spec.issuerURI`.
    1. Delete your `AuthServer`-specific `Service` and ingress resources.
    1. Apply your `AuthServer`. You can find its issuer URI in
       `.status.issuerURI`.
    1. Update the redirect URIs in your upstream identity providers.

- If you use the `internalUnsafe` identity provider to migrate existing users
  by replacing the bcrypt hash through the plain-text equivalent. You can still
  use existing bcrypt passwords by prefixing them with `{bcrypt}`:

   ```yaml
   ---
   apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
   kind: AuthServer
   metadata:
     # ...
   spec:
     identityProviders:
       - name: internal
         internalUnsafe:
           users:
             # v1.0
             - username: test-user-1
               password: $2a$10$201z9o/tHlocFsHFTo0plukh03ApBYe4dRiXcqeyRQH6CNNtS8jWK # bcrypt-encoded "password"
               # ...
             # v2.0
             - username: "test-user-1"
               password: "{bcrypt}$2a$10$201z9o/tHlocFsHFTo0plukh03ApBYe4dRiXcqeyRQH6CNNtS8jWK" # same bcrypt hash, with {bcrypt} prefix
             - username: "test-user-2"
               password: "password" # plain text
     # ...
   ```
