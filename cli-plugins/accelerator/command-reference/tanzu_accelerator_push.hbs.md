# tanzu accelerator push

Push local path to source image

## Synopsis

Push source code from local path to source image used by an accelerator

```console
tanzu accelerator push [flags]
```

## Examples

```console
tanzu accelerator push --local-path <local path> --source-image <image>
```

## Options

```console
  -h, --help                  help for push
      --local-path string     path to the directory containing the source for the accelerator
      --source-image string   name of the source image for the accelerator
```

> **Note**  When you run the `tanzu accelerator push` command, `--source-image` is only required if the registry being used is not handled by Local Source Proxy.

## <a id="config-src-img-registry"></a> Configure Local Source Proxy

For information about Local Source Proxy, see [Overview of Local Source Proxy](../../apps/../../local-source-proxy/about.hbs.md).

If Local Source Proxy cannot be configured, use a source image registry. Before deploying a workload, you must authenticate with an image registry to store your source code.

## Options inherited from parent commands

```console
      --context name      name of the kubeconfig context to use (default is current-context defined by kubeconfig)
      --kubeconfig file   kubeconfig file (default is $HOME/.kube/config)
```

## SEE ALSO

* [tanzu accelerator](tanzu_accelerator.md)	 - Manage accelerators in a Kubernetes cluster
