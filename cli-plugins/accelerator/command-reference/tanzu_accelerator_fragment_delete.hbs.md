# tanzu accelerator fragment delete

This topic tells you how to use the Tanzu Accelerator CLI `tanzu accelerator fragment delete`
command to delete an accelerator fragment.

## Synopsis

Delete the accelerator fragment resource with the specified name.

```console
tanzu accelerator fragment delete [flags]
```

## Examples

```console
tanzu accelerator fragment delete <fragment-name>
```

## Options

```console
  -h, --help               help for delete
  -n, --namespace string   namespace for accelerator system (default "accelerator-system")
```

## Options inherited from parent commands

```console
      --context name      name of the kubeconfig context to use (default is current-context defined by kubeconfig)
      --kubeconfig file   kubeconfig file (default is $HOME/.kube/config)
```

## SEE ALSO

[tanzu accelerator fragment](tanzu_accelerator_fragment.md)
