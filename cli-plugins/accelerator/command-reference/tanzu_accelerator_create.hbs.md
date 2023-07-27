# tanzu accelerator create

This command creates a new accelerator.

## Synopsis

Create a new accelerator resource with specified configuration.

Accelerator configuration options include:
- Git repository URL and branch/tag where accelerator code and metadata is defined
- Metadata like description, display-name, tags and icon-url

The Git repository option is required. Metadata options are optional and will override any values for
the same options specified in the accelerator metadata retrieved from the Git repository.

```console
tanzu accelerator create [flags]
```

### Examples

```console
tanzu accelerator create <accelerator-name> --git-repository <URL> --git-branch <branch>
```

### Options

```console
      --description string    description of this accelerator
      --display-name string   display name for the accelerator
      --git-branch string     Git repository branch to be used
      --git-repo string       Git repository URL for the accelerator
      --git-sub-path string   Git repository subPath to be used
      --git-tag string        Git repository tag to be used
  -h, --help                  help for create
      --icon-url string       URL for icon to use with the accelerator
      --interval string       interval for checking for updates to Git or image repository
      --local-path string     path to the directory containing the source for the accelerator
  -n, --namespace string      namespace for accelerator system (default "accelerator-system")
      --secret-ref string     name of secret containing credentials for private Git or image repository
      --source-image string   name of the source image for the accelerator
      --tags strings          tags that can be used to search for accelerators
```

### Options inherited from parent commands

```console
      --context name      name of the kubeconfig context to use (default is current-context defined by kubeconfig)
      --kubeconfig file   kubeconfig file (default is $HOME/.kube/config)
```

### SEE ALSO

* [tanzu accelerator](tanzu_accelerator.md)	 - Manage accelerators in a Kubernetes cluster
