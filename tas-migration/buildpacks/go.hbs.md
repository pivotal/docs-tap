# Migrate Go buildpack

<!-- do users do all these sections in order or do they choose the section for their use case -->


## Install a specific Go version

| Feature                                                                     | TAS              | TAP                  |
| --------------------------------------------------------------------------- | ---------------- | -------------------- |
| Detects version from `go.mod`                                                 | ❌               | ✅                   |
| Override app-based version detection (see Using environment variable below) | Using $GOVERSION | Using $BP_GO_VERSION |


### Using environment variable

In TAS, users would set the env var `$GOVERSION="go1.22"` (example) to instruct the buildpack to pick
a specific version. In TAP, you use `$BP_GO_VERSION` just like the following example.

Here’s an excerpt from the `spec` section of a sample `workload.yaml`:

```yaml
---
spec:
  build:
    env:
    - name: BP_GO_VERSION
       value: "1.22.*"
```

## Setting LDFLAGS

| Feature           | TAS                                                             | TAP                  |
| ----------------- | --------------------------------------------------------------- | -------------------- |
| Set any ldflag    | ❌                                                              | $BP_GO_BUILD_LDFLAGS |
| Set the -X ldflag | Using `buidpack.yml` OR `{$GO_LINKER_SYMBOL, $GO_LINKER_VALUE}` | $BP_GO_BUILD_LDFLAGS |

In TAS Go buildpack, users are limited in their power to set linker flags - they only have the option
to set the value of a variable (i.e the -X flag). In TAP Go buildpack, you can set any arbitrary ldflag.

So a TAS `buildpack.yml`:

```yaml
---
go:
  ldflags:
    main.var1: val1
    main.var2: val2
```

should be migrated to TAP `workload.yaml`:

```yaml
---
spec:
  build:
    env:
    - name: BP_GO_BUILD_LDFLAGS
       value: "-X 'main.var1=val1' -X 'main.var2=val2'"
```

Note that the TAS buildpack also provided a special env variable combo to set just one variable value.
(`$GO_LINKER_SYMBOL `and `$GO_LINKER_VALUE`). If you use this combo, please use the generic TAP format
shown above for migration.


## Custom Build Flags

The TAS buildpack did not allow users to set custom build flags other than the `-X ldflag` discussed above.
A build flag of `"-tags cloudfoundry -buildmode pie"` was always added to the build in TAS.
In TAP, you may set your own build flags with `$BP_GO_BUILD_FLAGS`, like the following example:

```yaml
---
spec:
  build:
    env:
    - name: BP_GO_BUILD_FLAGS
       value: "-buildmode=default -tags=ilovetanzu"
```

Note that for Static Stack in TAP, unless the user provides a -buildmode flag via `$BP_GO_BUILD_FLAGS`,
the buildpack sets `CGO_ENABLED=0` and `-buildmode=default` build flag to enable support for the static
stack out of the box.

## Build Non-Default Package(s)


| Feature                                                       | TAS                        | TAP              |
| ------------------------------------------------------------- | -------------------------- | ---------------- |
| Set location(s)/target(s) of the go program(s) to be compiled | `$GO_INSTALL_PACKAGE_SPEC` | `$BP_GO_TARGETS` |

The following TAS `manifest.yml`:

```yaml
---
applications:
- name: myapp
  env:
    GO_INSTALL_PACKAGE_SPEC: "./app1 ./app2"
```

should be migrated to the following TAP `workload.yaml`:

```yaml
---
spec:
  build:
    env:
    - name: BP_GO_TARGETS
       value: "./app1:./app2"
```

## Pre-vendored apps based on go mod

In TAS, users were required to set the` $GOPACKAGENAME` for go-mod based apps that had their dependencies
vendored into a vendor directory. See the [Cloud Foundry documentation](https://docs.cloudfoundry.org/buildpacks/go/index.html#push-an-app-without-a-vendoring-tool).

In TAP, this is not required as the TAP Go buildpack can auto-detect your vendor directory, and use
it if it exists.

## Glide and Dep based apps

Programs based on Glide and Go Dep dependency management tools are not supported by the TAP Go buildpack,
since the Go community has moved towards go modules. Please update your apps to use go modules.
