# tanzu accelerator update

This command updates an accelerator.

## Synopsis

Update an accelerator resource with the specified name using the specified configuration.

Accelerator configuration options include:
- Git repository URL and branch/tag where accelerator code and metadata is defined
- Metadata like description, display-name, tags and icon-url

The update command also provides a --reoncile flag that will force the accelerator to be refreshed
with any changes made to the associated Git repository.

```console
tanzu accelerator update [flags]
```

## Examples

```console
tanzu accelerator update <accelerator-name> --description "Lorem Ipsum"
```

## Options

```console
      --description string    description of this accelerator
      --display-name string   display name for the accelerator
      --git-branch string     Git repository branch to be used
      --git-repo string       Git repository URL for the accelerator
      --git-sub-path string   Git repository subPath to be used
      --git-tag string        Git repository tag to be used
  -h, --help                  help for update
      --icon-url string       URL for icon to use with the accelerator
      --interval string       interval for checking for updates to Git or image repository
  -n, --namespace string      namespace for accelerator system (default "accelerator-system")
      --reconcile             trigger a reconciliation including the associated GitRepository resource
      --secret-ref string     name of secret containing credentials for private Git or image repository
      --source-image string   name of the source image for the accelerator
      --tags strings          tags that can be used to search for accelerators
```

## Options inherited from parent commands

```console
      --context name      name of the kubeconfig context to use (default is current-context defined by kubeconfig)
      --kubeconfig file   kubeconfig file (default is $HOME/.kube/config)
```

## SEE ALSO

* [tanzu accelerator](tanzu_accelerator.md)	 - Manage accelerators in a Kubernetes cluster
