## tanzu accelerator apply

This command creates or updates accelerators.

### Synopsis

Create or update accelerator resource using specified manifest file.

```console
tanzu accelerator apply [flags]
```

### Examples

```console
tanzu accelerator apply --filename <path-to-resource-manifest>
```

### Options

```console
  -f, --filename string    path of manifest file for the resource
  -h, --help               help for apply
  -n, --namespace string   namespace for the resource (default "accelerator-system")
```

### Options inherited from parent commands

```console
      --context name      name of the kubeconfig context to use (default is current-context defined by kubeconfig)
      --kubeconfig file   kubeconfig file (default is $HOME/.kube/config)
```

### SEE ALSO

* [tanzu accelerator](tanzu_accelerator.md)	 - Manage accelerators in a Kubernetes cluster
