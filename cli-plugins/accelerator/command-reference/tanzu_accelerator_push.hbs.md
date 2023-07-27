## tanzu accelerator push

This command pushes source code from local path to source image.

### Synopsis

Push source code from local path to source image used by an accelerator

```
tanzu accelerator push [flags]
```

### Examples

```
tanzu accelerator push --local-path <local path> --source-image <image>
```

### Options

```
  -h, --help                  help for push
      --local-path string     path to the directory containing the source for the accelerator
      --source-image string   name of the source image for the accelerator
```

### Options inherited from parent commands

```
      --context name      name of the kubeconfig context to use (default is current-context defined by kubeconfig)
      --kubeconfig file   kubeconfig file (default is $HOME/.kube/config)
```

### SEE ALSO

* [tanzu accelerator](tanzu_accelerator.md)	 - Manage accelerators in a Kubernetes cluster

