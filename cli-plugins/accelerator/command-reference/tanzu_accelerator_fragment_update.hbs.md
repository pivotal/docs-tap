# tanzu accelerator fragment update

This command updates an accelerator fragment.

## Synopsis

Update an accelerator fragment resource with the specified name using the specified configuration.

Accelerator configuration options include:
- Git repository URL and branch/tag where accelerator code and metadata is defined
- Metadata like display-name

The update command also provides a --reconcile flag that will force the accelerator fragment to be refreshed
with any changes made to the associated Git repository.

```console
tanzu accelerator fragment update [flags]
```

## Examples

```console
tanzu accelerator update <accelerator-name> --description "Lorem Ipsum"
```

## Options

```console
      --display-name string   display name for the accelerator fragment
      --git-branch string     Git repository branch to be used
      --git-repo string       Git repository URL for the accelerator fragment
      --git-sub-path string   Git repository subPath to be used
      --git-tag string        Git repository tag to be used
  -h, --help                  help for update
      --interval string       interval for checking for updates to Git repository
  -n, --namespace string      namespace for accelerator fragments (default "accelerator-system")
      --reconcile             trigger a reconciliation including the associated GitRepository resource
      --secret-ref string     name of secret containing credentials for private Git repository
```

## Options inherited from parent commands

```console
      --context name      name of the kubeconfig context to use (default is current-context defined by kubeconfig)
      --kubeconfig file   kubeconfig file (default is $HOME/.kube/config)
```

## SEE ALSO

* [tanzu accelerator fragment](tanzu_accelerator_fragment.md)	 - Fragment commands
