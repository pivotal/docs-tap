## tanzu accelerator push

Push local path to source image

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
Note:  `--source-image` is not needed anymore or is optional unless the registry being used is not handled by Local Source Proxy when running the command 
`tanzu accelerator push --local-path <local path> --source-image <image>`

### <a id="config-src-img-registry"></a> How to configure Local Source Proxy

Please configure Local Source Proxy following these [instructions](../../apps/../../local-source-proxy/about.hbs.md).

For more information, see

[Prerequisites for Local Source Proxy](../../apps/../../local-source-proxy/prereqs.hbs.md)

[Install Local Source Proxy](../../apps/../../local-source-proxy/install.hbs.md)

[Troubleshoot Local Source Proxy](../../apps/../../local-source-proxy/troubleshoot.hbs.md)

If Local Source Proxy cannot be configured, then use a source image registry. Before deploying a workload, you must authenticate with an image registry to store your source code.



### Options inherited from parent commands

```
      --context name      name of the kubeconfig context to use (default is current-context defined by kubeconfig)
      --kubeconfig file   kubeconfig file (default is $HOME/.kube/config)
```

### SEE ALSO

* [tanzu accelerator](tanzu_accelerator.md)	 - Manage accelerators in a Kubernetes cluster

