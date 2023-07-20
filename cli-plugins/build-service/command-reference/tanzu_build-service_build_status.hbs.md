# tanzu build-service build status

This command displays the status for an image resource build.

## Synopsis

Prints detailed information about the status of a specific build of an image resource in the provided namespace.

The build defaults to the latest build number.
The namespace defaults to the kubernetes current-context namespace.

```console
tanzu build-service build status <image-name> [flags]
```

## Examples

```console
tanzu build-service build status my-image
tanzu build-service build status my-image -b 2 -n my-namespace
```

## Options

```console
  -b, --build string       build number
  -h, --help               help for status
  -n, --namespace string   kubernetes namespace
```

## SEE ALSO

* [tanzu build-service build](tanzu_build-service_build.md)	 - Build Commands
