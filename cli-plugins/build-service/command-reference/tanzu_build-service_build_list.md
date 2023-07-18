## tanzu build-service build list

List builds

### Synopsis

Prints a table of the most important information about builds in the provided namespace.

The namespace defaults to the kubernetes current-context namespace.

```
tanzu build-service build list [image-resource-name] [flags]
```

### Examples

```
tanzu build-service build list
tanzu build-service build list my-image
tanzu build-service build list my-image -n my-namespace
```

### Options

```
  -h, --help               help for list
  -n, --namespace string   kubernetes namespace
```

### SEE ALSO

* [tanzu build-service build](tanzu_build-service_build.md)	 - Build Commands

