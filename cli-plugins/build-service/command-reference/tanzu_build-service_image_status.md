## tanzu build-service image status

Display status of an image resource

### Synopsis

Prints detailed information about the status of a specific image resource in the provided namespace.

The namespace defaults to the kubernetes current-context namespace.

```
tanzu build-service image status <name> [flags]
```

### Examples

```
tanzu build-service image status my-image
tanzu build-service image status my-other-image -n my-namespace
```

### Options

```
  -h, --help               help for status
  -n, --namespace string   kubernetes namespace
```

### SEE ALSO

* [tanzu build-service image](tanzu_build-service_image.md)	 - Image commands

