## tanzu build-service clusterbuildpack status

Display status of a buildpack

### Synopsis

Prints detailed information about the status of a specific buildpack in the provided namespace.

The namespace defaults to the kubernetes current-context namespace.

```
tanzu build-service clusterbuildpack status <name> [flags]
```

### Examples

```
tanzu build-service clusterbuildpack status my-buildpack
```

### Options

```
  -h, --help               help for status
  -n, --namespace string   kubernetes namespace
```

### SEE ALSO

* [tanzu build-service clusterbuildpack](tanzu_build-service_clusterbuildpack.md)	 - ClusterBuildpack Commands

