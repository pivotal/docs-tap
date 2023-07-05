## tanzu build-service image trigger

Trigger an image resource build

### Synopsis

Trigger a build using current inputs for a specific image resource in the provided namespace.

The namespace defaults to the kubernetes current-context namespace.

```
tanzu build-service image trigger <name> [flags]
```

### Examples

```
tanzu build-service image trigger my-image
```

### Options

```
  -h, --help               help for trigger
  -n, --namespace string   kubernetes namespace
```

### SEE ALSO

* [tanzu build-service image](tanzu_build-service_image.md)	 - Image commands

