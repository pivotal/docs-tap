# Migrate to the Go Cloud Native Buildpack

This topic tells you how to migrate your Go app from using a Cloud Foundry buildpack for Tanzu Application Service
(commonly known as TAS for VMs) to using a Cloud Native Buildpack for Tanzu Application Platform (commonly known as TAP).

## <a id="versions"></a>Install a specific Go version

The following table compares how Tanzu Application Service and Tanzu Application Platform deals with
installing specific versions.

| Feature                              | Tanzu Application Service | Tanzu Application Platform |
| ------------------------------------ | ------------------------- | -------------------------- |
| Detects version from `go.mod`        | ❌                        | ✅                         |
| Override app-based version detection | Using `$GOVERSION`        | Using `$BP_GO_VERSION`     |

### <a id="override-version-tas"></a>  Tanzu Application Service: Override version detection

To instruct the buildpack to select a specific version, set the environment variable `$GOVERSION`.
For example, `$GOVERSION="go1.22"`.

### <a id="override-version-tap"></a> Tanzu Application Platform: Override version detection

To configure the version, set the environment variable `$BP_GO_VERSION` in your `workload.yaml` file.

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

### <a id="ldflags-tas"></a> Tanzu Application Service: Set LDFLAGS

In the Tanzu Application Service Go buildpack, you can only set the value of a variable when setting
linker flags, that is, the `-X` flag.

Example Tanzu Application Service `buildpack.yml`:

```yaml
---
go:
  ldflags:
    main.var1: val1
    main.var2: val2
```

### <a id="ldflags-tap"></a> Tanzu Application Platform: Set LDFLAGS

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

> **Note** The Tanzu Application Service buildpack provided a special environment variable combination to set
> one variable value, `$GO_LINKER_SYMBOL` and `$GO_LINKER_VALUE`.
> If you used this combination, use the generic Tanzu Application Platform format shown in the preceding
> snippet for migration.

## <a id="custom-build-flags"></a> Custom build flags

The Tanzu Application Service buildpack did not allow users to set custom build flags other than the
`-X ldflag`.
A build flag of `"-tags cloudfoundry -buildmode pie"` is always added to the build in Tanzu Application Service.

In Tanzu Application Platform, you can set your own build flags with `$BP_GO_BUILD_FLAGS`, for example:

```yaml
---
spec:
  build:
    env:
    - name: BP_GO_BUILD_FLAGS
       value: "-buildmode=default -tags=ilovetanzu"
```

For Static Stack in Tanzu Application Platform, unless you provide a `-buildmode` flag through `$BP_GO_BUILD_FLAGS`,
the buildpack sets `CGO_ENABLED=0` and `-buildmode=default` build flag to enable support for the static
stack by default.

## <a id="non-default-packages"></a> Build non-default packages

The following table compares how Tanzu Application Service and Tanzu Application Platform deals with
installing specific versions.

| Feature                                                    | Tanzu Application Service  | Tanzu Application Platform |
| ---------------------------------------------------------- | -------------------------- | -------------------------- |
| Set locations or targets of the Go programs to be compiled | `$GO_INSTALL_PACKAGE_SPEC` | `$BP_GO_TARGETS`           |

### <a id="non-default-packages-tas"></a> Tanzu Application Service: Build non-default packages

Example Tanzu Application Service `manifest.yml`:

```yaml
---
applications:
- name: myapp
  env:
    GO_INSTALL_PACKAGE_SPEC: "./app1 ./app2"
```

### <a id="non-default-packages-tap"></a> Tanzu Application Platform: Build non-default packages

Example `spec` section from a `workload.yaml`:

```yaml
---
spec:
  build:
    env:
    - name: BP_GO_TARGETS
       value: "./app1:./app2"
```

## <a id="pre-vendored-apps"></a> Pre-vendored apps based on Go mod

In Tanzu Application Service, you must set the `$GOPACKAGENAME` for go-mod based apps with dependencies
vendored into a vendor directory. For more information, see
the [Cloud Foundry documentation](https://docs.cloudfoundry.org/buildpacks/go/index.html#push-an-app-without-a-vendoring-tool).

In Tanzu Application Platform, this is not required because the Tanzu Application Platform Go buildpack
can auto-detect your vendor directory, and use it if it exists.

## <a id="glide-and-dep"></a>Glide and Dep based apps

The Tanzu Application Platform Go buildpack does not support programs based on Glide and Go Dep
dependency management tools.
This is because the Go community has moved towards go modules. You must update your apps to use go modules.
