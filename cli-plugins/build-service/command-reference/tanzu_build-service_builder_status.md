## tanzu build-service builder status

Display status of a builder

### Synopsis

Prints detailed information about the status of a specific builder in the provided namespace.

The namespace defaults to the kubernetes current-context namespace.

```
tanzu build-service builder status <name> [flags]
```

### Examples

```
tanzu build-service builder status my-builder
tanzu build-service builder status -n my-namespace other-builder
```

### Options

```
  -h, --help               help for status
  -n, --namespace string   kubernetes namespace
```

### SEE ALSO

* [tanzu build-service builder](tanzu_build-service_builder.md)	 - Builder Commands

