## tanzu build-service image list

List image resources

### Synopsis

Prints a table of the most important information about image resources in the provided namespace.

The namespace defaults to the kubernetes current-context namespace.

```
tanzu build-service image list [flags]
```

### Examples

```
tanzu build-service image list
tanzu build-service image list -A
tanzu build-service image list -n my-namespace
tanzu build-service image list --filter ready=true --filter latest-reason=commit,trigger
```

### Options

```
  -A, --all-namespaces       Return objects found in all namespaces
      --filter stringArray   Each new filter argument requires an additional filter flag.
                             Multiple values can be provided using comma separation.
                             Supported filters and values:
                               builder=string
                               clusterbuilder=string
                               latest-reason=commit,trigger,config,stack,buildpack
                               ready=true,false,unknown
  -h, --help                 help for list
  -n, --namespace string     kubernetes namespace
```

### SEE ALSO

* [tanzu build-service image](tanzu_build-service_image.md)	 - Image commands

