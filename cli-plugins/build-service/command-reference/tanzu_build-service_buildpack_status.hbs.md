# tanzu build-service buildpack status

This command displays the status of a buildpack.

## Synopsis

Prints detailed information about the status of a specific buildpack in the provided namespace.

The namespace defaults to the kubernetes current-context namespace.

```console
tanzu build-service buildpack status <name> [flags]
```

## Examples

```console
tanzu build-service buildpack status my-buildpack
tanzu build-service buildpack status -n my-namespace other-buildpack
```

## Options

```console
  -h, --help               help for status
  -n, --namespace string   kubernetes namespace
```

## SEE ALSO

* [tanzu build-service buildpack](tanzu_build-service_buildpack.hbs.md)	 - Buildpack Commands
