# tanzu accelerator get

This command gets accelerator information.

## Synopsis

Get accelerator information.

You can choose to get the accelerator from the Application Accelerator server using --server-url flag
or from a Kubernetes context using --from-context flag. The default is to get accelerators from the
Kubernetes context. To override this, you can set the ACC_SERVER_URL environment variable with the URL for the Application Accelerator server you want to access.

```console
tanzu accelerator get [flags]
```

## Examples

```console
tanzu accelerator get <accelerator-name> --from-context
```

## Options

```console
      --from-context        retrieve resources from current context defined in kubeconfig
  -h, --help                help for get
  -n, --namespace string    namespace for accelerator system (default "accelerator-system")
      --server-url string   the URL for the Application Accelerator server
  -v, --verbose             include all fields and show long URLs in the output
```

## Options inherited from parent commands

```console
      --context name      name of the kubeconfig context to use (default is current-context defined by kubeconfig)
      --kubeconfig file   kubeconfig file (default is $HOME/.kube/config)
```

## SEE ALSO

[tanzu accelerator](tanzu_accelerator.md)
