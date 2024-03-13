# Migrate to the Ruby Cloud Native Buildpack

This topic tells you how to migrate your Ruby app from using a Cloud Foundry buildpack for Tanzu Application Service
(commonly known as TAS for VMs) to using a Cloud Native Buildpack for Tanzu Application Platform (commonly known as TAP).

<!-- do users do all these sections in order or do they choose the section for their use case -->

## Specifying Ruby Version to Install

| Feature                                                  | TAS | TAP |
| -------------------------------------------------------- | --- | --- |
| Detects version from `Gemfile`</br>`ruby '~> <version>'` | ✅  | ✅  |
| Detects version from `$BP_MRI_VERSION` env var           | ❌  | ✅  |

### Migration to environment variable

In TAP, users set the `$BP_MRI_VERSION` environment variable to specify which version of MRI should be
installed, the version can be set to any valid semver version or version constraint (e.g. 2.7.4, 2.7.*).
The buildpack will automatically install an MRI version that is compatible with the selected version.

Here’s a the spec section from a sample `workload.yaml`:

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

## Specifying Bundler Version to Install

| Feature                                                         | TAS | TAP |
| --------------------------------------------------------------- | --- | --- |
| Detects version from Gemfile.lock</br>`BUNDLED_WITH <version>'` | ✅  | ✅  |
| Detects version from `$BP_BUNDLER_VERSION` env var              | ❌  | ✅  |

## Specifying Jruby Version to Install

This feature is not supported in TAP.

| Feature                      | TAS | TAP |
| ---------------------------- | --- | --- |
| Detects version from Gemfile | ✅  | ❌  |

## Vendoring App Dependencies Before Build

| Feature                                                           | TAS | TAP |
| ----------------------------------------------------------------- | --- | --- |
| Packages in the default cache location</br>`bundle package --all` | ✅  | ✅  |
| Packages in a non-default cache location                          | ❌  | ✅  |

### Migration to vendoring gems in a non-default cache location

In TAP, users can vendor in their app dependencies prior to a build. To do this, the user should put
all `.gem` files into the custom path inside app source code, such as `custom_dir/custom_cache`.
Then, create a `.bundle/config` file with the `BUNDLE_CACHE_PATH` setting configured:
<!-- is this ".bundle or .config" or is this ".bundle/config"? -->

```
---
BUNDLE_CACHE_PATH: "custom_dir/custom_cache"
```
<!-- what language is this snippet? -->

## Configuring Rake Tasks

| Feature                       | TAS | TAP |
| ----------------------------- | --- | --- |
| Non-default Rake task support | ✅  | ✅  |
| Default Rake task support     | ❌  | ✅  |

### Migration for Rake tasks

In TAS, users can automatically invoke a Rake task by:
Including a `.rake` file containing a Rake task in `lib/tasks`. Example:

```ruby
namespace :cf do
    desc "Only run on the first application instance"
    task :on_first_instance do
        instance_index = JSON.parse(ENV["VCAP_APPLICATION"])["instance_index"] rescue nil
    exit(0) unless instance_index == 0
    end
end
```

Add task to the `manifest.yml` with the command attribute to use this as the start command:

```yaml
applications:
- name: my-app
  command: bundle exec rake cf:on_first_instance db:migrate
```

In TAP, users still specify a Rake task, but it goes inside of a Rakefile inside of the root of the
application directory.
Then, the default Rake task will be automatically set as the start command by the buildpacks.

If a default Rake task is specified, this will be the task executed by the buildpack
If a non-default Rake task is specified:
Leverage the Procfile Buildpack by including the start command for the non-default task in a Procfile
file, set as the web process:

```
web: bundle exec rake non_default
```

## Building a Rails application

| Feature                      | TAS | TAP |
| ---------------------------- | --- | --- |
| Building a Rails application | ✅  | ✅  |

Building Rails applications is supported on both TAS and TAP. In both scenarios, the rails gem
must be specified in the Gemfile.

In TAP, one of the following asset directories must also be present in the application source code:

- `app/assets`
- `lib/assets`
- `vendor/assets`
- `app/javascript`

## Supported Web Servers

| Feature      | TAS                                                         | TAP |
| ------------ | ----------------------------------------------------------- | --- |
| Rake         | ✅                                                          | ✅  |
| Thin         | ✅                                                          | ✅  |
| Rackup       | ✅                                                          | ✅  |
| Rails Server | ✅                                                          | ✅  |
| Puma         | ✅                                                          | ✅  |
| Unicorn      | ❌ requires custom start command through the `manifest.yml` | ✅  |
| Passenger    | ❌                                                          | ✅  |

## Supported Dependencies

| Feature   | TAS | TAP |
| --------- | --- | --- |
| Bundler   | ✅  | ✅  |
| Ruby      | ✅  | ✅  |
| Node      | ✅  | ✅  |
| Yarn      | ✅  | ✅  |
| Jruby     | ✅  | ❌  |
| OpenJDK   | ✅  | ❌  |
| Ruby Gems | ✅  | ❌  |
