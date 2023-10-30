# Configure the Configurator with a private registry

If you have plug-ins stored in a private registry that you want to include in your customized
Tanzu Developer Portal, you can configure Configurator in the `tdp-config.yaml` file.

> **Caution** This feature is in the alpha stage. Do not use this feature in a production
> environment.

## <a id="methods"></a> Methods

Use one of two methods to configure Configurator:

- Provide the private registry token in the tpb configuration
- Store the private registry token in a secret

tpb config method
: This method makes your credentials base64-encoded in the workload definition.
  Therefore, use this method with caution.

  1. In your `tdp-config.yaml` file, add a `registry.uplinks` section to include your private
     registry. Include the `auth` property detailed [here](https://verdaccio.org/docs/uplinks/#auth-property)
     to use an auth token with an uplink. You can do this using the default environment variable, a
     specified custom environment variable, or by directly specifying a token in the configuration
     file. Note: you cannot create an uplink with the names `tpb` or `npmjs` as these packages are
     reserved and cannot be overriden.

  2. In your `tdp-config.yaml` file, add a `registry.packages` section. This section lists access
     rules for different packages. More details about this section can be found
     [here](https://verdaccio.org/docs/packages/).
     You cannot create a package with the names `@tpb/*` as these packages are reserved and
     cannot be overriden.

     Here is a full example that directly specifies the auth token in the configuration file:

     ```yaml
     registry:
       uplinks:
         private-registry:
           url: <private-registry-endpoint>
           auth:
             type: bearer
             token: <valid-token-for-private-registry>
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

     This configuration is telling to download any package with scope `@company` from the
     `private-registry` registry with the specified credentials.

secret method
: This method is more appropriate if you don't want the registry token to appear in the workload.
  It is based on the secrets mechanism available in Kubernetes.

  1. Create a secret resource that will contain the private registry token. For example:

     ```yaml
     apiVersion: v1
     kind: Secret
     metadata:
       namespace: <developer-namespace>
       name: private-registry
     data:
       registry_token: <a-token>
     ```

     Where `<a-token>` is the token value encoded in Base 64.

  2. In your `tdp-config.yaml` file, add a `registry.uplinks` section to include your private
     registry. Include the `auth` property detailed [here](https://verdaccio.org/docs/uplinks/#auth-property)
     to use an auth token with an uplink. In the following example, we specified the environment
     variable that will contain the token value to be `NPM_TOKEN`. Note: you cannot create an uplink
     with the names `tpb` or `npmjs` as these uplinks are reserved and cannot be overriden.

  3. In your `tdp-config.yaml` file, add a `registry.packages` section. This section lists access
     rules for different packages. More details about this section can be found
     [here](https://verdaccio.org/docs/packages/).
     You cannot create a package with the names `@tpb/*` as these packages are reserved and cannot
     be overriden.

     Here is the full example that uses the NPM_TOKEN environment variable:

     ```yaml
     registry:
       uplinks:
         private:
           url: <private-registry-endpoint>
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

     This configuration is telling to download any package with scope `@company` from the
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

By default, the configurator redirects all the external requests to `npmjs`. If, for some
reason, you need to redirect those requests to your private registry, here is how it can be done:

```yaml
registry:
  uplinks:
    private:
      url: <private-registry-endpoint>
      auth:
        type: bearer
        token_env: NPM_TOKEN
  packages:
    '**':
      access: $all
      proxy: private
```