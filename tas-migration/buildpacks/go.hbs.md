# Migrate to the Go Cloud Native Buildpack

This topic tells you how to migrate your Go app from using a Cloud Foundry buildpack for Tanzu Application Service
(commonly known as TAS for VMs) to using a Cloud Native Buildpack for Tanzu Application Platform (commonly known as TAP).

<!-- do users do all these sections in order or do they choose the section for their use case -->

## <a id="versions"></a>Install a specific Go version

The following table compares how Tanzu Application Service and Tanzu Application Platform deals with
installing specific versions.

| Feature                                                                     | Tanzu Application Service | Tanzu Application Platform |
| --------------------------------------------------------------------------- | ------------------------- | -------------------------- |
| Detects version from `go.mod`                                               | ❌                        | ✅                         |
| Override app-based version detection (see Using environment variable below) | Using `$GOVERSION`          | Using `$BP_GO_VERSION`       |


### <a id="env-var"></a>Configure the environment variable


#### Tanzu Application Service

Set the environment variable, for example, `$GOVERSION="go1.22"`, to instruct the buildpack to pick
a specific version.

#### Tanzu Application Platform

Set the environment variable `$BP_GO_VERSION` to set the version.

Example `spec` section from a `workload.yaml`:

```yaml
---
spec:
  build:
    env:
    - name: BP_GO_VERSION
       value: "1.22.*"
```

## <a id="ldflags"></a> Set LDFLAGS

The following table compares how you set LDFLAGS in Tanzu Application Service and Tanzu Application Platform.

| Feature           | Tanzu Application Service                                       | Tanzu Application Platform |
| ----------------- | --------------------------------------------------------------- | -------------------------- |
| Set any LDFLAG    | ❌                                                              | `$BP_GO_BUILD_LDFLAGS`     |
| Set the -X LDFLAG | Using `buidpack.yml` OR `{$GO_LINKER_SYMBOL, $GO_LINKER_VALUE}` | `$BP_GO_BUILD_LDFLAGS`     |

In the Tanzu Application Service Go buildpack, for setting linker flags you can only
set the value of a variable, that is, the `-X` flag.

Example Tanzu Application Service `buildpack.yml`:

```yaml
---
go:
  ldflags:
    main.var1: val1
    main.var2: val2
```

In Tanzu Application Platform Go buildpack, you can set any arbitrary LDFLAG.

Example `spec` section from a `workload.yaml`:

```yaml
---
spec:
  build:
    env:
    - name: BP_GO_BUILD_LDFLAGS
       value: "-X 'main.var1=val1' -X 'main.var2=val2'"
```

The Tanzu Application Service buildpack also provided a special environment variable combination to set
just one variable value, `$GO_LINKER_SYMBOL` and `$GO_LINKER_VALUE`.
If you use this combination, use the generic Tanzu Application Platform format shown in the preceding
snippet for migration.

## <a id="custom-build-flags"></a> Custom build flags

The Tanzu Application Service buildpack did not allow users to set custom build flags other than the `-X ldflag` discussed above.
A build flag of `"-tags cloudfoundry -buildmode pie"` was always added to the build in Tanzu Application Service.
In Tanzu Application Platform, you may set your own build flags with `$BP_GO_BUILD_FLAGS`, like the following example:

```yaml
---
spec:
  build:
    env:
    - name: BP_GO_BUILD_FLAGS
       value: "-buildmode=default -tags=ilovetanzu"
```

Note that for Static Stack in Tanzu Application Platform, unless the user provides a -buildmode flag via `$BP_GO_BUILD_FLAGS`,
the buildpack sets `CGO_ENABLED=0` and `-buildmode=default` build flag to enable support for the static
stack out of the box.

## <a id="non-default-packages"></a> Build non-default packages

The following table compares how Tanzu Application Service and Tanzu Application Platform deals with
installing specific versions.

| Feature                                                    | Tanzu Application Service  | Tanzu Application Platform |
| ---------------------------------------------------------- | -------------------------- | -------------------------- |
| Set locations or targets of the Go programs to be compiled | `$GO_INSTALL_PACKAGE_SPEC` | `$BP_GO_TARGETS`           |

The following Tanzu Application Service `manifest.yml`:

```yaml
---
applications:
- name: myapp
  env:
    GO_INSTALL_PACKAGE_SPEC: "./app1 ./app2"
```

should be migrated to the following Tanzu Application Platform `workload.yaml`:

```yaml
---
spec:
  build:
    env:
    - name: BP_GO_TARGETS
       value: "./app1:./app2"
```

## <a id="pre-vendored-apps"></a> Pre-vendored apps based on Go mod

In Tanzu Application Service, users were required to set the` $GOPACKAGENAME` for go-mod based apps that had their dependencies
vendored into a vendor directory. See the [Cloud Foundry documentation](https://docs.cloudfoundry.org/buildpacks/go/index.html#push-an-app-without-a-vendoring-tool).

In Tanzu Application Platform, this is not required as the Tanzu Application Platform Go buildpack can auto-detect your vendor directory, and use
it if it exists.

## <a id="glide-and-dep"></a>Glide and Dep based apps

Programs based on Glide and Go Dep dependency management tools are not supported by the Tanzu Application Platform Go buildpack,
since the Go community has moved towards go modules. Please update your apps to use go modules.
