# Migrate to the PHP Cloud Native Buildpack

This topic tells you how to migrate your PHP app from using a Cloud Foundry buildpack for Tanzu Application Service
(commonly known as TAS for VMs) to using a Cloud Native Buildpack for Tanzu Application Platform (commonly known as TAP).

## <a id="php-config"></a> PHP configuration

This section describes how you change PHP configurations when migrating from Tanzu Application Service
to Tanzu Application Platform.

### <a id="versions"></a> Install specific PHP versions

The following table compares how Tanzu Application Service and Tanzu Application Platform deal with
installing specific versions.

| Feature                                                                                       | Tanzu Application Service | Tanzu Application Platform |
| --------------------------------------------------------------------------------------------- | ------------------------- | -------------------------- |
| Detects version from `composer.lock`                                                          | ✅                        | ✅                         |
| Detects version from `composer.json`: </br><pre>"require": {</br>  "php": ">=8.0"</br>}</pre> | ✅                        | ✅                         |
| Override app-based version detection                                                          | Use `options.json`        | Use `$BP_PHP_VERSION`      |

### <a id="override-version-tas"></a> Tanzu Application Service: Override version detection

Tanzu Application Service buildpacks allows you to specify a PHP version using a `options.json` file.

Example `options.json`:

```json
{
    "PHP_VERSION": "7.34.5"
}
```

The Tanzu Application Service `options.json` supports providing the exact version to use, or specifying
a more general minor version line to use such as `PHP_80_LATEST` instead of `8.0.1`.

### <a id="override-version-tap"></a> Tanzu Application Platform: Override version detection

In Tanzu Application Platform, set the `$BP_PHP_VERSION` environment variable to specify which version
of the PHP distribution to install.

Example `spec` section from a `workload.yaml`:

```yaml
---
spec:
  build:
    env:
    - name: BP_PHP_VERSION
      value: 8.0.0
```

### <a id="php-library-directory"></a> Configure the PHP library directory

The following table compares how you configure the PHP library directory for Tanzu Application Service
and Tanzu Application Platform.

| Feature                   | Tanzu Application Service | Tanzu Application Platform |
| ------------------------- | ------------------------- | -------------------------- |
| Set PHP library directory | Use `options.json`        | Use `$BP_PHP_LIB_DIR`      |

#### <a id="php-library-directory-tas"></a> Tanzu Application Service: Configure the PHP library directory

Tanzu Application Service buildpacks allow you to specify the PHP library directory using a `options.json` file.

Example `options.json`:

```json
{
    "LIBDIR": "lib"
}
```

#### <a id="php-library-directory-tap"></a> Tanzu Application Platform: Configure the PHP library directory

In Tanzu Application Platform, specify the PHP library directory by using the  `$BP_PHP_LIB_DIR`
environment variable.

Example `spec` section from a `workload.yaml`:

```yaml
---
spec:
  build:
    env:
    - name: BP_PHP_LIB_DIR
      value: lib
```

### <a id="custom-ini-file"></a> Configure a custom `.ini` file

In Tanzu Application Service and Tanzu Application Platform, you can configure custom `.ini` files
in addition to the default `php.ini` provided.

The following table compares how you configure a custom `.ini` file for Tanzu Application Service
and Tanzu Application Platform.

| Feature                               | Tanzu Application Service                              | Tanzu Application Platform               |
| ------------------------------------- | ------------------------------------------------------ | ---------------------------------------- |
| Custom `.ini` file in the application | ✅ Enabled by file in `.bp-config/php/php.ini.d/*.ini` | ✅ Enabled by file in `.php.ini.d/*.ini` |

Create an `.ini` file under `.bp-config/php/php.ini.d/FILENAME.ini` in Tanzu Application Service,
and under `.php.ini.d/FILENAME.ini` in Tanzu Application Platform.

### <a id="php-extensions"></a> Enable PHP extensions

In Tanzu Application Platform, the only extensions available to use at this time are the ones
that come with the distribution of PHP.

The following table compares how you enable PHP extensions for Tanzu Application Service
and Tanzu Application Platform.

