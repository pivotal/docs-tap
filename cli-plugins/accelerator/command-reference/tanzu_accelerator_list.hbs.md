# tanzu accelerator list

This command lists accelerators.

## Synopsis

List all accelerators.

You can choose to list the accelerators from the Application Accelerator server using --server-url flag
or from a Kubernetes context using --from-context flag. The default is to list accelerators from the
Kubernetes context. To override this, you can set the ACC_SERVER_URL environment variable with the URL for
the Application Accelerator server you want to access.

```console
tanzu accelerator list [flags]
```

## Examples

```console
tanzu accelerator list
```

## Options

```console
      --from-context        retrieve resources from current context defined in kubeconfig
  -h, --help                help for list
  -n, --namespace string    namespace for accelerator system (default "accelerator-system")
      --server-url string   the URL for the Application Accelerator server
  -t, --tags strings        accelerator tags to match against
```

## Options inherited from parent commands

```console
      --context name      name of the kubeconfig context to use (default is current-context defined by kubeconfig)
      --kubeconfig file   kubeconfig file (default is $HOME/.kube/config)
```

### SEE ALSO

* [tanzu accelerator](tanzu_accelerator.md)	 - Manage accelerators in a Kubernetes cluster
