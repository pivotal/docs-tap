# Migrate PHP buildpack

This topic tells you how to migrate your PHP app from using a Cloud Foundry buildpack for Tanzu Application Service
(commonly known as TAS for VMs) to using a Cloud Native Buildpack for Tanzu Application Platform (commonly known as TAP).

## PHP configuration

### Install specific PHP versions

| Feature                                                                                              | Tanzu Application Service | Tanzu Application Platform |
| ---------------------------------------------------------------------------------------------------- | ------------------------- | -------------------------- |
| Detects version from `composer.lock`                                                                 | ✅                        | ✅                         |
| Detects version from `composer.json`: </br><pre>"require": {</br>  "php": ">=8.0"</br>}</pre>        | ✅                        | ✅                         |
| Override app-based version detection (see Migrate from `options.json` to environment variable section) | Use `options.json`        | Use `$BP_PHP_VERSION`      |


#### Migrate from `options.json` to environment variable

##### Tanzu Application Service

TAS buildpacks allows user to specify a PHP version using a `options.json`, for example:

```json
{
    "PHP_VERSION": "7.34.5"
}
```

TAS’s `options.json` supports providing the exact version to use, OR specifying a more general minor
version line to use such as `PHP_80_LATEST` (instead of 8.0.1).

##### Tanzu Application Platform

In TAP, users set the `$BP_PHP_VERSION` environment variable to specify which version of the PHP distribution
should be installed.

Example `spec` section from a `workload.yaml`:

```yaml
---
spec:
  build:
    env:
    - name: BP_PHP_VERSION
      value: 8.0.0
```

### Configure the PHP library directory

| Feature                                                                                     | Tanzu Application Service | Tanzu Application Platform |
| ------------------------------------------------------------------------------------------- | ------------------------- | -------------------------- |
| Set PHP library directory (see Migrate from `options.json` to environment variable section) | Use `options.json`        | Use `$BP_PHP_LIB_DIR`      |

#### Migrate from `options.json` to environment variable

##### Tanzu Application Service

TAS buildpacks allow users to specify the PHP library directory using a `options.json`, For example:

```json
{
    "LIBDIR": "lib"
}
```

##### Tanzu Application Platform

TAP buildpacks allow users to specify the PHP library directory via the $BP_PHP_LIB_DIR environment variable.

Example `spec` section from a `workload.yaml`:

```yaml
---
spec:
  build:
    env:
    - name: BP_PHP_LIB_DIR
      value: lib
```

### Configure custom `.ini` file

In TAS and TAP, users can configure custom `.ini` files in addition to the default `php.ini` provided.
This is achieved by creating an `.ini` file under `.bp-config/php/php.ini.d/FILENAME.ini` in TAS,
and under `.php.ini.d/FILENAME.ini` in TAP.

| Feature                               | Tanzu Application Service                              | Tanzu Application Platform               |
| ------------------------------------- | ------------------------------------------------------ | ---------------------------------------- |
| Custom `.ini` file in the application | ✅ Enabled by file in `.bp-config/php/php.ini.d/*.ini` | ✅ Enabled by file in `.php.ini.d/*.ini` |


### Enable PHP extensions

In TAP, the only extensions available for usage at this time are the ones that come with the distribution of PHP.

