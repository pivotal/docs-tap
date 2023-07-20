# tanzu build-service buildpack list

This command lists available buildpacks.

## Synopsis

Prints a table of the most important information about the available buildpacks in the provided namespace.

The namespace defaults to the kubernetes current-context namespace.

```console
tanzu build-service buildpack list [flags]
```

## Examples

```console
tanzu build-service buildpack list
tanzu build-service buildpack list -n my-namespace
```

## Options

```console
  -h, --help               help for list
  -n, --namespace string   kubernetes namespace
```

## SEE ALSO

* [tanzu build-service buildpack](tanzu_build-service_buildpack.md)	 - Buildpack Commands