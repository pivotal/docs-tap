## tanzu accelerator delete

This command deletes an accelerator.

### Synopsis

Delete the accelerator resource with the specified name.

```
tanzu accelerator delete [flags]
```

### Examples

```
tanzu accelerator delete <accelerator-name>
```

### Options

```
  -h, --help               help for delete
  -n, --namespace string   namespace for accelerator system (default "accelerator-system")
```

### Options inherited from parent commands

```
      --context name      name of the kubeconfig context to use (default is current-context defined by kubeconfig)
      --kubeconfig file   kubeconfig file (default is $HOME/.kube/config)
```

### SEE ALSO

* [tanzu accelerator](tanzu_accelerator.md)	 - Manage accelerators in a Kubernetes cluster

