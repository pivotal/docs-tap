# tanzu accelerator fragment create

This command creates a new accelerator fragment.

## Synopsis

Create a new accelerator fragment resource with specified configuration.

Accelerator configuration options include:

- Git repository URL and branch/tag where accelerator code and metadata is defined
- Metadata like description, display-name, tags and icon-url

The Git repository option is required. Metadata options are optional and will override any values for
the same options specified in the accelerator metadata retrieved from the Git repository.

```console
tanzu accelerator fragment create [flags]
```

## Examples

```console
tanzu acceleratorent fragm create <fragment-name> --git-repository <URL> --git-branch <branch> --git-sub-path <sub-path>
```

## Options

```console
      --display-name string   display name for the accelerator fragment
      --git-branch string     Git repository branch to be used (default "main")
      --git-repo string       Git repository URL for the accelerator fragment
      --git-sub-path string   Git repository subPath to be used
      --git-tag string        Git repository tag to be used
  -h, --help                  help for create
      --interval string       interval for checking for updates to Git or image repository
      --local-path string     path to the directory containing the source for the accelerator fragment
  -n, --namespace string      namespace for accelerator system (default "accelerator-system")
      --secret-ref string     name of secret containing credentials for private Git or image repository
      --source-image string   name of the source image for the accelerator
```

## Options inherited from parent commands

```console
      --context name      name of the kubeconfig context to use (default is current-context defined by kubeconfig)
      --kubeconfig file   kubeconfig file (default is $HOME/.kube/config)
```

## SEE ALSO

[tanzu accelerator fragment](tanzu_accelerator_fragment.md)
