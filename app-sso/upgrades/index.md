# Upgrades

The `AppSSO` package is upgraded as part of your `TAP` package installation. 

For specific help on migrating your resources in between versions refer to the [migration guides](#migration-guides).

If you installed the `AppSSO` package on its own, and not as part of `TAP`, you can upgrade it individually by running:

```
tanzu package installed update PACKAGE_INSTALLATION_NAME -p sso.apps.tanzu.vmware.com -v 2.0.0 --values-file PATH_TO_YOUR_VALUES_YAML -n YOUR_INSTALL_NAMESPACE
```

## Migration guides

### `v1.0.0` → `v2.0.0`

We strongly recommended that you recreate your `AuthServers` after upgrading your AppSSO package installation to `2.0.0`
with the following changes:

- Migrate from `.spec.issuerURI` to `.spec.tls`. AppSSO will template your issuer URI for you and provide TLS-enabled. A
  custom `Service` and ingress resource are no longer required.
    1. Configure one of `.spec.tls.{issuerRef, certificateRef, secretRef}`(
       see [Issuer URI & TLS](app-sso/service-operators/issuer-uri-and-tls.md)). Optionally, disable TLS
       with `.spec.tls.disabled`.
    2. Remove `.spec.issuerURI`.
    3. Delete your `AuthServer`-specific `Service` and ingress resources.
    4. Apply your `AuthServer`. You will find its issuer URI in `.status.issuerURI`.
    5. You can now update the redirect URIs in your upstream identity providers.

- If you are using the `internalUnsafe` identity provider migrate existing users by replacing the bcrypt hash by the
  plain-text equivalent. You can still use existing
  bcrypt passwords by prefixing them with `{bcrypt}`:

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

New versions of AppSSO are available from the Tanzu Application Platform package repository. See [AppSSO documentation](app-sso/platform-operators/upgrades.md) for detailed upgrade steps.
You can also upgrade AppSSO as part of upgrading Tanzu Application Platform as a whole. See [Upgrading Tanzu Application Platform](upgrading.hbs.md) for more information.
