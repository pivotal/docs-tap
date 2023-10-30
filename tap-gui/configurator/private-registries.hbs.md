# Configure the Configurator with a private registry

If you have plug-ins stored in a private registry that you want to include in your customized
Tanzu Developer Portal, you can configure Configurator in the `tdp-config.yaml` file.

> **Caution** This feature is in the alpha stage. Do not use this feature in a production
> environment.

## <a id="methods"></a> Methods

Use one of two methods to configure Configurator:

- Provide the private registry token in the `tpb` configuration
- Store the private registry token in a secret

tpb config method
: This method makes your credentials Base64-encoded in the workload definition.
  Therefore, use this method with caution.

  1. In your `tdp-config.yaml` file, add a `registry.uplinks` section to include your private
     registry. Include the `auth` property to the `registry.uplinks` section, as seen in the
     [Verdaccio documentation](https://verdaccio.org/docs/uplinks/#auth-property).

  2. Use an authentication token with the uplink by using one of three methods:

     - Use the default environment variable
     - Use a specified custom environment variable
     - Directly specify a token in the configuration file

     You cannot create an uplink with the name `tpb` or `npmjs` because these packages are reserved
     and cannot be overridden.

  3. In your `tdp-config.yaml` file, add a `registry.packages` section. This section lists access
     rules for different packages. For more information about this section, see the
     [Verdaccio documentation](https://verdaccio.org/docs/packages/).
     You cannot create a package with the name `@tpb/*` because these packages are reserved and
     cannot be overridden.

     Here is a full example that directly specifies the authentication token in the configuration file:

     ```yaml
     registry:
       uplinks:
         private-registry:
           url: PRIVATE-REGISTRY-ENDPOINT
           auth:
             type: bearer
             token: VALID-TOKEN-FOR-PRIVATE-REGISTRY
       packages:
         '@company/*':
           access: $all
           proxy: private-registry
     app:
       plugins:
         - name: '@tpb/plugin-hello-world'
     backend:
       plugins:
         - name: '@tpb/plugin-hello-world-backend'
     ```

     This configuration instructs to download any package with the scope `@company` from the
     `private-registry` registry with the specified credentials.

secret method
: This method is more appropriate if you don't want the registry token to appear in the workload.
  It is based on the secrets mechanism available in Kubernetes.

  1. Create a secret resource that will contain the private registry token. For example:

     ```yaml
     apiVersion: v1
     kind: Secret
     metadata:
       namespace: DEVELOPER-NAMESPACE
       name: private-registry
     data:
       registry_token: A-TOKEN
     ```

     Where `A-TOKEN` is the token value encoded in Base64.

  2. In your `tdp-config.yaml` file, add a `registry.uplinks` section to include your private
     registry. Add the `auth` property to the `registry.uplinks` section, as seen in the
     [Verdaccio documentation](https://verdaccio.org/docs/uplinks/#auth-property),
     to use an authentication token with an uplink.

     You cannot create an uplink with the name `tpb` or `npmjs` because these uplinks are reserved
     and cannot be overridden.

  3. In your `tdp-config.yaml` file, add a `registry.packages` section. This section lists access
     rules for different packages. For more information about this section, see the
     [Verdaccio documentation](https://verdaccio.org/docs/packages/).

     You cannot create a package with the name `@tpb/*` because these packages are reserved and cannot
     be overridden.

     Here is the full example that uses a `NPM_TOKEN` environment variable:

     ```yaml
     registry:
       uplinks:
         private:
           url: PRIVATE-REGISTRY-ENDPOINT
           auth:
             type: bearer
             token_env: NPM_TOKEN
       packages:
         '@company/*':
           access: $all
           proxy: private
     app:
       plugins:
         - name: '@company/company-plugin'
     backend:
       plugins:
         - name: '@company/company-plugin-backend'
     ```

     This configuration instructs to download any package with the scope `@company` from the
     `private-registry` registry with the specified credentials.

  4. Populate the environment variable value with the secret value in the workload file:

     ```yaml
     apiVersion: carto.run/v1alpha1
     kind: Workload
     # ... remaining of the workload file
     spec:
       build:
         env:
           - name: NPM_TOKEN
             valueFrom:
               secretKeyRef:
                 key: registry_token
                 name: private-registry
     # ... remaining of the workload file
     ```

## <a id="redir-npm-reqs"></a> (Optional) Redirect all the npm requests to a private registry

By default, Configurator redirects all the external requests to `npmjs`. If, for some reason,
you need to redirect those requests to your private registry, edit the `registry.packages` section
as follows:

```yaml
registry:
  uplinks:
    private:
      url: PRIVATE-REGISTRY-ENDPOINT
      auth:
        type: bearer
        token_env: NPM_TOKEN
  packages:
    '**':
      access: $all
      proxy: private
```
