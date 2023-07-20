# tanzu build-service image trigger

This command trigger an image resource build.

## Synopsis

Trigger a build using current inputs for a specific image resource in the provided namespace.

The namespace defaults to the kubernetes current-context namespace.

```console
tanzu build-service image trigger <name> [flags]
```

## Examples

```console
tanzu build-service image trigger my-image
```

## Options

```console
  -h, --help               help for trigger
  -n, --namespace string   kubernetes namespace
```

## SEE ALSO

* [tanzu build-service image](tanzu_build-service_image.hbs.md)	 - Image commands
