## tanzu accelerator fragment create

This command creates a new accelerator fragment.

### Synopsis

Create a new accelerator fragment resource with specified configuration.

Accelerator configuration options include:
- Git repository URL and branch/tag where accelerator code and metadata is defined
- Metadata like description, display-name, tags and icon-url

The Git repository option is required. Metadata options are optional and will override any values for
the same options specified in the accelerator metadata retrieved from the Git repository.


```
tanzu accelerator fragment create [flags]
```

### Examples

```
tanzu acceleratorent fragm create <fragment-name> --git-repository <URL> --git-branch <branch> --git-sub-path <sub-path>
```

### Options

```
      --display-name string   display name for the accelerator
      --git-branch string     Git repository branch to be used
      --git-repo string       Git repository URL for the accelerator
      --git-sub-path string   Git repository subPath to be used
      --git-tag string        Git repository tag to be used
  -h, --help                  help for create
      --interval string       interval for checking for updates to Git or image repository
  -n, --namespace string      namespace for accelerator system (default "accelerator-system")
      --secret-ref string     name of secret containing credentials for private Git or image repository
```

### Options inherited from parent commands

```
      --context name      name of the kubeconfig context to use (default is current-context defined by kubeconfig)
      --kubeconfig file   kubeconfig file (default is $HOME/.kube/config)
```

### SEE ALSO

* [tanzu accelerator fragment](tanzu_accelerator_fragment.md)	 - Fragment commands