| Feature                                                                                                                                                                           | Tanzu Application Service                             | Tanzu Application Platform                |
| --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------- | ----------------------------------------- |
| Enabled by custom `.ini` snippet                                                                                                                                                  | ✅ Located in `.bp-config/php/php.ini.d/FILENAME.ini` | ✅ Located in `APP-ROOT/.php.ini.d/*.ini` |
| Enabled by `composer.json`                                                                                                                                                        | ✅                                                    | ✅                                        |
| Enable additional custom extensions through `.extensions` directory ([link for more info](https://github.com/cloudfoundry/php-buildpack/blob/master/README.md#adding-extensions)) | ✅                                                    | ❌                                        |

#### Migrating custom `.ini` files

##### Tanzu Application Service

In TAS, extensions can be specified in a custom `.ini` file under `.bp-config/php/php.ini.d/FILENAME.ini`
in the application.
If an extension was already present and enabled in the compiled PHP, explicitly enabling the extension
was not required in TAS.

For example:

```ini
extension=bz2.so
extension=curl.so
zend_extension=opcache.so
```

##### Tanzu Application Platform

In TAP, extensions can be enabled via custom `.ini` file snippet. An `.ini` snippet is a valid PHP configuration file.
The buildpacks will look for any user-provided snippets under `APP-ROOT/.php.ini.d/*.ini`.

For example:

```ini
extension=bz2.so
extension=curl.so
```

Alternatively, in both TAS and TAP, if you are using composer as a package manager, you can specify
extensions through the `composer.json` file.

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

### Profile scripts

| Feature                                                                                                                                                                           | Tanzu Application Service            | Tanzu Application Platform |
| --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------ | -------------------------- |
| Enable launch-time scripts ([link for more info](https://docs.vmware.com/en/VMware-Tanzu-Buildpacks/services/tanzu-buildpacks/GUID-php-php-migration.html#unsupported-workflows)) | ✅ Located in `.profile.d` directory | ❌                         |

A `.profile.d` directory containing scripts to be run just before application launch is not currently supported in TAP.
These scripts will be ignored during launch.


## Server configuration

### Select a web server

| Feature                  | Tanzu Application Service | Tanzu Application Platform |
| ------------------------ | ------------------------- | -------------------------- |
| Select web server to use | ✅ Use `options.json`     | ✅ Use `$BP_WEB_SERVER`    |

#### Migrate from `options.json` to environment variable

##### Tanzu Application Service

TAS buildpacks allow users to specify which web server to use via an `options.json`, for example:

```json
{
    "WEB_SERVER": "httpd"
}
```

##### Tanzu Application Platform

TAP buildpacks allow users to [specify the web server](https://docs.vmware.com/en/VMware-Tanzu-Buildpacks/services/tanzu-buildpacks/GUID-php-php-buildpack.html#select-a-web-server)
by using the `$BP_WEB_SERVER` environment variable.

Example `spec` section from a `workload.yaml`:

```yaml
---
spec:
  build:
    env:
    - name: BP_WEB_SERVER
      value: httpd
```

### Set server configuration

| Feature             | Tanzu Application Service    | Tanzu Application Platform                                                                  |
| ------------------- | ---------------------------- | ------------------------------------------------------------------------------------------- |
| HTTPD configuration | ✅ `.bp-config/httpd/*.conf` | ✅ `APP-DIRECTORY/.httpd.conf.d/*.conf`                                                     |
| NGINX configuration | ✅ `.bp-config/nginx/*.conf` | ✅ `APP-DIRECTORY/.nginx.conf.d/*-server.conf` OR `APP-DIRECTORY/.nginx.conf.d/*-http.conf` |
| FPM configuration   | ✅ `.bp-config/php/fpm.d`    | ✅ `APP-DIRECTORY/.php.fpm.d/*.conf.`                                                       |


#### Migrate server configuration files

##### Tanzu Application Service

In TAS, [server configuration files](https://docs.cloudfoundry.org/buildpacks/php/gsg-php-config.html#engine-configurations)
can be added under the `.bp-config` directory to override the buildpack-set configuration options.
These files should be placed under `.bp-config` in directories named for the relevant component,
such as `httpd`, `nginx`, and `fpm.d` for HTTPD, NGINX and FPM configuration respectively.

##### Tanzu Application Platform

TAP buildpacks also support [providing custom settings](https://docs.vmware.com/en/VMware-Tanzu-Buildpacks/services/tanzu-buildpacks/GUID-php-php-buildpack.html#set-server-configuration)
for HTTPD, NGINX and FPM that are not supported through the buildpack environment variables using
specially-named directories:

- **HTTPD:** `APP-DIRECTORY/.httpd.conf.d/*.conf`
- **NGINX:** `APP-DIRECTORY/.nginx.conf.d/*-server.conf` OR `APP-DIRECTORY/.nginx.conf.d/*-http.conf`
- **FPM:** `APP-DIRECTORY/.php.fpm.d/*.conf.`

### Configure the web directory

| Feature               | Tanzu Application Service | Tanzu Application Platform |
| --------------------- | ------------------------- | -------------------------- |
| Set the web directory | ✅ Use `options.json`     | ✅ Use `$BP_WEB_SERVER`    |


#### Migrate from `options.json` to environment variable

##### Tanzu Application Service

TAS buildpacks allow users to specify the root directory of the files served by the web server
(relative to the root of the app) through an `options.json`, for example:

```json
{
    "WEBDIR": "htdocs"
}
```

##### Tanzu Application Platform

TAP buildpacks allow users to [specify this directory](https://docs.vmware.com/en/VMware-Tanzu-Buildpacks/services/tanzu-buildpacks/GUID-php-php-buildpack.html#configure-web-directory)
by using the `$BP_PHP_WEB_DIR` environment variable.

Example `spec` section from a `workload.yaml`:

```yaml
---
spec:
  build:
    env:
    - name: BP_PHP_WEB_DIR
      value: htdocs
```

### Set the app start command

| Feature                        | Tanzu Application Service | Tanzu Application Platform |
| ------------------------------ | ------------------------- | -------------------------- |
| Set a custom app start command | ✅ Use `options.json`     | ✅ Use Procfile            |


#### Migration from `options.json` to Procfile

##### Tanzu Application Service

TAS buildpacks allow you to specify the start command for your app through an `options.json`, for example:

```json
{
    "APP_START_CMD": "app.php"
}
```

##### Tanzu Application Platform

TAP buildpacks support setting a [custom start command](https://docs.vmware.com/en/VMware-Tanzu-Buildpacks/services/tanzu-buildpacks/GUID-php-php-buildpack.html#additional-configuration)
for your app by using a Procfile located at the root of the application.

Example Procfile:

```procfile
web: php -S 0.0.0.0:"${PORT:-80}" -t htdocs && echo hi
```

### Activate or deactivate HTTPS redirect

| Feature                               | Tanzu Application Service | Tanzu Application Platform |
| ------------------------------------- | ------------------------- | -------------------------- |
| Activate or deactivate HTTPS redirect | ❌                        | ✅ Use Procfile            |


HTTPS redirect is enabled by default for nginx and httpd. In TAP, you can deactivate this by
setting the `$BP_PHP_ENABLE_HTTPS_REDIRECT` environment variable to false at build time.

Example `spec` section from a `workload.yaml`:

```yaml
---
spec:
  build:
    env:
    - name: BP_PHP_ENABLE_HTTPS_REDIRECT
      value: false
```

## Composer Configuration

### Install Specific Composer Versions

| Feature                              | Tanzu Application Service | Tanzu Application Platform    |
| ------------------------------------ | ------------------------- | ----------------------------- |
| Override app-based version detection | ✅ Use `options.json`     | ✅ Use `$BP_COMPOSER_VERSION` |

#### Migrate from `options.json` to environment variable

##### Tanzu Application Service

TAS buildpacks allow you to specify a composer version using a `options.json`, for example:

```json
{
    "COMPOSER_VERSION": "2.6.6"
}
```

##### Tanzu Application Platform

TAP buildpacks allow you to [specify composer version](https://docs.vmware.com/en/VMware-Tanzu-Buildpacks/services/tanzu-buildpacks/GUID-php-php-buildpack.html#set-composer-version)
by using the `$BP_COMPOSER_VERSION` environment variable.

Example `spec` section from a `workload.yaml`:

```yaml
---
spec:
  build:
    env:
    - name: BP_COMPOSER_VERSION
      value: 2.6.6
```

### Set composer install options

| Feature                                                | Tanzu Application Service | Tanzu Application Platform            |
| ------------------------------------------------------ | ------------------------- | ------------------------------------- |
| Set a list of options to be passed to composer install | ✅ Use `options.json`     | ✅ Use `$BP_COMPOSER_INSTALL_OPTIONS` |


#### Migration from `options.json` to environment variable

##### Tanzu Application Service

TAS buildpacks allow you to specify composer install options by using an `options.json`, for example:

```json
{
    "COMPOSER_INSTALL_OPTIONS": ["--no-interaction","--no-dev","--no-progress"]
}
```

##### Tanzu Application Platform

TAP buildpacks allow you to [specify composer install options](https://docs.vmware.com/en/VMware-Tanzu-Buildpacks/services/tanzu-buildpacks/GUID-php-php-buildpack.html#set-composer-install-options)
by using the `$BP_COMPOSER_INSTALL_OPTIONS` environment variable.

Example `spec` section from a `workload.yaml`:

```yaml
---
spec:
  build:
    env:
    - name: BP_COMPOSER_INSTALL_OPTIONS
      value: "--no-dev --prefer-install=auto"
```

### Set the `composer.json` path

| Feature                         | Tanzu Application Service | Tanzu Application Platform |
| ------------------------------- | ------------------------- | -------------------------- |
| Set a custom composer.json path | ✅ Use `$COMPOSER_PATH`   | ✅ Use `$COMPOSER`         |


#### Migration from options.json to environment variable

##### Tanzu Application Service

TAS buildpacks allow you to [specify a composer.json path](https://docs.cloudfoundry.org/buildpacks/php/gsg-php-composer.html#configuration)
(relative to the project root) using the `$COMPOSER_PATH` environment variable either through the `manifest.yml`
or the cf CLI, for example:

```console
cf set-env YOUR_APP_NAME COMPOSER_PATH "PATH_TO_COMPOSER_JSON"
```

##### Tanzu Application Platform

TAP buildpacks allow you to [specify the composer.json](https://docs.vmware.com/en/VMware-Tanzu-Buildpacks/services/tanzu-buildpacks/GUID-php-php-buildpack.html#set-the-composer.json-path)
path (relative to the project root) by using the native `$COMPOSER` environment variable.

Example `spec` section from a `workload.yaml`:

```yaml
---
spec:
  build:
    env:
    - name: COMPOSER
      value: some-other-composer-json
```

### Set Composer-native environment variables

| Feature                                                                                                                   | Tanzu Application Service | Tanzu Application Platform                                          |
| ------------------------------------------------------------------------------------------------------------------------- | ------------------------- | ------------------------------------------------------------------- |
| Override buildpack-set Composer environment variables (see Migrate from `options.json` to environment variable section) | ✅ Use `options.json`     | ✅ Use `$COMPOSER_ENV-VAR-NAME`. For example: `COMPOSER_VENDOR_DIR` |


#### Migration from options.json to environment variable

##### Tanzu Application Service

TAS buildpacks allow you to specify various Composer-native extensions using an `options.json`,
which is passed through to Composer to override the buildpack-set defaults, for example:

```json
{
    "COMPOSER_VENDOR_DIR": "vendor",
}
```

##### Tanzu Application Platform

TAP buildpacks respect any Composer-native environment variables set at build-time.

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

### Supply Composer authentication

| Feature                                                                                                                        | Tanzu Application Service             | Tanzu Application Platform |
| ------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------- | -------------------------- |
| Supply Composer authentication (for example, GitHub token) (see Migration from `options.json` to environment variable section) | ✅ Use `$COMPOSER_GIHTUB_OAUTH_TOKEN` | ✅ Use `$COMPOSER_AUTH`    |


#### Migration to `COMPOSER_AUTH` variable

##### Tanzu Application Service

TAS buildpacks allow you to [supply Composer authentication](https://docs.cloudfoundry.org/buildpacks/php/gsg-php-composer.html)
(mainly in the form of a Github token to bypass rate-limiting) by using an environment variable, for example:

```console
cf set-env YOUR_APP_NAME COMPOSER_GITHUB_OAUTH_TOKEN "OAUTH_TOKEN_VALUE"
```

##### Tanzu Application Platform

TAP buildpacks respect any Composer-native environment variables set at build-time.
Thus, it is possible to supply a GitHub token (or any other authentication supported by Composer) through the
[native COMPOSER_AUTH environment variable](https://docs.vmware.com/en/VMware-Tanzu-Buildpacks/services/tanzu-buildpacks/GUID-php-php-buildpack.html#set-composer-authentication).

Example `spec` section from a `workload.yaml`:

```yaml
---
spec:
  build:
    env:
    - name: COMPOSER_AUTH
      value: '{"github-oauth": {"github.com": "<oauthtoken>"}}'
```

## Session Handlers

### Enable Redis or Memcached session handler

| Feature                                     | Tanzu Application Service  | Tanzu Application Platform |
| ------------------------------------------- | -------------------------- | -------------------------- |
| Bind session handler service to application | ✅ Use `cf create-service` | ✅ Use Service Bindings    |

#### Migrate to service bindings

##### Tanzu Application Service

In TAS, a Redis or Memcached instance can be bound to a PHP app [using the cf cli](https://docs.cloudfoundry.org/buildpacks/php/gsg-php-sessions.html),
for example:

```console
$ cf create-service redis some-plan app-redis-sessions
$ cf bind-service app app-redis-sessions
$ cf restage app
```

##### Tanzu Application Platform

In TAP, you can configure session handlers for Redis or Memcached by using [Service Bindings](https://docs.vmware.com/en/VMware-Tanzu-Buildpacks/services/tanzu-buildpacks/GUID-php-php-buildpack.html#enable-a-session-handler-via-service-bindings):

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

For more information on using Service Bindings in TAP, see [Configure build-time service bindings](../../tanzu-build-service/tbs-workload-config.hbs.md#service-bindings).

## New Relic

### Configure New Relic

| Feature                                     | Tanzu Application Service                      | Tanzu Application Platform |
| ------------------------------------------- | ---------------------------------------------- | -------------------------- |
| Bind session handler service to application | ✅ Use `$VCAP_SERVICES` or `$NEWRELIC_LICENSE` | ✅ Use Service Bindings    |

#### Migration to service bindings

##### Tanzu Application Service

In TAS, you can configure New Relic for the [PHP buildpack](https://docs.cloudfoundry.org/buildpacks/php/gsg-php-newrelic.html#configuration) either by:

- Using a Cloud Foundry service: Your `VCAP_SERVICES` environment variable must contain a service named `newrelic`,
  the `newrelic` service must contain a key named `credentials`, and the `credentials` key must contain a `licenseKey`.

- Obtaining a license key and setting the value of the environment variable `NEWRELIC_LICENSE` to your
  New Relic license key in manifest.yml or through the cf CLI, for example:

```console
$ cf set-env NEWRELIC_LICENSE <NEW-RELIC-LICENSE-KEY>
```

##### Tanzu Application Platform

In TAP, the PHP language family buildpack includes the [New Relic buildpack](https://github.com/pivotal-cf/tanzu-new-relic?tab=readme-ov-file#behavior),
which participates in a build provided there is a service binding of type `NewRelic`.

To configure Nes Relic:

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
