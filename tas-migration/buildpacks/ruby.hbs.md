# Migrate to the Ruby Cloud Native Buildpack

This topic tells you how to migrate your Ruby app from using a Cloud Foundry buildpack for Tanzu Application Service
(commonly known as TAS for VMs) to using a Cloud Native Buildpack for Tanzu Application Platform (commonly known as TAP).

## <a id="versions"></a> Specifying the Ruby version to install

The following table compares how Tanzu Application Service and Tanzu Application Platform handle
installing specific Ruby versions.

| Feature                                                  | Tanzu Application Service | Tanzu Application Platform |
| -------------------------------------------------------- | ------------------------- | -------------------------- |
| Detects version from `Gemfile`</br>`ruby '~> <version>'` | ✅                        | ✅                         |
| Detects version from `$BP_MRI_VERSION` env var           | ❌                        | ✅                         |

### <a id="override-version-tas"></a> Tanzu Application Service: Override version detection

Specifying the version to install is not supported.

### <a id="override-version-tap"></a> Tanzu Application Platform: Override version detection

In Tanzu Application Platform, set the `$BP_MRI_VERSION` environment variable to specify which version
of Ruby MRI to install. You can set the version to any valid semver version or version constraint,
for example, `2.7.4` or `2.7.*`.
The buildpack automatically installs an Ruby MRI version that is compatible with the selected version.

Example `spec` section from a `workload.yaml`:

```yaml
---
spec:
  build:
    env:
    - name: BP_MRI_VERSION
      value: 3.2.*
  source:
    git:
      ref:
        branch: master
      url: https://github.com/cloudfoundry/ruby-buildpack
    subPath: fixtures/bundler_2
```

## <a id="bundler-versions"></a> Specifying the Bundler version to install

The following table compares how Tanzu Application Service and Tanzu Application Platform handle
installing specific Bundler versions.

| Feature                                                         | Tanzu Application Service | Tanzu Application Platform |
| --------------------------------------------------------------- | ------------------------- | -------------------------- |
| Detects version from Gemfile.lock</br>`BUNDLED_WITH <version>'` | ✅                        | ✅                         |
| Detects version from `$BP_BUNDLER_VERSION` env var              | ❌                        | ✅                         |

## <a id="jruby-versions"></a> Specifying the Jruby version to install

Specifying the Jruby version is not supported in Tanzu Application Platform.

| Feature                      | Tanzu Application Service | Tanzu Application Platform |
| ---------------------------- | ------------------------- | -------------------------- |
| Detects version from Gemfile | ✅                        | ❌                         |

## <a id="vendoring"></a> Vendor in app dependencies before a build

The following table compares vendoring app dependencies before a build for Tanzu Application Service
and Tanzu Application Platform.

| Feature                                                           | Tanzu Application Service | Tanzu Application Platform |
| ----------------------------------------------------------------- | ------------------------- | -------------------------- |
| Packages in the default cache location</br>`bundle package --all` | ✅                        | ✅                         |
| Packages in a non-default cache location                          | ❌                        | ✅                         |

### <a id="migrate-vendoring"></a> Migration to vendoring gems in a non-default cache location

In Tanzu Application Platform, you can vendor in your app dependencies before a build.
To do this, put all `.gem` files into the custom path inside the app source code, for example, `custom_dir/custom_cache`.
Then, create a `.bundle/config` file with the `BUNDLE_CACHE_PATH` setting configured:

```
---
BUNDLE_CACHE_PATH: "custom_dir/custom_cache"
```

## <a id="rake-config"></a> Configure Rake tasks

The following table compares how to configure rake tasks with Tanzu Application Service and
Tanzu Application Platform.

| Feature                       | Tanzu Application Service | Tanzu Application Platform |
| ----------------------------- | ------------------------- | -------------------------- |
| Non-default Rake task support | ✅                        | ✅                         |
| Default Rake task support     | ❌                        | ✅                         |

### <a id="invoke-rake-tas"></a> Tanzu Application Service: Invoke Rake tasks

In Tanzu Application Service, you can automatically invoke a Rake task as follows:

1. Include a `.rake` file containing a Rake task in `lib/tasks`. For example:

    ```ruby
    namespace :cf do
        desc "Only run on the first application instance"
        task :on_first_instance do
            instance_index = JSON.parse(ENV["VCAP_APPLICATION"])["instance_index"] rescue nil
        exit(0) unless instance_index == 0
        end
    end
    ```

1. Add the task to the `manifest.yml` with the command attribute to use this as the start command. For example:

    ```yaml
    applications:
    - name: my-app
      command: bundle exec rake cf:on_first_instance db:migrate
    ```

### <a id="invoke-rake-tap"></a> Tanzu Application Platform: Invoke Rake tasks

In Tanzu Application Platform, you still specify a Rake task, but it goes in a Rakefile in the root
of the application directory.
Then, the buildpacks automatically set the default Rake task as the start command.

- If you specify a default Rake task, this is the task executed by the buildpack.
- If you specify a non-default Rake task, use the Procfile Buildpack by including the start
  command for the non-default task in a Procfile file. Set as the web process, for example:

    ```
    web: bundle exec rake non_default
    ```

## <a id="build-rails-app"></a> Building a Rails application

The following table compares building a rails app on Tanzu Application Service and Tanzu Application Platform.

| Feature                      | Tanzu Application Service | Tanzu Application Platform |
| ---------------------------- | ------------------------- | -------------------------- |
| Building a Rails application | ✅                        | ✅                         |

Building Rails applications is supported on both Tanzu Application Service and Tanzu Application Platform.
In both cases, you must specify the rails gem in the Gemfile.

In Tanzu Application Platform, one of the following asset directories must also be present in the application source code:

- `app/assets`
- `lib/assets`
- `vendor/assets`
- `app/javascript`

## <a id="supported-web-servers"></a> Supported web servers

The following table compares supported web servers for Tanzu Application Service and Tanzu Application Platform.

| Feature      | Tanzu Application Service                                   | Tanzu Application Platform |
| ------------ | ----------------------------------------------------------- | -------------------------- |
| Rake         | ✅                                                          | ✅                         |
| Thin         | ✅                                                          | ✅                         |
| Rackup       | ✅                                                          | ✅                         |
| Rails Server | ✅                                                          | ✅                         |
| Puma         | ✅                                                          | ✅                         |
| Unicorn      | ❌ requires custom start command through the `manifest.yml` | ✅                         |
| Passenger    | ❌                                                          | ✅                         |

## <a id="supported dependencies"></a>Supported dependencies

The following table compares supported dependencies for Tanzu Application Service and Tanzu Application Platform.

| Feature   | Tanzu Application Service | Tanzu Application Platform |
| --------- | ------------------------- | -------------------------- |
| Bundler   | ✅                        | ✅                         |
| Ruby      | ✅                        | ✅                         |
| Node      | ✅                        | ✅                         |
| Yarn      | ✅                        | ✅                         |
| Jruby     | ✅                        | ❌                         |
| OpenJDK   | ✅                        | ❌                         |
| Ruby Gems | ✅                        | ❌                         |
