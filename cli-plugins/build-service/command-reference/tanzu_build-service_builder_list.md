## tanzu build-service builder list

List available builders

### Synopsis

Prints a table of the most important information about the available builders in the provided namespace.

The namespace defaults to the kubernetes current-context namespace.

```
tanzu build-service builder list [flags]
```

### Examples

```
tanzu build-service builder list
tanzu build-service builder list -n my-namespace
```

### Options

```
  -h, --help               help for list
  -n, --namespace string   kubernetes namespace
```

### SEE ALSO

* [tanzu build-service builder](tanzu_build-service_builder.md)	 - Builder Commands