| Feature                                                                                                                                                                                                                       | Tanzu Application Service                             | Tanzu Application Platform                |
| ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------- | ----------------------------------------- |
| Enable PHP extensions by custom `.ini` snippet                                                                                                                                                                                | ✅ Located in `.bp-config/php/php.ini.d/FILENAME.ini` | ✅ Located in `APP-ROOT/.php.ini.d/*.ini` |
| Enable PHP extensions by `composer.json`                                                                                                                                                                                      | ✅                                                    | ✅                                        |
| Enable additional custom extensions through `.extensions` directory. For more information, see the ([php-buildpack README](https://github.com/cloudfoundry/php-buildpack/blob/master/README.md#adding-extensions)) in GitHub. | ✅                                                    | ❌                                        |

#### <a id="php-extensions-ini-tas"></a> Tanzu Application Service: Enable PHP extensions by custom `.ini` file

In Tanzu Application Service, you can specify extensions in a custom `.ini` file under
`.bp-config/php/php.ini.d/FILENAME.ini` in the application.
If an extension is already present and enabled in the compiled PHP, explicitly enabling the extension
is not required in Tanzu Application Service.

For example:

```ini
extension=bz2.so
extension=curl.so
zend_extension=opcache.so
```

#### <a id="php-extensions-ini-tap"></a> Tanzu Application Platform: Enable PHP extensions by custom `.ini` file

In Tanzu Application Platform, you can enable extensions by using a custom `.ini` file snippet.
An `.ini` snippet is a valid PHP configuration file.
The buildpacks look for any user-provided snippets under `APP-ROOT/.php.ini.d/*.ini`.

For example:

```ini
extension=bz2.so
extension=curl.so
```

Alternatively, in both Tanzu Application Service and Tanzu Application Platform, if you are using
Composer as a package manager, you can specify extensions through the `composer.json` file.

For example:

```json
{
    "require": {
        "php": ">=7.1",
        "ext-bz2": "*",
        "ext-curl": "*",
    },
}
```

### <a id="profile-scripts"></a> Profile scripts

The following table compares enabling launch-time scripts for Tanzu Application Service
and Tanzu Application Platform.

| Feature                                                                                                                                                                           | Tanzu Application Service            | Tanzu Application Platform |
| --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------ | -------------------------- |
| Enable launch-time scripts ([link for more info](https://docs.vmware.com/en/VMware-Tanzu-Buildpacks/services/tanzu-buildpacks/GUID-php-php-migration.html#unsupported-workflows)) | ✅ Located in `.profile.d` directory | ❌                         |

A `.profile.d` directory containing scripts to be run just before application launch is not currently
supported in Tanzu Application Platform. These scripts are ignored during launch.

## <a id="server-config"></a> Server configuration

This section describes how you change server configurations when migrating from Tanzu Application Service
to Tanzu Application Platform.

### <a id="select-web-server"></a> Select a web server

The following table compares how you select a web server in Tanzu Application Service and
Tanzu Application Platform.

| Feature                    | Tanzu Application Service | Tanzu Application Platform |
| -------------------------- | ------------------------- | -------------------------- |
| Select a web server to use | ✅ Use `options.json`     | ✅ Use `$BP_WEB_SERVER`    |

#### <a id="select-web-server-tas"></a> Tanzu Application Service: Select a web server

Tanzu Application Service buildpacks allow you to specify which web server to use by using an `options.json` file.

Example `options.json`:

```json
{
    "WEB_SERVER": "httpd"
}
```

#### <a id="select-web-server-tap"></a> Tanzu Application Platform: Select a web server

In Tanzu Application Platform, you specify the web server by using the `$BP_WEB_SERVER` environment variable.
For more information about the web servers you can, see [Select a Web Server](https://docs.vmware.com/en/VMware-Tanzu-Buildpacks/services/tanzu-buildpacks/GUID-php-php-buildpack.html#select-a-web-server)
in the Tanzu Buildpacks documentation.

Example `spec` section from a `workload.yaml`:

```yaml
---
spec:
  build:
    env:
    - name: BP_WEB_SERVER
      value: httpd
```

### <a id="set-server-config"></a> Set server configuration

The following table compares how you set server configuration in Tanzu Application Service and
Tanzu Application Platform.

| Feature             | Tanzu Application Service    | Tanzu Application Platform                                                                  |
| ------------------- | ---------------------------- | ------------------------------------------------------------------------------------------- |
| HTTPD configuration | ✅ `.bp-config/httpd/*.conf` | ✅ `APP-DIRECTORY/.httpd.conf.d/*.conf`                                                     |
| NGINX configuration | ✅ `.bp-config/nginx/*.conf` | ✅ `APP-DIRECTORY/.nginx.conf.d/*-server.conf` OR `APP-DIRECTORY/.nginx.conf.d/*-http.conf` |
| FPM configuration   | ✅ `.bp-config/php/fpm.d`    | ✅ `APP-DIRECTORY/.php.fpm.d/*.conf.`                                                       |


#### <a id="set-server-config-tas"></a> Tanzu Application Service: Set server configuration

For Tanzu Application Service buildpacks, you can add server configuration files
under the `.bp-config` directory to override the buildpack-set configuration options.
For more information, see the [Cloud Foundry documentation](https://docs.cloudfoundry.org/buildpacks/php/gsg-php-config.html#engine-configurations).

Put these files under `.bp-config` in directories named for the relevant component,
such as `httpd` for HTTPD, `nginx` for  NGINX, and `fpm.d` for FPM configuration.

#### <a id="set-server-config-tap"></a> Tanzu Application Platform: Set server configuration

Tanzu Application Platform buildpacks also support providing custom settings
for HTTPD, NGINX and FPM that are not supported through the buildpack environment variables using
specially-named directories:

- **HTTPD:** `APP-DIRECTORY/.httpd.conf.d/*.conf`
- **NGINX:** `APP-DIRECTORY/.nginx.conf.d/*-server.conf` OR `APP-DIRECTORY/.nginx.conf.d/*-http.conf`
- **FPM:** `APP-DIRECTORY/.php.fpm.d/*.conf.`

For more information, see [Set Server Configuration](https://docs.vmware.com/en/VMware-Tanzu-Buildpacks/services/tanzu-buildpacks/GUID-php-php-buildpack.html#set-server-configuration).

### <a id="web-directory-config"></a> Configure the web directory

The following table compares how you set the web directory in Tanzu Application Service and
Tanzu Application Platform.

| Feature               | Tanzu Application Service | Tanzu Application Platform |
| --------------------- | ------------------------- | -------------------------- |
| Set the web directory | ✅ Use `options.json`     | ✅ Use `$BP_WEB_SERVER`    |


#### <a id="web-directory-config-tas"></a> Tanzu Application Service: Configure the web directory

Tanzu Application Service buildpacks allow you to specify the root directory of the files served by the web server,
relative to the root of the app, through an `options.json`, for example:

```json
{
    "WEBDIR": "htdocs"
}
```

#### <a id="web-directory-config-tap"></a> Tanzu Application Platform: Configure the web directory

In Tanzu Application Platform you specify the web directory by using the `$BP_PHP_WEB_DIR` environment variable.
For more information, see [Configure Web Directory](https://docs.vmware.com/en/VMware-Tanzu-Buildpacks/services/tanzu-buildpacks/GUID-php-php-buildpack.html#configure-web-directory)
in the Tanzu Buildpacks documentation.

Example `spec` section from a `workload.yaml`:

```yaml
---
spec:
  build:
    env:
    - name: BP_PHP_WEB_DIR
      value: htdocs
```

### <a id="start-command"></a> Set the app start command

The following table compares how you set the app start command in Tanzu Application Service and
Tanzu Application Platform.

| Feature                        | Tanzu Application Service | Tanzu Application Platform |
| ------------------------------ | ------------------------- | -------------------------- |
| Set a custom app start command | ✅ Use `options.json`     | ✅ Use Procfile            |


#### <a id="start-command-tas"></a>  Tanzu Application Service: Set the app start command

Tanzu Application Service buildpacks allow you to specify the start command for your app through an `options.json` file.

Example `options.json`:

```json
{
    "APP_START_CMD": "app.php"
}
```

#### <a id="start-comma-tap"></a> Tanzu Application Platform: Set the app start command

In Tanzu Application Platform buildpacks support setting a custom start command
for your app by using a Procfile located at the root of the application.
For more information, see [Additional Configuration](https://docs.vmware.com/en/VMware-Tanzu-Buildpacks/services/tanzu-buildpacks/GUID-php-php-buildpack.html#additional-configuration)
in the Tanzu Buildpacks documentation.

Example Procfile:

```procfile
web: php -S 0.0.0.0:"${PORT:-80}" -t htdocs && echo hi
```

### <a id="https-redirect"></a> Activate or deactivate HTTPS redirect

The following table compares how you activate or deactivate the HTTPS redirect in Tanzu Application Service and
Tanzu Application Platform.

| Feature                               | Tanzu Application Service | Tanzu Application Platform |
| ------------------------------------- | ------------------------- | -------------------------- |
| Activate or deactivate HTTPS redirect | ❌                        | ✅ Use Procfile            |


HTTPS redirect is enabled by default for NGINX and HTTPD. In Tanzu Application Platform, you can deactivate this by
setting the `$BP_PHP_ENABLE_HTTPS_REDIRECT` environment variable to `false` at build time.

Example `spec` section from a `workload.yaml`:

```yaml
---
spec:
  build:
    env:
    - name: BP_PHP_ENABLE_HTTPS_REDIRECT
      value: false
```

## <a id="composer-config"></a> Composer configuration

This section describes how you change the Composer configurations when migrating from Tanzu Application Service
to Tanzu Application Platform.

### <a id="composer-versions"></a> Install specific Composer versions

The following table compares how Tanzu Application Service and Tanzu Application Platform deal with
installing specific Composer versions.

| Feature                              | Tanzu Application Service | Tanzu Application Platform    |
| ------------------------------------ | ------------------------- | ----------------------------- |
| Override app-based version detection | ✅ Use `options.json`     | ✅ Use `$BP_COMPOSER_VERSION` |

#### <a id="composer-versions-tas"></a> Tanzu Application Service: Override Composer version detection

Tanzu Application Service buildpacks allow you to specify a Composer version using an `options.json` file.

Example `options.json`:

```json
{
    "COMPOSER_VERSION": "2.6.6"
}
```

#### <a id="composer-versions-tap"></a> Tanzu Application Service: Override Composer version detection

Tanzu Application Platform buildpacks allow you to specify Composer version by using the `$BP_COMPOSER_VERSION`
environment variable.
For more information, see [Set Composer Version](https://docs.vmware.com/en/VMware-Tanzu-Buildpacks/services/tanzu-buildpacks/GUID-php-php-buildpack.html#set-composer-version)
in the Tanzu Buildpacks documentation.

Example `spec` section from a `workload.yaml`:

```yaml
---
spec:
  build:
    env:
    - name: BP_COMPOSER_VERSION
      value: 2.6.6
```

### <a id="composer-install-options"></a> Set Composer install options

The following table compares how you set install options for Composer in Tanzu Application Service and
Tanzu Application Platform.

| Feature                                                | Tanzu Application Service | Tanzu Application Platform            |
| ------------------------------------------------------ | ------------------------- | ------------------------------------- |
| Set a list of options to be passed to Composer install | ✅ Use `options.json`     | ✅ Use `$BP_COMPOSER_INSTALL_OPTIONS` |

#### <a id="composer-install-tas"></a> Tanzu Application Service: Set Composer install options

Tanzu Application Service buildpacks allow you to specify Composer install options by using an `options.json` file.

Example `options.json`:

```json
{
    "COMPOSER_INSTALL_OPTIONS": ["--no-interaction","--no-dev","--no-progress"]
}
```

#### <a id="composer-install-tap"></a> Tanzu Application Platform: Set Composer install options

Tanzu Application Platform buildpacks allow you to specify composer install options by using the
`$BP_COMPOSER_INSTALL_OPTIONS` environment variable.
For more information, see [Set Composer Install Options](https://docs.vmware.com/en/VMware-Tanzu-Buildpacks/services/tanzu-buildpacks/GUID-php-php-buildpack.html#set-composer-install-options)
in the Tanzu Buildpacks documentation.

Example `spec` section from a `workload.yaml`:

```yaml
---
spec:
  build:
    env:
    - name: BP_COMPOSER_INSTALL_OPTIONS
      value: "--no-dev --prefer-install=auto"
```

### <a id="composer-json-path"></a> Set the `composer.json` path

The following table compares how you set the `composer.json` path in Tanzu Application Service and
Tanzu Application Platform.

| Feature                         | Tanzu Application Service | Tanzu Application Platform |
| ------------------------------- | ------------------------- | -------------------------- |
| Set a custom composer.json path | ✅ Use `$COMPOSER_PATH`   | ✅ Use `$COMPOSER`         |


#### <a id="composer-json-path-tas"></a> Tanzu Application Service: Set `composer.json` path

Tanzu Application Service buildpacks allow you to specify a `composer.json` path, relative to the project
root, using the `$COMPOSER_PATH` environment variable either through the `manifest.yml` or the cf CLI,
for example:

```console
cf set-env YOUR_APP_NAME COMPOSER_PATH "PATH_TO_COMPOSER_JSON"
```

For more information, see the [Cloud Foundry documentation](https://docs.cloudfoundry.org/buildpacks/php/gsg-php-composer.html#configuration).

#### <a id="composer-json-path-tap"></a> Tanzu Application Platform: Set `composer.json` path

Tanzu Application Platform buildpacks allow you to specify the `composer.json` path, relative to the
project root, by using the native `$COMPOSER` environment variable.
For more information, see [Set the composer.json Path](https://docs.vmware.com/en/VMware-Tanzu-Buildpacks/services/tanzu-buildpacks/GUID-php-php-buildpack.html#set-the-composer.json-path).
in the Tanzu Buildpacks documentation.

Example `spec` section from a `workload.yaml`:

```yaml
---
spec:
  build:
    env:
    - name: COMPOSER
      value: some-other-composer-json
```

### <a id="composer-env-vars"></a> Set Composer-native environment variables

The following table compares how you set Composer-native environment variables Tanzu Application Service
and Tanzu Application Platform.

| Feature                                               | Tanzu Application Service | Tanzu Application Platform                                          |
| ----------------------------------------------------- | ------------------------- | ------------------------------------------------------------------- |
| Override buildpack-set Composer environment variables | ✅ Use `options.json`     | ✅ Use `$COMPOSER_ENV-VAR-NAME`. For example: `COMPOSER_VENDOR_DIR` |

#### <a id="composer-env-vars-tas"></a> Tanzu Application Service: Set Composer-native environment variables

Tanzu Application Service buildpacks allow you to specify various Composer-native extensions using an `options.json`,
which is passed through to Composer to override the buildpack-set defaults.

Example `options.json`:

```json
{
    "COMPOSER_VENDOR_DIR": "vendor",
}
```

#### <a id="composer-env-vars-tap"></a> Tanzu Application Platform: Set Composer-native environment variables

Tanzu Application Platform buildpacks respect any Composer-native environment variables set at build-time.

Example `spec` section from a `workload.yaml`:

```yaml
---
spec:
  build:
    env:
    - name: COMPOSER_VENDOR_DIR
      value: vendor
    - name: COMPOSER_BIN_DIR
      value: some-bin-dir
    - name: COMPOSER_CACHE_DIR
      value: some-cache-dir
```

### <a id="composer-auth"></a> Supply Composer authentication

The following table compares how you supply Composer authentication in Tanzu Application Service and
Tanzu Application Platform.

| Feature                                                    | Tanzu Application Service             | Tanzu Application Platform |
| ---------------------------------------------------------- | ------------------------------------- | -------------------------- |
| Supply Composer authentication (for example, GitHub token) | ✅ Use `$COMPOSER_GIHTUB_OAUTH_TOKEN` | ✅ Use `$COMPOSER_AUTH`    |

#### <a id="composer-auth-tas"></a> Tanzu Application Service: Supply Composer authentication

Tanzu Application Service buildpacks allow you to supply Composer authentication, mainly in the form
of a Github token to bypass rate-limiting, by using an environment variable, for example:

```console
cf set-env YOUR-APP-NAME COMPOSER_GITHUB_OAUTH_TOKEN "OAUTH-TOKEN-VALUE"
```

Where:

- `YOUR-APP-NAME` is the name of your app.
- `OAUTH-TOKEN-VALUE` is the token.

For more information, see the [Cloud Foundry documentation](https://docs.cloudfoundry.org/buildpacks/php/gsg-php-composer.html).

#### <a id="composer-auth-tap"></a> Tanzu Application Platform: Supply Composer authentication

Tanzu Application Platform buildpacks respect any Composer-native environment variables set at build-time.
You can supply a GitHub token, or any other authentication supported by Composer, through the
native `COMPOSER_AUTH` environment variable.
For more information, see [Set Composer Authentication](https://docs.vmware.com/en/VMware-Tanzu-Buildpacks/services/tanzu-buildpacks/GUID-php-php-buildpack.html#set-composer-authentication).
in the Tanzu Buildpacks documentation.

Example `spec` section from a `workload.yaml`:

```yaml
---
spec:
  build:
    env:
    - name: COMPOSER_AUTH
      value: '{"github-oauth": {"github.com": "<oauthtoken>"}}'
```

## <a id="session-handlers"></a> Session Handlers

This section describes how you change session handlers when migrating from Tanzu Application Service
to Tanzu Application Platform.

### <a id="redis-memcached"></a> Enable Redis or Memcached session handler

The following table compares how you enable a Redis or Memcached session handler in Tanzu Application Service
and Tanzu Application Platform.

| Feature                                     | Tanzu Application Service  | Tanzu Application Platform |
| ------------------------------------------- | -------------------------- | -------------------------- |
| Bind session handler service to application | ✅ Use `cf create-service` | ✅ Use Service Bindings    |

#### <a id="redis-memcached-tas"></a> Tanzu Application Service: Enable session handler

In Tanzu Application Service, you can bind a Redis or Memcached instance to a PHP app using the cf CLI,
for example:

```console
$ cf create-service redis some-plan app-redis-sessions
$ cf bind-service app app-redis-sessions
$ cf restage app
```

For more information, see the [Cloud Foundry documentation](https://docs.cloudfoundry.org/buildpacks/php/gsg-php-sessions.html).

#### <a id="redis-memcached-tap"></a> Tanzu Application Platform: Enable session handler

In Tanzu Application Platform, you can configure session handlers for Redis or Memcached by using
[Service Bindings](https://docs.vmware.com/en/VMware-Tanzu-Buildpacks/services/tanzu-buildpacks/GUID-php-php-buildpack.html#enable-a-session-handler-via-service-bindings):

1. Create the service binding as a secret. For example:

    ```yaml
    ---
    apiVersion: v1
    kind: Secret
    metadata:
      name: php-redis-session
      namespace: my-apps
    type: service.binding/php-redis-session
    stringData:
      type: php-redis-session
      host: HOST # default: 127.0.0.1
    port: PORT # default: 6379
    password: PASSWORD # omitted if unset
    ```

1. Use the binding in the workload. For example:

    ```yaml
    ---
    kind: Workload
    apiVersion: carto.run/v1alpha1
    metadata:
    name: php-app
    spec:
    # ...
      params:
      - name: buildServiceBindings
        value:
          - name: php-redis-session
            kind: Secret
            apiVersion: v1
    ```

For more information on using Service Bindings in Tanzu Application Platform, see
[Configure build-time service bindings](../../tanzu-build-service/tbs-workload-config.hbs.md#service-bindings).

## <a id="new-relic"></a> New Relic

This section describes how you configure New Relic when migrating from Tanzu Application Service
to Tanzu Application Platform.

### <a id="new-relic-config"></a> Configure New Relic

| Feature                                     | Tanzu Application Service                      | Tanzu Application Platform |
| ------------------------------------------- | ---------------------------------------------- | -------------------------- |
| Bind session handler service to application | ✅ Use `$VCAP_SERVICES` or `$NEWRELIC_LICENSE` | ✅ Use Service Bindings    |

#### <a id="new-relic-config-tas"></a> Tanzu Application Service: Configure New Relic

In Tanzu Application Service, you can configure New Relic for the [PHP buildpack](https://docs.cloudfoundry.org/buildpacks/php/gsg-php-newrelic.html#configuration) either by:

- Using a Cloud Foundry service: Your `VCAP_SERVICES` environment variable must contain a service named `newrelic`.
  The `newrelic` service must contain a key named `credentials` and the `credentials` key must contain a `licenseKey`.

- Obtaining a license key and setting the value of the environment variable `NEWRELIC_LICENSE` to your
  New Relic license key in the `manifest.yml` or through the cf CLI, for example:

    ```console
    cf set-env NEWRELIC_LICENSE NEW-RELIC-LICENSE-KEY
    ```

    Where `NEW-RELIC-LICENSE-KEY` is you New Relic license key.

#### <a id="new-relic-config-tap"></a> Tanzu Application Platform: Configure New Relic

In Tanzu Application Platform, the PHP language family buildpack includes the [New Relic buildpack](https://github.com/pivotal-cf/tanzu-new-relic?tab=readme-ov-file#behavior),
which participates in a build when there is a service binding of type `NewRelic`.

To configure New Relic:

1. Create the service binding as a secret. For example:

    ```yaml
    ---
    apiVersion: v1
    kind: Secret
    metadata:
      name: new-relic
      namespace: my-apps
    type: service.binding/NewRelic
    stringData:
      type: NewRelic
    ```

1. Use the binding in the workload. For example:

    ```yaml
    ---
    kind: Workload
    apiVersion: carto.run/v1alpha1
    metadata:
    name: php-app
    spec:
    # ...
      params:
      - name: buildServiceBindings
        value:
          - name: new-relic
            kind: Secret
            apiVersion: v1
    ```
