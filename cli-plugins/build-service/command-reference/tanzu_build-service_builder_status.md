# tanzu build-service builder status

This command displays the status of a builder.

### Synopsis

Prints detailed information about the status of a specific builder in the provided namespace.

The namespace defaults to the kubernetes current-context namespace.

```console
tanzu build-service builder status <name> [flags]
```

## Examples

```console
tanzu build-service builder status my-builder
tanzu build-service builder status -n my-namespace other-builder
```

## Options

```console
  -h, --help               help for status
  -n, --namespace string   kubernetes namespace
```

## SEE ALSO

* [tanzu build-service builder](tanzu_build-service_builder.md)	 - Builder Commands
